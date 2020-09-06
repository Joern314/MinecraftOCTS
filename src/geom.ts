export type Vec3 = [number, number, number];
export function sum(a: Vec3, b: Vec3): Vec3 {
    return [a[0] + b[0], a[1] + b[1], a[2] + b[2]]
}
export function sub(a: Vec3, b: Vec3): Vec3 {
    return [a[0] - b[0], a[1] - b[1], a[2] - b[2]]
}
export function mul(a: number, b: Vec3): Vec3 {
    return [a * b[0], a * b[1], a * b[2]]
}
export function hashVec3(v: Vec3): string {
    return `${v[0]}:${v[1]}:${v[2]}`;
}
export function eq(a: Vec3, b: Vec3): boolean {
    return a[0] == b[0] && a[1] == b[1] && a[2] == b[2];
}

export enum Facing {
    posx = 5,
    negx = 4,
    posz = 3,
    negz = 2,
    posy = 1,
    negy = 0,
};
export const Facings: Array<Facing> = [0, 1, 2, 3, 4, 5];
export type Facing2d = Facing.posx | Facing.negx | Facing.posz | Facing.negz;

export function toNormal(f: Facing): Vec3 {
    switch (f) {
        case Facing.posx: return [1, 0, 0];
        case Facing.negx: return [-1, 0, 0];
        case Facing.posy: return [0, 1, 0];
        case Facing.negy: return [0, -1, 0];
        case Facing.posz: return [0, 0, 1];
        case Facing.negz: return [0, 0, -1];
    }
}
export function negate(f: Facing): Facing {
    switch (f) {
        case Facing.posx: return Facing.negx;
        case Facing.negx: return Facing.posx;
        case Facing.posy: return Facing.negy;
        case Facing.negy: return Facing.posy;
        case Facing.posz: return Facing.negz;
        case Facing.negz: return Facing.posz;
    }
}


export enum Side {
    left = 5,
    right = 4,
    front = 3,
    back = 2,
    top = 1,
    bottom = 0,
}
export type Side2d = Side.left | Side.right | Side.front | Side.back;

export function toSide(front: Facing2d, f: Facing): Side {
    if (f == Facing.posy) return Side.top;
    if (f == Facing.negy) return Side.bottom;

    switch (front) {
        case Facing.posz: switch (f) {
            case Facing.posz: return Side.front;
            case Facing.posx: return Side.left;
            case Facing.negz: return Side.back;
            case Facing.negx: return Side.right;
        }
        case Facing.posx: switch (f) {
            case Facing.posx: return Side.front;
            case Facing.negz: return Side.left;
            case Facing.negx: return Side.back;
            case Facing.posz: return Side.right;
        }
        case Facing.negz: switch (f) {
            case Facing.negz: return Side.front;
            case Facing.negx: return Side.left;
            case Facing.posz: return Side.back;
            case Facing.posx: return Side.right;
        }
        case Facing.negx: switch (f) {
            case Facing.negx: return Side.front;
            case Facing.posz: return Side.left;
            case Facing.posx: return Side.back;
            case Facing.negz: return Side.right;
        }
    }
}

export function toFacing(front: Facing2d, s: Side): Facing {
    switch (s) {
        case Side.top: return Facing.posy;
        case Side.bottom: return Facing.negy;
        case Side.front: return front;
        case Side.back: switch (front) {
            case Facing.posz: return Facing.negz;
            case Facing.posx: return Facing.negx;
            case Facing.negz: return Facing.posz;
            case Facing.negx: return Facing.posx;
        }
        case Side.left: switch (front) {
            case Facing.posz: return Facing.posx;
            case Facing.posx: return Facing.negz;
            case Facing.negz: return Facing.negx;
            case Facing.negx: return Facing.posz;
        }
        case Side.right: switch (front) {
            case Facing.posz: return Facing.negx;
            case Facing.posx: return Facing.posz;
            case Facing.negz: return Facing.posx;
            case Facing.negx: return Facing.negz;
        }
    }
}

export type Voxel<Data> = Data & { xyz: Vec3 };
export class VoxelMap<Data> {
    _data: Partial<{ [hash: string]: Voxel<Data> }> = {};
    newUnknown: () => Data = () => <Data>{}; // used for unknown voxels

    createVoxelData(v: Vec3): Voxel<Data> {
        let obj = this.newUnknown();

        let d = { ...obj, xyz: v };
        let h = hashVec3(v);
        this._data[h] = d;
        return d;
    }

    get(v: Vec3): Voxel<Data> {
        let h = hashVec3(v);
        let d = this._data[h];
        if (d === undefined) {
            d = this.createVoxelData(v);
        }
        return d;
    }
    set(v: Vec3, obj: Data): Voxel<Data> {
        let d = { ...obj, xyz: v };
        let h = hashVec3(v);
        this._data[h] = d;
        return d;
    }

    foreach(cb: (d: Voxel<Data>) => void) {
        for (let h in this._data) {
            let d = this._data[h]!;
            cb(d);
        }
    }
}

export type DistanceData = { passable: boolean, distance?: number, reversePath?: Facing };

export function calculateDistances<Data extends DistanceData>(
    start: Vec3,
    map: VoxelMap<Data>,
    target: Vec3 | undefined
) {
    map.foreach(d => {
        d.distance = undefined;
        d.reversePath = undefined;
    });
    let dstart = map.get(start);
    dstart.distance = 0;
    dstart.reversePath = undefined;

    let boundary: Array<Vec3> = [start];
    let distance = 1;
    let running = true;
    while (running) {
        let nboundary: Array<Vec3> = [];
        for (let v of boundary) {
            for (let f of Facings) {
                let n = toNormal(f);
                let w = sum(v, n);
                let d = map.get(w);
                if (d.passable && d.distance === undefined) {  
                    // visit a new point
                    d.distance = distance;
                    d.reversePath = negate(f);
                    nboundary.push(w);
                }

                if (target !== undefined && eq(w, target)) {
                    running = false;
                }
            }
        }
        distance = distance + 1;
        boundary = nboundary;
        if (boundary.length === 0) {
            running = false; //no more voxels will be visited
        }
    }
}

export function getPath<Data extends DistanceData>(
    start: Vec3,
    map: VoxelMap<Data>,
    target: Vec3,
) {
    let dstart = map.get(start);
    let dtarget = map.get(target);

    if (dstart.distance !== 0) {
        calculateDistances(start, map, target);
    }
    if(dtarget.distance === undefined) {
        return undefined; // not connected 
    }

    let path: Array<Facing> = []
    let v = target;
    while(!eq(v, start)) {
        let f = map.get(v).reversePath!;
        path.push(negate(f));
        v = sum(v, toNormal(f));
    }
    return path.reverse();
}