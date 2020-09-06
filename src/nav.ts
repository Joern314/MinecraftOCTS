import * as computer from "computer"
import * as robot from "robot"
import * as sides from "sides"
import { Vec3, Facing, Side, toSide, Facing2d, Side2d, toFacing, toNormal, sum } from "./geom"

export interface State {
    v: Vec3
    facing: Facing2d;
}

const _state: State = { v: [0, 0, 0], facing: 0 }

export function getPosition() {
    return _state.v;
}
export function getFacing() {
    return _state.facing;
}
export function setPosition(v: Vec3) {
    _state.v = v;
}
export function setFacing(f: Facing2d) {
    _state.facing = f;
}


export function turn(f: Facing2d): void {
    let s = <Side2d>toSide(getFacing(), f);
    turnSide(s);
}
export function turnSide(s: Side2d): void {
    switch (s) {
        case Side.front: break;
        case Side.left: robot.turnLeft(); break;
        case Side.right: robot.turnRight(); break;
        case Side.back: robot.turnAround(); break;
    }
    let f = <Facing2d>toFacing(getFacing(), s);
    setFacing(f);
}

export function move(f: Facing, preserve_facing: boolean = true): [boolean, string?] {
    let s = <Side2d>toSide(getFacing(), f);
    return moveSide(s, preserve_facing);
}
export function moveSide(s: Side, preserve_facing: boolean = true): [boolean, string?] {
    let success: boolean, error: string | undefined;
    let v = getPosition();
    let n = toNormal(toFacing(getFacing(), s));
    switch (s) {
        case Side.top: [success, error] = robot.up(); break;
        case Side.bottom: [success, error] = robot.down(); break;
        case Side.front: [success, error] = robot.forward(); break;
        case Side.back: [success, error] = robot.back(); break;
        case Side.left:
            turnSide(Side.left);
            [success, error] = robot.forward();
            if (preserve_facing)
                turnSide(Side.right)
            break;
        case Side.right:
            turnSide(Side.right);
            [success, error] = robot.forward();
            if (preserve_facing)
                turnSide(Side.left)
            break;
    }
    if (success) {
        setPosition(sum(v, n));
        return [true, undefined];
    } else {
        return [false, error];
    }
}

