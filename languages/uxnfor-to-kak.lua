#!/usr/bin/env lua

math.randomseed(os.time())

-- stolen from https://github.com/rxi/lume, lol
local function uuid()
    local fn = function(x)
        local r = math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

local tmp = string.format(".uxnfor_temp_%s.tal", uuid())

local f = assert(io.open(tmp, "w+b"))
f:write(io.read "*a")
f:close()

local proc = assert(io.popen(string.format(
    "uxncli %s/uxnfor.rom %s",
    os.getenv "UXN_ROMS_DIR", tmp
)))

local res = proc:read "*l"
if res ~= nil then
    io.write("error:", res, "\n")
    os.exit(false)
end

f = assert(io.open(tmp, "rb"))
io.write(f:read "*a")
f:close()
os.execute("rm '" .. tmp .. "'")
