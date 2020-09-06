--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____geom = require("geom")
local getPath = ____geom.getPath
local toSide = ____geom.toSide
local Side = ____geom.Side
local ____nav = require("nav")
local getPosition = ____nav.getPosition
local move = ____nav.move
local turn = ____nav.turn
local getFacing = ____nav.getFacing
local ____util = require("util")
local Failure = ____util.Failure
local Success = ____util.Success
local isFailure = ____util.isFailure
local robot = require("robot")
function ____exports.getVoxelMap(self)
    local a = {}
    return a
end
function ____exports.go_to(self, target)
    local map = ____exports.getVoxelMap(nil)
    local path = getPath(
        nil,
        getPosition(nil),
        map,
        target
    )
    if path == nil then
        return Failure(nil, "No Path Found")
    end
    while #path > 0 do
        local f = __TS__ArrayShift(path)
        local success, ____error = unpack(
            move(nil, f, false)
        )
        if not success then
            return Failure(nil, ____error)
        end
    end
    return Success(nil, true)
end
function ____exports.go_near(self, target)
    local map = ____exports.getVoxelMap(nil)
    local path = getPath(
        nil,
        getPosition(nil),
        map,
        target
    )
    if path == nil then
        return Failure(nil, "No Path Found")
    end
    if #path == 0 then
        return Failure(nil, "Inside Target Position")
    end
    while #path > 1 do
        local f = __TS__ArrayShift(path)
        local success, ____error = unpack(
            move(nil, f, false)
        )
        if not success then
            return Failure(nil, ____error)
        end
    end
    local face = __TS__ArrayShift(path)
    return Success(nil, face)
end
function ____exports.break_block(self, target)
    local walk = ____exports.go_near(nil, target)
    if isFailure(nil, walk) then
        return walk
    end
    local face = walk.value
    local side = toSide(
        nil,
        getFacing(nil),
        face
    )
    local success
    local interact
    local ____switch14 = side
    if ____switch14 == Side.top then
        goto ____switch14_case_0
    elseif ____switch14 == Side.bottom then
        goto ____switch14_case_1
    end
    goto ____switch14_case_default
    ::____switch14_case_0::
    do
        success, interact = robot.swingUp()
        goto ____switch14_end
    end
    ::____switch14_case_1::
    do
        success, interact = robot.swingDown()
        goto ____switch14_end
    end
    ::____switch14_case_default::
    do
        turn(nil, face)
        success, interact = robot.swing()
        goto ____switch14_end
    end
    ::____switch14_end::
    if success then
        return Success(nil, interact)
    else
        return Failure(nil, "Block not broken")
    end
end
____exports.Task = __TS__Class()
local Task = ____exports.Task
Task.name = "Task"
function Task.prototype.____constructor(self)
end
function Task.prototype.onExecute(self)
end
function Task.prototype.getPriority(self)
    return -10
end
____exports.TaskFarmBreak = __TS__Class()
local TaskFarmBreak = ____exports.TaskFarmBreak
TaskFarmBreak.name = "TaskFarmBreak"
__TS__ClassExtends(TaskFarmBreak, ____exports.Task)
function TaskFarmBreak.prototype.____constructor(self, param, loc)
    TaskFarmBreak.____super.prototype.____constructor(self)
    self.priority = param.priority or 10
    self.loc = loc
    self.regrow_time = param.regrow_time
    self.retry_time = param.retry_time or (self.regrow_time / 2)
    self.next_schedule = os.time()
end
function TaskFarmBreak.prototype.onExecute(self)
    local s = ____exports.break_block(nil, self.loc)
    if isFailure(nil, s) then
        self.next_schedule = os.time() + self.retry_time
    else
        self.next_schedule = os.time() + self.regrow_time
    end
end
function TaskFarmBreak.prototype.getPriority(self)
    if os.time() < self.next_schedule then
        return 0
    else
        return self.priority
    end
end
return ____exports
