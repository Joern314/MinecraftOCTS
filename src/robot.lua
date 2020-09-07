function stub(name)
    return function ()
        print(name)
        return true, nil
    end
end

local funs = {"up","down","forward","back","turnLeft","turnRight","turnAround","swingDown","swingForward","swingUp"}

local robot = {}

local _, f
for _, f in ipairs(funs) do
    robot[f] = stub(f)
end

return robot