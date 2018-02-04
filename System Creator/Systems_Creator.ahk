#SingleInstance Force

SetWorkingDir %A_ScriptDir%

Loop ..\Modules\*, 2 ; return only folders at this level
FolderList .= A_LoopFileName . "|"
FolderList := RTrim(FolderList, "`|")


MsgBox FolderList = `n`n%FolderList%
MsgBox, %A_WorkingDir%\Test.txt



IfExist, %A_WorkingDir%\Test.txt
{
	FileDelete, %A_WorkingDir%\Test.txt
	MsgBox, yes
	FileAppend, %FolderList%, %A_WorkingDir%\Test.txt
	
}
else
{
FileAppend, %FolderList%, %A_WorkingDir%\Test.txt
}
FileRead, in, %A_WorkingDir%\Test.txt

;~ Loop, parse, Contents, `n, `r

list := in

Gui, Add, DropDownList, vVariable, %list%
Gui Add, Edit, x116 y112 w120 h21
Gui, Show, w300 h300, Test
guiControl,, Variable, %newlist%
return

GuiClose:
ExitApp
