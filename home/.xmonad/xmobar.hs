-- xmobar config used by Andrew Seidl, inspired by Vic Fryzel
-- Author: Vic Fryzel
-- Modified by: Andrew Seidl <fersla>
-- http://github.com/fersla/xmonad-config
-- https://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1080 monitors
Config {
    font = "xft:Fixed-8",
    bgColor = "#002b36",
    fgColor = "#657b83",
    position = Static { xpos = 0, ypos = 0, width = 2560, height = 10 },
    lowerOnStart = True,
    commands = [
        Run Weather "KMSN" ["-t","<tempF>F <skyCondition>","-L","64","-H","77","-n","#CEFFAC","-h","#FFB6B0","-l","#96CBFE"] 3600,
        Run MultiCpu ["-t","Cpu: <autototal>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Network "eth0" ["-t","Net: <tx> <rx>","-H","200","-L","10","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Date "%a %b %_d %l:%M" "date" 10,
        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %multicpu%   %memory%   %eth0%   <fc=#FFFFCC>%date%</fc>   %KMSN%"
}
