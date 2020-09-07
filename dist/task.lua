--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____geom = require("geom")
local VoxelMap = ____geom.VoxelMap
local getPath = ____geom.getPath
local toSide = ____geom.toSide
local Side = ____geom.Side
local sum = ____geom.sum
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
function ____exports.parseVoxels(self, obj, blocks)
    local size2 = #obj.layers
    local size1 = #obj.layers[1]
    local size0 = #obj.layers[1][1]
    local voxels = __TS__New(VoxelMap)
    local axes_map = {x = 0, y = 1, z = 2}
    local axes_pos = {x = -1, y = -1, z = -1}
    local a0 = string.sub(obj.config.axes[1], 2, 2)
    local a1 = string.sub(obj.config.axes[2], 2, 2)
    local a2 = string.sub(obj.config.axes[3], 2, 2)
    local s0 = ((string.sub(obj.config.axes[1], 1, 1) == "+") and 1) or -1
    local s1 = ((string.sub(obj.config.axes[1], 1, 1) == "+") and 1) or -1
    local s2 = ((string.sub(obj.config.axes[1], 1, 1) == "+") and 1) or -1
    axes_pos[a0] = 0
    axes_pos[a1] = 1
    axes_pos[a2] = 2
    local axes_sign = {x = -1, y = -1, z = -1}
    axes_sign[a0] = s0
    axes_sign[a1] = s1
    axes_sign[a2] = s2
    local orig = obj.config.origin
    local function transform(self, v)
        local x = axes_sign.x * v[axes_pos.x + 1]
        local y = axes_sign.y * v[axes_pos.y + 1]
        local z = axes_sign.z * v[axes_pos.z + 1]
        return sum(nil, orig, {x, y, z})
    end
    do
        local i2 = 0
        while i2 < size2 do
            do
                local i1 = 0
                while i1 < size1 do
                    do
                        local i0 = 0
                        while i0 < size0 do
                            local char = __TS__StringCharAt(obj.layers[i2 + 1][i1 + 1], i0)
                            local block = blocks[char]
                            if block ~= nil then
                                block = __TS__ObjectAssign({}, block)
                            else
                                block = __TS__ObjectAssign({}, blocks.default)
                                block.char = char
                            end
                            local v = transform(nil, {i0, i1, i2})
                            voxels:set(v, block)
                            i0 = i0 + 1
                        end
                    end
                    i1 = i1 + 1
                end
            end
            i2 = i2 + 1
        end
    end
    return voxels
end
function ____exports.parseTasks(self, obj, map)
    local tasks = {}
    for ____, tobj in ipairs(obj.tasks) do
        local tlist = ____exports.parseTaskMulti(nil, tobj, map)
        tasks = __TS__ArrayFlat({tasks, tlist})
    end
    return tasks
end
function ____exports.parseTaskMulti(self, obj, map)
    local locations
    if type(obj.location) == "string" then
        locations = {}
        map:foreach(
            function(____, d)
                if d.char == obj.location then
                    __TS__ArrayPush(locations, d.xyz)
                end
            end
        )
    else
        locations = {obj.location}
    end
    local tasks = {}
    for ____, loc in ipairs(locations) do
        local task = ____exports.parseTask(
            nil,
            obj,
            map:get(loc),
            loc
        )
        if task ~= nil then
            __TS__ArrayPush(tasks, task)
        end
    end
    return tasks
end
function ____exports.parseTask(self, obj, block, loc)
    local ____switch47 = obj.action
    if ____switch47 == "farm_break" then
        goto ____switch47_case_0
    end
    goto ____switch47_case_default
    ::____switch47_case_0::
    do
        return __TS__New(____exports.TaskFarmBreak, obj, loc)
    end
    ::____switch47_case_default::
    do
        return nil
    end
    ::____switch47_end::
end
____exports.state = {}
function ____exports.getVoxelMap(self)
    return ____exports.state.map
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
    self.regrow_time = param.regrow_time or 30
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
function ____exports.parseBlocks(self, obj)
    local blocks = {}
    for bchar in pairs(obj.blocks) do
        local bobj = obj.blocks[bchar]
        blocks[bchar] = {
            passable = (((bobj.passable ~= nil) and (function() return bobj.passable end)) or (function() return false end))(),
            char = bchar
        }
    end
    return blocks
end
function ____exports.parseAreaMap(self, obj)
    local blocks = ____exports.parseBlocks(nil, obj)
    local map = ____exports.parseVoxels(nil, obj, blocks)
    local tasks = ____exports.parseTasks(nil, obj, map)
    return {map, tasks}
end
local IDLE_TASK = {
    onExecute = function(self)
    end,
    getPriority = function(self)
        os.sleep(1)
        return 0
    end
}
function ____exports.pickHighestPriority(self, tasks)
    local optimum = IDLE_TASK
    local priority = 0
    for ____, task in ipairs(tasks) do
        local p = task:getPriority()
        if p > priority then
            optimum = task
            priority = p
        end
    end
    return optimum
end
function ____exports.executorLoop(self, map, tasks)
    ____exports.state.map = map
    ____exports.state.tasks = tasks
    while true do
        local task = ____exports.pickHighestPriority(nil, ____exports.state.tasks)
        task:onExecute()
    end
end
return ____exports
