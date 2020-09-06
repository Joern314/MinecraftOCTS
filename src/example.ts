import { Vec3, VoxelMap, Voxel, sum } from "./geom"
import { Task, TaskFarmBreak} from "./task"
import { Try } from "./util";

export const example: AreaMapObj = {
    config: {
        origin: [0, 0, 0],
        axes: ["+x", "+z", "+y"],
    },
    tasks: [
        {
            action: "farm_break",
            location: "h",
            timer: 30.0,
        },
    ],
    layers: [
        [
            "sdddddddd",
            "sddwddwdd",
            "sdddddddd"
        ], [
            " HHHHHHHH",
            "cHH HH HH",
            "yHHHHHHHH"
        ], [
            " hhhhhhhh",
            " hh hh hh",
            " hhhhhhhh",
        ], [
            "         ",
            "         ",
            "         ",
        ]
    ]
}
export type TaskObj = {
    action: string,
    location: string | Vec3,
} & any;
export type Axis = "+x" | "-x" | "+y" | "-y" | "+z" | "-z";

export type AreaMapObj = {
    config: {
        origin: Vec3
        axes: [Axis, Axis, Axis],
    }
    tasks: Array<TaskObj>,
    layers: Array<Array<string>>
};

export type VData = {
    char: string;
}

export function parseVoxels(obj: AreaMapObj): VoxelMap<VData> {
    let s2 = obj.layers.length;
    let s1 = obj.layers[0].length;
    let s0 = obj.layers[0][0].length;

    let voxels = new VoxelMap<VData>();

    let axes_map: any = { "x": 0, "y": 1, "z": 2};
    const _axis_perm = [-1, -1, -1];
    _axis_perm[axes_map[obj.config.axes[0].charAt(1)]] = 0
    _axis_perm[axes_map[obj.config.axes[1].charAt(1)]] = 1
    _axis_perm[axes_map[obj.config.axes[2].charAt(1)]] = 2
    const _axis_sign = [-1, -1, -1];
    _axis_sign[0] = obj.config.axes[_axis_perm[0]].charAt(0) === "+" ? 1 : -1;
    _axis_sign[1] = obj.config.axes[_axis_perm[1]].charAt(0) === "+" ? 1 : -1;
    _axis_sign[2] = obj.config.axes[_axis_perm[2]].charAt(0) === "+" ? 1 : -1;

    const orig = obj.config.origin;
    function transform(v: Vec3): Vec3 {
        let x = _axis_sign[0] * v[_axis_perm[0]];
        let y = _axis_sign[1] * v[_axis_perm[1]];
        let z = _axis_sign[2] * v[_axis_perm[2]];
        return sum(orig, [x,y,z]);
    }

    for (let i2 = 0; i2 < s2; i2++) {
        for (let i1 = 0; i1 < s1; i1++) {
            for (let i0 = 0; i0 < s0; i0++) {
                voxels.set(transform([i0,i1,i2]), {
                    char: obj.layers[i2][i1].charAt(i0)
                });
            }
        }
    }

    return voxels;
}
export function parseTasks(obj: TaskObj, map: VoxelMap<VData>): Array<Task> {
    let locations: Array<Vec3>;
    if (typeof (obj.location) === "string") {
        locations = [];
        map.foreach(d => {
            if (d.char === obj.location) {
                locations.push(d.xyz);
            }
        })
    } else {
        locations = [obj.location];
    }

    let tasks = [];
    for (let loc of locations) {
        let task = parseTask(obj, loc);
        if (task !== undefined) {
            tasks.push(task);
        }
    }

    return tasks;
}
export function parseTask(obj: TaskObj, loc: Vec3): Task | undefined {
    switch (obj.action) {
        case "farm_break": return new TaskFarmBreak(obj, loc);
        default: return undefined;
    }
}