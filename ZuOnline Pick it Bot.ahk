/*
Name: ZuOnline Auto Fight/Loot
Version = Pre-Alpha 0.1
Made by: Flow_Snake & DrSinner
Autohotkey version: v1.1.22.03
tested on: Windows 7 64bit
Date: 21/08/2015

Contact info:
http://www.autohotkey.com/board/user/21149-snowflake/
https://github.com/floowsnaake

What does it do?
----------------------

NOTE: YOU will need to change the (Under_Mouse =) adress with a one that works/its diffirent for you so miy adress WILL NOT work for you!

Also make sure that you edit these 2 words/items inside of the " " 

IF (QQ = "Attacking Spar" or QQ = "Defensive Spar")

These are the items that the bot will pick up if it gets dropped.

This bot will ONL work if you are a Summoner class becuse it uses the (Ghostly Puppet) to auto mark/select an Enemy and then switch the Puppet into Agressive mode/Auto attack mode, then when the Enemy is killed it will check for a specific item/loot that the Enemy droped and pick it up and continue to do that/loop it all again.

Hotkeys
----------
X = Start the Bot-
Escape/ESC = Exit the bot-

*/

IF NOT A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

OnExit, Fix_Keys
ProcessName := "ZuOnline.exe"
hwnd := MemoryOpenFromName(ProcessName)

Under_Mouse = 0x11CCA6F0

Gui, +AlwaysOnTop +Disabled -SysMenu +Owner
Gui, Add, Text,,Iteam/NPC/Monster (For Debugg):
Gui, Add, Text,,Pointer:
Gui, Add, Edit, ReadOnly w190 vUnder_Mouse_GUI ym,
Gui, Add, Edit, ReadOnly w190, %Under_Mouse% 
GuiControl,, Under_Mouse_GUI,Press X Key

Gui, Show, NoActivate x0 y0, Auto Fight/Loot
WinActivate, ahk_exe ZuOnline.exe
WinWaitActive, ahk_exe ZuOnline.exe

X::
SoundBeep
GuiControl,, Under_Mouse_GUI,
send, {Ctrl down}
Loop
{
Sleep,1004
send,{Q Down} ;Auto target a Ape
Sleep, 184
send,{Q Up}
Sleep,752
send,{F Down} ;Sends the Puppet to kill it.
Sleep,176
send,{F Up}

GuiControl,, Under_Mouse_GUI, % A := MemoryReadPointer(hwnd, Under_Mouse, "Str", 16)
QQ := MemoryReadPointer(hwnd, Under_Mouse, "Str", 16)

CoordMode, Pixel, Screen
PixelSearch, FoundX, FoundY, 239, 212, 1037, 810, 0x3240F3, 0, Fast RGB
If ErrorLevel = 0 ; IF MAgic iteam color is found on the screen.
{
MouseMove, %FoundX%, %FoundY%
IF (QQ = "Attacking Spar" or QQ = "Defensive Spar") ; IF mouse if under these iteams then pick it.
{
Sleep, 300
Click ; clicks the item.
Sleep, 3000
}
}

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
