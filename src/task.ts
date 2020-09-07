import { Vec3, Facing, VoxelMap, Voxel, getPath, toSide, Side, Facing2d, sum } from "./geom";
import { getPosition, move, turn, getFacing } from "./nav";
import { Try, Failure, Success, isSuccess, isFailure } from "./util";
//import * as robot from "robot"
const robot: any = {};

export type VData = {
    passable: boolean,
    char: string,
    distance?: number,
    reversePath?: Facing,
};

export function getVoxelMap(): VoxelMap<VData> {
    let a: any = {}
    return a;
}

export function go_to(target: Vec3): Try<true> {
    let map = getVoxelMap();
    let path = getPath(getPosition(), map, target);
    if (path === undefined) {
        return Failure("No Path Found");
    }
    while (path.length > 0) {
        let f = path.shift()!;
        let [success, error] = move(f, false);
        if (!success) {
            return Failure(error);
        }
    }
    return Success(true);
}
export function go_near(target: Vec3): Try<Facing> {
    let map = getVoxelMap();
    let path = getPath(getPosition(), map, target);
    if (path === undefined) {
        return Failure("No Path Found");
    }
    if (path.length == 0) {
        // TODO: just step out of the current block and be done
        return Failure("Inside Target Position");
    }
    while (path.length > 1) {
        let f = path.shift()!;
        let [success, error] = move(f, false);
        if (!success) {
            return Failure(error);
        }
    }
    let face = path.shift()!; //facing towards the target
    return Success(face);
}

export function break_block(target: Vec3): Try<string> {
    let walk = go_near(target);
    if (isFailure(walk)) {
        return walk;
    }
    let face = walk.value; // facing towards the block
    let side = toSide(getFacing(), face);
    let success, interact;
    switch (side) {
        case Side.top:
            [success, interact] = robot.swingUp();
            break;
        case Side.bottom:
            [success, interact] = robot.swingDown();
            break;
        default: //2d case requires looking towards the block
            turn(<Facing2d>face);
            [success, interact] = robot.swing();
            break;
    }
    if (success) {
        return Success(interact);
    } else {
        return Failure("Block not broken");
    }
}


export class Task {
    onExecute(): void {
    };
    getPriority(): number {
        return -10;
    };
}

export class TaskFarmBreak extends Task {
    priority: number;
    loc: Vec3;
    regrow_time: number;
    retry_time: number;

    next_schedule: number;

    constructor(param: any, loc: Vec3) {
        super();
        this.priority = <number>param.priority || 10.0;
        this.loc = loc;
        this.regrow_time = <number>param.regrow_time;
        this.retry_time =  <number>param.retry_time || (this.regrow_time / 2);

        this.next_schedule = os.time();
    }
    onExecute() {
        let s = break_block(this.loc);
        if(isFailure(s)) {
            this.next_schedule = os.time() + this.retry_time;
        } else {
            this.next_schedule = os.time() + this.regrow_time;
        }
    }
    getPriority() {
        if (os.time() < this.next_schedule) {
            return 0;
        } else {
            return this.priority;
        }
    }
}

export type TaskObj = unknown & {
    action: string,
    location: string | Vec3,
    [other: string]: any,
};
export type Axis = "+x" | "-x" | "+y" | "-y" | "+z" | "-z";

export type AreaMapObj = {
    blocks: {
        [char: string]: Partial<VData>
    },
    config: {
        origin: Vec3
        axes: [Axis, Axis, Axis],
    },
    tasks: Array<TaskObj>,
    layers: Array<Array<string>>
};
export type BlockDict = Partial<{
    [char: string]: VData
}>;
export function parseBlocks(obj: AreaMapObj): BlockDict {
    let blocks: BlockDict = {};
    for(let bchar in obj.blocks) {
        let bobj = obj.blocks[bchar]!;
        blocks[bchar] = {
            passable: bobj.passable !== undefined ? bobj.passable : false,
            char: bchar,
        };
    }
    return blocks;
}
export function parseAreaMap(obj: AreaMapObj): [VoxelMap<VData>, Array<Task>] {
    let blocks = parseBlocks(obj);
    let map = parseVoxels(obj, blocks);
    let tasks = parseTasks(obj, map);

    return [map, tasks];
}
export function parseVoxels(obj: AreaMapObj, blocks: BlockDict): VoxelMap<VData> {
    let s2 = obj.layers.length;
    let s1 = obj.layers[0].length;
    let s0 = obj.layers[0][0].length;

    let voxels = new VoxelMap<VData>();

    let axes_map: any = { "x": 0, "y": 1, "z": 2};
    const _axis_perm = [-1, -1, -1];

    let a = obj.config.axes[0].charAt(1);
    _axis_perm[axes_map[a]] = 0
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
                let char = obj.layers[i2][i1].charAt(i0);
                let block = blocks[char];
                // clone and adjust
                if (block !== undefined) {
                    block = Object.assign({}, block);
                } else {
                    block = Object.assign({}, blocks.default);
                    block.char = char;
                }

                let v = transform([i0,i1,i2]);
                voxels.set(v, block);
            }
        }
    }

    return voxels;
}
export function parseTasks(obj: AreaMapObj, map: VoxelMap<VData>): Array<Task> {
    let tasks: Array<Task> = [];
    for (let tobj of obj.tasks) {
        let tlist = parseTaskMulti(tobj, map);
        tasks = ([tasks, tlist]).flat();
    }
    return tasks;
}
export function parseTaskMulti(obj: TaskObj, map: VoxelMap<VData>): Array<Task> {
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
        let task = parseTask(obj, map.get(loc), loc);
        if (task !== undefined) {
            tasks.push(task);
        }
    }

    return tasks;
}
export function parseTask(obj: TaskObj, block: Voxel<VData>, loc: Vec3): Task | undefined {
    switch (obj.action) {
        case "farm_break": return new TaskFarmBreak(obj, loc);
        default: return undefined;
    }
}