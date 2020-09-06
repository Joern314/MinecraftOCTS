--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
function ____exports.Failure(self, ____error)
    return {success = false, error = ____error}
end
function ____exports.Success(self, value)
    return {success = true, value = value}
end
function ____exports.isFailure(self, obj)
    return not obj.success
end
function ____exports.isSuccess(self, obj)
    return obj.success
end
return ____exports
