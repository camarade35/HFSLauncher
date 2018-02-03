#SingleInstance Force

SplitPath, A_ScriptDir,,,,, drive ;~ Get Drive Letter

SetWorkingDir %A_ScriptDir%

System = %1% ;~System send by Z-Spin
Rom = %2% ;~Rom send by Z-Spin

Bezel_Path = "" ;~Bezel Folder
Fade_Path = ../../Modules/Fade/Fade.ahk
7zip = ../../../Utilities/7zip/7z.exe ;~ 7zip Exe

SetFormat, float, 6.2 ;~ Cut and around Screen Width/Height divide
resolution:= (A_ScreenWidth/A_ScreenHeight) ;~calcul ratio resolution


If (resolution = 1.6) ;~ resolution 16/10
{
	Bezel_Path = ../../../Media/Other/Bezel/1.6	
}

If (resolution = 1.78) ;~ resolution 16/9
{
	Bezel_Path = ../../../Media/Other/Bezel/1.78
}

If (resolution = 1.33) ;~ resolution 4/3
{
	Bezel_Path = ../../../Media/Other/Bezel/1.33
}

If (resolution = 1.25) ;~ resolution 5/4
{
	Bezel_Path = ../../../Media/Other/Bezel/1.25
}

IniRead, Emulator, ../../Settings/%System%/%System%.ini, System, Emulator ;~Name Emulator

IniRead, Duration, ../../Modules/Fade/Fade.ini, Timer, Duration ;~Fade Duration

IniRead, Emulator_Path, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, Emulator_Path ;~Emulator Path
IniRead, Emulator_Launch, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, Emulator_Launch ;~Emulator Launch
IniRead, Core_Path, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, Core_Path ;~Core Path
IniRead, Config_Path, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, Config_Path ;~Config Path

IniRead, Roms_Path, ../../Settings/%System%/%System%.ini, System, Roms_Path ;~Roms Path
IniRead, Roms_Ext, ../../Settings/%System%/%System%.ini, System, Roms_Ext ;~Roms Extension

IniRead, Bezel, ../../Settings/%System%/%System%.ini, Options, Bezel ;~Bezel option (false,true)
IniRead, Fade, ../../Settings/%System%/%System%.ini, Options, Fade ;~Fade option (false,true)

IniRead, Config, ../../Settings/%System%/%System%.ini, System, Config ;~Config
IniRead, Core, ../../Settings/%System%/%System%.ini, System, Core ;~Core use for System



;~~~~~~~~~~~~BEZEL~~~~~~~~~~~;

Bezel:

if (Bezel = "true") ;~ Set Bezel
{
	FileDelete, %Emulator_Path%\overlays\%System%\Bezel.png
	FileCopy, %Bezel_Path%\%Emulator%\%System%\Bezel.png, %Emulator_Path%\overlays\%System%, 1
}

else ;~ No Bezel
{
	FileDelete, %Emulator_Path%\overlays\%System%\Bezel.png
}


	SetWorkingDir %Emulator_Path% ;~Launch Other

	Run, %Emulator_Launch% -L %Core_Path%/%Core% "%Roms_Path%/%Rom%.%Roms_Ext%",,WinMinimize,RetroArch
	Sleep, 300
	SetTitleMatchMode, 1
	WinMinimize, Retro
	
	;~~~~~~~~~~~FADE~~~~~~~~~~~~~~;
	
	if (Fade = "true") ;~Fade
{
	SetWorkingDir %A_ScriptDir%
	Run, "..\..\Modules\Fade\Fade.ahk" "%System%" "%Rom%"  , ;~ Fade.ahk in script Folder
}

Sleep, %Duration%

SetTitleMatchMode, 1
WinMaximize, Retro

	
ExitApp