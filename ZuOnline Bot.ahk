/*
Name: ZuOnline Bot
Version = Pre-Alpha 0.1
Made by: Flow_Snake & DrSinner
Autohotkey version: v1.1.22.03
Tested on: Windows 7 64bit
Date: 21/08/2015

Contact info:
http://www.autohotkey.com/board/user/21149-snowflake/
https://github.com/floowsnaake
http://pastebin.com/u/Snow_Flake

What does it do?
----------------------
NOTE: YOU will need to change the (Item_Under_Mouse =) address with a one that works/its different for you so my address WILL NOT work for you!
Also make sure that you edit these 2 words/items inside of the " " 
IF (QQ = "Attacking Spar" or QQ = "Defensive Spar")
These are the items that the bot will pick up if it gets dropped.

This bot will ONLY work if you are a Summoner class because it uses the (Ghostly Puppet) to auto mark/select an Enemy and then switch the Puppet into Aggressive mode/Auto attack mode, then when the Enemy is killed it will check for a specific item/loot that the Enemy drooped and pick it up and continue to do that/loop it all again.

Hotkeys
----------
X = Start the Bot.
Escape/ESC = Exit the bot.
*/

IF NOT A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

OnExit, Fix_Keys
ProcessName := "ZuOnline.exe"
hwnd := MemoryOpenFromName(ProcessName)

Adress = 1FAA41C0 ; This is the Address under the mouse to make the bot see the item thats under the mouse., Like this for example 1FAA41C0, note that you dont need to add the 0x part.

Item_Under_Mouse = 0x%adress%
Pixel_Item_Pick = 0x3240F3 ; Blue color (Magic item)

IfEqual,Item_Under_Mouse,0x, {
MsgBox, 4112, Under Mouse Error, The Item_Under_Mouse variable does not contain a String Value! it must be likes this 0x1FAA41C0`nZuOnline Auto Fight/Loot Bot will now Exit!
ExitApp
}

Gui, +AlwaysOnTop
Gui, Add, Text,,Items To Pick:
Gui, Add, Text,,Pixel Pick Color:
Gui, Add, Text,,Item/NPC/Monster (For Debug):
Gui, Add, Text,,Pointer:
Gui, Add, Edit, ReadOnly w190 ym, Attacking Spar & Defensive Spar
Gui, Add, Progress, w20 h20 vCol, 100
Gui, Add, Edit, ReadOnly x206 y32 w100 h20 , %Pixel_Item_Pick%
Gui, Add, Edit, ReadOnly w190 vItem_Under_Mouse_GUI, 
Gui, Add, Edit, ReadOnly w190, %Item_Under_Mouse% 

GuiControl,, Item_Under_Mouse_GUI,Press X Key

Gui, Show, NoActivate x0 y0, ZuOnline Auto Fight/Loot
WinActivate, ahk_exe ZuOnline.exe
WinWaitActive, ahk_exe ZuOnline.exe

X::
Random, delay,100,700
SoundBeep
GuiControl,, Item_Under_Mouse_GUI,
send, {Ctrl down} ;Shows the items on the ground/on the map.
Loop ;Loops it all
{
Sleep,1004
send,{Q Down} ;Auto target a Enemy.
Sleep, %delay%
send,{Q Up}
Sleep, %delay%
send,{F Down} ;Sends the Puppet to kill it.
Sleep, %delay%
send,{F Up}

GuiControl,, Item_Under_Mouse_GUI, % A := MemoryReadPointer(hwnd, Item_Under_Mouse, "Str", 16)
QQ := MemoryReadPointer(hwnd, Item_Under_Mouse, "Str", 16)

CoordMode, Pixel, Screen
PixelSearch, FoundX, FoundY, 239, 212, 1037, 810, %Pixel_Item_Pic%, 0, Fast RGB ; color is Blue
IF ErrorLevel = 0 ; IF Magic iteam color is found on the screen.
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


^Esc::
Esc::
ExitApp
return


Fix_Keys:
send, {ctrl}
send, {ctrl down}
send, {ctrl up}
ExitApp
return
