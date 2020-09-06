--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____geom = require("geom")
local VoxelMap = ____geom.VoxelMap
local sum = ____geom.sum
local ____task = require("task")
local TaskFarmBreak = ____task.TaskFarmBreak
function ____exports.parseTask(self, obj, loc)
    local ____switch15 = obj.action
    if ____switch15 == "farm_break" then
        goto ____switch15_case_0
    end
    goto ____switch15_case_default
    ::____switch15_case_0::
    do
        return __TS__New(TaskFarmBreak, obj, loc)
    end
    ::____switch15_case_default::
    do
        return nil
    end
    ::____switch15_end::
end
____exports.example = {config = {origin = {0, 0, 0}, axes = {"+x", "+z", "+y"}}, tasks = {{action = "farm_break", location = "h", timer = 30}}, layers = {{"sdddddddd", "sddwddwdd", "sdddddddd"}, {" HHHHHHHH", "cHH HH HH", "yHHHHHHHH"}, {" hhhhhhhh", " hh hh hh", " hhhhhhhh"}, {"         ", "         ", "         "}}}
function ____exports.parseVoxels(self, obj)
    local s2 = #obj.layers
    local s1 = #obj.layers[1]
    local s0 = #obj.layers[1][1]
    local voxels = __TS__New(VoxelMap)
    local axes_map = {x = 0, y = 1, z = 2}
    local _axis_perm = {-1, -1, -1}
    _axis_perm[axes_map[string.sub(obj.config.axes[1], 2, 2)]] = 0
    _axis_perm[axes_map[string.sub(obj.config.axes[2], 2, 2)]] = 1
    _axis_perm[axes_map[string.sub(obj.config.axes[3], 2, 2)]] = 2
    local _axis_sign = {-1, -1, -1}
    _axis_sign[1] = ((string.sub(obj.config.axes[_axis_perm[1] + 1], 1, 1) == "+") and 1) or -1
    _axis_sign[2] = ((string.sub(obj.config.axes[_axis_perm[2] + 1], 1, 1) == "+") and 1) or -1
    _axis_sign[3] = ((string.sub(obj.config.axes[_axis_perm[3] + 1], 1, 1) == "+") and 1) or -1
    local orig = obj.config.origin
    local function transform(self, v)
        local x = _axis_sign[1] * v[_axis_perm[1] + 1]
        local y = _axis_sign[2] * v[_axis_perm[2] + 1]
        local z = _axis_sign[3] * v[_axis_perm[3] + 1]
        return sum(nil, orig, {x, y, z})
    end
    do
        local i2 = 0
        while i2 < s2 do
            do
                local i1 = 0
                while i1 < s1 do
                    do
                        local i0 = 0
                        while i0 < s0 do
                            voxels:set(
                                transform(nil, {i0, i1, i2}),
                                {
                                    char = __TS__StringCharAt(obj.layers[i2 + 1][i1 + 1], i0)
                                }
                            )
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
        local task = ____exports.parseTask(nil, obj, loc)
        if task ~= nil then
            __TS__ArrayPush(tasks, task)
        end
    end
    return tasks
end
return ____exports
