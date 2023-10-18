;- Top
;  -------------------------------------------------------------------------------------------------------------------------------------------------
;          Title: Ice Button Theme Library (for Dark or Light Theme Button)
;    Description: This library will add a theme to your ButtonGadget, ButtonImageGadget
;                 They'll still work in the same way as PureBasic Button, they're ButtonGadget, ButtonImageGadget
;    Source Name: IceButtons.pbi
;         Author: ChrisR
;  Creation Date: 2023-10-06
;  Revision Date: 2023-10-18
;        Version: 1.4
;     PB-Version: 6.0 or other
;             OS: Windows Only
;         Credit: JellyButtons by Justin Jack (January  1, 2014)
;          Forum: https://www.purebasic.fr/english/viewtopic.php?t=82592
;
;
; * How tu use: 
;     Add: XIncludeFile "IceButtons.pbi"
;     And apply one of the themes With the function: SetIceButtonTheme(#IceBtn_Theme_DarkBlue) or SetIceButtonTheme(#IceBtn_Theme_LightBlue)
;   Easy ;) That's all :)   
;   Note that you can SetIceButtonTheme(Theme) anywhere you like in your source, before or after creating the window, gadget's and buttons
;
;  -------------------------------------------------------------------------------------------------------------------------------------------------
;  |      Theme attribute (see DataSection)           |      Description
;  |--------------------------------------------------|---------------------------------------------------------------------------------------------
;  | #IceBtn_color, Color                             | Button color
;  | #IceBtn_BackColor, Color or #PB_Default          | Button background color, #PB_Default to get window color
;  | #IceBtn_DisableColor, Color or #PB_Default       | Disable Button color, #PB_Default to obtain the color by applying a deactivated filter to the button color
;  | #IceBtn_FrontColor, Color or #PB_Default         | Button text color, #PB_Default = White or Black depending on whether the button color is dark or light
;  | #IceBtn_DisableFrontColor, Color or #PB_Default  | Disable text color, #PB_Default to obtain the color by applying a deactivated filter to the button text color
;  | #IceBtn_EnableShadow, 0 or 1                     | Disable or Enable text shadow
;  | #IceBtn_ShadowColor, Color or #PB_Default        | Button text shadow color, #PB_Default = White or Black depending on whether the button text color is dark or light
;  | #IceBtn_BorderColor, Color or #PB_Default        | Button border color, #PB_Default for the Button color
;  | #IceBtn_RoundX, Size                             | from 1 to X. For RoundBox(), the radius of the rounded corners in the X direction
;  | #IceBtn_RoundY, Size                             | from 1 to Y. For RoundBox(), the radius of the rounded corners in the Y direction
;  -------------------------------------------------------------------------------------------------------------------------------------------------
;
;  -------------------------------------------------------------------------------------------------------------------------------------------------
;  |             Public Functions                     |      Description
;  |--------------------------------------------------|--------------------------------------------------------------------------------------------- 
;  | SetIceButtonTheme(#Theme)                        | Apply, Change theme
;  |     Ex: SetIceButtonTheme(#IceBtn_Theme_DarkBlue) or SetIceButtonTheme(#IceBtn_Theme_LightBlue) or custom future Theme
;  |                                                  |
;  | GetIceButtonTheme()                              | Get the current theme
;  |                                                  |
;  | IsIceButton(#Gadget)                             | Is it an IceButton?
;  |                                                  |
;  | FreeIceButtonTheme()                             | Free the theme, IceButton and associated resources and return to the standard ButtonGadget
;  |                                                  |
;  | SetIceBtnThemeAttribute(#Attribut, Value)        | Changes a theme attribute value
;  |   - Ex: SetIceBtnThemeAttribute(#IceBtn_color, #Blue) to change the theme Button color attribute in blue
;  |                                                  |
;  | GetIceBtnThemeAttribute(#Attribut)               | Returns a theme Attribute value
;  |   - Ex: GetIceBtnThemeAttribute(#IceBtn_color)
;  |                                                  |
;  | SetIceButtonAttribute(#Gadget, #Attribut, Value) | Changes an IceButton attribute value
;  |   - Ex: SetIceButtonAttribute(#Gadget, #IceBtn_color, #Blue) to change the IceButton color in blue
;  |                                                  |
;  | GetIceButtonAttribute(#Gadget, #Attribut)        | Returns an IceButton attribute value
;  |   - Ex: GetIceButtonAttribute(#Gadget, #IceBtn_color)
;  -------------------------------------------------------------------------------------------------------------------------------------------------

EnableExplicit

Enumeration IceButtonTheme 1
  #IceBtn_Theme
  #IceBtn_Theme_DarkBlue
  #IceBtn_Theme_LightBlue
  #IceBtn_MyTheme
EndEnumeration

Enumeration IceButtonTheme
  #IceBtn_color
  #IceBtn_BackColor
  #IceBtn_DisableColor
  #IceBtn_FrontColor
  #IceBtn_DisableFrontColor
  #IceBtn_EnableShadow
  #IceBtn_ShadowColor
  #IceBtn_BorderColor
  #IceBtn_RoundX
  #IceBtn_RoundY
  #IceBtn_END
EndEnumeration

Structure IBTN_INFO
  sButtonText.s
  bButtonState.b
  bButtonEnable.b
  iButtonColor.i
  iButtonBackColor.i
  iDisableBackColor.i
  iActiveFont.i
  iFrontColor.i
  iDisableFrontColor.i
  bEnableShadow.b
  iShadowColor.i
  iBorderColor.i
  iButtonImage.i
  iButtonImageID.i
  iButtonPressedImage.i
  iButtonPressedImageID.i
  iRoundX.i
  iRoundY.i
  bMouseOver.b
  bHiLiteTimer.b
  bClickTimer.b
  imgRegular.i
  imgHilite.i
  imgPressed.i
  imgHiPressed.i
  imgDisabled.i
  hRgn.i
  hDcRegular.i
  hDcHiLite.i
  hDcPressed.i
  hDcHiPressed.i
  hDcDisabled.i
  hObjRegular.i
  hObjHiLite.i
  hObjPressed.i
  hObjHiPressed.i
  hObjDisabled.i
EndStructure
  
Structure ICEBUTTON_INFO
  PBGadget.i
  IDGadget.i
  IDParent.i
  PBGadgetType.i
  *BtnInfo.IBTN_INFO
  *OldWndProc
EndStructure

Declare ToolTipHandle() 
Declare IBWindowPB(WindowID)
Declare IBIsDarkColor(iColor)
Declare IBDisabledDarkColor(iColor)
Declare IBDisabledLightColor(iColor)

Declare _ButtonGadget(Gadget, X, Y, Width, Height, Text$, Flags)
Declare LoadIceButtonTheme(Theme)
Declare MakeIceButtonImages(cX, cY, *IceButton.ICEBUTTON_INFO)
Declare MakeIceImagesButton(cX, cY, *IceButton.ICEBUTTON_INFO)
Declare ChangeIceButton(Gadget)
Declare UpdateIceButtonImages(*IceButton.ICEBUTTON_INFO)
Declare FreeIceButton(Gadget)
Declare AddIceButton(Gadget, *IceButton.ICEBUTTON_INFO, UpdateIceButton.b = #False)
Declare IceButton_WndProc(hWnd, uMsg, wParam, lParam)

Declare IsIceButton(Gadget)
Declare GetIceBtnThemeAttribute(Attribut)
Declare SetIceBtnThemeAttribute(Attribut, Value)
Declare GetIceButtonAttribute(Gadget, Attribut)
Declare SetIceButtonAttribute(Gadget, Attribut, Value)
Declare FreeIceButtonTheme()
Declare GetIceButtonTheme()
Declare SetIceButtonTheme(Theme)

Global NewMap IceBtnTheme()
Global NewList IceButton.ICEBUTTON_INFO()
Global Tooltip

Macro IBProcedureReturnIf(Cond, ReturnVal = 0)
  If Cond
    ProcedureReturn ReturnVal
  EndIf
EndMacro

Macro IceButtonID(pIceButton, Gadget, ReturnValue = #False)
  PushListPosition(IceButton())
  Repeat
    ForEach IceButton()
      If IceButton()\PBGadget = Gadget
        pIceButton = @IceButton()
        PopListPosition(IceButton())
        Break 2
      EndIf
    Next
    Debug "IceButtons Error: IceButton not found in IceButtons list."
    PopListPosition(IceButton())
    ProcedureReturn ReturnValue
  Until #True
EndMacro

;
; -----------------------------------------------------------------------------
;- ----- Color & Filter -----
; -----------------------------------------------------------------------------

Structure PB_Globals
  CurrentWindow.i
  FirstOptionGadget.i
  DefaultFont.i
  *PanelStack
  PanelStackIndex.l
  PanelStackSize.l
  ToolTipWindow.i
EndStructure

Import ""
  CompilerIf Not (Defined(PB_Object_EnumerateStart, #PB_Procedure))  : PB_Object_EnumerateStart(PB_Gadget_Objects)                 : CompilerEndIf
  CompilerIf Not (Defined(PB_Object_EnumerateNext, #PB_Procedure))   : PB_Object_EnumerateNext(PB_Gadget_Objects, *Object.Integer) : CompilerEndIf
  CompilerIf Not (Defined(PB_Object_EnumerateAbort, #PB_Procedure))  : PB_Object_EnumerateAbort(PB_Gadget_Objects)                 : CompilerEndIf
  CompilerIf Not (Defined(PB_Object_GetThreadMemory, #PB_Procedure)) : PB_Object_GetThreadMemory(*Mem)                             : CompilerEndIf
  CompilerIf Not (Defined(PB_Window_Objects, #PB_Variable))          : PB_Window_Objects.i                                         : CompilerEndIf
  CompilerIf Not (Defined(PB_Gadget_Objects, #PB_Variable))          : PB_Gadget_Objects.i                                         : CompilerEndIf
  CompilerIf Not (Defined(PB_Image_Objects, #PB_Variable))           : PB_Image_Objects.i                                         : CompilerEndIf
  CompilerIf Not (Defined(PB_Gadget_Globals, #PB_Variable))          : PB_Gadget_Globals.i                                         : CompilerEndIf
EndImport

Procedure ToolTipHandle() 
  Protected *PBGadget.PB_Globals 
  *PBGadget = PB_Object_GetThreadMemory(PB_Gadget_Globals) 
  ProcedureReturn *PBGadget\ToolTipWindow 
EndProcedure

Macro _ToolTipHandle()
  Tooltip = ToolTipHandle()
  If Tooltip
    SetWindowTheme_(Tooltip, @"", @"")
    ;SendMessage_(Tooltip, #TTM_SETDELAYTIME, #TTDT_INITIAL, 250) : SendMessage_(Tooltip, #TTM_SETDELAYTIME,#TTDT_AUTOPOP, 5000) : SendMessage_(Tooltip, #TTM_SETDELAYTIME,#TTDT_RESHOW, 250)
    Protected TmpBackColor = GetIceBtnThemeAttribute(#IceBtn_BackColor)
    SendMessage_(Tooltip, #TTM_SETTIPBKCOLOR, TmpBackColor, 0)
    If IBIsDarkColor(TmpBackColor)
      SendMessage_(Tooltip, #TTM_SETTIPTEXTCOLOR, #White, 0)
    Else
      SendMessage_(Tooltip, #TTM_SETTIPTEXTCOLOR, #Black, 0)
    EndIf
    SendMessage_(Tooltip, #WM_SETFONT, 0, 0)
  EndIf
EndMacro

Procedure IBWindowPB(WindowID) ; Find pb-id over handle
  Protected Result = -1, Window
  PB_Object_EnumerateStart(PB_Window_Objects)
  While PB_Object_EnumerateNext(PB_Window_Objects, @Window)
    If WindowID = WindowID(Window)
      Result = Window
      Break
    EndIf
  Wend
  PB_Object_EnumerateAbort(PB_Window_Objects)
  ProcedureReturn Result
EndProcedure

Procedure ImagePB(ImageID) ; Find pb-id over handle
  Protected result, image
  result = -1
  PB_Object_EnumerateStart(PB_Image_Objects)
  While PB_Object_EnumerateNext(PB_Image_Objects, @image)
    If ImageID = ImageID(image)
      result = image
      Break
    EndIf
  Wend
  PB_Object_EnumerateAbort(PB_Image_Objects)
  ProcedureReturn result
EndProcedure

Procedure IBIsDarkColor(iColor)
  If Red(iColor)*0.299 + Green(iColor)*0.587 +Blue(iColor)*0.114 < 128   ; Based on Human perception of color, following the RGB values (0.299, 0.587, 0.114)
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure ScaleGrayCallback(x, y, SourceColor, TargetColor)
  Protected light
  light = ((Red(TargetColor) * 30 + Green(TargetColor) * 59 + Blue(TargetColor) * 11) / 100)
  ProcedureReturn RGBA(light, light, light, 255)
EndProcedure

Procedure IBDisabledDarkColor(iColor)
  Protected R, G, B
  R = Red(iColor)   * 0.5 + (Red(iColor)   + 80) * 0.5 : If R > 255 : R = 255 : EndIf
  G = Green(iColor) * 0.5 + (Green(iColor) + 80) * 0.5 : If G > 255 : G = 255 : EndIf
  B = Blue(iColor)  * 0.5 + (Blue(iColor)  + 80) * 0.5 : If B > 255 : B = 255 : EndIf
  ProcedureReturn RGBA(R, G, B, Alpha(iColor))
EndProcedure

Procedure IBDisabledLightColor(iColor)
  Protected R, G, B
  R = Red(iColor)   * 0.5 + (Red(iColor)   - 80) * 0.5 : If R > 255 : R = 255 : EndIf
  G = Green(iColor) * 0.5 + (Green(iColor) - 80) * 0.5 : If G > 255 : G = 255 : EndIf
  B = Blue(iColor)  * 0.5 + (Blue(iColor)  - 80) * 0.5 : If B > 255 : B = 255 : EndIf
  ProcedureReturn RGBA(R, G, B, Alpha(iColor))
EndProcedure

;
; -----------------------------------------------------------------------------
;- ----- Ice Buttons Private -----
; -----------------------------------------------------------------------------
Procedure _ButtonImageGadget(Gadget, X, Y, Width, Height, IDImage, Flags)
  Protected AddIceButton, RetVal

  If Gadget = #PB_Any
    Gadget = ButtonImageGadget(#PB_Any, X, Y, Width, Height, IDImage, Flags)
    RetVal = Gadget
  Else
    RetVal = ButtonImageGadget(Gadget, X, Y, Width, Height, IDImage, Flags)
  EndIf
  
  If MapSize(IceBtnTheme()) > 0   ; SetIceButtonTheme() Done
    AddIceButton = #True
    ForEach IceButton()
      If IceButton()\PBGadget = Gadget And IceButton()\IDGadget = GadgetID(Gadget)
        AddIceButton(Gadget, IceButton(), #True)  ; UpdateIceButton = #True
        AddIceButton = #False  
        Break
      EndIf
    Next
    If AddIceButton
      AddElement(IceButton())
      AddIceButton(Gadget, IceButton())
    EndIf
  EndIf
  
  ProcedureReturn RetVal
EndProcedure

; Macro ButtonGadget written after _ButtonGadget procedure, not to be extended in _ButtonGadget procedure at compile time (1 pass)
Macro ButtonImageGadget(Gadget, X, Y, Width, Height, IDImage, Flags = 0)
  _ButtonImageGadget(Gadget, X, Y, Width, Height, IDImage, Flags)
EndMacro

Procedure _ButtonGadget(Gadget, X, Y, Width, Height, Text$, Flags)
  Protected AddIceButton, RetVal

  If Gadget = #PB_Any
    Gadget = ButtonGadget(#PB_Any, X, Y, Width, Height, Text$, Flags)
    RetVal = Gadget
  Else
    RetVal = ButtonGadget(Gadget, X, Y, Width, Height, Text$, Flags)
  EndIf
  
  If MapSize(IceBtnTheme()) > 0   ; SetIceButtonTheme() Done
    AddIceButton = #True
    ForEach IceButton()
      If IceButton()\PBGadget = Gadget And IceButton()\IDGadget = GadgetID(Gadget)
        AddIceButton(Gadget, IceButton(), #True)  ; UpdateIceButton = #True
        AddIceButton = #False  
        Break
      EndIf
    Next
    If AddIceButton
      AddElement(IceButton())
      AddIceButton(Gadget, IceButton())
    EndIf
  EndIf
  
  ProcedureReturn RetVal
EndProcedure

; Macro ButtonGadget written after _ButtonGadget procedure, not to be extended in _ButtonGadget procedure at compile time (1 pass)
Macro ButtonGadget(Gadget, X, Y, Width, Height, Text, Flags = 0)
  _ButtonGadget(Gadget, X, Y, Width, Height, Text, Flags)
EndMacro

Procedure _SetGadgetAttribute(Gadget, Attribute, Value)
  If MapSize(IceBtnTheme()) > 0
    If GadgetType(Gadget) = #PB_GadgetType_ButtonImage
      ForEach IceButton()
        If IceButton()\PBGadget = Gadget And IceButton()\IDGadget = GadgetID(Gadget)
          Select Attribute
            Case #PB_Button_Image
              IceButton()\BtnInfo\iButtonImageID = Value
              If Value
                IceButton()\BtnInfo\iButtonImage = ImagePB(Value)
              Else
                IceButton()\BtnInfo\iButtonImage = 0
              EndIf
              If IceButton()\BtnInfo\iButtonPressedImageID = 0
                IceButton()\BtnInfo\iButtonPressedImageID = Value
                IceButton()\BtnInfo\iButtonPressedImage = IceButton()\BtnInfo\iButtonImage
              EndIf
              ChangeIceButton(IceButton()\PBGadget)
            Case #PB_Button_PressedImage
              IceButton()\BtnInfo\iButtonPressedImageID = Value
              If Value
                IceButton()\BtnInfo\iButtonPressedImage = ImagePB(Value)
              Else
                IceButton()\BtnInfo\iButtonPressedImage = 0
              EndIf
              ChangeIceButton(IceButton()\PBGadget)
          EndSelect
          Break
        EndIf
      Next
    EndIf
  EndIf
  SetGadgetAttribute(Gadget, Attribute, Value)
EndProcedure

Macro SetGadgetAttribute(Gadget, Attribute, Value)
  _SetGadgetAttribute(Gadget, Attribute, Value)
EndMacro

Procedure LoadIceButtonTheme(Theme)
  Protected Buffer.i, ColorType.s, I.i, J.i 
  
  Select Theme
    Case #IceBtn_Theme_DarkBlue
      Restore DarkBlue
    Case #IceBtn_Theme_LightBlue
      Restore LightBlue
    Case #IceBtn_MyTheme
      Restore MyTheme
    Default
      Restore DarkBlue
  EndSelect
  IceBtnTheme(Str(#IceBtn_Theme)) = Theme
  For I = 1 To 99
    For J = 1 To 2
      Read.i Buffer
      Select J
        Case 1
          If Buffer = #IceBtn_END
            Break 2
          EndIf
          ColorType = Str(Buffer)
        Case 2
          IceBtnTheme(ColorType) = Buffer
      EndSelect
    Next
  Next
EndProcedure

Procedure MakeIceButtonImages(cX, cY, *IceButton.ICEBUTTON_INFO)
  Protected *ThisImage, I
  
  With *IceButton\BtnInfo
    Protected ButtonColor = \iButtonColor, ButtonBackColor = \iButtonBackColor, BorderColor = \iBorderColor
    Protected RoundX = \iRoundX, RoundY = \iRoundY
    
    ; DPIaware Images size. The image size must be greater than 0 To avoid an error when resizing  
    cX = DesktopScaledX(cX) : cY = DesktopScaledY(cY)
    If cX = 0 : cX = 1 : EndIf
    If cY = 0 : cY = 1 : EndIf
    
    If \imgRegular   And IsImage(\imgRegular)   : FreeImage(\imgRegular)   : EndIf
    If \imgHilite    And IsImage(\imgHilite)    : FreeImage(\imgHilite)    : EndIf
    If \imgPressed   And IsImage(\imgPressed)   : FreeImage(\imgPressed)   : EndIf
    If \imgHiPressed And IsImage(\imgHiPressed) : FreeImage(\imgHiPressed) : EndIf
    If \imgDisabled  And IsImage(\imgDisabled)  : FreeImage(\imgDisabled)  : EndIf
    
    \imgRegular   = CreateImage(#PB_Any, cX, cY, 32)
    \imgHilite    = CreateImage(#PB_Any, cX, cY, 32)
    \imgPressed   = CreateImage(#PB_Any, cX, cY, 32)
    \imgHiPressed = CreateImage(#PB_Any, cX, cY, 32)
    \imgDisabled  = CreateImage(#PB_Any, cX, cY, 32)
       
    For I = 0 To 4
      Select I
        Case 0
          *ThisImage  = \imgRegular
        Case 1
          *ThisImage  = \imgHilite
        Case 2
          *ThisImage  = \imgPressed
        Case 3
          *ThisImage  = \imgHiPressed
        Case 4
          *ThisImage  = \imgDisabled
          ButtonColor = \iDisableBackColor
      EndSelect
      
      If StartDrawing(ImageOutput(*ThisImage))
        
        Box(0, 0, cX, cY, ButtonBackColor)
        RoundBox(0, 0, cX, cY, RoundX, RoundY, ButtonColor | $80000000)
        DrawingMode(#PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend)
        
        ; Draw an ellipse a little wider than the button and slightly offset upwards, to have a gradient with the background color in the 4 corners and more important at the bottom
        EllipticalGradient(cX / 2, cY * 2 / 5, cX * 3 / 5, cY * 4 / 5)
        GradientColor(0.0, ButtonColor | $BE000000)
        Select I
          Case 0, 4   ; imgRegular, imgDisabled
            GradientColor(0.15, ButtonColor | $BE000000)
          Case 1, 3   ; imgHilite, imgHiPressed
            GradientColor(0.3,  ButtonColor | $BE000000)
          Case 2      ; imgPressed
            GradientColor(0.45, ButtonColor | $BE000000)
        EndSelect
        GradientColor(1.0,  ButtonBackColor | $BE000000)
        RoundBox(0, 0, cX, cY, RoundX, RoundY)
        
        ; Border drawn with button color and an inner 1 px border with background color (full inside or top left or bottom right)
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(0, 0, cX, cY, RoundX, RoundY, BorderColor)
        Select I
          Case 0, 4     ; imgRegular, imgDisabled
            RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, ButtonBackColor)
          Case 1, 3     ; imgHilite, imgHiPressed
            RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, BorderColor)
            RoundBox(2, 2, cX-4, cY-4, RoundX, RoundY, ButtonBackColor)
          Case 2        ; imgPressed
            RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, BorderColor)
            RoundBox(2, 2, cX-4, cY-4, RoundX, RoundY, BorderColor)
            RoundBox(3, 3, cX-6, cY-6, RoundX, RoundY, ButtonBackColor)
        EndSelect
        
        StopDrawing()
      EndIf
    Next
    
    SelectObject_(\hDcRegular,   ImageID(\imgRegular))
    SelectObject_(\hDcHiLite,    ImageID(\imgHilite))
    SelectObject_(\hDcPressed,   ImageID(\imgPressed))
    SelectObject_(\hDcHiPressed, ImageID(\imgHiPressed))
    SelectObject_(\hDcDisabled,  ImageID(\imgDisabled))
  EndWith
  
EndProcedure

Procedure MakeIceImagesButton(cX, cY, *IceButton.ICEBUTTON_INFO)
  Protected *ThisImage, I
  
  With *IceButton\BtnInfo
    Protected ButtonColor = \iButtonColor, ButtonBackColor = \iButtonBackColor, BorderColor = \iBorderColor
    Protected RoundX = \iRoundX, RoundY = \iRoundY
    
    ; DPIaware Images size. The image size must be greater than 0 To avoid an error when resizing  
    cX = DesktopScaledX(cX) : cY = DesktopScaledY(cY)
    If cX = 0 : cX = 1 : EndIf
    If cY = 0 : cY = 1 : EndIf
    
    If \imgRegular   And IsImage(\imgRegular)   : FreeImage(\imgRegular)   : EndIf
    If \imgHilite    And IsImage(\imgHilite)    : FreeImage(\imgHilite)    : EndIf
    If \imgPressed   And IsImage(\imgPressed)   : FreeImage(\imgPressed)   : EndIf
    If \imgHiPressed And IsImage(\imgHiPressed) : FreeImage(\imgHiPressed) : EndIf
    If \imgDisabled  And IsImage(\imgDisabled)  : FreeImage(\imgDisabled)  : EndIf
    
    \imgRegular   = CreateImage(#PB_Any, cX, cY, 32)
    \imgHilite    = CreateImage(#PB_Any, cX, cY, 32)
    \imgPressed   = CreateImage(#PB_Any, cX, cY, 32)
    \imgHiPressed = CreateImage(#PB_Any, cX, cY, 32)
    \imgDisabled  = CreateImage(#PB_Any, cX, cY, 32)
       
    For I = 0 To 4
      Select I
        Case 0
          *ThisImage  = \imgRegular
        Case 1
          *ThisImage  = \imgHilite
        Case 2
          *ThisImage  = \imgPressed
        Case 3
          *ThisImage  = \imgHiPressed
        Case 4
          *ThisImage  = \imgDisabled
          ButtonColor = \iDisableBackColor
      EndSelect

      If StartDrawing(ImageOutput(*ThisImage))
        
        Select I
          Case 0, 1
            If \iButtonImageID And IsImage(\iButtonImage)
              DrawImage(\iButtonImageID, 0, 0, cX, cY)
            Else
              Box(0, 0, cX, cY, GetSysColor_(#COLOR_3DFACE))
            EndIf
          Case 2, 3
            If \iButtonPressedImageID And IsImage(\iButtonPressedImage)
              DrawImage(\iButtonPressedImageID, 0, 0, cX, cY)
            Else
              Box(0, 0, cX, cY, GetSysColor_(#COLOR_3DFACE))  
            EndIf
          Case 4
            If \iButtonImageID And IsImage(\iButtonImage)
              DrawImage(\iButtonImageID, 0, 0, cX, cY)
            Else
              Box(0, 0, cX, cY, GetSysColor_(#COLOR_3DFACE))
            EndIf
            DrawingMode(#PB_2DDrawing_CustomFilter)
            CustomFilterCallback(@ScaleGrayCallback())
            Box(0, 0, cX, cY)
        EndSelect
        
        ; Draw a transparent ellipse a little wider than the button and slightly offset upwards, to have a gradient with the background color in the 4 corners and more important at the bottom
        Select I
          Case 1, 3     ; imgHilite, imgHiPressed
            DrawingMode(#PB_2DDrawing_Gradient | #PB_2DDrawing_AlphaBlend)
            EllipticalGradient(cX / 2, cY * 2 / 5, cX * 3 / 5, cY * 4 / 5)
            GradientColor(0.0, ButtonColor | $14000000)
            GradientColor(0.3,  ButtonColor | $14000000)
            GradientColor(1.0,  ButtonBackColor | $14000000)
            RoundBox(0, 0, cX, cY, RoundX, RoundY)
        EndSelect
        
        ; Fill outside RoundBox border, corner with background color
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, $B200FF)
        FillArea(0, 0, $B200FF, ButtonBackColor)
        RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, #Black)
        FillArea(0, 0, #Black, ButtonBackColor)
        
        ; Border drawn with button color and an inner 1 px border with background color (full inside or top left or bottom right)
        RoundBox(0, 0, cX, cY, RoundX, RoundY, BorderColor)
        Select I
          Case 0, 4     ; imgRegular, imgDisabled
            RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, ButtonBackColor)
          Case 1, 3     ; imgHilite, imgHiPressed
            RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, BorderColor)
            RoundBox(2, 2, cX-4, cY-4, RoundX, RoundY, ButtonBackColor)
          Case 2        ; imgPressed
            RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, BorderColor)
            RoundBox(2, 2, cX-4, cY-4, RoundX, RoundY, BorderColor)
            RoundBox(3, 3, cX-6, cY-6, RoundX, RoundY, ButtonBackColor)
        EndSelect
        
        StopDrawing()
      EndIf
    Next
    
    SelectObject_(\hDcRegular,   ImageID(\imgRegular))
    SelectObject_(\hDcHiLite,    ImageID(\imgHilite))
    SelectObject_(\hDcPressed,   ImageID(\imgPressed))
    SelectObject_(\hDcHiPressed, ImageID(\imgHiPressed))
    SelectObject_(\hDcDisabled,  ImageID(\imgDisabled))
  EndWith
  
EndProcedure

Procedure ChangeIceButton(Gadget)
  Protected RetVal
  Protected *IceButton.ICEBUTTON_INFO : IceButtonID(*IceButton, Gadget, #False)

  ; DesktopScaledX(Y) is done in MakeIceButtonImages
  Select *IceButton\PBGadgetType
    Case #PB_GadgetType_Button
      MakeIceButtonImages(GadgetWidth(Gadget), GadgetHeight(Gadget), IceButton())
    Case #PB_GadgetType_ButtonImage
      MakeIceImagesButton(GadgetWidth(Gadget), GadgetHeight(Gadget), IceButton())
  EndSelect
  
      With *IceButton\BtnInfo
        SelectObject_(\hDcRegular,   ImageID(\imgRegular))
        SelectObject_(\hDcHiLite,    ImageID(\imgHilite))
        SelectObject_(\hDcPressed,   ImageID(\imgPressed))
        SelectObject_(\hDcHiPressed, ImageID(\imgHiPressed))
        SelectObject_(\hDcDisabled,  ImageID(\imgDisabled))
      EndWith
      InvalidateRect_(*IceButton\IDGadget, 0, 0)
      RetVal = #True

  ProcedureReturn RetVal
EndProcedure

Procedure UpdateIceButtonImages(*IceButton.ICEBUTTON_INFO)
  Protected hGenDC, CancelOut, RetVal
  
  With *IceButton\BtnInfo
    SelectObject_(\hDcRegular,   \hObjRegular)   : DeleteDC_(\hDcRegular)
    SelectObject_(\hDcHiLite,    \hObjHiLite)    : DeleteDC_(\hDcHiLite)
    SelectObject_(\hDcPressed,   \hObjPressed)   : DeleteDC_(\hDcPressed)
    SelectObject_(\hDcHiPressed, \hObjHiPressed) : DeleteDC_(\hDcHiPressed)
    SelectObject_(\hDcDisabled,  \hObjDisabled)  : DeleteDC_(\hDcDisabled)
    
    ; DesktopScaledX(Y) is done in MakeIceButtonImages()
    Select *IceButton\PBGadgetType
      Case #PB_GadgetType_Button
        MakeIceButtonImages(GadgetWidth(*IceButton\PBGadget), GadgetHeight(*IceButton\PBGadget), IceButton())
      Case #PB_GadgetType_ButtonImage
        MakeIceImagesButton(GadgetWidth(*IceButton\PBGadget), GadgetHeight(*IceButton\PBGadget), IceButton())
    EndSelect
    
    If Not (IsImage(\imgRegular))   : Debug "imgRegular is missing!"   : CancelOut = #True: EndIf
    If Not (IsImage(\imgHilite))    : Debug "imgHilite is missing!"    : CancelOut = #True: EndIf
    If Not (IsImage(\imgPressed))   : Debug "imgPressed is missing!"   : CancelOut = #True: EndIf
    If Not (IsImage(\imgHiPressed)) : Debug "imgHiPressed is missing!" : CancelOut = #True: EndIf
    If Not (IsImage(\imgDisabled))  : Debug "imgDisabled is missing!"  : CancelOut = #True: EndIf
    
    If CancelOut = #True
      If \imgRegular   And IsImage(\imgRegular)   : FreeImage(\imgRegular)   : EndIf
      If \imgHilite    And IsImage(\imgHilite)    : FreeImage(\imgHilite)    : EndIf
      If \imgPressed   And IsImage(\imgPressed)   : FreeImage(\imgPressed)   : EndIf
      If \imgHiPressed And IsImage(\imgHiPressed) : FreeImage(\imgHiPressed) : EndIf
      If \imgDisabled  And IsImage(\imgDisabled)  : FreeImage(\imgDisabled)  : EndIf
      ProcedureReturn 0
    EndIf
    
    hGenDC         = GetDC_(#Null)
    \hDcRegular    = CreateCompatibleDC_(hGenDC)
    \hDcHiLite     = CreateCompatibleDC_(hGenDC)
    \hDcPressed    = CreateCompatibleDC_(hGenDC)
    \hDcHiPressed  = CreateCompatibleDC_(hGenDC)
    \hDcDisabled   = CreateCompatibleDC_(hGenDC)
    
    \hObjRegular   = SelectObject_(\hDcRegular,    ImageID(\imgRegular))
    \hObjHiLite    = SelectObject_(\hDcHiLite,     ImageID(\imgHilite))
    \hObjPressed   = SelectObject_(\hDcPressed,    ImageID(\imgPressed))
    \hObjHiPressed = SelectObject_(\hDcHiPressed,  ImageID(\imgHiPressed))
    \hObjDisabled  = SelectObject_(\hDcDisabled,   ImageID(\imgDisabled))
    
    ReleaseDC_(#Null, hGenDC)
    InvalidateRect_(*IceButton\IDGadget, 0, 0)
    RetVal = #True
  EndWith
  
  ProcedureReturn RetVal
EndProcedure

Procedure FreeIceButton(Gadget)
  Protected SavText.s, RetVal
  Protected *IceButton.ICEBUTTON_INFO : IceButtonID(*IceButton, Gadget, #False)
  
  SetWindowLongPtr_(IceButton()\IDGadget, #GWLP_WNDPROC, IceButton()\OldWndProc)
  
  With *IceButton\BtnInfo
    SelectObject_(\hDcRegular,   \hObjRegular)   : DeleteDC_(\hDcRegular)
    SelectObject_(\hDcHiLite,    \hObjHiLite)    : DeleteDC_(\hDcHiLite)
    SelectObject_(\hDcPressed,   \hObjPressed)   : DeleteDC_(\hDcPressed)
    SelectObject_(\hDcHiPressed, \hObjHiPressed) : DeleteDC_(\hDcHiPressed)
    SelectObject_(\hDcDisabled,  \hObjDisabled)  : DeleteDC_(\hDcDisabled)
    
    If \imgRegular   And IsImage(\imgRegular)    : FreeImage(\imgRegular)   : EndIf
    If \imgHilite    And IsImage(\imgHilite)     : FreeImage(\imgHilite)    : EndIf
    If \imgPressed   And IsImage(\imgPressed)    : FreeImage(\imgPressed)   : EndIf
    If \imgHiPressed And IsImage(\imgHiPressed)  : FreeImage(\imgHiPressed) : EndIf
    If \imgDisabled  And IsImage(\imgDisabled)   : FreeImage(\imgDisabled)  : EndIf
  EndWith
  
  SavText = *IceButton\BtnInfo\sButtonText
  ;SetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE, GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) ! #BS_OWNERDRAW)
  SetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE, GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) ! #BS_USERBUTTON ! #BS_HATCHED)   ; #BS_OWNERDRAW Without #BS_DEFPUSHBUTTON
  SetWindowPos_(*IceButton\IDGadget, #Null, 0, 0, 0, 0, #SWP_NOZORDER | #SWP_NOSIZE | #SWP_NOMOVE)
  
  FreeMemory(*IceButton\BtnInfo)
  DeleteElement(IceButton())
  
  If IsGadget(Gadget)
    SetGadgetText(Gadget, SavText)
    InvalidateRect_(GadgetID(Gadget), 0, 0)
  EndIf
  RetVal = #True
  
  ProcedureReturn RetVal
EndProcedure

Procedure AddIceButton(Gadget, *IceButton.ICEBUTTON_INFO, UpdateIceButton.b = #False)
  IBProcedureReturnIf(Not (IsGadget(Gadget))) 
  Protected hGenDC, CancelOut, RetVal
  
  If UpdateIceButton
    With *IceButton\BtnInfo
      SelectObject_(\hDcRegular,   \hObjRegular)   : DeleteDC_(\hDcRegular)
      SelectObject_(\hDcHiLite,    \hObjHiLite)    : DeleteDC_(\hDcHiLite)
      SelectObject_(\hDcPressed,   \hObjPressed)   : DeleteDC_(\hDcPressed)
      SelectObject_(\hDcHiPressed, \hObjHiPressed) : DeleteDC_(\hDcHiPressed)
      SelectObject_(\hDcDisabled,  \hObjDisabled)  : DeleteDC_(\hDcDisabled)
      ; FreeImage() done in MakeIceButtonImages()
    EndWith
  Else
    With *IceButton
      \PBGadget             = Gadget
      \IDGadget             = GadgetID(Gadget)
      \IDParent             = GetParent_(\IDGadget)
      \PBGadgetType         = GadgetType(Gadget)
      \BtnInfo              = AllocateMemory(SizeOf(IBTN_INFO))
      \OldWndProc           = GetWindowLongPtr_(\IDGadget, #GWLP_WNDPROC)
      \BtnInfo\sButtonText  = GetGadgetText(Gadget)
    EndWith
  EndIf
  
  With *IceButton
    If \PBGadgetType = #PB_GadgetType_ButtonImage
      \BtnInfo\iButtonImageID = GetGadgetAttribute(Gadget, #PB_Button_Image)
      \BtnInfo\iButtonImage   = ImagePB(\BtnInfo\iButtonImageID)
      \BtnInfo\iButtonPressedImageID   = GetGadgetAttribute(Gadget, #PB_Button_PressedImage)
      If \BtnInfo\iButtonPressedImageID = 0
        \BtnInfo\iButtonPressedImageID = \BtnInfo\iButtonImageID
        \BtnInfo\iButtonPressedImage   = \BtnInfo\iButtonImage
      Else
        \BtnInfo\iButtonPressedImage   = ImagePB(\BtnInfo\iButtonPressedImageID)
      EndIf
    EndIf
  EndWith
  
  With *IceButton\BtnInfo
    If (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_PUSHLIKE = #BS_PUSHLIKE)
      \bButtonState = GetGadgetState(Gadget)
    EndIf
    
    _ToolTipHandle()
    
    \bButtonEnable = IsWindowEnabled_(*IceButton\IDGadget)
    
    \iButtonColor = IceBtnTheme(Str(#IceBtn_color)) 
    
    \iButtonBackColor = IceBtnTheme(Str(#IceBtn_BackColor))
    If \iButtonBackColor = #PB_Default
      Protected WinParent = IBWindowPB(GetAncestor_(*IceButton\IDGadget, #GA_ROOT))
      If IsWindow(WinParent)
        \iButtonBackColor = GetWindowColor(WinParent)
        If \iButtonBackColor = #PB_Default
          \iButtonBackColor = GetSysColor_(#COLOR_WINDOW)
        EndIf
      Else
        \iButtonBackColor = GetSysColor_(#COLOR_WINDOW)
      EndIf
    EndIf
    
    \iDisableBackColor = IceBtnTheme(Str(#IceBtn_DisableColor))
    If \iDisableBackColor = #PB_Default
      If IBIsDarkColor(\iButtonColor)
        \iDisableBackColor = IBDisabledDarkColor(\iButtonColor)
      Else
        \iDisableBackColor =  IBDisabledLightColor(\iButtonColor)
      EndIf
    EndIf
    
    \iActiveFont  = SendMessage_(*IceButton\IDGadget, #WM_GETFONT, 0, 0)
    
    \iFrontColor = IceBtnTheme(Str(#IceBtn_FrontColor))
    If \iFrontColor = #PB_Default
      If IBIsDarkColor(\iButtonColor)
        \iFrontColor = #White
      Else
        \iFrontColor = #Black
      EndIf
    EndIf
    
    \iDisableFrontColor = IceBtnTheme(Str(#IceBtn_DisableFrontColor))
    If \iDisableFrontColor = #PB_Default
      If IBIsDarkColor(\iFrontColor)
        \iDisableFrontColor = IBDisabledDarkColor(\iFrontColor)
      Else
        \iDisableFrontColor = IBDisabledLightColor(\iFrontColor)
      EndIf
    EndIf
    
    \bEnableShadow = IceBtnTheme(Str(#IceBtn_EnableShadow))
    
    \iShadowColor = IceBtnTheme(Str(#IceBtn_ShadowColor))
    If \iShadowColor = #PB_Default
      If IBIsDarkColor(\iFrontColor)
        \iShadowColor = #White
      Else
        \iShadowColor = #Black
      EndIf
    EndIf
    
    \iBorderColor = IceBtnTheme(Str(#IceBtn_BorderColor))
    If \iBorderColor = #PB_Default
      \iBorderColor = \iButtonColor
    EndIf
    
    \iRoundX = IceBtnTheme(Str(#IceBtn_RoundX))
    \iRoundY = IceBtnTheme(Str(#IceBtn_RoundY))
    
    If \hRgn : DeleteObject_(\hRgn) : EndIf
    ;\hRgn         = CreateRoundRectRgn_(0, 0, DesktopScaledX(GadgetWidth(Gadget)), DesktopScaledY(GadgetHeight(Gadget)), \iRoundX, \iRoundY)
    \hRgn        = CreateRectRgn_(0, 0, DesktopScaledX(GadgetWidth(Gadget)), DesktopScaledY(GadgetHeight(Gadget)))
    
    ; DesktopScaledX(Y) is done in MakeIceButtonImages()
    Select *IceButton\PBGadgetType
      Case #PB_GadgetType_Button
        MakeIceButtonImages(GadgetWidth(Gadget), GadgetHeight(Gadget), IceButton())
      Case #PB_GadgetType_ButtonImage
        MakeIceImagesButton(GadgetWidth(Gadget), GadgetHeight(Gadget), IceButton())
    EndSelect
    
    If Not (IsImage(\imgRegular))   : Debug "imgRegular is missing!"   : CancelOut = #True: EndIf
    If Not (IsImage(\imgHilite))    : Debug "imgHilite is missing!"    : CancelOut = #True: EndIf
    If Not (IsImage(\imgPressed))   : Debug "imgPressed is missing!"   : CancelOut = #True: EndIf
    If Not (IsImage(\imgHiPressed)) : Debug "imgHiPressed is missing!" : CancelOut = #True: EndIf
    If Not (IsImage(\imgDisabled))  : Debug "imgDisabled is missing!"  : CancelOut = #True: EndIf
    
    If CancelOut = #True
      If \imgRegular   And IsImage(\imgRegular)   : FreeImage(\imgRegular)   : EndIf
      If \imgHilite    And IsImage(\imgHilite)    : FreeImage(\imgHilite)    : EndIf
      If \imgPressed   And IsImage(\imgPressed)   : FreeImage(\imgPressed)   : EndIf
      If \imgHiPressed And IsImage(\imgHiPressed) : FreeImage(\imgHiPressed) : EndIf
      If \imgDisabled  And IsImage(\imgDisabled)  : FreeImage(\imgDisabled)  : EndIf
      
      FreeMemory(IceButton()\BtnInfo)
      DeleteElement(IceButton())
      ProcedureReturn 0
    EndIf
    
    hGenDC         = GetDC_(#Null)
    \hDcRegular    = CreateCompatibleDC_(hGenDC)
    \hDcHiLite     = CreateCompatibleDC_(hGenDC)
    \hDcPressed    = CreateCompatibleDC_(hGenDC)
    \hDcHiPressed  = CreateCompatibleDC_(hGenDC)
    \hDcDisabled   = CreateCompatibleDC_(hGenDC)
  
    \hObjRegular   = SelectObject_(\hDcRegular,   ImageID(\imgRegular))
    \hObjHiLite    = SelectObject_(\hDcHiLite,    ImageID(\imgHilite))
    \hObjPressed   = SelectObject_(\hDcPressed,   ImageID(\imgPressed))
    \hObjHiPressed = SelectObject_(\hDcHiPressed, ImageID(\imgHiPressed))
    \hObjDisabled  = SelectObject_(\hDcDisabled,  ImageID(\imgDisabled))
    
    ReleaseDC_(#Null, hGenDC)
    InvalidateRect_(IceButton()\IDGadget, 0, 0)
    
    If Not UpdateIceButton
      ;SetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE, GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) | #BS_OWNERDRAW)
      SetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE, GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) | #BS_USERBUTTON | #BS_HATCHED)   ; #BS_OWNERDRAW Without #BS_DEFPUSHBUTTON
      
      SetWindowPos_(*IceButton\IDGadget, #Null, 0, 0, 0, 0, #SWP_NOZORDER | #SWP_NOSIZE | #SWP_NOMOVE)
      
      SetWindowLongPtr_(*IceButton\IDGadget, #GWLP_WNDPROC, @IceButton_WndProc())
    EndIf
    
    RetVal = #True
  EndWith
  
  ProcedureReturn RetVal
EndProcedure

Procedure IceButton_WndProc(hWnd, uMsg, wParam, lParam)
  Protected *IceButton.ICEBUTTON_INFO, OldWndProc, CursorPos.POINT, ps.PAINTSTRUCT, Rect.RECT
  Protected cX, cY, Margin = 6, Xofset, Yofset, HFlag, VFlag, Text.s, TextLen, TxtHeight, In_Button_Rect, hDC_to_use, Change_Image
  
  ForEach IceButton()
   If IceButton()\IDGadget = hWnd
     *IceButton = @IceButton()
     OldWndProc = *IceButton\OldWndProc
     Break
   EndIf
  Next
  
  If *IceButton = 0
    ProcedureReturn DefWindowProc_(hWnd, uMsg, wParam, lParam)
  EndIf
  
  Select uMsg
      
    Case #WM_DESTROY
      FreeIceButton(*IceButton\PBGadget)
     
    Case #WM_TIMER
      Select wParam
        Case 124
          If GetAsyncKeyState_(#VK_LBUTTON) & $8000 <> $8000
            KillTimer_(hWnd, 124)
            *IceButton\BtnInfo\bClickTimer = #False
            *IceButton\BtnInfo\bHiLiteTimer = #False
            InvalidateRect_(hWnd, 0, 1)
          EndIf
        Case 123
          GetCursorPos_(@CursorPos)
          ScreenToClient_(*IceButton\IDParent, @CursorPos)
          In_Button_Rect   = #True
          If CursorPos\x < DesktopScaledX(GadgetX(*IceButton\PBGadget)) Or CursorPos\x > DesktopScaledX(GadgetX(*IceButton\PBGadget) + GadgetWidth(*IceButton\PBGadget))
            In_Button_Rect = #False
          EndIf
          If CursorPos\y < DesktopScaledY(GadgetY(*IceButton\PBGadget)) Or CursorPos\y > DesktopScaledY(GadgetY(*IceButton\PBGadget) + GadgetHeight(*IceButton\PBGadget))
            In_Button_Rect = #False
          EndIf
          If Not In_Button_Rect
            KillTimer_(hWnd, 123)
            *IceButton\BtnInfo\bMouseOver = #False
            *IceButton\BtnInfo\bHiLiteTimer = #False
            InvalidateRect_(hWnd, 0, 1)
          Else
            Delay(1)
          EndIf
      EndSelect
      
    Case #WM_MOUSEMOVE
      GetCursorPos_(@CursorPos)
      ScreenToClient_(*IceButton\IDParent, @CursorPos)
      In_Button_Rect     = #True
      If CursorPos\x < DesktopScaledX(GadgetX(*IceButton\PBGadget)) Or CursorPos\x > DesktopScaledX(GadgetX(*IceButton\PBGadget) + GadgetWidth(*IceButton\PBGadget))
        In_Button_Rect   = #False
      EndIf
      If CursorPos\y < DesktopScaledY(GadgetY(*IceButton\PBGadget)) Or CursorPos\y > DesktopScaledY(GadgetY(*IceButton\PBGadget) + GadgetHeight(*IceButton\PBGadget))
        In_Button_Rect   = #False
      EndIf
      If In_Button_Rect = #True And Not *IceButton\BtnInfo\bMouseOver
        *IceButton\BtnInfo\bMouseOver = #True
        *IceButton\BtnInfo\bHiLiteTimer = #True
        SetTimer_(hWnd, 123, 50, #Null)
        InvalidateRect_(hWnd, 0, 1)
      EndIf
      
    Case #WM_LBUTTONDOWN
      If Not *IceButton\BtnInfo\bClickTimer
        *IceButton\BtnInfo\bClickTimer = #True
        SetTimer_(hWnd, 124, 100, #Null)
        If (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_PUSHLIKE = #BS_PUSHLIKE)
          *IceButton\BtnInfo\bButtonState  = *IceButton\BtnInfo\bButtonState ! 1
        EndIf
        InvalidateRect_(hWnd, 0, 1)
      EndIf
      
    Case #WM_ENABLE
      *IceButton\BtnInfo\bButtonEnable = wParam
      InvalidateRect_(hWnd, 0, 1)
      ProcedureReturn 0
      
    Case #WM_WINDOWPOSCHANGED
      DeleteObject_(*IceButton\BtnInfo\hRgn)
      ;*IceButton\BtnInfo\hRgn  = CreateRoundRectRgn_(0, 0, DesktopScaledX(GadgetWidth(*IceButton\PBGadget)), DesktopScaledY(GadgetHeight(*IceButton\PBGadget)), *IceButton\BtnInfo\iRoundX, *IceButton\BtnInfo\iRoundY)
      *IceButton\BtnInfo\hRgn = CreateRectRgn_(0, 0, DesktopScaledX(GadgetWidth(*IceButton\PBGadget)), DesktopScaledY(GadgetHeight(*IceButton\PBGadget)))
      ChangeIceButton(*IceButton\PBGadget)   ; Or with UpdateIceButtonImages(IceButton())
      
    Case #WM_SETTEXT
      *IceButton\BtnInfo\sButtonText = PeekS(lParam)
      DefWindowProc_(hWnd, uMsg, wParam, lParam)
      InvalidateRect_(hWnd, 0, 0)
      ProcedureReturn 1
           
    Case #BM_SETCHECK
      If (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_PUSHLIKE = #BS_PUSHLIKE)
        *IceButton\BtnInfo\bButtonState = wParam
        InvalidateRect_(hWnd, 0, 0)
      EndIf
      
    Case #BM_GETCHECK
      ProcedureReturn *IceButton\BtnInfo\bButtonState
    
    Case #WM_SETFONT
      *IceButton\BtnInfo\iActiveFont = wParam
      InvalidateRect_(hWnd, 0, 0)
      
    Case #WM_PAINT
      cX                = DesktopScaledX(GadgetWidth(*IceButton\PBGadget))
      cY                = DesktopScaledY(GadgetHeight(*IceButton\PBGadget))
      Xofset            = 0
      Yofset            = 0
      
      GetCursorPos_(@CursorPos)
      ScreenToClient_(*IceButton\IDParent, @CursorPos)
      In_Button_Rect     = #True
      If CursorPos\x < DesktopScaledX(GadgetX(*IceButton\PBGadget)) Or CursorPos\x > DesktopScaledX(GadgetX(*IceButton\PBGadget) + GadgetWidth(*IceButton\PBGadget))
        In_Button_Rect   = #False
      EndIf
      If CursorPos\y < DesktopScaledY(GadgetY(*IceButton\PBGadget)) Or CursorPos\y > DesktopScaledY(GadgetY(*IceButton\PBGadget) + GadgetHeight(*IceButton\PBGadget))
        In_Button_Rect   = #False
      EndIf
      
      If (*IceButton\BtnInfo\bClickTimer And In_Button_Rect = #True)
        ; Invert Regular And pressed images during the Click Timer, to better see click action
        If *IceButton\BtnInfo\bButtonState
          hDC_to_use    = *IceButton\BtnInfo\hDcRegular
        Else
          hDC_to_use    = *IceButton\BtnInfo\hDcPressed
        EndIf
        Xofset          = 1
        Yofset          = 1
      ElseIf *IceButton\BtnInfo\bHiLiteTimer
        If *IceButton\BtnInfo\bButtonState
          hDC_to_use      = *IceButton\BtnInfo\hDcHiPressed
        Else
          hDC_to_use      = *IceButton\BtnInfo\hDcHiLite
        EndIf
      Else
        If *IceButton\BtnInfo\bButtonEnable  = 0
          hDC_to_use    = *IceButton\BtnInfo\hDcDisabled
        ElseIf *IceButton\BtnInfo\bButtonState
          hDC_to_use    = *IceButton\BtnInfo\hDcPressed
        Else
          hDC_to_use    = *IceButton\BtnInfo\hDcRegular
        EndIf
      EndIf
      
      BeginPaint_(hWnd, @ps.PAINTSTRUCT)
      
      ; Calculate text height for multiline buttons, then adapt rectangle to center text vertically (DT_VCenter doesn't do the trick)
      ; It must be done before BitBlt() to be overwritten
      If (*IceButton\BtnInfo\sButtonText <> "") And (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_MULTILINE = #BS_MULTILINE) 
        Text  = *IceButton\BtnInfo\sButtonText
        TextLen = Len(Text)
        SelectObject_(ps\hdc, *IceButton\BtnInfo\iActiveFont)
        SetBkMode_(ps\hdc, #TRANSPARENT)
        SetTextColor_(ps\hdc, *IceButton\BtnInfo\iFrontColor)
        Rect\left       = Xofset + Margin
        Rect\top        = Yofset + Margin
        Rect\right      = cX + Xofset - Margin
        Rect\bottom     = cY + Yofset - Margin
        TxtHeight = DrawText_(ps\hdc, @Text, TextLen, @Rect, #DT_CENTER | #DT_VCENTER | #DT_WORDBREAK)
      EndIf
                
      SelectClipRgn_(ps\hdc, *IceButton\BtnInfo\hRgn)
      BitBlt_(ps\hdc, 0, 0, cX, cY, hDC_to_use, 0, 0, #SRCCOPY)
      
      If *IceButton\BtnInfo\sButtonText <> ""
        Text  = *IceButton\BtnInfo\sButtonText
        TextLen = Len(Text)
        If (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & (#BS_LEFT | #BS_RIGHT) = (#BS_LEFT | #BS_RIGHT)) : HFlag | #DT_CENTER
        ElseIf (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_LEFT = #BS_LEFT)                         : HFlag | #DT_LEFT
        ElseIf (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_RIGHT = #BS_RIGHT)                       : HFlag | #DT_RIGHT
        Else                                                                                                      : HFlag | #DT_CENTER
        EndIf
        If (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & (#BS_TOP | #BS_BOTTOM) = (#BS_TOP | #BS_BOTTOM)) : VFlag | #DT_VCENTER
        ElseIf (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_TOP = #BS_TOP)                           : VFlag | #DT_TOP
        ElseIf (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_BOTTOM = #BS_BOTTOM)                     : VFlag | #DT_BOTTOM
        Else                                                                                                      : VFlag | #DT_VCENTER
        EndIf
        If (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_MULTILINE = #BS_MULTILINE) 
          VFlag | #DT_WORDBREAK
        Else  
          VFlag | #DT_SINGLELINE
        EndIf
        
        SelectObject_(ps\hdc, *IceButton\BtnInfo\iActiveFont)
        SetBkMode_(ps\hdc, #TRANSPARENT)
        
        If IceButton()\BtnInfo\bEnableShadow
          SetTextColor_(ps\hdc, *IceButton\BtnInfo\iShadowColor)
          Rect\left     = 1 + Xofset + Margin
          Rect\top      = 1 + Yofset + Margin
          Rect\right    = cX + 1 + Xofset - Margin
          Rect\bottom   = cY + 1 + Yofset - Margin
          If  VFlag & #DT_WORDBREAK = #DT_WORDBREAK
            If VFlag & #DT_VCENTER = #DT_VCENTER
              Rect\top + (Rect\bottom - Rect\top - TxtHeight) / 2 
              Rect\bottom - (Rect\bottom - Rect\top - TxtHeight)
            ElseIf VFlag & #DT_BOTTOM = #DT_BOTTOM
              Rect\top + (Rect\bottom - TxtHeight) - Margin
            EndIf
          EndIf
          DrawText_(ps\hdc, @Text, TextLen, @Rect, HFlag | VFlag)
        EndIf
        
        If *IceButton\BtnInfo\bButtonEnable
          SetTextColor_(ps\hdc, *IceButton\BtnInfo\iFrontColor)
        Else
          SetTextColor_(ps\hdc, *IceButton\BtnInfo\iDisableFrontColor)
        EndIf
        Rect\left       = Xofset + Margin
        Rect\top        = Yofset + Margin
        Rect\right      = cX + Xofset - Margin
        Rect\bottom     = cY + Yofset - Margin
        If  VFlag & #DT_WORDBREAK = #DT_WORDBREAK
          If VFlag & #DT_VCENTER = #DT_VCENTER
            Rect\top + (Rect\bottom - Rect\top - TxtHeight) / 2 
            Rect\bottom - (Rect\bottom - Rect\top - TxtHeight)
          ElseIf VFlag & #DT_BOTTOM = #DT_BOTTOM
            Rect\top + (Rect\bottom - TxtHeight) - Margin
          EndIf
        EndIf
        DrawText_(ps\hdc, @Text, TextLen, @Rect, HFlag | VFlag)

      EndIf
      EndPaint_(hWnd, @ps)
      ProcedureReturn #True
      
    Case #WM_PRINT
      cX                = DesktopScaledX(GadgetWidth(*IceButton\PBGadget))
      cY                = DesktopScaledY(GadgetHeight(*IceButton\PBGadget))
      
      If *IceButton\BtnInfo\bButtonEnable  = 0
        hDC_to_use      = *IceButton\BtnInfo\hDcDisabled
      ElseIf *IceButton\BtnInfo\bButtonState
        hDC_to_use      = *IceButton\BtnInfo\hDcPressed
      Else
        hDC_to_use      = *IceButton\BtnInfo\hDcRegular
      EndIf
      
      ; Calculate text height for multiline buttons, then adapt rectangle to center text vertically (DT_VCenter doesn't do the trick)
      ; It must be done before BitBlt() to be overwritten
      If (*IceButton\BtnInfo\sButtonText <> "") And (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_MULTILINE = #BS_MULTILINE) 
        Text  = *IceButton\BtnInfo\sButtonText
        TextLen = Len(Text)
        SelectObject_(wParam, *IceButton\BtnInfo\iActiveFont)
        SetBkMode_(wParam, #TRANSPARENT)
        SetTextColor_(wParam, *IceButton\BtnInfo\iFrontColor)
        Rect\left       = Xofset + Margin
        Rect\top        = Yofset + Margin
        Rect\right      = cX + Xofset - Margin
        Rect\bottom     = cY + Yofset - Margin
        TxtHeight = DrawText_(wParam, @Text, TextLen, @Rect, #DT_CENTER | #DT_VCENTER | #DT_WORDBREAK)
      EndIf
      
      SelectClipRgn_(wParam, *IceButton\BtnInfo\hRgn)
      BitBlt_(wParam, 0, 0, cX, cY, hDC_to_use, 0, 0, #SRCCOPY)
      
      If *IceButton\BtnInfo\sButtonText <> ""
        Text           = *IceButton\BtnInfo\sButtonText
        TextLen        = Len(Text)
        If (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & (#BS_LEFT | #BS_RIGHT) = (#BS_LEFT | #BS_RIGHT)) : HFlag | #DT_CENTER
        ElseIf (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_LEFT = #BS_LEFT)                         : HFlag | #DT_LEFT
        ElseIf (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_RIGHT = #BS_RIGHT)                       : HFlag | #DT_RIGHT
        Else                                                                                                      : HFlag | #DT_CENTER
        EndIf
        If (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & (#BS_TOP | #BS_BOTTOM) = (#BS_TOP | #BS_BOTTOM)) : VFlag | #DT_VCENTER
        ElseIf (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_TOP = #BS_TOP)                           : VFlag | #DT_TOP
        ElseIf (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_BOTTOM = #BS_BOTTOM)                     : VFlag | #DT_BOTTOM
        Else                                                                                                      : VFlag | #DT_VCENTER
        EndIf
        If (GetWindowLongPtr_(*IceButton\IDGadget, #GWL_STYLE) & #BS_MULTILINE = #BS_MULTILINE) 
          VFlag | #DT_WORDBREAK
        Else  
          VFlag | #DT_SINGLELINE
        EndIf

        SelectObject_(wParam, *IceButton\BtnInfo\iActiveFont)
        SetBkMode_(wParam, #TRANSPARENT)
        
        If IceButton()\BtnInfo\bEnableShadow
          SetTextColor_(wParam, *IceButton\BtnInfo\iShadowColor)
          Rect\left     = 1 + Xofset + Margin
          Rect\top      = 1 + Yofset + Margin
          Rect\right    = cX + 1 + Xofset - Margin
          Rect\bottom   = cY + 1 + Yofset - Margin
          If  VFlag & #DT_WORDBREAK = #DT_WORDBREAK
            If VFlag & #DT_VCENTER = #DT_VCENTER
              Rect\top + (Rect\bottom - Rect\top - TxtHeight) / 2 
              Rect\bottom - (Rect\bottom - Rect\top - TxtHeight)
            ElseIf VFlag & #DT_BOTTOM = #DT_BOTTOM
              Rect\top + (Rect\bottom - TxtHeight) - Margin
            EndIf
          EndIf
          DrawText_(wParam, @Text, TextLen, @Rect, HFlag | VFlag)
        EndIf
        
        If *IceButton\BtnInfo\bButtonEnable
          SetTextColor_(wParam, *IceButton\BtnInfo\iFrontColor)
        Else
          SetTextColor_(wParam, *IceButton\BtnInfo\iDisableFrontColor)
        EndIf
        Rect\left       = Xofset + Margin
        Rect\top        = Yofset + Margin
        Rect\right      = cX + Xofset - Margin
        Rect\bottom     = cY + Yofset - Margin
        If  VFlag & #DT_WORDBREAK = #DT_WORDBREAK
          If VFlag & #DT_VCENTER = #DT_VCENTER
            Rect\top + (Rect\bottom - Rect\top - TxtHeight) / 2 
            Rect\bottom - (Rect\bottom - Rect\top - TxtHeight)
          ElseIf VFlag & #DT_BOTTOM = #DT_BOTTOM
            Rect\top + (Rect\bottom - TxtHeight) - Margin
          EndIf
        EndIf
        DrawText_(wParam, @Text, TextLen, @Rect, HFlag | VFlag)
      EndIf
      ProcedureReturn #True
      
    Case #WM_ERASEBKGND
      ProcedureReturn #True
      
  EndSelect
  ProcedureReturn CallWindowProc_(OldWndProc, hWnd, uMsg, wParam, lParam)
EndProcedure

;
; -----------------------------------------------------------------------------
;- ----- Ice Buttons Public -----
; -----------------------------------------------------------------------------

Procedure IsIceButton(Gadget)
  Protected RetVal
  If Not (IsGadget(Gadget)) : ProcedureReturn RetVal : EndIf
  
  ForEach IceButton()
    If IceButton()\PBGadget = Gadget And IceButton()\IDGadget = GadgetID(Gadget)
      RetVal = #True
      Break
    EndIf
  Next
  ProcedureReturn RetVal
EndProcedure

Procedure GetIceBtnThemeAttribute(Attribut)
  Protected RetVal
  
  Select Attribut
    Case #IceBtn_color, #IceBtn_BackColor, #IceBtn_DisableColor, #IceBtn_FrontColor, #IceBtn_DisableFrontColor, #IceBtn_EnableShadow, #IceBtn_ShadowColor, #IceBtn_BorderColor, #IceBtn_RoundX, #IceBtn_RoundY
      RetVal = IceBtnTheme(Str(Attribut))
  EndSelect
  
  ProcedureReturn RetVal
EndProcedure

Procedure SetIceBtnThemeAttribute(Attribut, Value)
  Protected RetVal
  
  Select Attribut
    Case #IceBtn_color, #IceBtn_BackColor, #IceBtn_DisableColor, #IceBtn_FrontColor, #IceBtn_DisableFrontColor, #IceBtn_EnableShadow, #IceBtn_ShadowColor, #IceBtn_BorderColor, #IceBtn_RoundX, #IceBtn_RoundY
      IceBtnTheme(Str(Attribut)) = Value
      RetVal = #True
  EndSelect
  
  SetIceButtonAttribute(#PB_All, Attribut, Value)
  
  ProcedureReturn RetVal
EndProcedure

Procedure GetIceButtonAttribute(Gadget, Attribut)
  IBProcedureReturnIf(Not (IsGadget(Gadget)))
  Protected RetVal
  Protected *IceButton.ICEBUTTON_INFO : IceButtonID(*IceButton, Gadget, #False)
  
  With *IceButton\BtnInfo
    Select Attribut
      Case #IceBtn_color
        RetVal = \iButtonColor
      Case #IceBtn_BackColor
        RetVal = \iButtonBackColor
      Case #IceBtn_DisableColor
        RetVal = \iDisableBackColor
      Case #IceBtn_FrontColor
        RetVal = \iFrontColor
      Case #IceBtn_DisableFrontColor
        RetVal = \iDisableFrontColor
      Case #IceBtn_EnableShadow
        RetVal = \bEnableShadow
      Case #IceBtn_ShadowColor
        RetVal = \iShadowColor
      Case #IceBtn_BorderColor
        RetVal = \iBorderColor
      Case #IceBtn_RoundX
        RetVal = \iRoundX
      Case #IceBtn_RoundY
        RetVal = \iRoundY
    EndSelect
  EndWith
  
  ProcedureReturn RetVal
EndProcedure

Procedure SetIceButtonAttribute(Gadget, Attribut, Value)
  IBProcedureReturnIf(Not (IsGadget(Gadget) Or Gadget = #PB_All))
  Protected WinParent, RetVal 
  
  With IceButton()\BtnInfo 
    ForEach IceButton()
      If IceButton()\PBGadget = Gadget Or Gadget = #PB_All
        Select Attribut
          Case #IceBtn_color
            \iButtonColor         = Value
            
            If IceBtnTheme(Str(#IceBtn_BackColor)) = #PB_Default
              WinParent = IBWindowPB(GetAncestor_(IceButton()\IDGadget, #GA_ROOT))
              If IsWindow(WinParent)
                \iButtonBackColor = GetWindowColor(WinParent)
                If \iButtonBackColor = #PB_Default
                  \iButtonBackColor = GetSysColor_(#COLOR_WINDOW)
                EndIf
              Else
                \iButtonBackColor = GetSysColor_(#COLOR_WINDOW)
              EndIf
            EndIf
            
            If IceBtnTheme(Str(#IceBtn_DisableColor)) = #PB_Default
              If IBIsDarkColor(\iButtonColor)
                \iDisableBackColor = IBDisabledDarkColor(\iButtonColor)
              Else
                \iDisableBackColor =  IBDisabledLightColor(\iButtonColor)
              EndIf
            EndIf
            
            If IceBtnTheme(Str(#IceBtn_FrontColor)) = #PB_Default
              If IBIsDarkColor(\iButtonColor)
                \iFrontColor = #White
              Else
                \iFrontColor = #Black
              EndIf
              
              If IceBtnTheme(Str(#IceBtn_DisableFrontColor)) = #PB_Default
                If IBIsDarkColor(\iFrontColor)
                  \iDisableFrontColor = IBDisabledDarkColor(\iFrontColor)
                Else
                  \iDisableFrontColor = IBDisabledLightColor(\iFrontColor)
                EndIf
              EndIf
              
              If IceBtnTheme(Str(#IceBtn_ShadowColor)) = #PB_Default
                If IBIsDarkColor(\iFrontColor)
                  \iShadowColor = #White
                Else
                  \iShadowColor = #Black
                EndIf
              EndIf
              
            EndIf
            
            If IceBtnTheme(Str(#IceBtn_BorderColor)) = #PB_Default
              \iBorderColor         = \iButtonColor
            EndIf
    
          Case #IceBtn_BackColor
            If Value = #PB_Default
              WinParent = IBWindowPB(GetAncestor_(IceButton()\IDGadget, #GA_ROOT))
              If IsWindow(WinParent)
                \iButtonBackColor = GetWindowColor(WinParent)
                If \iButtonBackColor = #PB_Default
                  \iButtonBackColor = GetSysColor_(#COLOR_WINDOW)
                EndIf
              Else
                \iButtonBackColor = GetSysColor_(#COLOR_WINDOW)
              EndIf
            Else
              \iButtonBackColor     = Value
            EndIf
            
          Case #IceBtn_DisableColor
            If Value = #PB_Default
              If IBIsDarkColor(\iButtonColor)
                \iDisableBackColor = IBDisabledDarkColor(\iButtonColor)
              Else
                \iDisableBackColor =  IBDisabledLightColor(\iButtonColor)
              EndIf
            Else
              \iDisableBackColor    = Value
            EndIf
                        
          Case #IceBtn_FrontColor
            If Value = #PB_Default
              If IBIsDarkColor(\iButtonColor)
                \iFrontColor = #White
              Else
                \iFrontColor = #Black
              EndIf
            Else
              \iFrontColor   = Value
            EndIf
            
            If IceBtnTheme(Str(#IceBtn_DisableFrontColor)) = #PB_Default
              If IBIsDarkColor(\iFrontColor)
                \iDisableFrontColor = IBDisabledDarkColor(\iFrontColor)
              Else
                \iDisableFrontColor = IBDisabledLightColor(\iFrontColor)
              EndIf
            EndIf
            
            If IceBtnTheme(Str(#IceBtn_ShadowColor)) = #PB_Default
              If IBIsDarkColor(\iFrontColor)
                \iShadowColor       = #White
              Else
                \iShadowColor       = #Black
              EndIf
            EndIf
            
          Case #IceBtn_DisableFrontColor
            If Value = #PB_Default
              If IBIsDarkColor(\iFrontColor)
                \iDisableFrontColor    = IBDisabledDarkColor(\iFrontColor)
              Else
                \iDisableFrontColor    = IBDisabledLightColor(\iFrontColor)
              EndIf
            Else
              \iDisableFrontColor      = Value
            EndIf
            
          Case #IceBtn_EnableShadow
            \bEnableShadow             = Value
            
          Case #IceBtn_ShadowColor
            If Value = #PB_Default
              If IBIsDarkColor(\iFrontColor)
                \iShadowColor          = #White
              Else
                \iShadowColor          = #Black
              EndIf
            Else
              \iShadowColor            = Value
            EndIf
            
          Case #IceBtn_BorderColor
            If Value = #PB_Default
              \iBorderColor            = \iButtonColor
            Else
              \iBorderColor            = Value
            EndIf
            
          Case #IceBtn_RoundX
            \iRoundX                   = Value
          Case #IceBtn_RoundY
            \iRoundY                   = Value
            
        EndSelect
        
        If Not UpdateIceButtonImages(IceButton())   ; or ChangeIceButton(Gadget)
         FreeMemory(IceButton()\BtnInfo)
         DeleteElement(IceButton())
         ProcedureReturn 0
        EndIf

        RetVal = #True
        If Not (Gadget = #PB_All)
          Break
        EndIf
      EndIf
    Next
  EndWith
  
  ProcedureReturn RetVal
EndProcedure

Procedure FreeIceButtonTheme()
  Protected RetVal
  
  ForEach IceButton()
    FreeIceButton(IceButton()\PBGadget)
    RetVal = #True
  Next
  ClearMap(IceBtnTheme())
  
  ProcedureReturn RetVal
EndProcedure

Procedure GetIceButtonTheme()
  
  ProcedureReturn IceBtnTheme(Str(#IceBtn_Theme))
EndProcedure

Procedure SetIceButtonTheme(Theme)
  Protected Object, AddIceButton, RetVal
  
  If Theme = #PB_Default 
    If MapSize(IceBtnTheme()) = 0
      LoadIceButtonTheme(Theme)
    EndIf
  Else  
    LoadIceButtonTheme(Theme)
  EndIf
  
  ResetList(IceButton())
  While NextElement(IceButton())
    If Not (IsGadget(IceButton()\PBGadget)) Or Not (IsWindow_(IceButton()\IDGadget))
      DeleteElement(IceButton())
    EndIf
  Wend
  
  PB_Object_EnumerateStart(PB_Gadget_Objects)
  While PB_Object_EnumerateNext(PB_Gadget_Objects, @Object)
    Select GadgetType(Object)
      Case #PB_GadgetType_Button, #PB_GadgetType_ButtonImage
        AddIceButton = #True
        ResetList(IceButton())
        While NextElement(IceButton())
          If IceButton()\PBGadget = Object And IceButton()\IDGadget = GadgetID(Object)
            AddIceButton(Object, IceButton(), #True)  ; UpdateIceButton = #True
            AddIceButton = #False
            Break
          EndIf
        Wend
        If AddIceButton
          AddElement(IceButton())
          RetVal = AddIceButton(Object, IceButton())
        EndIf
    EndSelect
  Wend
  PB_Object_EnumerateAbort(PB_Gadget_Objects)
  
  ProcedureReturn RetVal
EndProcedure

;
; -----------------------------------------------------------------------------
;- ----- Define Themes in DataSection -----
; -----------------------------------------------------------------------------
;$A84C0A
DataSection
  DarkBlue:
  Data.i #IceBtn_color, $FD6E0D
  Data.i #IceBtn_BackColor, $292521
  Data.i #IceBtn_DisableColor, #PB_Default
  Data.i #IceBtn_FrontColor, #White
  Data.i #IceBtn_DisableFrontColor, #PB_Default
  Data.i #IceBtn_EnableShadow, 1
  Data.i #IceBtn_ShadowColor, $292521
  Data.i #IceBtn_BorderColor, #PB_Default
  Data.i #IceBtn_RoundX, 8
  Data.i #IceBtn_RoundY, 8
  Data.i #IceBtn_END
  
  LightBlue:
  Data.i #IceBtn_color, $FD6E0D
  Data.i #IceBtn_BackColor, $FFD7C9
  Data.i #IceBtn_DisableColor, #PB_Default
  Data.i #IceBtn_FrontColor, #Black
  Data.i #IceBtn_DisableFrontColor, #PB_Default
  Data.i #IceBtn_EnableShadow, 1
  Data.i #IceBtn_ShadowColor, $FFB47F
  Data.i #IceBtn_BorderColor, $FEA26B
  Data.i #IceBtn_RoundX, 8
  Data.i #IceBtn_RoundY, 8
  Data.i #IceBtn_END
  
  MyTheme:
  Data.i #IceBtn_color, $FFA6A6
  Data.i #IceBtn_BackColor, $F0F0F0
  Data.i #IceBtn_DisableColor, $FFB0B0
  Data.i #IceBtn_FrontColor, $000000
  Data.i #IceBtn_DisableFrontColor, $464243
  Data.i #IceBtn_EnableShadow, 0
  Data.i #IceBtn_ShadowColor, #PB_Default
  Data.i #IceBtn_BorderColor, #PB_Default
  Data.i #IceBtn_RoundX, 8
  Data.i #IceBtn_RoundY, 8
  Data.i #IceBtn_END
EndDataSection

;-
; -----------------------------------------------------------------------------
;- ----- Demo example -----
; -----------------------------------------------------------------------------

CompilerIf (#PB_Compiler_IsMainFile)
  
  Procedure Blue2RedColor(image)
    If StartDrawing( ImageOutput(image))
      Protected X, Y
      Protected WidthImage = ImageWidth(image)-1, HeightImage = ImageHeight(image)-1
      For X = 1 To WidthImage
        For Y = 1 To HeightImage
          If Point(X, Y) = 8613207
            Plot(X, Y, $4F3CA0)   ;RGB(160,60,79))
          EndIf
        Next
      Next
      StopDrawing()
    EndIf
  EndProcedure

  Procedure Resize_Window()
    Protected ScaleX.f, ScaleY.f
    Static Window_WidthIni, Window_HeightIni
    If Window_WidthIni = 0
      Window_WidthIni = WindowWidth(0) : Window_HeightIni = WindowHeight(0)
    EndIf
    
    ScaleX = WindowWidth(0) / Window_WidthIni : ScaleY = WindowHeight(0) / Window_HeightIni
    ResizeGadget(0, ScaleX * 60, ScaleY * 20 , ScaleX * 240, ScaleY * 60)
    ResizeGadget(1, ScaleX * 60, ScaleY * 100, ScaleX * 240, ScaleY * 60)
    ResizeGadget(2, ScaleX * 60, ScaleY * 180, ScaleX * 240, ScaleY * 60)
    ResizeGadget(3, ScaleX * 60, ScaleY * 260, ScaleX * 240, ScaleY * 60)
    
    ResizeGadget(4, ScaleX * 360, ScaleY * 20 , ScaleX * 240, ScaleY * 60)
    ResizeGadget(5, ScaleX * 360, ScaleY * 100, ScaleX * 240, ScaleY * 60)
    ResizeGadget(6, ScaleX * 360, ScaleY * 180, ScaleX * 240, ScaleY * 60)
    ResizeGadget(7, ScaleX * 360, ScaleY * 260, ScaleX * 240, ScaleY * 60)
  EndProcedure
  
  LoadFont(0, "", 9)
  LoadFont(1, "", 9, #PB_Font_Italic)
  
  LoadImage(0, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp")
  CopyImage(0, 1)
  Blue2RedColor(1)
  LoadImage(2, #PB_Compiler_Home + "Examples/Sources/Data/Background.bmp")
  
  ;- OpenWindow
  If OpenWindow(0, 0, 0, 660, 340, "Demo Ice Buttons", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    
    ; SetIceButtonTheme can be positioned anywhere, before or after ButtonGadget creation
    ;SetIceButtonTheme(#IceBtn_Theme_DarkBlue) ;: SetIceButtonAttribute(#IceBtn_FrontColor, #Red)
    SetGadgetFont(#PB_Default, FontID(0))
    ButtonGadget(0, 60, 20,  240, 60, "Apply Light Blue Theme")
    ButtonGadget(1, 60, 100, 240, 60, "Change Text Color and RoundXY for this  MultiLine IceButton Gadget", #PB_Button_Toggle | #PB_Button_MultiLine)
    ButtonGadget(2, 60, 180, 240, 60, "Toggle Button (ON)", #PB_Button_Toggle)
    SetGadgetState(2, #True)
    GadgetToolTip(2, "Toggle Button (ON/OFF)")
    ButtonGadget(3, 60, 260, 240, 60, "Disabled Button")
    DisableGadget(3, #True)
    
    ButtonImageGadget(4, 360, 20,  240, 60, ImageID(0))
    ButtonImageGadget(5, 360, 100, 240, 60, 0, #PB_Button_Toggle)
    SetGadgetAttribute(5, #PB_Button_Image, ImageID(2))
    SetWindowLongPtr_(GadgetID(5), #GWL_STYLE, GetWindowLongPtr_(GadgetID(5), #GWL_STYLE) | #BS_MULTILINE)
    SetGadgetText(5, "Change Text Color and RoundXY for this  MultiLine IceButtonImage Gadget")
    ButtonImageGadget(6, 360, 180, 240, 60, ImageID(0), #PB_Button_Toggle)
    SetGadgetAttribute(6, #PB_Button_PressedImage, ImageID(1))
    SetGadgetState(6, #True)
    ButtonImageGadget(7, 360, 260, 240, 60, ImageID(0))
    DisableGadget(7, #True)
    
    SetGadgetData(0, #IceBtn_Theme_DarkBlue)
    SetIceButtonTheme(#IceBtn_Theme_DarkBlue)
    SetWindowColor(0, GetIceBtnThemeAttribute(#IceBtn_BackColor))
    
    BindEvent(#PB_Event_SizeWindow, @Resize_Window(), 0)
    PostEvent(#PB_Event_SizeWindow, 0, 0)
    
    WindowBounds(0, 480, 300, #PB_Ignore, #PB_Ignore)
      
    ;- Event loop
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          Break
        Case #PB_Event_Gadget
          Select EventGadget()
            Case 0   ; Apply Dark or Light Blue theme
              Select GetGadgetData(0)
                Case #IceBtn_Theme_DarkBlue
                  SetGadgetData(0, #IceBtn_Theme_LightBlue)
                  SetGadgetText(0, "Apply Dark Blue Theme")
                  SetIceButtonTheme(#IceBtn_Theme_LightBlue)
                  SetWindowColor(0, GetIceBtnThemeAttribute(#IceBtn_BackColor))
                  ;Debug "IceButton Apply Dark Blue Theme. Theme #IceBtn_Theme_LightBlue = " + Str(GetIceButtonTheme())
                  ; ---------------------------------------------------------------------------------------------------
                  ;   Comment/Uncomment for Testing: SetIceBtnThemeAttribute, FreeIceButtonTheme,...
                  ; ---------------------------------------------------------------------------------------------------
                  ;Debug "GetGadgetText(0) : " + GetGadgetText(0)
                  ;SetIceBtnThemeAttribute(#IceBtn_color, $2880FC)
                  ;Define Color = GetIceBtnThemeAttribute(#IceBtn_color)
                  ;Debug "GetIceBtnThemeAttribute(#IceBtn_color) : RGB(" + Str(Red(Color)) + ", " + Str(Green(Color)) + ", " + Str(Blue(Color)) + ")"
                  ;Color = GetIceButtonAttribute(1, #IceBtn_color)
                  ;Debug "GetIceButtonAttribute(1, #IceBtn_color) : RGB(" + Str(Red(Color)) + ", " + Str(Green(Color)) + ", " + Str(Blue(Color)) + ")"
                  ;FreeIceButtonTheme()
                Case #IceBtn_Theme_LightBlue
                  SetGadgetData(0, #IceBtn_Theme_DarkBlue)
                  SetGadgetText(0, "Apply Light Blue tTheme")
                  SetIceButtonTheme(#IceBtn_Theme_DarkBlue)
                  SetWindowColor(0, GetIceBtnThemeAttribute(#IceBtn_BackColor))
                  ;Debug "IceButton Apply Light Blue Theme. Theme #IceBtn_Theme_DarkBlue = " + Str(GetIceButtonTheme())
              EndSelect
              
            Case 1, 5   ; Change Text Button Color in Red or with the Text color from the theme attribute. And Change RoundXY
              If GetIceButtonAttribute(1, #IceBtn_FrontColor) = #Red
                SetGadgetFont(1, FontID(0))
                SetIceButtonAttribute(1, #IceBtn_FrontColor, GetIceBtnThemeAttribute(#IceBtn_FrontColor))
                SetIceButtonAttribute(1, #IceBtn_RoundX, GetIceBtnThemeAttribute(#IceBtn_RoundX))
                SetIceButtonAttribute(1, #IceBtn_RoundY, GetIceBtnThemeAttribute(#IceBtn_RoundY))
                SetGadgetFont(5, FontID(0))
                SetIceButtonAttribute(5, #IceBtn_FrontColor, GetIceBtnThemeAttribute(#IceBtn_FrontColor))
                SetIceButtonAttribute(5, #IceBtn_RoundX, GetIceBtnThemeAttribute(#IceBtn_RoundX))
                SetIceButtonAttribute(5, #IceBtn_RoundY, GetIceBtnThemeAttribute(#IceBtn_RoundY))
                ;Define Color = GetIceButtonAttribute(1, #IceBtn_FrontColor)
                ;Debug "IceButton RoundXY = " + Str(GetIceButtonAttribute(1, #IceBtn_RoundX)) + " * " + Str(GetIceButtonAttribute(1, #IceBtn_RoundY)) + " - Text Color RGB(" + Str(Red(Color)) + ", " + Str(Green(Color)) + ", " + Str(Blue(Color)) + ") - Font Normal"
              Else
                SetGadgetFont(1, FontID(1))
                SetIceButtonAttribute(1, #IceBtn_FrontColor, #Red)
                SetIceButtonAttribute(1, #IceBtn_RoundX, 24)
                SetIceButtonAttribute(1, #IceBtn_RoundY, 24)
                SetGadgetFont(5, FontID(1))
                SetIceButtonAttribute(5, #IceBtn_FrontColor, #Red)
                SetIceButtonAttribute(5, #IceBtn_RoundX, 24)
                SetIceButtonAttribute(5, #IceBtn_RoundY, 24)
                ;Define Color = GetIceButtonAttribute(1, #IceBtn_FrontColor)
                ;Debug "IceButton RoundXY = " + Str(GetIceButtonAttribute(1, #IceBtn_RoundX)) + " * " + Str(GetIceButtonAttribute(1, #IceBtn_RoundY)) + " - Text Color RGB(" + Str(Red(Color)) + ", " + Str(Green(Color)) + ", " + Str(Blue(Color)) + ") - Font Italic"
              EndIf
              
            Case 2   ; Toggle Button (ON/OFF)
              If GetGadgetState(2)
                SetGadgetText(2, "Toggle Button (ON)")
              Else
                SetGadgetText(2, "Toggle Button (OFF)")
              EndIf
              ;Debug "IceButton " + GetGadgetText(2) + " State = " + Str(GetGadgetState(2))
              
          EndSelect
      EndSelect
    ForEver

  EndIf
CompilerEndIf

; IDE Options = PureBasic 6.03 LTS (Windows - x64)
; Folding = --------
; EnableXP