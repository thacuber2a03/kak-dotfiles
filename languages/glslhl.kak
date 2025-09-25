provide-module glsl %§
	add-highlighter shared/glsl regions

	add-highlighter shared/glsl/code default-region group
	add-highlighter shared/glsl/ region %{(?<!')(?<!'\\\\)"} %{(?<!\\\\)(?:\\\\\\\\)*"} fill string
	add-highlighter shared/glsl/ region /\*(\*[^/]|!) \*/ fill documentation
	add-highlighter shared/glsl/ region //[/!] $ fill documentation
	add-highlighter shared/glsl/ region /\\* \\*/ fill comment
	add-highlighter shared/glsl/ region // (?<!\\\\)(?=\\n) fill comment
	add-highlighter shared/glsl/ region -recurse "#\\h*if(?:def)?" ^\\h*?#\\h*if\\h+(?:0|FALSE)\\b "#\\h*(?:else|elif|endif)" fill comment
	add-highlighter shared/glsl/ region %{^\\h*\\K#\\h*(?:define|elif|if)(?=\\h)} %{(?<!\\\\)(?=\\s)|(?=//)} fill meta

	add-highlighter shared/glsl/macro region %{^\\h*#} %{(?<!\\\\)(?=\\n)|(?=//)} group
	add-highlighter shared/glsl/macro/ regex ^\\h*(#\\h*\\S*) 1:meta
	add-highlighter shared/glsl/macro/ regex ^\\h*#\\h*include\\h+(<[^>]*>|"(?:[^"\\\\]|\\\\.)*") 1:module
	add-highlighter shared/glsl/macro/ regex /\\*.*?\\*/ 0:comment

	add-highlighter shared/glsl/code/ regex '[\+\-=/\*\^%<>!~\|&]' 0:operator

	add-highlighter shared/glsl/code/ regex '\bgl_\w+\b' 0:keyword

	evaluate-commands %sh{
		# Grammar
		keywords='if else do while for break continue return const switch case default const
		          attribute varying uniform buffer shared layout centroid flat smooth noperspective
		          patch sample in out inout invariant precise lowp mediump highp precision struct
		          subroutine'

		types='void bool int uint atomic_uint float double
		       bvec2 ivec2 uvec2 vec2 dvec2
		       bvec3 ivec3 uvec3 vec3 dvec3
		       bvec4 ivec4 uvec4 vec4 dvec4
		       mat2x2 mat2x3 mat2x4
		       mat3x2 mat3x3 mat3x4
		       mat4x2 mat4x3 mat4x4
		       mat2 mat3 mat4
		       sampler1D sampler2D sampler3D samplerCube sampler2DRect
		       sampler1DArray sampler2DArray samplerCubeArray samplerBuffer
		       sampler2DMS sampler2DMSArray
		       isampler1D isampler2D isampler3D isamplerCube isampler2DRect
		       isampler1DArray isampler2DArray isamplerCubeArray isamplerBuffer
		       isampler2DMS isampler2DMSArray
		       usampler1D usampler2D usampler3D usamplerCube usampler2DRect
		       usampler1DArray usampler2DArray usamplerCubeArray usamplerBuffer
		       usampler2DMS usampler2DMSArray
		       image1D image2D image3D imageCube image2DRect image1DArray
		       image2DArray imageCubeArray imageBuffer image2DMS image2DMSArray
		       uimage1D uimage2D uimage3D uimageCube uimage2DRect uimage1DArray
		       uimage2DArray uimageCubeArray uimageBuffer uimage2DMS uimage2DMSArray
		       iimage1D iimage2D iimage3D iimageCube iimage2DRect iimage1DArray
		       iimage2DArray iimageCubeArray iimageBuffer iimage2DMS iimage2DMSArray'

		values='true false NULL'

		functions='radians degrees sin cos tan asin acos atan sinh cosh tanh asinh acosh pow
		           exp exp2 log2 sqrt inversesqrt abs sign floor trunc round roundEven ceil
		           fract mod modf min max clamp mix step smoothstep isnan isinf floatBitsToInt
		           floatBitsToUint intBitsToFloat uintBitsToFloat fma frexp ldexp packUnorm2x16
		           packSnorm2x16 packUnorm4x8 packSnorm4x8 unpackUnorm2x16 unpackSnorm2x16
		           unpackUnorm4x8 unpackSnorm4x8 packHalf2x16 unpackHalf2x16 packDouble2x32
		           unpackDouble2x32 length distance dot cross normalize ftransform faceforward
		           reflect refract matrixCompMult outerProduct transpose determinant inverse
		           lessThan lessThanEqual greaterThan greaterThanEqual equal notEqual any all not
		           uaddCarry usubBorrow umulExtended imulExtended bitfieldExtract bitfieldInsert
		           bitfieldReverse bitCount findLSB findMSB textureSize textureQueryLod
		           textureQueryLevels textureSamples texture textureProj textureLod textureOffset
		           texelFetch texelFetchOffset textureProjOffset textureLodOffset textureProjLod
		           textureProjLodOffset textureGrad textureGradOffset textureProjGrad
		           textureProjGradOffset textureGather textureGatherOffset textureGatherOffsets
		           atomicCounterIncrement atomicCounterDecrement atomicCounter atomicCounterAdd
		           atomicCounterSubtract atomicCounterMin atomicCounterMax atomicCounterAnd
		           atomicCounterOr atomicCounterXor atomicCounterExchange atomicCounterCompSwap
		           atomicAdd atomicMin atomicMax atomicAnd atomicOr atomicXor atomicExchange
		           atomicCompSwap imageSize imageSamples imageLoad imageStore imageAtomicAdd
		           imageAtomicMin imageAtomicMax imageAtomicAnd imageAtomicOr imageAtomicXor
		           imageAtomicExchange imageAtomicCompSwap EmitStreamVertex EndStreamPrimitive
		           EmitVertex EndPrimitive dFdx dFdy dFdxFine dFdyFine dFdxCoarse dFdyCoarse
		           fwidth fwidthFine fwidthCoarse interpolateAtCentroid interpolateAtSample
		           interpolateAtOffset barrier memoryBarrier memoryBarrierAtomicCounter
		           memoryBarrierBuffer memoryBarrierShared memoryBarrierImage groupMemoryBarrier
		           subpassLoad anyInvocation allInvocations allInvocationsEqual'

		join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

		# Add the language's grammar to the static completion list
		printf %s\\n "declare-option str-list glsl_static_words $(join "${keywords} ${attributes} ${types} ${values} ${functions}" ' ')"

		# Highlight keywords
		printf %s "
		    add-highlighter shared/glsl/code/keyword   regex \b($(join "${keywords}" '|'))\b 0:keyword
		    add-highlighter shared/glsl/code/attribute regex \b($(join "${attributes}" '|'))\b 0:attribute
		    add-highlighter shared/glsl/code/type      regex \b($(join "${types}" '|'))\b 0:type
		    add-highlighter shared/glsl/code/value     regex \b($(join "${values}" '|'))\b 0:value
		    add-highlighter shared/glsl/code/builtin   regex \b($(join "${functions}" '|'))\b 0:builtin
		"
	}

	define-command -hidden glsl-trim-indent %{
	    # remove the line if it's empty when leaving the insert mode
	    try %{ execute-keys -draft x 1s^(\h+)$<ret> d }
	}

	define-command -hidden glsl-indent-on-newline %< evaluate-commands -draft -itersel %<
	    execute-keys <semicolon>
	    try %<
	        # if previous line is part of a comment, do nothing
	        execute-keys -draft <a-?>/\*<ret> <a-K>^\h*[^/*\h]<ret>
	    > catch %<
	        # else if previous line closed a paren (possibly followed by words and a comment),
	        # copy indent of the opening paren line
	        execute-keys -draft kx 1s(\))(\h+\w+)*\h*(\;\h*)?(?://[^\n]+)?\n\z<ret> m<a-semicolon>J <a-S> 1<a-&>
	    > catch %<
	        # else indent new lines with the same level as the previous one
	        execute-keys -draft K <a-&>
	    >
	    # remove previous empty lines resulting from the automatic indent
	    try %< execute-keys -draft k x <a-k>^\h+$<ret> Hd >
	    # indent after an opening brace or parenthesis at end of line
	    try %< execute-keys -draft k x <a-k>[{(]\h*$<ret> j <a-gt> >
	    # indent after a label
	    try %< execute-keys -draft k x s[a-zA-Z0-9_-]+:\h*$<ret> j <a-gt> >
	    # indent after a statement not followed by an opening brace
	    try %< execute-keys -draft k x s\)\h*(?://[^\n]+)?\n\z<ret> \
	                               <a-semicolon>mB <a-k>\A\b(if|for|while)\b<ret> <a-semicolon>j <a-gt> >
	    try %< execute-keys -draft k x s \belse\b\h*(?://[^\n]+)?\n\z<ret> \
	                               j <a-gt> >
	    # deindent after a single line statement end
	    try %< execute-keys -draft K x <a-k>\;\h*(//[^\n]+)?$<ret> \
	                               K x s\)(\h+\w+)*\h*(//[^\n]+)?\n([^\n]*\n){2}\z<ret> \
	                               MB <a-k>\A\b(if|for|while)\b<ret> <a-S>1<a-&> >
	    try %< execute-keys -draft K x <a-k>\;\h*(//[^\n]+)?$<ret> \
	                               K x s \belse\b\h*(?://[^\n]+)?\n([^\n]*\n){2}\z<ret> \
	                               <a-S>1<a-&> >
	    # deindent closing brace(s) when after cursor
	    try %< execute-keys -draft x <a-k> ^\h*[})] <ret> gh / [})] <esc> m <a-S> 1<a-&> >
	    # align to the opening parenthesis or opening brace (whichever is first)
	    # on a previous line if its followed by text on the same line
	    try %< evaluate-commands -draft %<
	        # Go to opening parenthesis and opening brace, then select the most nested one
	        try %< execute-keys [c [({],[)}] <ret> >
	        # Validate selection and get first and last char
	        execute-keys <a-k>\A[{(](\h*\S+)+\n<ret> <a-K>"(([^"]*"){2})*<ret> <a-K>'(([^']*'){2})*<ret> <a-:><a-semicolon>L <a-S>
	        # Remove possibly incorrect indent from new line which was copied from previous line
	        try %< execute-keys -draft , <a-h> s\h+<ret> d >
	        # Now indent and align that new line with the opening parenthesis/brace
	        execute-keys 1<a-&> &
	     > >
	> >

	define-command -hidden glsl-indent-on-opening-curly-brace %[
	    # align indent with opening paren when { is entered on a new line after the closing paren
	    try %[ execute-keys -draft -itersel h<a-F>)M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> <a-S> 1<a-&> ]
	    # align indent with opening paren when { is entered on a new line after the else
	    try %[ execute-keys -draft -itersel hK x s \belse\b\h*(?://[^\n]+)?\n\h*\{<ret> <a-S> 1<a-&> ]
	]

	define-command -hidden glsl-indent-on-closing-curly-brace %[
	    evaluate-commands -draft -itersel -verbatim try %[
	        # check if alone on the line and select to opening curly brace
	        execute-keys <a-h><a-:><a-k>^\h+\}$<ret>hm
	        try %[
	            # in case open curly brace follows a closing paren possibly with qualifiers, extend to opening paren
	            execute-keys -draft <a-f>) <a-k> \A\)(\h+\w+)*\h*\{\z <ret>
	            execute-keys <a-F>)M
	        ]
	        # align to selection start
	        execute-keys <a-S>1<a-&>
	    ]
	]

	define-command -hidden glsl-insert-on-closing-curly-brace %[
	    # add a semicolon after a closing brace if part of a class, union or struct definition
	    evaluate-commands -itersel -draft -verbatim try %[
	        execute-keys -draft hmh <a-?>\b(class|struct|union|enum)\b<ret> <a-K>\{<ret> <a-K>\)(\s+\w+)*\s*\z<ret>
	        execute-keys -draft ';i;<esc>'
	    ]
	]

	define-command -hidden glsl-insert-on-newline %[ evaluate-commands -itersel -draft %[
	    execute-keys <semicolon>
	    try %[
	        evaluate-commands -draft -save-regs '/"' %[
	            # copy the commenting prefix
	            execute-keys -save-regs '' k x1s^\h*(//+\h*)<ret> y
	            try %[
	                # if the previous comment isn't empty, create a new one
	                execute-keys x<a-K>^\h*//+\h*$<ret> jxs^\h*<ret>P
	            ] catch %[
	                # if there is no text in the previous comment, remove it completely
	                execute-keys d
	            ]
	        ]

	        # trim trailing whitespace on the previous line
	        try %[ execute-keys -draft k x s\h+$<ret> d ]
	    ]
	    try %[
	        # if the previous line isn't within a comment scope, break
	        execute-keys -draft kx <a-k>^(\h*/\*|\h+\*(?!/))<ret>

	        # find comment opening, validate it was not closed, and check its using star prefixes
	        execute-keys -draft <a-?>/\*<ret><a-H> <a-K>\*/<ret> <a-k>\A\h*/\*([^\n]*\n\h*\*)*[^\n]*\n\h*.\z<ret>

	        try %[
	            # if the previous line is opening the comment, insert star preceeded by space
	            execute-keys -draft kx<a-k>^\h*/\*<ret>
	            execute-keys -draft i*<space><esc>
	        ] catch %[
	           try %[
	                # if the next line is a comment line insert a star
	                execute-keys -draft jx<a-k>^\h+\*<ret>
	                execute-keys -draft i*<space><esc>
	            ] catch %[
	                try %[
	                    # if the previous line is an empty comment line, close the comment scope
	                    execute-keys -draft kx<a-k>^\h+\*\h+$<ret> x1s\*(\h*)<ret>c/<esc>
	                ] catch %[
	                    # if the previous line is a non-empty comment line, add a star
	                    execute-keys -draft i*<space><esc>
	                ]
	            ]
	        ]

	        # trim trailing whitespace on the previous line
	        try %[ execute-keys -draft k x s\h+$<ret> d ]
	        # align the new star with the previous one
	        execute-keys Kx1s^[^*]*(\*)<ret>&
	    ]
	] ]
§

hook global BufCreate .+\.glsl %{ set-option buffer filetype glsl }

hook global WinSetOption filetype=glsl %[
	require-module glsl

    hook -group glsl-trim-indent window ModeChange pop:insert:.* glsl-trim-indent

    hook -group glsl-insert window InsertChar \n glsl-insert-on-newline
    hook -group glsl-indent window InsertChar \n glsl-indent-on-newline
    hook -group glsl-indent window InsertChar \{ glsl-indent-on-opening-curly-brace
    hook -group glsl-indent window InsertChar \} glsl-indent-on-closing-curly-brace
    hook -group glsl-insert window InsertChar \} glsl-insert-on-closing-curly-brace

	set-option buffer static_words %opt{glsl_static_words}

	hook -once -always window WinSetOption filetype=.* %{
		remove-hooks window glsl-.+
		unalias window alt glsl-alternative-file
	}
]

hook -group glsl-highlight global WinSetOption filetype=glsl %{
	add-highlighter window/glsl ref glsl
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/glsl
	}
}
