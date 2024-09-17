Config { font = "-*-Fixed-Bold-R-Normal-*-13-*-*-*-*-*-*-*"
	, additionalFonts = [ "xft:FontAwesome:pixelsize=13" ]
        , borderColor = "black"
        , border = TopB
        , bgColor = "black"
        , fgColor = "grey"
        , position = TopW L 100
        , commands = [ Run Weather "CYVR" ["-t","<tempC>C","-L","18","-H","25","--normal","green","--high","red","--low","lightblue"] 36000
                        , Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
                        , Run Memory ["-t","Mem: <usedratio>%"] 10
                        , Run Swap [] 10
			, Run DiskIO [("/", "R:<read> W:<write>"), ("sda", "<total>")] [] 10
			, Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
			, Run Com "curl" ["ru.wttr.in/?format=%C+%t"] "wttr" 600
                        , Run StdinReader
                        ]
        , sepChar = "%"
        , alignSep = "}{"
        , template = "%StdinReader% | %cpu% | %memory% * %swap% | %diskio%}{<fc=#ee9a00>%date%</fc> | %wttr% |"
        }


--<fn=1>%wttr%</fn> 
