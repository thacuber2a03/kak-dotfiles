# option names taken directly from the original
declare-option -hidden str duotone_background 'rgb:151515'
declare-option -hidden str duotone_background2 'rgb:151515'
declare-option -hidden str duotone_background3 'rgb:151515'
declare-option -hidden str duotone_text 'rgb:707070'
declare-option -hidden str duotone_caret 'rgb:dfdfdf'
declare-option -hidden str duotone_accent 'rgb:d0d0d0'
declare-option -hidden str duotone_tone 'rgb:01a870'
declare-option -hidden str duotone_white 'rgb:dfdfdf'

face global value %opt{duotone_white}
face global type %opt{duotone_white}
face global variable 'rgb:a0a0a0'
face global module %opt{duotone_tone}
face global function %opt{duotone_tone}
face global string %opt{duotone_white}
face global keyword %opt{duotone_white}
face global operator %opt{duotone_tone}
face global attribute %opt{duotone_tone}
face global comment 'rgb:404040'
face global documentation +b@comment
face global meta %opt{duotone_tone}
face global builtin 'rgb:dfdfdf+b'

face global title %opt{duotone_tone}
face global header %opt{duotone_tone}
face global mono %opt{duotone_white}
face global block %opt{duotone_tone}
face global link %opt{duotone_tone}
face global bullet %opt{duotone_white}
face global list %opt{duotone_white}

# builtin faces
face global Default rgb:dfdfdf,rgb:151515
face global PrimarySelection white,blue+fg
face global SecondarySelection black,blue+fg
face global PrimaryCursor black,white+fg
face global SecondaryCursor black,white+fg
face global PrimaryCursorEol black,cyan+fg
face global SecondaryCursorEol black,cyan+fg
face global LineNumbers default,rgb:252525
face global LineNumberCursor default,rgb:444444
face global MenuForeground "rgb:151515,%opt{duotone_white}"
face global MenuBackground "%opt{duotone_white},rgb:151515"
face global MenuInfo cyan
face global Information black,yellow
face global Error black,red
face global DiagnosticError red
face global DiagnosticWarning yellow
face global StatusLine "%opt{duotone_white},default"
face global StatusLineMode "%opt{duotone_tone},default"
face global StatusLineInfo "%opt{duotone_tone},default"
face global StatusLineValue "%opt{duotone_tone},default"
face global StatusCursor black,cyan
face global Prompt "%opt{duotone_tone},default"
face global MatchingChar default,default+b
face global Whitespace default,default+fd
face global BufferPadding "%opt{duotone_white},default"
