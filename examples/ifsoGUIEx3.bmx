' tabber, button - also panel, label, checkbox, listbox, button

SuperStrict

Framework brl.glmax2d
Import brl.freetypefont
Import brl.pngloader

Import ifsogui.GUI
Import ifsogui.panel
Import ifsogui.window
Import ifsogui.label
Import ifsogui.listbox
Import ifsogui.checkbox
Import ifsogui.button
Import ifsogui.tabber

'Include "incbinSkin.bmx"

SetGraphicsDriver GLMax2DDriver()
Graphics(800, 600)
GUI.SetResolution(800, 600)
'GUI.SetUseIncBin(True)
GUI.SetZipInfo("../Skins.zip", "") ' loading skin from zip - Bug: zip files causing random crash at init (except basic examples)
GUI.LoadTheme("Skin2")
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
lstEvents.SetMouseHighlight(False)
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
window = ifsoGUI_Window.Create(10, 10, 380, 380, "ControlsPanel1")
window.SetCaption("Controls 1")
window.SetDragTop(True)
'window.SetMinWH(150, 150)
window.SetResizable(True)
GUI.AddGadget(window)
Global tb:ifsoGUI_Tabber = ifsoGUI_Tabber.Create(5, 5, 360, 340, "tabber", 3)
tb.SetTabText(0, "Tab 1")
tb.SetTabTip(0, "Tabs can be added on the fly")
tb.SetTabText(1, "The Second Tab")
tb.SetTabTip(1, "Tabs can be removed on the fly")
tb.SetTabText(2, "3rd Tab")
tb.SetTabTip(2, "Tabs have automatic scrollbars")
window.AddChild(tb)
button = ifsoGUI_Button.Create(5, 5, 70, 30, "btn1", "Add Tab")
tb.AddTabChild(button, 0)
button = ifsoGUI_Button.Create(35, 35, 90, 30, "btn2", "Remove Tab")
tb.AddTabChild(button, 1)
button = ifsoGUI_Button.Create(105, 505, 50, 30, "btn3", "Button")
tb.AddTabChild(button, 2)

Local iFPSCounter:Int, iFPSTime:Int, iFPS:Int 'For the FPS Counter

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
		ElseIf e.gadget.Name = "chkTop" And e.id = ifsoGUI_EVENT_CHANGE
			ifsoGUI_Panel(GUI.GetGadget("StatusPanel")).SetAlwaysOnTop(e.data)
		ElseIf e.gadget.name = "btn1" And e.id = ifsoGUI_EVENT_CLICK
			tb.AddTab("Added Tab", "New Tab")
		ElseIf e.gadget.name = "btn2" And e.id = ifsoGUI_EVENT_CLICK
			If tb.GetNumTabs() > 3 tb.RemoveTab(tb.GetNumTabs() - 1)
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
