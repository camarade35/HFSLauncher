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

IniRead, Emulator, ../../Settings/%System%/%System%.ini, System, Emulator

IniRead, Duration, ../../Modules/Fade/Fade.ini, Timer, Duration ;~Fade Duration

IniRead, Emulator_Path, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, Emulator_Path ;~Emulator Path
IniRead, Emulator_Launch, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, Emulator_Launch ;~Emulator Launch

IniRead, Roms_Path, ../../Settings/%System%/%System%.ini, System, Roms ;~Roms Path

IniRead, Bezel, ../../Settings/%System%/%System%.ini, Options, Bezel ;~Bezel option (false,true)
IniRead, Fade, ../../Settings/%System%/%System%.ini, Options, Fade ;~Fade option (false,true)

IniRead, Scanlines, ../../Settings/%System%/%System%.ini, Video, Scanlines ;~Scanline option (false/true)
IniRead, HLSL, ../../Settings/%System%/%System%.ini, Video, HLSL ;~HLSL enable (false,true)
IniRead, GLSL, ../../Settings/%System%/%System%.ini, Video, GLSL ;~Video option (d3d,opengl,gdi)

IniRead, Special_Games, ../../Settings/%System%/%System%.ini, Games, Games ;~HLSL enable (false,true)
IniRead, Scanlines_SG, ../../Settings/%System%/%System%.ini, Games, Scanlines ;~Scanline option (false/true)
IniRead, HLSL_SG, ../../Settings/%System%/%System%.ini, Games, HLSL ;~HLSL enable (false,true)
IniRead, GLSL_SG, ../../Settings/%System%/%System%.ini, Games, GLSL ;~GLSL enable (false,true)

IniRead, Vertical_Games, ../../Settings/%System%/%System%.ini, Vertical, Games ;~List of Vertical Games

IniRead, Exe_Games, ../../Settings/%System%/%System%.ini, Exe_Games, Exe_Games ;~List of Exe Game (ds2 in Cave for exemple)
IniRead, Folder, ../../Settings/%System%/%System%.ini, %Rom%, Folder ;~Folder exe localise Exe Game
IniRead, Launch, ../../Settings/%System%/%System%.ini, %Rom%, Launch ;~File to Launch Exe Game


;~~~~~~~~~~~~Special Games Video Options~~~~~~~~~;

If Rom in %Special_Games% ;~ for vertical game, the namefile must be "System V.zip"
	{
		if (Scanlines_SG = "true") ;~Scanline
		{
			Scanlines = true
		}
		if (HLSL_SG = "true") ;~HLSL
		{
			HLSL = true
		}
		if (GLSL_SG = "true") ;~GLSL
		{
			GLSL = true
		}
	}


;~~~~~~~~~~~~~Scanlines~~~~~~~~~~;


if (Scanlines = "true") ;~Scanline
{
	FileRemoveDir, %Emulator_Path%/artwork, 1
	FileCreateDir, %Emulator_Path%/artwork
	FileCopy, %Emulator_Path%/scanlines/scanlines.png, %Emulator_Path%/artwork
	ini = scanlines
	goto, Bezel
}
else
{
	FileRemoveDir, %Emulator_Path%/artwork, 1
	FileCreateDir, %Emulator_Path%/artwork
	ini = ""
}


;~~~~~~~~~~~HLSL~~~~~~~~~~~~~~;



if (HLSL = "true") ;~Scanline
{
	FileRemoveDir, %Emulator_Path%/artwork, 1
	FileCreateDir, %Emulator_Path%/artwork
	ini = hlsl
	goto, Bezel

}
else
{
	FileRemoveDir, %Emulator_Path%/artwork, 1
	FileCreateDir, %Emulator_Path%/artwork
	ini = ""
}


;~~~~~~~~~~~GLSL~~~~~~~~~~~~~~;



if (GLSL = "true") ;~Scanline
{
	GLSL:
	FileRemoveDir, %Emulator_Path%/artwork, 1
	FileCreateDir, %Emulator_Path%/artwork
	ini = glsl
	goto, Bezel
}
else
{
	FileRemoveDir, %Emulator_Path%/artwork, 1
	FileCreateDir, %Emulator_Path%/artwork
	ini = ""
}

;~~~~~~~~~~~~BEZEL~~~~~~~~~~~;

Bezel:

if (Bezel = "true") ;~ Set Bezel
{
	
	If Rom in %Vertical_Games% ;~ for vertical game, the namefile must be "System V.zip"
	{
	FileRemoveDir, %Emulator_Path%/artwork/%Rom%, 1
	bezel =  -use_bezels
	runwait, "%7zip%" x "%Bezel_Path%\%System%%A_Space%V.zip" -o"%Emulator_Path%\artwork\%Rom%" -y,,Hide
	}
	
	else
	{
	FileRemoveDir, %Emulator_Path%\artwork\%Rom%, 1 ;~ for horizontal game, the namefile must be "System H.zip"
	bezel =  -use_bezels
	runwait, "%7zip%" x "%Bezel_Path%\%System%%A_Space%H.zip" -o"%Emulator_Path%\artwork\%Rom%" -y,,Hide	
	}
}
else ;~ No Bezel
{
	bezel =  -nouse_bezels
}

;~~~~~~~~~~~FADE~~~~~~~~~~~~~~;

	if (Fade = "true") ;~Fade
{
	Run, "..\..\Modules\Fade\Fade.ahk" "%System%" "%Rom%"  , ;~ Fade.ahk in script Folder
}

;~~~~~~~~~~~~~~EXE Games~~~~~~~~~;

If Rom in %Exe_Games% ;~ Launch Game Exe
	{
	Sleep, %Duration%
	SetWorkingDir, %Folder%
	Run, %Launch%
	}
	else
	{	
	SetWorkingDir %Emulator_Path% ;~Launch Other
	Run, %Emulator_Launch% -readconfig -inipath %ini% -rompath "%Roms_Path%" %Rom%,,WinMinimize,MAME
	
	Sleep, %Duration%
	Process, Close, cmd.exe
	
	Sleep, 1000
	SetTitleMatchMode, 1
	WinActivate, MAME
	}
	
ExitApp