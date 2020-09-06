import { Vec3, Facing, VoxelMap, Voxel, getPath, toSide, Side, Facing2d } from "./geom";
import { getPosition, move, turn, getFacing } from "./nav";
import { Try, Failure, Success, isSuccess, isFailure } from "./util";
import * as robot from "robot"

type VoxelCommand = (v: Vec3) => void;

type VData = {
    passable: boolean,
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