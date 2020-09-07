import { Vec3, VoxelMap, Voxel, sum } from "./geom"
import { Task, TaskFarmBreak, AreaMapObj, parseAreaMap } from "./task"
import { Try } from "./util";
require("util2");

export const example: AreaMapObj = {
    blocks: {
        "default": {passable: false},
        " ": { passable: true },
    },
    config: {
        origin: [0, 0, 0],
        axes: ["+x", "+z", "+y"],
    },
    tasks: [
        {
            action: "farm_break",
            location: "h",
            regrow_time: 30.0,
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

let [map, tasks] = parseAreaMap(example);