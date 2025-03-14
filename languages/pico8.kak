provide-module pico8 %{
	require-module lua

	add-highlighter shared/pico8 regions

	add-highlighter shared/pico8/header region 'pico-8 cartridge // http://www.pico-8.com' (?=__) group
	add-highlighter shared/pico8/header/ fill +b@Default
	add-highlighter shared/pico8/header/ regex '^(version) (\d+)$' 1:meta 2:value

	add-highlighter shared/pico8/lua region __lua__\K (?=__) group
	add-highlighter shared/pico8/lua/ ref lua
	add-highlighter shared/pico8/lua/ regex '^-->8$' 0:meta

	add-highlighter shared/pico8/gfx region __gfx__\K (?=__) group
	add-highlighter shared/pico8/gfx/0 regex '0' 0:rgb:000000,rgb:000000
	add-highlighter shared/pico8/gfx/1 regex '1' 0:rgb:1d2b53,rgb:1d2b53
	add-highlighter shared/pico8/gfx/2 regex '2' 0:rgb:7e2553,rgb:7e2553
	add-highlighter shared/pico8/gfx/3 regex '3' 0:rgb:008751,rgb:008751
	add-highlighter shared/pico8/gfx/4 regex '4' 0:rgb:ab5236,rgb:ab5236
	add-highlighter shared/pico8/gfx/5 regex '5' 0:rgb:5f574f,rgb:5f574f
	add-highlighter shared/pico8/gfx/6 regex '6' 0:rgb:c2c3c7,rgb:c2c3c7
	add-highlighter shared/pico8/gfx/7 regex '7' 0:rgb:fff1e8,rgb:fff1e8
	add-highlighter shared/pico8/gfx/8 regex '8' 0:rgb:ff004d,rgb:ff004d
	add-highlighter shared/pico8/gfx/9 regex '9' 0:rgb:ffa300,rgb:ffa300
	add-highlighter shared/pico8/gfx/a regex 'a' 0:rgb:ffec27,rgb:ffec27
	add-highlighter shared/pico8/gfx/b regex 'b' 0:rgb:00e436,rgb:00e436
	add-highlighter shared/pico8/gfx/c regex 'c' 0:rgb:29adff,rgb:29adff
	add-highlighter shared/pico8/gfx/d regex 'd' 0:rgb:83769c,rgb:83769c
	add-highlighter shared/pico8/gfx/e regex 'e' 0:rgb:ff77a8,rgb:ff77a8
	add-highlighter shared/pico8/gfx/f regex 'f' 0:rgb:ffccaa,rgb:ffccaa

	add-highlighter shared/pico8/map region __map__\K (?=__) group
	add-highlighter shared/pico8/map/0 regex '(\d0)' 0:rgb:000000,rgb:000000
	add-highlighter shared/pico8/map/1 regex '(\d1)' 0:rgb:1d2b53,rgb:1d2b53
	add-highlighter shared/pico8/map/2 regex '(\d2)' 0:rgb:7e2553,rgb:7e2553
	add-highlighter shared/pico8/map/3 regex '(\d3)' 0:rgb:008751,rgb:008751
	add-highlighter shared/pico8/map/4 regex '(\d4)' 0:rgb:ab5236,rgb:ab5236
	add-highlighter shared/pico8/map/5 regex '(\d5)' 0:rgb:5f574f,rgb:5f574f
	add-highlighter shared/pico8/map/6 regex '(\d6)' 0:rgb:c2c3c7,rgb:c2c3c7
	add-highlighter shared/pico8/map/7 regex '(\d7)' 0:rgb:fff1e8,rgb:fff1e8
	add-highlighter shared/pico8/map/8 regex '(\d8)' 0:rgb:ff004d,rgb:ff004d
	add-highlighter shared/pico8/map/9 regex '(\d9)' 0:rgb:ffa300,rgb:ffa300
	add-highlighter shared/pico8/map/a regex '(\da)' 0:rgb:ffec27,rgb:ffec27
	add-highlighter shared/pico8/map/b regex '(\db)' 0:rgb:00e436,rgb:00e436
	add-highlighter shared/pico8/map/c regex '(\dc)' 0:rgb:29adff,rgb:29adff
	add-highlighter shared/pico8/map/d regex '(\dd)' 0:rgb:83769c,rgb:83769c
	add-highlighter shared/pico8/map/e regex '(\de)' 0:rgb:ff77a8,rgb:ff77a8
	add-highlighter shared/pico8/map/f regex '(\df)' 0:rgb:ffccaa,rgb:ffccaa

	add-highlighter shared/pico8/label region __label__\K (?=__) ref pico8/gfx

	add-highlighter shared/pico8/ default-region fill +b@Default
}

hook global BufCreate .*\.p8 %{
	set-option buffer filetype pico8
}

hook -group pico8-highlight global WinSetOption filetype=pico8 %{
	require-module pico8
	add-highlighter window/pico8 ref pico8
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/pico8
	}
}
