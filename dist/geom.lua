--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
function ____exports.sum(self, a, b)
    return {a[1] + b[1], a[2] + b[2], a[3] + b[3]}
end
function ____exports.sub(self, a, b)
    return {a[1] - b[1], a[2] - b[2], a[3] - b[3]}
end
function ____exports.mul(self, a, b)
    return {a * b[1], a * b[2], a * b[3]}
end
function ____exports.hashVec3(self, v)
    return (((tostring(v[1]) .. ":") .. tostring(v[2])) .. ":") .. tostring(v[3])
end
function ____exports.eq(self, a, b)
    return ((a[1] == b[1]) and (a[2] == b[2])) and (a[3] == b[3])
end
____exports.Facing = {}
____exports.Facing.posx = 5
____exports.Facing[____exports.Facing.posx] = "posx"
____exports.Facing.negx = 4
____exports.Facing[____exports.Facing.negx] = "negx"
____exports.Facing.posz = 3
____exports.Facing[____exports.Facing.posz] = "posz"
____exports.Facing.negz = 2
____exports.Facing[____exports.Facing.negz] = "negz"
____exports.Facing.posy = 1
____exports.Facing[____exports.Facing.posy] = "posy"
____exports.Facing.negy = 0
____exports.Facing[____exports.Facing.negy] = "negy"
____exports.Facings = {0, 1, 2, 3, 4, 5}
function ____exports.toNormal(self, f)
    local ____switch8 = f
    if ____switch8 == ____exports.Facing.posx then
        goto ____switch8_case_0
    elseif ____switch8 == ____exports.Facing.negx then
        goto ____switch8_case_1
    elseif ____switch8 == ____exports.Facing.posy then
        goto ____switch8_case_2
    elseif ____switch8 == ____exports.Facing.negy then
        goto ____switch8_case_3
    elseif ____switch8 == ____exports.Facing.posz then
        goto ____switch8_case_4
    elseif ____switch8 == ____exports.Facing.negz then
        goto ____switch8_case_5
    end
    goto ____switch8_end
    ::____switch8_case_0::
    do
        return {1, 0, 0}
    end
    ::____switch8_case_1::
    do
        return {-1, 0, 0}
    end
    ::____switch8_case_2::
    do
        return {0, 1, 0}
    end
    ::____switch8_case_3::
    do
        return {0, -1, 0}
    end
    ::____switch8_case_4::
    do
        return {0, 0, 1}
    end
    ::____switch8_case_5::
    do
        return {0, 0, -1}
    end
    ::____switch8_end::
end
function ____exports.negate(self, f)
    local ____switch10 = f
    if ____switch10 == ____exports.Facing.posx then
        goto ____switch10_case_0
    elseif ____switch10 == ____exports.Facing.negx then
        goto ____switch10_case_1
    elseif ____switch10 == ____exports.Facing.posy then
        goto ____switch10_case_2
    elseif ____switch10 == ____exports.Facing.negy then
        goto ____switch10_case_3
    elseif ____switch10 == ____exports.Facing.posz then
        goto ____switch10_case_4
    elseif ____switch10 == ____exports.Facing.negz then
        goto ____switch10_case_5
    end
    goto ____switch10_end
    ::____switch10_case_0::
    do
        return ____exports.Facing.negx
    end
    ::____switch10_case_1::
    do
        return ____exports.Facing.posx
    end
    ::____switch10_case_2::
    do
        return ____exports.Facing.negy
    end
    ::____switch10_case_3::
    do
        return ____exports.Facing.posy
    end
    ::____switch10_case_4::
    do
        return ____exports.Facing.negz
    end
    ::____switch10_case_5::
    do
        return ____exports.Facing.posz
    end
    ::____switch10_end::
end
____exports.Side = {}
____exports.Side.left = 5
____exports.Side[____exports.Side.left] = "left"
____exports.Side.right = 4
____exports.Side[____exports.Side.right] = "right"
____exports.Side.front = 3
____exports.Side[____exports.Side.front] = "front"
____exports.Side.back = 2
____exports.Side[____exports.Side.back] = "back"
____exports.Side.top = 1
____exports.Side[____exports.Side.top] = "top"
____exports.Side.bottom = 0
____exports.Side[____exports.Side.bottom] = "bottom"
function ____exports.toSide(self, front, f)
    if f == ____exports.Facing.posy then
        return ____exports.Side.top
    end
    if f == ____exports.Facing.negy then
        return ____exports.Side.bottom
    end
    local ____switch14 = front
    if ____switch14 == ____exports.Facing.posz then
        goto ____switch14_case_0
    elseif ____switch14 == ____exports.Facing.posx then
        goto ____switch14_case_1
    elseif ____switch14 == ____exports.Facing.negz then
        goto ____switch14_case_2
    elseif ____switch14 == ____exports.Facing.negx then
        goto ____switch14_case_3
    end
    goto ____switch14_end
    ::____switch14_case_0::
    do
        local ____switch15 = f
        if ____switch15 == ____exports.Facing.posz then
            goto ____switch15_case_0
        elseif ____switch15 == ____exports.Facing.posx then
            goto ____switch15_case_1
        elseif ____switch15 == ____exports.Facing.negz then
            goto ____switch15_case_2
        elseif ____switch15 == ____exports.Facing.negx then
            goto ____switch15_case_3
        end
        goto ____switch15_end
        ::____switch15_case_0::
        do
            return ____exports.Side.front
        end
        ::____switch15_case_1::
        do
            return ____exports.Side.left
        end
        ::____switch15_case_2::
        do
            return ____exports.Side.back
        end
        ::____switch15_case_3::
        do
            return ____exports.Side.right
        end
        ::____switch15_end::
    end
    ::____switch14_case_1::
    do
        local ____switch16 = f
        if ____switch16 == ____exports.Facing.posx then
            goto ____switch16_case_0
        elseif ____switch16 == ____exports.Facing.negz then
            goto ____switch16_case_1
        elseif ____switch16 == ____exports.Facing.negx then
            goto ____switch16_case_2
        elseif ____switch16 == ____exports.Facing.posz then
            goto ____switch16_case_3
        end
        goto ____switch16_end
        ::____switch16_case_0::
        do
            return ____exports.Side.front
        end
        ::____switch16_case_1::
        do
            return ____exports.Side.left
        end
        ::____switch16_case_2::
        do
            return ____exports.Side.back
        end
        ::____switch16_case_3::
        do
            return ____exports.Side.right
        end
        ::____switch16_end::
    end
    ::____switch14_case_2::
    do
        local ____switch17 = f
        if ____switch17 == ____exports.Facing.negz then
            goto ____switch17_case_0
        elseif ____switch17 == ____exports.Facing.negx then
            goto ____switch17_case_1
        elseif ____switch17 == ____exports.Facing.posz then
            goto ____switch17_case_2
        elseif ____switch17 == ____exports.Facing.posx then
            goto ____switch17_case_3
        end
        goto ____switch17_end
        ::____switch17_case_0::
        do
            return ____exports.Side.front
        end
        ::____switch17_case_1::
        do
            return ____exports.Side.left
        end
        ::____switch17_case_2::
        do
            return ____exports.Side.back
        end
        ::____switch17_case_3::
        do
            return ____exports.Side.right
        end
        ::____switch17_end::
    end
    ::____switch14_case_3::
    do
        local ____switch18 = f
        if ____switch18 == ____exports.Facing.negx then
            goto ____switch18_case_0
        elseif ____switch18 == ____exports.Facing.posz then
            goto ____switch18_case_1
        elseif ____switch18 == ____exports.Facing.posx then
            goto ____switch18_case_2
        elseif ____switch18 == ____exports.Facing.negz then
            goto ____switch18_case_3
        end
        goto ____switch18_end
        ::____switch18_case_0::
        do
            return ____exports.Side.front
        end
        ::____switch18_case_1::
        do
            return ____exports.Side.left
        end
        ::____switch18_case_2::
        do
            return ____exports.Side.back
        end
        ::____switch18_case_3::
        do
            return ____exports.Side.right
        end
        ::____switch18_end::
    end
    ::____switch14_end::
end
function ____exports.toFacing(self, front, s)
    local ____switch20 = s
    if ____switch20 == ____exports.Side.top then
        goto ____switch20_case_0
    elseif ____switch20 == ____exports.Side.bottom then
        goto ____switch20_case_1
    elseif ____switch20 == ____exports.Side.front then
        goto ____switch20_case_2
    elseif ____switch20 == ____exports.Side.back then
        goto ____switch20_case_3
    elseif ____switch20 == ____exports.Side.left then
        goto ____switch20_case_4
    elseif ____switch20 == ____exports.Side.right then
        goto ____switch20_case_5
    end
    goto ____switch20_end
    ::____switch20_case_0::
    do
        return ____exports.Facing.posy
    end
    ::____switch20_case_1::
    do
        return ____exports.Facing.negy
    end
    ::____switch20_case_2::
    do
        return front
    end
    ::____switch20_case_3::
    do
        local ____switch21 = front
        if ____switch21 == ____exports.Facing.posz then
            goto ____switch21_case_0
        elseif ____switch21 == ____exports.Facing.posx then
            goto ____switch21_case_1
        elseif ____switch21 == ____exports.Facing.negz then
            goto ____switch21_case_2
        elseif ____switch21 == ____exports.Facing.negx then
            goto ____switch21_case_3
        end
        goto ____switch21_end
        ::____switch21_case_0::
        do
            return ____exports.Facing.negz
        end
        ::____switch21_case_1::
        do
            return ____exports.Facing.negx
        end
        ::____switch21_case_2::
        do
            return ____exports.Facing.posz
        end
        ::____switch21_case_3::
        do
            return ____exports.Facing.posx
        end
        ::____switch21_end::
    end
    ::____switch20_case_4::
    do
        local ____switch22 = front
        if ____switch22 == ____exports.Facing.posz then
            goto ____switch22_case_0
        elseif ____switch22 == ____exports.Facing.posx then
            goto ____switch22_case_1
        elseif ____switch22 == ____exports.Facing.negz then
            goto ____switch22_case_2
        elseif ____switch22 == ____exports.Facing.negx then
            goto ____switch22_case_3
        end
        goto ____switch22_end
        ::____switch22_case_0::
        do
            return ____exports.Facing.posx
        end
        ::____switch22_case_1::
        do
            return ____exports.Facing.negz
        end
        ::____switch22_case_2::
        do
            return ____exports.Facing.negx
        end
        ::____switch22_case_3::
        do
            return ____exports.Facing.posz
        end
        ::____switch22_end::
    end
    ::____switch20_case_5::
    do
        local ____switch23 = front
        if ____switch23 == ____exports.Facing.posz then
            goto ____switch23_case_0
        elseif ____switch23 == ____exports.Facing.posx then
            goto ____switch23_case_1
        elseif ____switch23 == ____exports.Facing.negz then
            goto ____switch23_case_2
        elseif ____switch23 == ____exports.Facing.negx then
            goto ____switch23_case_3
        end
        goto ____switch23_end
        ::____switch23_case_0::
        do
            return ____exports.Facing.negx
        end
        ::____switch23_case_1::
        do
            return ____exports.Facing.posz
        end
        ::____switch23_case_2::
        do
            return ____exports.Facing.posx
        end
        ::____switch23_case_3::
        do
            return ____exports.Facing.negz
        end
        ::____switch23_end::
    end
    ::____switch20_end::
end
____exports.VoxelMap = __TS__Class()
local VoxelMap = ____exports.VoxelMap
VoxelMap.name = "VoxelMap"
function VoxelMap.prototype.____constructor(self)
    self._data = {}
    self.newUnknown = function() return {} end
end
function VoxelMap.prototype.createVoxelData(self, v)
    local obj = self:newUnknown()
    local d = __TS__ObjectAssign({}, obj, {xyz = v})
    local h = ____exports.hashVec3(nil, v)
    self._data[h] = d
    return d
end
function VoxelMap.prototype.get(self, v)
    local h = ____exports.hashVec3(nil, v)
    local d = self._data[h]
    if d == nil then
        d = self:createVoxelData(v)
    end
    return d
end
function VoxelMap.prototype.set(self, v, obj)
    local d = __TS__ObjectAssign({}, obj, {xyz = v})
    local h = ____exports.hashVec3(nil, v)
    self._data[h] = d
    return d
end
function VoxelMap.prototype.foreach(self, cb)
    for h in pairs(self._data) do
        local d = self._data[h]
        cb(nil, d)
    end
end
function ____exports.calculateDistances(self, start, map, target)
    map:foreach(
        function(____, d)
            d.distance = nil
            d.reversePath = nil
        end
    )
    local dstart = map:get(start)
    dstart.distance = 0
    dstart.reversePath = nil
    local boundary = {start}
    local distance = 1
    local running = true
    while running do
        local nboundary = {}
        for ____, v in ipairs(boundary) do
            for ____, f in ipairs(____exports.Facings) do
                local n = ____exports.toNormal(nil, f)
                local w = ____exports.sum(nil, v, n)
                local d = map:get(w)
                if d.passable and (d.distance == nil) then
                    d.distance = distance
                    d.reversePath = ____exports.negate(nil, f)
                    __TS__ArrayPush(nboundary, w)
                end
                if (target ~= nil) and ____exports.eq(nil, w, target) then
                    running = false
                end
            end
        end
        distance = distance + 1
        boundary = nboundary
        if #boundary == 0 then
            running = false
        end
    end
end
function ____exports.getPath(self, start, map, target)
    local dstart = map:get(start)
    local dtarget = map:get(target)
    if dstart.distance ~= 0 then
        ____exports.calculateDistances(nil, start, map, target)
    end
    if dtarget.distance == nil then
        return nil
    end
    local path = {}
    local v = target
    while not ____exports.eq(nil, v, start) do
        local f = map:get(v).reversePath
        __TS__ArrayPush(
            path,
            ____exports.negate(nil, f)
        )
        v = ____exports.sum(
            nil,
            v,
            ____exports.toNormal(nil, f)
        )
    end
    return __TS__ArrayReverse(path)
end
return ____exports
