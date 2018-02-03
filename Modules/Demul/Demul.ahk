#SingleInstance Force

SplitPath, A_ScriptDir,,,,, drive ;~ Get Drive Letter

SetWorkingDir %A_ScriptDir%

System = %1% ;~System send by Z-Spin
Rom = %2% ;~Rom send by Z-Spin

if System contains atomiswave
{
	Run, "Atomiswave.ahk" "%System%" "%Rom%" , 
}



ExitApp






