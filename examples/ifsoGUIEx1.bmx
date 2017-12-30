SuperStrict

Framework brl.glmax2d
Import brl.FreeTypeFont

Import ifsogui.GUI
Import ifsogui.panel
Import ifsogui.window
Import ifsogui.label
Import ifsogui.listbox
Import ifsogui.checkbox
Import ifsogui.button
Import ifsogui.textbox
Import ifsogui.progressbar
Import ifsogui.slider
Import ifsogui.combobox
Import ifsogui.spinner
Import brl.audio
?win32
Import brl.directsoundaudio
?Not win32
Import brl.freeaudioaudio
?
Import brl.wavloader

'Incbin "Skins.zip" ' Bug: incbin'd zip files crash randomly
Include "../editor/incbinSkin.bmx"

SetGraphicsDriver GLMax2DDriver()
Graphics(800, 600)
?win32
SetAudioDriver("DirectSound")
?Not win32
SetAudioDriver("FreeAudio")
?
GUI.SetResolution(800, 600)
GUI.SetUseIncBin(True) ' add incbin:: to path
'GUI.SetZipInfo("Skins.zip", "") ' add zip:: to path
GUI.LoadTheme("Skin2") ' add Skin name to path
GUI.SetDefaultFont(LoadImageFont(GUI.FileHeader + "Skin2/fonts/arial.ttf", 12))
GUI.SetDrawMouse(True)

'Status Panel
Local panel:ifsoGUI_Panel = ifsoGUI_Panel.Create(650, 480, 140, 110, "StatusPanel")
GUI.AddGadget(panel)
panel.AddChild(ifsoGUI_Label.Create(5, 5, 100, 20, "FPSLabel"))
Local label:ifsoGUI_Label = ifsoGUI_Label.Create(5, 30, 100, 20, "EventCount")
label.SetLabel("List Items: 0")
panel.AddChild(label)
Local checkbox:ifsoGUI_CheckBox = ifsoGUI_CheckBox.Create(5, 55, 100, 20, "chkTop", "Always On Top")
checkbox.SetLabelClick(True)
checkbox.SetTip("Sets this Status Panel Always on Top")
panel.AddChild(checkbox)
checkbox = ifsoGUI_CheckBox.Create(5, 80, 100, 20, "chkSkin", "Skin 2")
checkbox.SetLabelClick(True)
checkbox.SetTip("Use alternate skin?")
checkbox.SetValue(False)
panel.AddChild(checkbox)

'Event Window
Local window:ifsoGUI_Window = ifsoGUI_Window.Create(10, 400, 550, 190, "EventPanel")
window.SetCaption("Events")
window.SetDragTop(True)
GUI.AddGadget(window)
Global lstEvents:ifsoGUI_ListBox = ifsoGUI_ListBox.Create(5, 5, 400, window.GetClientHeight() - 10, "EventsList")
lstEvents.SetHScrollbar(ifsoGUI_SCROLLBAR_AUTO)
lstEvents.SetMultiSelect(True)
lstEvents.SetMouseHighlight(True)
window.AddChild(lstEvents)
checkbox = ifsoGUI_CheckBox.Create(410, 5, 120, 20, "chkMouseMove", "Mouse Move")
checkbox.SetLabelClick(True)
checkbox.SetTip("Show Mouse Move events in the list")
window.AddChild(checkbox)
checkbox = ifsoGUI_CheckBox.Create(410, 30, 120, 20, "chkMouseEnter", "Mouse Enter/Exit")
checkbox.SetLabelClick(True)
checkbox.SetTip("Show Mouse Enter/Exit events in the list")
window.AddChild(checkbox)
checkbox = ifsoGUI_CheckBox.Create(410, 55, 120, 20, "chkListEvents", "Event List Events")
checkbox.SetLabelClick(True)
checkbox.SetTip("Show events generated by the event listbox")
window.AddChild(checkbox)
checkbox = ifsoGUI_CheckBox.Create(410, 80, 120, 20, "chkFocus", "Gain/Lose Focus")
checkbox.SetLabelClick(True)
checkbox.SetTip("Show Focus events in the list")
window.AddChild(checkbox)
Local button:ifsoGUI_Button = ifsoGUI_Button.Create(465, 135, 75, 25, "btnClearList", "Clear List")
button.SetTip("Clears the event list")
window.AddChild(button)

'Control Window 1
Local window2:ifsoGUI_Window = ifsoGUI_Window.Create(10, 10, 380, 380, "ControlsPanel1")
'window2.SetCaption("Controls 1")
'window2.SetDragTop(True)
window2.SetDragable(True)
'window2.SetMinWH(150, 150)
window2.SetResizable(True)
'window2.SetBackgroundImage(LoadImage("cardback.JPG"))
window2.SetAutoSize(ifsoGUI_IMAGE_SCALETOPANEL)
GUI.AddGadget(window2)
button = ifsoGUI_Button.Create(5, 5, 75, 25, "btn1", "Button 1")
button.SetTip("Only this button has a tip (and sound)")
Local snd:TSound = LoadSound("drop.wav")
button.AddSound(ifsoGUI_EVENT_CLICK, snd)
window2.AddChild(button)
button.SetTabOrder(1)
window2.AddChild(ifsoGUI_Button.Create(100, 5, 75, 25, "btn2", "Button 2"))
window2.AddChild(ifsoGUI_Button.Create(205, 5, 75, 25, "btn3", "Button 3"))
Local tb:ifsoGUI_TextBox = ifsoGUI_TextBox.Create(5, 33, 150, 20, "textbox", "textbox")
window2.AddChild(tb)
Local pb:ifsoGUI_ProgressBar = ifsoGUI_ProgressBar.Create(5, 60, 190, 15, "progressbar")
pb.SetDrawStyle(ifsoGUI_DRAWSTYLE_TILE)
window2.AddChild(pb)
Local sl:ifsoGUI_Slider = ifsoGUI_Slider.Create(5, 80, 190, "slider")
sl.SetInterval(1)
sl.SetMax(100)
sl.SetShowTicks(False)
sl.SetTip("Value: 0")
window2.AddChild(sl)
Local cb:ifsoGUI_Combobox = ifsoGUI_Combobox.Create(5, 105, 120, 24, "combo")
cb.AddItem("Item 1", 1, "")
cb.AddItem("Item 2", 2, "")
cb.AddItem("Item 3", 3, "")
cb.AddItem("Item 4", 4, "")
window2.AddChild(cb)
window2.AddChild(ifsoGUI_Label.Create(130, 105, 40, 24, "SpinnerLabel", "0"))
window2.AddChild(ifsoGUI_Spinner.Create(170, 105, 18, 24, "Spinner"))

Local iFPSCounter:Int, iFPSTime:Int, iFPS:Int 'For the FPS Counter
SetClsColor(200, 200, 200)
While Not AppTerminate()
	Cls
	CheckEvents()
	GUI.Refresh()
	iFPSCounter:+1
	If MilliSecs() - iFPSTime > 1000
		iFPS = iFPSCounter
		iFPSTime = MilliSecs()
		iFPSCounter = 0
		ifsoGUI_Label(GUI.GetGadget("FPSLabel")).SetLabel("FPS: " + iFPS)
	End If
	Flip 0
Wend

Function CheckEvents()
	Local e:ifsoGUI_Event
	Repeat
		e = GUI.GetEvent()
		If Not e Exit
		If e.gadget = lstEvents And Not ifsoGUI_CheckBox(GUI.GetGadget("chkListEvents")).GetValue() Continue
		If e.gadget.Name = "btnClearList" And e.id = ifsoGUI_EVENT_CLICK
			lstEvents.RemoveAll()
			ifsoGUI_Label(GUI.GetGadget("EventCount")).SetLabel("List Items: 0")
			Continue
		ElseIf e.gadget.Name = "slider" And e.id = ifsoGUI_EVENT_CHANGE
			ifsoGUI_ProgressBar(GUI.GetGadget("progressbar")).SetValue(e.data)
			e.gadget.SetTip("Value: " + e.data)
		ElseIf e.gadget.Name = "Spinner" And e.id = ifsoGUI_EVENT_CLICK
			Local label:ifsoGUI_Label = ifsoGUI_Label(GUI.GetGadget("SpinnerLabel"))
			Label.SetLabel(Int(label.GetLabel()) + e.data)
		ElseIf e.gadget.Name = "chkTop" And e.id = ifsoGUI_EVENT_CHANGE
			ifsoGUI_Panel(GUI.GetGadget("StatusPanel")).SetAlwaysOnTop(e.data)
		ElseIf e.gadget.Name = "chkSkin" And e.id = ifsoGUI_EVENT_CHANGE
			If ifsoGUI_CheckBox(e.gadget).GetValue()
				GUI.LoadTheme("Skin")
			Else
				GUI.LoadTheme("Skin2")
			End If
		End If
		Select e.id
			Case ifsoGUI_EVENT_MOUSE_MOVE
				If Not ifsoGUI_CheckBox(GUI.GetGadget("chkMouseMove")).GetValue() Continue
			Case ifsoGUI_EVENT_MOUSE_ENTER, ifsoGUI_EVENT_MOUSE_EXIT
				If Not ifsoGUI_CheckBox(GUI.GetGadget("chkMouseEnter")).GetValue() Continue
			Case ifsoGUI_EVENT_GAIN_FOCUS, ifsoGUI_EVENT_LOST_FOCUS
				If Not ifsoGUI_CheckBox(GUI.GetGadget("chkFocus")).GetValue() Continue
		End Select
		lstEvents.AddItem("NAME: " + e.gadget.Name + " EVENT: " + e.EventString(e.id) + " DATA: " + e.data)
		lstEvents.SetTopItem(lstEvents.Items.Length)
		lstEvents.SetItemTip(lstEvents.GetCount() - 1, e.EventString(e.id))
		ifsoGUI_Label(GUI.GetGadget("EventCount")).SetLabel("List Items: " + lstEvents.GetCount())
	Forever
End Function
