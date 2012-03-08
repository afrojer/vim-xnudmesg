" Vim syntax file
" Language: /proc/kmsg output on XNU development Linux kernels
" Maintainer: Jeremy C. Andrus <jchristian.andrus@gmail.com>
" Last Change: 2012-03-08
" URL: https://github.com/afrojer/vim-xnudmesg

" Setup
if version >= 600
	if exists("b:current_syntax")
		finish
	endif
else
	syntax clear
endif

syn case match

" Parse the line

syn region dmesgVerbosed start="(" end=")" matchgroup=Normal contained oneline
syn match dmesgFuncName "\]\s*[a-zA-Z_]\+:\s\s"ms=s+1,me=e-2 contained
syn match dmesgIPCFunc "\]\s*_X[a-zA-Z_]\+:\s\s"ms=s+1,me=e-2 contained
syn match dmesgAssign "[^\]]\s*\w\+[:=][^\s]"ms=s+1,me=e-2 contained
syn match dmesgSpecialChar "\\\d\d\d\|\\." contained
syn region dmesgString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=dmesgSpecialChar oneline contained
syn match dmesgNumber "\W[+-]\=\(\d\+\)\=\.\=\d\+\([eE][+-]\=\d\+\)\="lc=1 contained
syn match dmesgNumber "\W0x\x\+"lc=1 contained
syn match dmesgNumber "\W0x\s*(null)"lc=1 contained
syn match dmesgConstant "[A-Z_]\{2,}" contained
syn match dmesgOperator "[-+=*/!%&|:,><]" contained
syn match dmesgMachTrapStart "-----\strap\s\d\+\sSTART\s-----" contained
syn match dmesgMachTrapEnd "-----\strap\s\d\+\sEND\s-----" contained
syn match dmesgThinkDifferent "THINK\sDIFFERENT" contained
syn match dmesgThinkDifferent "think\sdifferent" contained
syn match dmesgPID "\]\s*\[\s*\d\+\]"ms=s+3,me=e-1
syn match dmesgNIsys "!! IOS[_]ni[_]syscall:"
syn match dmesgPortFrom "from\s0x\x\+" contained
syn match dmesgPortTo "to\s0x\x\+" contained
syn region dmesgXNUFunc start="\]\s*[a-zA-Z_]\+:\s\s" end="$" contains=dmesgPortFrom,dmesgPortTo,dmesgMachTrapStart,dmesgMachTrapEnd,dmesgOperator,dmesgSpecialChar,dmesgConstant,dmesgAssign,dmesgNumber,dmesgFuncName,dmesgIPCFunc,dmesgVerbosed,dmesgThinkDifferent oneline transparent

syn match dmesgTS "\[\s*\d\+\.\d\+\s*\]"ms=s+1,me=e-1 contained
syn region dmesgLvlDebug start="^<7>" end="\]"me=e-1 contains=dmesgTS oneline
syn region dmesgLvlInfo start="^<6>" end="\]"me=e-1 contains=dmesgTS oneline
syn region dmesgLvlInfo start="^<5>" end="\]"me=e-1 contains=dmesgTS oneline
syn region dmesgLvlWarn start="^<4>" end="\]"me=e-1 contains=dmesgTS oneline
syn region dmesgLvlErr start="^<3>" end="\]"me=e-1 contains=dmesgTS oneline

" Define the default highlighting
if version >= 508 || !exists("did_dmesg_syntax_inits")
	if version < 508
		let did_dmesg_syntax_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	let s:my_syncolor=0
	if !exists(':SynColor') 
		command -nargs=+ SynColor hi def <args>
		let s:my_syncolor=1
	endif

	"Todo Identifier
	HiLink dmesgVerbosed Comment
	HiLink dmesgNumber Number
	HiLink dmesgString String
	HiLink dmesgConstant Function
	HiLink dmesgAssign Macro
	HiLink dmesgFuncName Statement
	HiLink dmesgIPCFunc Structure
	HiLink dmesgOperator Operator
	HiLink dmesgSpecialChar Special
	HiLink dmesgPID PreProc
	HiLink dmesgTS Comment
	HiLink dmesgLvlDebug Comment
	HiLink dmesgLvlInfo Macro
	HiLink dmesgLvlWarn Include
	HiLink dmesgLvlErr Error
	HiLink dmesgXNUFunc Normal
	SynColor dmesgThinkDifferent guibg=#ffff00 guifg=#9a9a50
	SynColor dmesgMachTrapStart guibg=#2a312a guifg=#2a8a2a gui=italic
	SynColor dmesgMachTrapEnd guibg=#312a2a guifg=#8a2a2a gui=italic
	SynColor dmesgPortFrom guibg=#000044 guifg=#5555ff gui=bold
	SynColor dmesgPortTo guibg=#004400 guifg=#00aa00 gui=bold
	SynColor dmesgNIsys guibg=firebrick3 guifg=Black gui=bold,italic

	if !exists(':PidLog')
		:command -nargs=1 PidLog :v/\[\s*<args>\]/d
	endif

	delcommand HiLink
	delcommand SynColor
endif

let b:current_syntax = "dmesg"
