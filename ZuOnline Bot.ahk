
win = Onwind Digital Co.,Ltd



MButton::
Gui, +AlwaysOnTop +Disabled -SysMenu +Owner
Gui, Add, Text,, Status:
Gui, Add, Text,, Ghostly Puppet:

Gui, Add, Edit, w200 ReadOnly  ym vSta
Gui, Add, Edit, w200 ReadOnly vPuppet,
Gui, Show, NoActivate x0 y0, Auto Fight/Loot
WinActivate, ahk_exe ZuOnline.exe
WinWaitActive, ahk_exe ZuOnline.exe


PixelGetcolor, Ghost_Puppet, 129, 101
 IfEqual, Ghost_Puppet, 0x666100, {
Ghost_Puppet_summond = Soummed
GuiControl,, Puppet, %Ghost_Puppet_summond%
Sleep, 400
}

PixelGetcolor, Ghost_Puppet, 129, 101
 IfNOTEqual, Ghost_Puppet, 0x666100, {
Ghost_Puppet_summond = Not Soummed
GuiControl,, Puppet, %Ghost_Puppet_summond%
Sleep, 200
Send, {2}

Ghost_Puppet_summond = Summining
GuiControl,, Puppet, %Ghost_Puppet_summond%

Loop
{
GuiControl,, Sta, Waiting to Summoning Ghost Puppet
PixelGetcolor, Ghost_Puppet, 129, 101
 IfEqual, Ghost_Puppet, 0x666100, {
Ghost_Puppet_summond = Soummed
GuiControl,, Puppet, %Ghost_Puppet_summond%
break
Sleep, 400
}	
}
}

Search_Ape:	
IF (Ghost_Puppet_summond = "Soummed")
{
GuiControl,, Sta, Searching For Ape Lesser Ape
send, {Q}
Sleep, 500
PixelGetcolor, Monster_target, 361, 31
IfEqual,Monster_target, 0x807A00,{
GuiControl,, Sta, Lesser Ape Targeted	
Sleep, 400

Loop
{	
send, {F}
GuiControl,, Sta, Attacking Lesser Ape
PixelGetcolor, Monster_target, 361, 31
IfNOTEqual,Monster_target, 0x807A00,{
GuiControl,, Sta, Lesser Ape Killed
Sleep, 400
gosub, Search_Ape
break
}

}
}
}
return
