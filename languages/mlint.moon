-- calls `moonc -l` and adjusts the output so it's Kakoune-friendly

-- `moonc -l` outputs:
--     no warnings or error: nothing
--     anything: starts with a filename

--     error:
--         Failed to parse:
--          [<line>] >> <text>
--     any warnings:
--         line <line>: <warning>
--         =============================
--         > <text>
--
--         <...and so on>

-- to avoid a lint warning on this very file
arg = arg

-- it outputs to stderr for some reason :/
with assert io.popen "moonc -l #{arg[1]} 2>&1"
	fname = \read!

	if fname
		if \read!\find "^Failed to parse:$"
			line = \read!\match "%[(%d+)%] >>"
			io.write "#{fname}:#{line}:1: error: failed to parse \n"
		else
			warnings = {}
			while true
				l = \read!
				break unless l
				line, msg = l\match "line (%d+): (.+)"
				continue unless msg and line
				table.insert warnings, :msg, :line

			io.write "#{fname}:#{w.line}:1: warning: #{w.msg} \n" for w in *warnings

	\close!
