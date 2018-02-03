; Generated by AutoGUI 2.1.0a
#NoEnv
#SingleInstance Force

;~ MsgBox, %A_ScreenWidth%  %A_ScreenHeight%
SetFormat, float, 0.2
resolution := (A_ScreenWidth / A_ScreenHeight)
;~ MsgBox, %resolution%

System = %1%
Rom = %2%

SplitPath, A_ScriptDir,,,,, drive ;~ Get Drive Letter

path = ../../../Media/Other/Fade/%System%

filelist = 

loop, %path%/*.*, 2 ; get only folders 
FileList = %FileList%%A_LoopFileName%`,
Sort, FileList 


if Rom contains %FileList% ;~ Control if list contain Rom Name
	
	{
		Fade_Folder=../../../Media/Other/Fade/%System%/%Rom%/
	}
else
	{
		Fade_Folder=../../../Media/Other/Fade/%System%/_Default/
	}

IniRead, Duration, ../../Modules/Fade/Fade.ini, Timer, Duration


SetWorkingDir %A_ScriptDir%
Gui, 1:Margin , 0, 0
Gui, 1:+AlwaysOnTop -Border -SysMenu +Owner -Caption +ToolWindow
Gui Add, Picture, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%, %Fade_Folder%Layer 1.png
Gui Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%, Fade

;~FadeIn/Out
FADE := 1
Loop 61
{
FADE := FADE + 4
WinSet, Transparent, %FADE%, Fade

if Fade=5
{
winshow, Fade
winactivate, Fade
}
Sleep, 15
}
WinSet, Transparent, 255, Fade
WinSet, AlwaysOnTop, On

sleep, %Duration%

;~ FADE := 255
;~ Loop 61
;~ {
;~ FADE := FADE - 4
;~ WinSet, Transparent, %FADE%, Fade

;~ if Fade=5
;~ {
;~ winshow, Fade
;~ winactivate, Fade
;~ }
;~ Sleep, 15
;~ }
;~ WinSet, Transparent, 0, Fade


ExitApp