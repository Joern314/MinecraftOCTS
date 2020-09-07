--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____geom = require("geom")
local Side = ____geom.Side
local toSide = ____geom.toSide
local toFacing = ____geom.toFacing
local toNormal = ____geom.toNormal
local sum = ____geom.sum
local robot, _state
function ____exports.getPosition(self)
    return _state.v
end
function ____exports.getFacing(self)
    return _state.facing
end
function ____exports.setPosition(self, v)
    _state.v = v
end
function ____exports.setFacing(self, f)
    _state.facing = f
end
function ____exports.turnSide(self, s)
    local ____switch8 = s
    if ____switch8 == Side.front then
        goto ____switch8_case_0
    elseif ____switch8 == Side.left then
        goto ____switch8_case_1
    elseif ____switch8 == Side.right then
        goto ____switch8_case_2
    elseif ____switch8 == Side.back then
        goto ____switch8_case_3
    end
    goto ____switch8_end
    ::____switch8_case_0::
    do
        goto ____switch8_end
    end
    ::____switch8_case_1::
    do
        robot:turnLeft()
        goto ____switch8_end
    end
    ::____switch8_case_2::
    do
        robot:turnRight()
        goto ____switch8_end
    end
    ::____switch8_case_3::
    do
        robot:turnAround()
        goto ____switch8_end
    end
    ::____switch8_end::
    local f = toFacing(
        nil,
        ____exports.getFacing(nil),
        s
    )
    ____exports.setFacing(nil, f)
end
function ____exports.moveSide(self, s, preserve_facing)
    if preserve_facing == nil then
        preserve_facing = true
    end
    local success
    local ____error
    local v = ____exports.getPosition(nil)
    local n = toNormal(
        nil,
        toFacing(
            nil,
            ____exports.getFacing(nil),
            s
        )
    )
    local ____switch11 = s
    if ____switch11 == Side.top then
        goto ____switch11_case_0
    elseif ____switch11 == Side.bottom then
        goto ____switch11_case_1
    elseif ____switch11 == Side.front then
        goto ____switch11_case_2
    elseif ____switch11 == Side.back then
        goto ____switch11_case_3
    elseif ____switch11 == Side.left then
        goto ____switch11_case_4
    elseif ____switch11 == Side.right then
        goto ____switch11_case_5
    end
    goto ____switch11_end
    ::____switch11_case_0::
    do
        success, ____error = robot:up()
        goto ____switch11_end
    end
    ::____switch11_case_1::
    do
        success, ____error = robot:down()
        goto ____switch11_end
    end
    ::____switch11_case_2::
    do
        success, ____error = robot:forward()
        goto ____switch11_end
    end
    ::____switch11_case_3::
    do
        success, ____error = robot:back()
        goto ____switch11_end
    end
    ::____switch11_case_4::
    do
        ____exports.turnSide(nil, Side.left)
        success, ____error = robot:forward()
        if preserve_facing then
            ____exports.turnSide(nil, Side.right)
        end
        goto ____switch11_end
    end
    ::____switch11_case_5::
    do
        ____exports.turnSide(nil, Side.right)
        success, ____error = robot:forward()
        if preserve_facing then
            ____exports.turnSide(nil, Side.left)
        end
        goto ____switch11_end
    end
    ::____switch11_end::
    if success then
        ____exports.setPosition(
            nil,
            sum(nil, v, n)
        )
        return {true, nil}
    else
        return {false, ____error}
    end
end
robot = {}
_state = {v = {0, 0, 0}, facing = 0}
function ____exports.turn(self, f)
    local s = toSide(
        nil,
        ____exports.getFacing(nil),
        f
    )
    ____exports.turnSide(nil, s)
end
function ____exports.move(self, f, preserve_facing)
    if preserve_facing == nil then
        preserve_facing = true
    end
    local s = toSide(
        nil,
        ____exports.getFacing(nil),
        f
    )
    return ____exports.moveSide(nil, s, preserve_facing)
end
return ____exports
