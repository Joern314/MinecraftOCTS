--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____task = require("task")
local parseAreaMap = ____task.parseAreaMap
require("util2")
____exports.example = {blocks = {default = {passable = false}, [" "] = {passable = true}}, config = {origin = {0, 0, 0}, axes = {"+x", "+z", "+y"}}, tasks = {{action = "farm_break", location = "h", regrow_time = 30}}, layers = {{"sdddddddd", "sddwddwdd", "sdddddddd"}, {" HHHHHHHH", "cHH HH HH", "yHHHHHHHH"}, {" hhhhhhhh", " hh hh hh", " hhhhhhhh"}, {"         ", "         ", "         "}}}
local map, tasks = unpack(
    parseAreaMap(nil, ____exports.example)
)
return ____exports
