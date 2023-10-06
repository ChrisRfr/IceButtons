;- Top
; -----------------------------------------------------------------------------
;          Title: Ice Button Build Theme
;    Description: Build your Ice Button Theme and copy it th clipboard
;    Source Name: IceButtons_BuildTheme.pb
;         Author: ChrisR
;           Date: 2023-10-06
;        Version: 1.0
;     PB-Version: 6.0 or other
;             OS: Windows Only
;          Forum: https://www.purebasic.fr/english/viewtopic.php?t=82592
; -----------------------------------------------------------------------------

EnableExplicit

XIncludeFile "IceButtons.pbi"

Enumeration Window
  #Window
EndEnumeration

Enumeration Gadgets
  #Canv_ButtonColor        = #IceBtn_color
  #Canv_BackgroundColor    = #IceBtn_BackColor
  #Canv_DisableColor       = #IceBtn_DisableColor
  #Canv_FrontColor         = #IceBtn_FrontColor
  #Canv_DisableFrontColor  = #IceBtn_DisableFrontColor
  #Check_EnableShadow      = #IceBtn_EnableShadow
  #Canv_ShadowColor        = #IceBtn_ShadowColor
  #Spin_RoundX             = #IceBtn_RoundX
  #Spin_RoundY             = #IceBtn_RoundY
  #Txt_ButtonColor
  #Txt_BackgroundColor
  #Txt_Disablecolor
  #Txt_FrontColor
  #Txt_DisableFrontColor
  #Txt_EnableShadow
  #Txt_ShadowColor
  #Txt_RounDX
  #Txt_RounDY
  #Img_EnableShadow
  #Btn_DarkBlue
  #Btn_LightBlue
  #Btn_Clipboard
  #Btn_Regular
  #Btn_Toggle
  #Btn_Disabled
EndEnumeration

Declare ClipboardText()
Declare Resize_Window()
Declare SetBackColor(Color)
Declare DrawCanvasColor(Canvas, Color = #PB_Default)
Declare Open_Window(X = 0, Y = 0, Width = 540, Height = 340)

Procedure ClipboardText()
  Protected Value, Text$ = "MyTheme:" +#LF$
  
  Value = GetIceBtnThemeAttribute(#IceBtn_color)
  Text$ + "Data.i #IceBtn_color, $"               + RSet(Hex(Blue(Value)), 2, "0") + RSet(Hex(Green(Value)), 2, "0") + RSet(Hex(Red(Value)), 2, "0") +#LF$
  
  Value = GetIceBtnThemeAttribute(#IceBtn_BackColor)
  If Value = #PB_Default
    Text$ + "Data.i #IceBtn_BackColor, #PB_Default" +#LF$
  Else
    Text$ + "Data.i #IceBtn_BackColor, $"         + RSet(Hex(Blue(Value)), 2, "0") + RSet(Hex(Green(Value)), 2, "0") + RSet(Hex(Red(Value)), 2, "0") +#LF$
  EndIf
  
  Value = GetIceBtnThemeAttribute(#IceBtn_DisableColor)
  If Value = #PB_Default
    Text$ + "Data.i #IceBtn_DisableColor, #PB_Default" +#LF$
  Else
    Text$ + "Data.i #IceBtn_DisableColor, $"      + RSet(Hex(Blue(Value)), 2, "0") + RSet(Hex(Green(Value)), 2, "0") + RSet(Hex(Red(Value)), 2, "0") +#LF$
  EndIf
  
  Value = GetIceBtnThemeAttribute(#IceBtn_FrontColor)
  If Value = #PB_Default
    Text$ + "Data.i #IceBtn_FrontColor, #PB_Default" +#LF$
  Else
    Text$ + "Data.i #IceBtn_FrontColor, $"        + RSet(Hex(Blue(Value)), 2, "0") + RSet(Hex(Green(Value)), 2, "0") + RSet(Hex(Red(Value)), 2, "0") +#LF$
  EndIf
  
  Value = GetIceBtnThemeAttribute(#IceBtn_DisableFrontColor)
  If Value = #PB_Default
    Text$ + "Data.i #IceBtn_DisableFrontColor, #PB_Default" +#LF$
  Else
    Text$ + "Data.i #IceBtn_DisableFrontColor, $" + RSet(Hex(Blue(Value)), 2, "0") + RSet(Hex(Green(Value)), 2, "0") + RSet(Hex(Red(Value)), 2, "0") +#LF$
  EndIf
  
  Value = GetIceBtnThemeAttribute(#IceBtn_EnableShadow)
  Text$ + "Data.i #IceBtn_EnableShadow, "         + Str(Value) +#LF$
  
  Value = GetIceBtnThemeAttribute(#IceBtn_ShadowColor)
  If Value = #PB_Default
    Text$ + "Data.i #IceBtn_ShadowColor, #PB_Default" +#LF$
  Else
    Text$ + "Data.i #IceBtn_ShadowColor, $"       + RSet(Hex(Blue(Value)), 2, "0") + RSet(Hex(Green(Value)), 2, "0") + RSet(Hex(Red(Value)), 2, "0") +#LF$
  EndIf
  
  Value = GetIceBtnThemeAttribute(#IceBtn_RoundX)
  Text$ + "Data.i #IceBtn_RoundX, "               + Str(Value) +#LF$
  
  Value = GetIceBtnThemeAttribute(#IceBtn_RoundY)
  Text$ + "Data.i #IceBtn_RoundY, "               + Str(Value)
  
  SetClipboardText(Text$)
  Debug Text$
  Text$ = ""
EndProcedure

Procedure Resize_Window()
  Protected ScaleX.f, ScaleY.f, ImgWidth
  Static Window_WidthIni, Window_HeightIni
  If Window_WidthIni = 0
    Window_WidthIni = WindowWidth(#Window) : Window_HeightIni = WindowHeight(#Window)
  EndIf

  ScaleX = WindowWidth(#Window) / Window_WidthIni : ScaleY = WindowHeight(#Window) / Window_HeightIni
  ResizeGadget(#Txt_ButtonColor, ScaleX * 40, ScaleY * 20, ScaleX * 120, ScaleY * 22)
  ResizeGadget(#Canv_ButtonColor, ScaleX * 165, ScaleY * 20, ScaleX * 22, ScaleY * 22)
  DrawCanvasColor(#Canv_ButtonColor, GetIceBtnThemeAttribute(#IceBtn_color))

  ResizeGadget(#Txt_BackgroundColor, ScaleX * 40, ScaleY * 50, ScaleX * 120, ScaleY * 22)
  ResizeGadget(#Canv_BackgroundColor, ScaleX * 165, ScaleY * 50, ScaleX * 22, ScaleY * 22)
  DrawCanvasColor(#Canv_BackgroundColor, GetIceBtnThemeAttribute(#IceBtn_BackColor))
  
  ResizeGadget(#Txt_Disablecolor, ScaleX * 40, ScaleY * 80, ScaleX * 120, ScaleY * 22)
  ResizeGadget(#Canv_DisableColor, ScaleX * 165, ScaleY * 80, ScaleX * 22, ScaleY * 22)
  DrawCanvasColor(#Canv_DisableColor, GetIceBtnThemeAttribute(#IceBtn_DisableColor))
  
  ResizeGadget(#Txt_FrontColor, ScaleX * 40, ScaleY * 110, ScaleX * 120, ScaleY * 22)
  ResizeGadget(#Canv_FrontColor, ScaleX * 165, ScaleY * 110, ScaleX * 22, ScaleY * 22)
  DrawCanvasColor(#Canv_FrontColor, GetIceBtnThemeAttribute(#IceBtn_FrontColor))
  
  ResizeGadget(#Txt_DisableFrontColor, ScaleX * 40, ScaleY * 140, ScaleX * 120, ScaleY * 22)
  ResizeGadget(#Canv_DisableFrontColor, ScaleX * 165, ScaleY * 140, ScaleX * 22, ScaleY * 22)
  DrawCanvasColor(#Canv_DisableFrontColor, GetIceBtnThemeAttribute(#IceBtn_DisableFrontColor))
  
  ResizeGadget(#Txt_EnableShadow, ScaleX * 40, ScaleY * 170, ScaleX * 120, ScaleY * 22)

  ImgWidth = Round(((ScaleX * 22) - 13) / 2, #PB_Round_Down)
  CreateImage(0, ImgWidth + 1, ScaleY * 22)
  If StartDrawing(ImageOutput(0))
    Box(0, 0, OutputWidth(), OutputHeight(), GetSysColor_(#COLOR_3DFACE))
    StopDrawing()
  EndIf
  ResizeGadget(#Img_EnableShadow, ScaleX * 165, ScaleY * 170, ImgWidth + 1, ScaleY * 22)
  SetGadgetState(#Img_EnableShadow, ImageID(0))
  ResizeGadget(#Check_EnableShadow, (ScaleX * 165) + ImgWidth, ScaleY * 170, (ScaleX * 22) - ImgWidth, ScaleY * 22)
  
  ResizeGadget(#Txt_ShadowColor, ScaleX * 40, ScaleY * 200, ScaleX * 120, ScaleY * 22)
  ResizeGadget(#Canv_ShadowColor, ScaleX * 165, ScaleY * 200, ScaleX * 22, ScaleY * 22)
  DrawCanvasColor(#Canv_ShadowColor, GetIceBtnThemeAttribute(#IceBtn_ShadowColor))
  
  ResizeGadget(#Txt_RounDX, ScaleX * 40, ScaleY * 230, ScaleX * 120, ScaleY * 22)
  ResizeGadget(#Spin_RoundX, ScaleX * 165, ScaleY * 229, ScaleX * 50, ScaleY * 24)
  
  ResizeGadget(#Txt_RounDY, ScaleX * 40, ScaleY * 260, ScaleX * 120, ScaleY * 22)
  ResizeGadget(#Spin_RoundY, ScaleX * 165, ScaleY * 259, ScaleX * 50, ScaleY * 24)
  
  ResizeGadget(#Btn_DarkBlue, ScaleX * 40, ScaleY * 300, ScaleX * 80, ScaleY * 24)
  ResizeGadget(#Btn_LightBlue, ScaleX * 135, ScaleY * 300, ScaleX * 80, ScaleY * 24)
  
  ResizeGadget(#Btn_Clipboard, ScaleX * 260, ScaleY * 20, ScaleX * 240, ScaleY * 60)
  ResizeGadget(#Btn_Regular, ScaleX * 260, ScaleY * 100, ScaleX * 240, ScaleY * 60)
  ResizeGadget(#Btn_Toggle, ScaleX * 260, ScaleY * 180, ScaleX * 240, ScaleY * 60)
  ResizeGadget(#Btn_Disabled, ScaleX * 260, ScaleY * 260, ScaleX * 240, ScaleY * 60)
EndProcedure

Procedure SetBackColor(Color)
  Protected I
  SetWindowColor(#Window, Color)
  For I = #Txt_ButtonColor To #Txt_RounDY
    SetGadgetColor(I, #PB_Gadget_BackColor, Color)
    If IBIsDarkColor(Color)
      SetGadgetColor(I, #PB_Gadget_FrontColor, #White)
    Else
      SetGadgetColor(I, #PB_Gadget_FrontColor, #Black)
    EndIf
  Next
EndProcedure

Procedure DrawCanvasColor(Canvas, Color = #PB_Default)
  If StartDrawing(CanvasOutput(Canvas))
    If Color = #PB_Default
      Box(0, 0, OutputWidth(), OutputHeight(), GetSysColor_(#COLOR_3DFACE))
      Box(OutputWidth() / 4, OutputHeight() / 4, OutputWidth() / 2, OutputHeight() / 2, $FF00FF)
      GadgetToolTip(Canvas, "#PB_Default")
    Else
      Box(0, 0, OutputWidth(), OutputHeight(), Color)
      GadgetToolTip(Canvas, "RGB(" + Str(Red(Color)) + ", " + Str(Green(Color)) + ", " + Str(Blue(Color)) + ")" +
                            " or $" + RSet(Hex(Blue(Color)), 2, "0") + RSet(Hex(Green(Color)), 2, "0") + RSet(Hex(Red(Color)), 2, "0"))
    EndIf
    StopDrawing()
  EndIf
EndProcedure
      
Procedure Open_Window(X = 0, Y = 0, Width = 540, Height = 340)
  If OpenWindow(#Window, X, Y, Width, Height, "Build Ice Buttons Theme", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    
    TextGadget(#Txt_ButtonColor, 40, 20, 120, 22, "Button color:")
    SetGadgetColor(#Txt_ButtonColor, #PB_Gadget_FrontColor, RGB(255, 255, 255))
    SetGadgetColor(#Txt_ButtonColor, #PB_Gadget_BackColor, RGB(33, 37, 41))
    CanvasGadget(#Canv_ButtonColor, 165, 20, 22, 22, #PB_Canvas_Border | #PB_Canvas_DrawFocus)
    DrawCanvasColor(#Canv_ButtonColor, GetIceBtnThemeAttribute(#IceBtn_color))
  
    TextGadget(#Txt_BackgroundColor, 40, 50, 120, 22, "Background color:")
    SetGadgetColor(#Txt_BackgroundColor, #PB_Gadget_FrontColor, RGB(255, 255, 255))
    SetGadgetColor(#Txt_BackgroundColor, #PB_Gadget_BackColor, RGB(33, 37, 41))
    CanvasGadget(#Canv_BackgroundColor, 165, 50, 22, 22, #PB_Canvas_Border | #PB_Canvas_DrawFocus)
    DrawCanvasColor(#Canv_BackgroundColor, GetIceBtnThemeAttribute(#IceBtn_BackColor))
    
    TextGadget(#Txt_Disablecolor, 40, 80, 120, 22, "Disable color:")
    SetGadgetColor(#Txt_Disablecolor, #PB_Gadget_FrontColor, RGB(255, 255, 255))
    SetGadgetColor(#Txt_Disablecolor, #PB_Gadget_BackColor, RGB(33, 37, 41))
    CanvasGadget(#Canv_DisableColor, 165, 80, 22, 22, #PB_Canvas_Border | #PB_Canvas_DrawFocus)
    DrawCanvasColor(#Canv_DisableColor, GetIceBtnThemeAttribute(#IceBtn_DisableColor))
    
    TextGadget(#Txt_FrontColor, 40, 110, 120, 22, "Text color:")
    SetGadgetColor(#Txt_FrontColor, #PB_Gadget_FrontColor, RGB(255, 255, 255))
    SetGadgetColor(#Txt_FrontColor, #PB_Gadget_BackColor, RGB(33, 37, 41))
    CanvasGadget(#Canv_FrontColor, 165, 110, 22, 22, #PB_Canvas_Border | #PB_Canvas_DrawFocus)
    DrawCanvasColor(#Canv_FrontColor, GetIceBtnThemeAttribute(#IceBtn_FrontColor))
    
    TextGadget(#Txt_DisableFrontColor, 40, 140, 120, 22, "Disable text color:")
    SetGadgetColor(#Txt_DisableFrontColor, #PB_Gadget_FrontColor, RGB(255, 255, 255))
    SetGadgetColor(#Txt_DisableFrontColor, #PB_Gadget_BackColor, RGB(33, 37, 41))
    CanvasGadget(#Canv_DisableFrontColor, 165, 140, 22, 22, #PB_Canvas_Border | #PB_Canvas_DrawFocus)
    DrawCanvasColor(#Canv_DisableFrontColor, GetIceBtnThemeAttribute(#IceBtn_DisableFrontColor))
    
    TextGadget(#Txt_EnableShadow, 40, 170, 120, 22, "Enable Shadow:")
    SetGadgetColor(#Txt_EnableShadow, #PB_Gadget_FrontColor, RGB(255, 255, 255))
    SetGadgetColor(#Txt_EnableShadow, #PB_Gadget_BackColor, RGB(33, 37, 41))
    ImageGadget(#Img_EnableShadow, 165, 170, 5, 22, 0)
    CheckBoxGadget(#Check_EnableShadow, 169, 170, 18, 22, "")
    SetGadgetState(#Check_EnableShadow, GetIceBtnThemeAttribute(#IceBtn_EnableShadow))
    
    TextGadget(#Txt_ShadowColor, 40, 200, 120, 22, "Shadow color:")
    SetGadgetColor(#Txt_ShadowColor, #PB_Gadget_FrontColor, RGB(255, 255, 255))
    SetGadgetColor(#Txt_ShadowColor, #PB_Gadget_BackColor, RGB(33, 37, 41))
    CanvasGadget(#Canv_ShadowColor, 165, 200, 22, 22, #PB_Canvas_Border | #PB_Canvas_DrawFocus)
    DrawCanvasColor(#Canv_ShadowColor, GetIceBtnThemeAttribute(#IceBtn_ShadowColor))
    
    TextGadget(#Txt_RounDX, 40, 230, 120, 22, "RounDX:")
    SetGadgetColor(#Txt_RounDX, #PB_Gadget_FrontColor, RGB(255, 255, 255))
    SetGadgetColor(#Txt_RounDX, #PB_Gadget_BackColor, RGB(33, 37, 41))
    SpinGadget(#Spin_RoundX, 165, 229, 50, 24, 0, 999, #PB_Spin_Numeric)
    SetWindowLongPtr_(GadgetID(#Spin_RoundX), #GWL_STYLE, GetWindowLongPtr_(GadgetID(#Spin_RoundX), #GWL_STYLE) | #ES_NUMBER)
    SetGadgetState(#Spin_RoundX, GetIceBtnThemeAttribute(#IceBtn_RoundX))
    
    TextGadget(#Txt_RounDY, 40, 260, 120, 22, "RounDY:")
    SetGadgetColor(#Txt_RounDY, #PB_Gadget_FrontColor, RGB(255, 255, 255))
    SetGadgetColor(#Txt_RounDY, #PB_Gadget_BackColor, RGB(33, 37, 41))
    SpinGadget(#Spin_RoundY, 165, 259, 50, 24, 0, 999, #PB_Spin_Numeric)
    SetWindowLongPtr_(GadgetID(#Spin_RoundY), #GWL_STYLE, GetWindowLongPtr_(GadgetID(#Spin_RoundY), #GWL_STYLE) | #ES_NUMBER)
    SetGadgetState(#Spin_RoundY, GetIceBtnThemeAttribute(#IceBtn_RoundY))
    
    ButtonGadget(#Btn_DarkBlue, 40, 300, 80, 24, "DarkBlue")
    GadgetToolTip(#Btn_DarkBlue, "Apply DarkBlue Theme")
    ButtonGadget(#Btn_LightBlue, 135, 300, 80, 24, "LightBlue")
    GadgetToolTip(#Btn_LightBlue, "Apply LightBlue Theme")
    
    ButtonGadget(#Btn_Clipboard, 260, 20, 240, 60, "Copy Theme to clipboard")
    ButtonGadget(#Btn_Regular, 260, 100, 240, 60, "MultiLine IceButton Gadget (#PB_Button_MultiLine)", #PB_Button_MultiLine)
    ButtonGadget(#Btn_Toggle, 260, 180, 240, 60, "Toggle Button (ON)", #PB_Button_Toggle)
    SetGadgetState(#Btn_Toggle, #True)
    ButtonGadget(#Btn_Disabled, 260, 260, 240, 60, "Disabled Button", #PB_Button_Toggle)
    DisableGadget(#Btn_Disabled, #True)
    
    BindEvent(#PB_Event_SizeWindow, @Resize_Window(), #Window)
    PostEvent(#PB_Event_SizeWindow, #Window, 0)
    
    WindowBounds(#Window, 450, 240, #PB_Ignore, #PB_Ignore)
  EndIf
EndProcedure

;- Main
Define Color

SetIceButtonTheme(#IceBtn_Theme_DarkBlue)

Open_Window()

SetBackColor(GetIceBtnThemeAttribute(#IceBtn_BackColor))
              
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break

    Case #PB_Event_Gadget
      Select EventGadget()
        Case #Btn_Clipboard
          ClipboardText()
          
        Case #Btn_Toggle
          If GetGadgetState(#Btn_Toggle)
            SetGadgetText(#Btn_Toggle, "Toggle Button (ON)")
          Else
            SetGadgetText(#Btn_Toggle, "Toggle Button (OFF)")
          EndIf
          
        Case #Canv_ButtonColor, #Canv_BackgroundColor, #Canv_DisableColor, #Canv_FrontColor, #Canv_DisableFrontColor, #Canv_ShadowColor
          If EventType() = #PB_EventType_LeftClick
            ; Attribute = EventGadget() (ex:  #Canv_ButtonColor = #IceBtn_Color)
            Color = ColorRequester(GetIceBtnThemeAttribute(EventGadget()))
            If EventGadget() = #Canv_ButtonColor And Color = #PB_Default
              Color = GetSysColor_(#COLOR_3DFACE)
            EndIf
            SetIceBtnThemeAttribute(EventGadget(), Color)
            DrawCanvasColor(EventGadget(), Color)
            If EventGadget() = #Canv_BackgroundColor
              SetBackColor(Color)
            EndIf
          EndIf

        Case #Check_EnableShadow
          SetIceBtnThemeAttribute(#IceBtn_EnableShadow, GetGadgetState(#Check_EnableShadow))
          
        Case #Spin_RoundX
          If EventType() = #PB_EventType_Change
            SetIceBtnThemeAttribute(#IceBtn_RoundX, GetGadgetState(#Spin_RoundX))
          EndIf
          
        Case #Spin_RoundY
          If EventType() = #PB_EventType_Change
            SetIceBtnThemeAttribute(#IceBtn_RoundY, GetGadgetState(#Spin_RoundY))
          EndIf
          
        Case #Btn_DarkBlue, #Btn_LightBlue
          Select EventGadget()
            Case #Btn_DarkBlue
              SetIceButtonTheme(#IceBtn_Theme_DarkBlue)
            Case #Btn_LightBlue
              SetIceButtonTheme(#IceBtn_Theme_LightBlue)  
          EndSelect
          SetBackColor(GetIceBtnThemeAttribute(#IceBtn_BackColor))
          SetGadgetState(#Check_EnableShadow, GetIceBtnThemeAttribute(#IceBtn_EnableShadow))
          SetGadgetState(#Spin_RoundX, GetIceBtnThemeAttribute(#IceBtn_RoundX))
          SetGadgetState(#Spin_RoundY, GetIceBtnThemeAttribute(#IceBtn_RoundY))
          PostEvent(#PB_Event_SizeWindow, #Window, 0)   ; To redraw Canvas Color with the new theme
          
      EndSelect
  EndSelect
ForEver
; IDE Options = PureBasic 6.01 LTS (Windows - x64)
; CursorPosition = 177
; FirstLine = 169
; Folding = -
; EnableXP