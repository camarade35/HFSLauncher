#SingleInstance Force

System = %1% ;~System send by Z-Spin
Rom = %2% ;~Rom send by Z-Spin

IniRead, Emulator, %A_ScriptDir%/Settings/%System%/%System%.ini, System, Emulator
IniRead, Roms_Path, %A_ScriptDir%/Settings/%System%/%System%.ini, System, Roms


Run, "%A_ScriptDir%\Modules\%Emulator%\%Emulator%.ahk" "%System%" "%Rom%" ,
ExitApp

