#SingleInstance Force
#NoTrayIcon

SplitPath, A_ScriptDir,,,,, drive ;~ Get Drive Letter

;~ SetWorkingDir %A_ScriptDir%

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


Demul_System = awave ;~dc, naomi, awave, hikaru, gaelco

IniRead, Emulator_Path, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, Emulator_Path ;~Emulator Path
IniRead, Emulator_Launch, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, Emulator_Launch ;~Emulator Launch

IniRead, Demul_ini, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, Demul_ini ;~INI Demul

IniRead, iniDX11, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, iniDX11 ;~INI DX11
IniRead, iniDX11old, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, iniDX11old ;~INI DX11old

IniRead, dllDX11, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, dllDX11 ;~INI DX11
IniRead, dllDX11old, ../../Modules/%Emulator%/%Emulator%.ini, Emulator, dllDX11old ;~INI DX11old


IniRead, Roms_Path, ../../Settings/%System%/%System%.ini, System, Roms ;~Roms Path

IniRead, Bezel, ../../Settings/%System%/%System%.ini, Options, Bezel ;~Bezel option (false,true)
IniRead, Fade, ../../Settings/%System%/%System%.ini, Options, Fade ;~Fade option (false,true)

IniRead, Fullscreen, ../../Settings/%System%/%System%.ini, Screen, Fullscreen ;~Fullscreen (true, false)

;~ IniRead, Window_Width, ../../Settings/%System%/%System%.ini, Window, Width ;~Window Width (set correct ratio)
;~ IniRead, Window_Height, ../../Settings/%System%/%System%.ini, Window, Height ;~Window Height (set correct ratio)

IniRead, DirectX, ../../Settings/%System%/%System%.ini, DirectX, GPU ;~Choose DirectX (gpuDX11 or gpuDX11old)

IniRead, usePass1, ../../Settings/%System%/%System%.ini, Shaders, usePass1 ;~ (enable or disable)
IniRead, shaderPass1, ../../Settings/%System%/%System%.ini, Shaders, shaderPass1 ;~ (only on gpuDXold, set FXAA, HDR-TV, SCANLINES, CARTOON, RGB DOT(MICRO), RGB DOT(TINY), BLUR)
IniRead, usePass2, ../../Settings/%System%/%System%.ini, Shaders, usePass2 ;~ (enable or disable)
IniRead, shaderPass2, ../../Settings/%System%/%System%.ini, Shaders, shaderPass2 ;~ (only on gpuDXold, set FXAA, HDR-TV, SCANLINES, CARTOON, RGB DOT(MICRO), RGB DOT(TINY) or BLUR)


If DirectX = gpuDX11
{
	goto, gpuDX11
}

If DirectX = gpuDX11old
{
	goto, gpuDX11old
}

gpuDX11:

IniWrite, %dllDX11%, %Emulator_Path%/%Demul_ini%, plugins, gpu

If Fullscreen = true
{
	IniWrite, 1, %Emulator_Path%/%iniDX11%, main, UseFullscreen
	IniWrite, 2, %Emulator_Path%/%iniDX11%, main, aspect
	goto, Launcher1
}
If Fullscreen = false
{
	IniWrite, 0, %Emulator_Path%/%iniDX11%, main, UseFullscreen
	IniWrite, %A_ScreenWidth%, %Emulator_Path%/%iniDX11%, resolution, Width
	IniWrite, %A_ScreenHeight%, %Emulator_Path%/%iniDX11%, resolution, Height
	IniWrite, 1, %Emulator_Path%/%iniDX11%, main, aspect
	goto, Launcher2
}


gpuDX11old:
{
	
IniWrite, %dllDX11old%, %Emulator_Path%/%Demul_ini%, plugins, gpu

If Fullscreen = true
{
	IniWrite, 1, %Emulator_Path%/%iniDX11old%, main, UseFullscreen
	IniWrite, 2, %Emulator_Path%/%iniDX11old%, main, aspect
	goto, Launcher1
}

If Fullscreen = false
{
	IniWrite, 0, %Emulator_Path%/%iniDX11old%, main, UseFullscreen
	IniWrite, %A_ScreenWidth%, %Emulator_Path%/%iniDX11old%, resolution, Width
	IniWrite, %A_ScreenHeight%, %Emulator_Path%/%iniDX11old%, resolution, Height
	IniWrite, 1, %Emulator_Path%/%iniDX11old%, main, aspect
}

	IniWrite, %usePass1%, %Emulator_Path%/%iniDX11%, shaders, usePass1
	IniWrite, %shaderPass1%, %Emulator_Path%/%iniDX11%, shaders, shaderPass1
	IniWrite, %usePass2%, %Emulator_Path%/%iniDX11%, shaders, usePass2
	IniWrite, %shaderPass2%, %Emulator_Path%/%iniDX11%, shaders, shaderPass2
	goto, Launcher2

}



Launcher1:

SetWorkingDir, %Emulator_Path%
Run, %Emulator_Launch% -run=%Demul_System% -rom=%Rom%, Hide Sleep 3000



	~~~~~~~~~~FADE~~~~~~~~~~~~~~;
	if (Fade = "true") ;~Fade
{
	SetWorkingDir %A_ScriptDir%
	Run, "..\..\Modules\Fade\Fade.ahk" "%System%" "%Rom%"  , ;~ Fade.ahk in script Folder
}	
return

Launcher2:
SetWorkingDir, %Emulator_Path%
Run, %Emulator_Launch% -run=%Demul_System% -rom=%Rom%, Hide Sleep 3000



	~~~~~~~~~~FADE~~~~~~~~~~~~~~;
	if (Fade = "true") ;~Fade
{
	SetWorkingDir %A_ScriptDir%
	Run, "..\..\Modules\Fade\Fade.ahk" "%System%" "%Rom%"  , ;~ Fade.ahk in script Folder
}	
WinHide ahk_class Shell_TrayWnd
WinHide,Start ahk_class Button

Sleep, %Duration%
Sleep, 500

SetWorkingDir, ../../../Media/Other/Bezel/1.78/Sammy Atomiswave/

Run, BezelLeft.ahk
Run, BezelRight.ahk

Sleep, 200
SetTitleMatchMode, 1
WinActivate, gpuDX
WinWaitActive, gpuDX
WinExist("ahk_class Shell_TrayWnd")

WinMove,,, -2, 0
WinSet, Style, -0xC00000, A
WinSet, Style, -0x40000, A
DllCall("SetMenu", uint, WinExist(), uint, 0)
;~ Sleep, 200
WinActivate, BezelLeft
WinActivate, BezelRight
WinHide ahk_class Shell_TrayWnd
WinHide,Start ahk_class Button
WinActivate, gpuDX
return

Escape::
{
Process, Close, demul.exe
WinClose, BezelLeft.ahk
WinClose, BezelRight.ahk
;~ WinShow ahk_class Shell_TrayWnd
;~ WinShow,Start ahk_class Button
Process, Close, cmd.exe
Sleep, 500
WinActivate, Z-Spin
ExitApp
}
