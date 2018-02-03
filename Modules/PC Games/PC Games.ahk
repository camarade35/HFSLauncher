#SingleInstance Force

System = %1%
Rom = %2%

SetWorkingDir %A_ScriptDir%

IniRead, Duration, ../../Modules/Fade/Fade.ini, Timer, Duration ;~Fade Duration

IniRead, Fade, ../../Settings/%System%/%System%.ini, System, Fade ;~Folder exe localise Exe Game

IniRead, Folder, ../../Settings/%System%/%System%.ini, %Rom%, Folder ;~Folder exe localise Exe Game
IniRead, Launch, ../../Settings/%System%/%System%.ini, %Rom%, Launch ;~File to Launch Exe Game

if (Fade = "true") ;~Fade
{
	RunWait, "..\..\Modules\Fade\Fade.ahk" "%System%" "%Rom%"  , ;~ Fade.ahk in script Folder
}

SetWorkingDir, %Folder%
Run, %Launch%

ExitApp