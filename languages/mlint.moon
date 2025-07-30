-- calls 'moonc -l' and adjusts the output so it's Kakoune-friendly

-- to avoid a lint warning on this very file
arg = arg

-- it outputs to stderr for some reason :/
f = assert io.popen "moonc -l #{arg[1]} 2>&1"
fname = f\read!

if l = f\read!
	if l\find "Failed"
		line = f\read!\match "%[(%d+)%] >>"
		io.write "#{fname}:#{line}:1: error: failed to parse\n"
	else
		warnings = {}
		while l
			line, msg = l\match "line (%d+): (.+)"
			continue unless msg and line
			table.insert warnings, :msg, :line
			l = f\read!

		-- kind doesn't have to have anything at all :P
		io.write "#{fname}:#{w.line}:1: : #{w.msg}\n" for w in *warnings

f\close!
