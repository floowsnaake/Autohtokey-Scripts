/*
180CA274 = Marked Ennemy
1F5DD2F0 = Menu/things under the mouse in the world
*/


IF NOT A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

OnExit, Fix_Keys
ProcessName := "ZuOnline.exe"
hwnd := MemoryOpenFromName(ProcessName)

Under_Mouse = 0x1F80E160

Gui, +AlwaysOnTop +Disabled -SysMenu +Owner
Gui, Add, Text,, Status:
Gui, Add, Text,, Ghostly Puppet:
Gui, Add, Text,,Under Mouse iteam:

Gui, Add, Edit, w200 ReadOnly  ym vSta
Gui, Add, Edit, w200 ReadOnly vPuppet,
Gui, Add, Edit, ReadOnly w190 vUnder_Mouse_GUI,--
Gui, Show, NoActivate x0 y0, Auto Fight/Loot
WinActivate, ahk_exe ZuOnline.exe
WinWaitActive, ahk_exe ZuOnline.exe

MButton::
SoundBeep
Loop
{
	
GuiControl,, Under_Mouse_GUI, % A := MemoryReadPointer(hwnd, Under_Mouse, "Str", 16)
QQ := MemoryReadPointer(hwnd, Under_Mouse, "Str", 16)

CoordMode, Pixel, Screen
PixelSearch, FoundX, FoundY, 239, 212, 1037, 810, 0x3240F3, 0, Fast RGB
If ErrorLevel = 0 ; IF MAgic iteam color is found on the screen.
{
IF (QQ = "Attacking Spar" or QQ = "Defensive Spar") ; IF mouse if under these iteams then pick it.

{
Click
}
}

send, {Ctrl down}

}
return

MemoryOpenFromName(Name)
{
    Process, Exist, %Name%
    Return DllCall("OpenProcess", "Uint", 0x1F0FFF, "int", 0, "int", PID := ErrorLevel)
}

MemoryReadPointer(hwnd, base, datatype="int", length=4, offsets=0, offset_1=0, offset_2=0, offset_3=0, offset_4=0, offset_5=0, offset_6=0, offset_7=0, offset_8=0, offset_9=0)
{
	B_FormatInteger := A_FormatInteger 
	Loop, %offsets%
	{
		baseresult := MemoryRead(hwnd,base)
		Offset := Offset_%A_Index%
		SetFormat, integer, h
		base := baseresult + Offset
		SetFormat, integer, d
	}
	SetFormat, Integer, %B_FormatInteger%
	return MemoryRead(hwnd,base,datatype,length)
}

MemoryRead(hwnd, address, datatype="int", length=4, offset=0)
{
	VarSetCapacity(readvalue,length, 0)
	DllCall("ReadProcessMemory","Uint",hwnd,"Uint",address+offset,"Str",readvalue,"Uint",length,"Uint *",0)
if (datatype = "Str")
		finalvalue := StrGet(&readvalue, length, "UTF-8")
else
	finalvalue := NumGet(readvalue, 0, datatype)
	return finalvalue
}


Esc::
ExitApp
return


Fix_Keys:
send, {ctrl}
send, {ctrl down}
send, {ctrl up}
ExitApp
return