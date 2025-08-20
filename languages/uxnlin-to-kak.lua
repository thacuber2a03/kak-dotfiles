#!/usr/bin/env lua

local proc = assert(io.popen(string.format(
    "uxncli %s/uxnlin.rom 2>&1 %s",
    os.getenv "UXN_ROMS_DIR",
    arg[1]
)))

while true do
    local line = assert(proc:read "*l")
    if line:match "^Linted" then break end
    local warning, file, line = line:match "%-%- (.-), in .-, at (.-):(%d+)"
    if not (warning or file or line) then
        io.write "couldn't match warning/file/line"
        os.exit(false)
    end
    io.write(file, ":", line, ":1: : ", warning, "\n")
end
