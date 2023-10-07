;- Top
;  -------------------------------------------------------------------------------------------------------------------------------------------------
;          Title: Ice Button Theme Library (for Dark or Light Theme Button)
;    Description: This library will add a theme to your ButtonGadget, IceButton
;                 They'll still work in the same way as PureBasic Button, they're ButtonGadgets
;    Source Name: IceButtons.pbi
;         Author: ChrisR
;           Date: 2023-10-06
;        Version: 1.2
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
  #IceBtn_RoundX
  #IceBtn_RoundY
  #IceBtn_END
EndEnumeration

; Optional inner border
; 0: the border with the 1px background color is drawn inside the border
; 1: The inner border with the background color is drawn only on the top left-hand side
; 2: The inner border with the background color is drawn only on the bottom right-hand side
#BackColor_Border = 0

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
  iRoundX.i
  iRoundY.i
  bMouseOver.b
  bHiLiteTimer.b
  bClickTimer.b
  imgRegular.i
  imgHilite.i
  imgPressed.i
  imgDisabled.i
  hRgn.i
  hDcRegular.i
  hDcPressed.i
  hDcHiLite.i
  hDcDisabled.i
  hObjRegular.i
  hObjPressed.i
  hObjHiLite.i
  hObjDisabled.i
EndStructure
  
Structure ICEBUTTON_INFO
  PBGadget.i
  IDGadget.i
  IDParent.i
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
Global NewList IceButtons.ICEBUTTON_INFO()
Global Tooltip

Macro IBProcedureReturnIf(Cond, ReturnVal = 0)
  If Cond
    ProcedureReturn ReturnVal
  EndIf
EndMacro

Macro IceButtonID(pIceButton, Gadget, ReturnValue = #False)
  PushListPosition(IceButtons())
  Repeat
    ForEach IceButtons()
      If IceButtons()\PBGadget = Gadget
        pIceButton = @IceButtons()
        PopListPosition(IceButtons())
        Break 2
      EndIf
    Next
    Debug "IceButtons Error: IceButton not found in IceButtons list."
    PopListPosition(IceButtons())
    ProcedureReturn ReturnValue
  Until #True
EndMacro

;-
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
  
Procedure IBIsDarkColor(iColor)
  If Red(iColor)*0.299 + Green(iColor)*0.587 +Blue(iColor)*0.114 < 128   ; Based on Human perception of color, following the RGB values (0.299, 0.587, 0.114)
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure IBDisabledDarkColor(iColor)
  Protected R, G, B
  R = Red(iColor)   * 0.6 + (Red(iColor)   + 80) * 0.4 : If R > 255 : R = 255 : EndIf
  G = Green(iColor) * 0.6 + (Green(iColor) + 80) * 0.4 : If G > 255 : G = 255 : EndIf
  B = Blue(iColor)  * 0.6 + (Blue(iColor)  + 80) * 0.4 : If B > 255 : B = 255 : EndIf
  ProcedureReturn RGBA(R, G, B, Alpha(iColor))
EndProcedure

Procedure IBDisabledLightColor(iColor)
  Protected R, G, B
  R = Red(iColor)   * 0.6 + (Red(iColor)   - 80) * 0.4 : If R > 255 : R = 255 : EndIf
  G = Green(iColor) * 0.6 + (Green(iColor) - 80) * 0.4 : If G > 255 : G = 255 : EndIf
  B = Blue(iColor)  * 0.6 + (Blue(iColor)  - 80) * 0.4 : If B > 255 : B = 255 : EndIf
  ProcedureReturn RGBA(R, G, B, Alpha(iColor))
EndProcedure

;-
; -----------------------------------------------------------------------------
;- ----- Ice Buttons Private -----
; -----------------------------------------------------------------------------

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
    ForEach IceButtons()
      If IceButtons()\PBGadget = Gadget And IceButtons()\IDGadget = GadgetID(Gadget)
        AddIceButton(Gadget, IceButtons(), #True)  ; UpdateIceButton = #True
        AddIceButton = #False  
        Break
      EndIf
    Next
    If AddIceButton
      AddElement(IceButtons())
      AddIceButton(Gadget, IceButtons())
    EndIf
  EndIf
  
  ProcedureReturn RetVal
EndProcedure

; Macro ButtonGadget written after _ButtonGadget procedure, not to be extended in _ButtonGadget procedure at compile time (1 pass)
Macro ButtonGadget(Gadget, X, Y, Width, Height, Text, Flags = 0)
  _ButtonGadget(Gadget, X, Y, Width, Height, Text, Flags)
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
    Protected ButtonColor = \iButtonColor, ButtonBackColor = \iButtonBackColor
    Protected RoundX = \iRoundX, RoundY = \iRoundY
    
    ; DPIaware Images size. The image size must be greater than 0 To avoid an error when resizing  
    cX = DesktopScaledX(cX) : cY = DesktopScaledY(cY)
    If cX = 0 : cX = 1 : EndIf
    If cY = 0 : cY = 1 : EndIf
    
    If \imgRegular  And IsImage(\imgRegular)  : FreeImage(\imgRegular)  : EndIf
    If \imgHilite   And IsImage(\imgHilite)   : FreeImage(\imgHilite)   : EndIf
    If \imgPressed  And IsImage(\imgPressed)  : FreeImage(\imgPressed)  : EndIf
    If \imgDisabled And IsImage(\imgDisabled) : FreeImage(\imgDisabled) : EndIf
    
    \imgRegular   = CreateImage(#PB_Any, cX, cY, 32)
    \imgHilite    = CreateImage(#PB_Any, cX, cY, 32)
    \imgPressed   = CreateImage(#PB_Any, cX, cY, 32)
    \imgDisabled  = CreateImage(#PB_Any, cX, cY, 32)
    
    For I = 0 To 3
      Select I
        Case 0
          *ThisImage  = \imgRegular
        Case 1
          *ThisImage  = \imgHilite
        Case 2
          *ThisImage  = \imgPressed
        Case 3
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
          Case 0, 4       ; imgRegular, imgDisabled
            GradientColor(0.15, ButtonColor | $BE000000)
          Case 1   ; imgHilite
            GradientColor(0.3, ButtonColor | $BE000000)
          Case 2   ; imgPressed
            GradientColor(0.45, ButtonColor | $BE000000)
        EndSelect
        GradientColor(1.0, ButtonBackColor | $BE000000)
        RoundBox(0, 0, cX, cY, RoundX, RoundY)
        
        ; Border drawn with button color and an inner 1 px border with background color (full inside or top left or bottom right)
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(0, 0, cX, cY, RoundX, RoundY, ButtonColor)
        
        ; #BackColor_Border = 0: the border with the 1px background color is drawn inside the border
        CompilerIf #BackColor_Border = 0
          Select I
            Case 0, 4     ; imgRegular, imgDisabled
              RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, ButtonBackColor)
            Case 1        ; imgHilite
              RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, ButtonColor)
              RoundBox(2, 2, cX-4, cY-4, RoundX, RoundY, ButtonBackColor)
            Case 2        ; imgPressed
              RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, ButtonColor)
              RoundBox(2, 2, cX-4, cY-4, RoundX, RoundY, ButtonColor)
              RoundBox(3, 3, cX-6, cY-6, RoundX, RoundY, ButtonBackColor)
          EndSelect
          
          ; #BackColor_Border = 1: The inner border with the background color is drawn only on the top left-hand side
        CompilerElseIf #BackColor_Border = 1
          Select I
            Case 0, 4     ; imgRegular, imgDisabled
              RoundBox(1, 1, cX-1, cY-1, RoundX, RoundY, ButtonBackColor)
              RoundBox(0, 0, cX-2, cY-2, RoundX, RoundY, ButtonColor)
            Case 1        ; imgHilite
              RoundBox(2, 2, cX-3, cY-3, RoundX, RoundY, ButtonBackColor)
              RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, ButtonColor)
              ECase 2     ; imgPressed
              RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, ButtonColor)
              RoundBox(3, 3, cX-4, cY-4, RoundX, RoundY, ButtonBackColor)
              RoundBox(2, 2, cX-3, cY-3, RoundX, RoundY, ButtonColor)
          EndSelect
          
          ; #BackColor_Border 2: The inner border with the background color is drawn only on the bottom right-hand side 
        CompilerElseIf #BackColor_Border = 2
          Select I
            Case 0, 4     ; imgRegular, imgDisabled
              RoundBox(0, 0, cX-1, cY-1, RoundX, RoundY, ButtonBackColor)
              RoundBox(0, 0, cX  , cY,   RoundX, RoundY, ButtonColor)
            Case 1        ; imgHilite
              RoundBox(1, 1, cX-3, cY-3, RoundX, RoundY, ButtonBackColor)
              RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, ButtonColor)
            Case 2        ; imgPressed
              RoundBox(1, 1, cX-2, cY-2, RoundX, RoundY, ButtonColor)
              RoundBox(2, 2, cX-4, cY-4, RoundX, RoundY, ButtonBackColor)
              RoundBox(2, 2, cX-3, cY-3, RoundX, RoundY, ButtonColor)
          EndSelect
        CompilerEndIf
        
        StopDrawing()
      EndIf
    Next
    
    SelectObject_(\hDcRegular,  ImageID(\imgRegular))
    SelectObject_(\hDcHiLite,   ImageID(\imgHilite))
    SelectObject_(\hDcPressed,  ImageID(\imgPressed))
    SelectObject_(\hDcDisabled, ImageID(\imgDisabled))
  EndWith
  
EndProcedure

Procedure ChangeIceButton(Gadget)
  Protected RetVal
  Protected *IceButtons.ICEBUTTON_INFO : IceButtonID(*IceButtons, Gadget, #False)

      ; DesktopScaledX(Y) is done in MakeIceButtonImages()
      MakeIceButtonImages(GadgetWidth(Gadget), GadgetHeight(Gadget), IceButtons())
      
      With *IceButtons\BtnInfo
        SelectObject_(\hDcRegular,  ImageID(\imgRegular))
        SelectObject_(\hDcHiLite,   ImageID(\imgHilite))
        SelectObject_(\hDcPressed,  ImageID(\imgPressed))
        SelectObject_(\hDcDisabled, ImageID(\imgDisabled))
      EndWith
      InvalidateRect_(*IceButtons\IDGadget, 0, 0)
      RetVal = #True

  ProcedureReturn RetVal
EndProcedure

Procedure UpdateIceButtonImages(*IceButton.ICEBUTTON_INFO)
  Protected hGenDC, CancelOut, RetVal
  
  With *IceButton\BtnInfo
    SelectObject_(\hDcRegular,  \hObjRegular)  : DeleteDC_(\hDcRegular)
    SelectObject_(\hDcHiLite,   \hObjHiLite)   : DeleteDC_(\hDcHiLite)
    SelectObject_(\hDcPressed,  \hObjPressed)  : DeleteDC_(\hDcPressed)
    SelectObject_(\hDcDisabled, \hObjDisabled) : DeleteDC_(\hDcDisabled)
    
    ; DesktopScaledX(Y) is done in MakeIceButtonImages()
    MakeIceButtonImages(GadgetWidth(*IceButton\PBGadget), GadgetHeight(*IceButton\PBGadget), IceButtons())
    
    If Not (IsImage(\imgRegular))  : Debug "imgRegular is missing!"  : CancelOut = #True: EndIf
    If Not (IsImage(\imgHilite))   : Debug "imgHilite is missing!"   : CancelOut = #True: EndIf
    If Not (IsImage(\imgPressed))  : Debug "imgPressed is missing!"  : CancelOut = #True: EndIf
    If Not (IsImage(\imgDisabled)) : Debug "imgDisabled is missing!" : CancelOut = #True: EndIf
    
    If CancelOut = #True
      If \imgRegular  And IsImage(\imgRegular)  : FreeImage(\imgRegular)  : EndIf
      If \imgHilite   And IsImage(\imgHilite)   : FreeImage(\imgHilite)   : EndIf
      If \imgPressed  And IsImage(\imgPressed)  : FreeImage(\imgPressed)  : EndIf
      If \imgDisabled And IsImage(\imgDisabled) : FreeImage(\imgDisabled) : EndIf
      ProcedureReturn 0
    EndIf
    
    hGenDC        = GetDC_(#Null)
    \hDcRegular   = CreateCompatibleDC_(hGenDC)
    \hDcHiLite    = CreateCompatibleDC_(hGenDC)
    \hDcPressed   = CreateCompatibleDC_(hGenDC)
    \hDcDisabled  = CreateCompatibleDC_(hGenDC)
    
    \hObjRegular  = SelectObject_(\hDcRegular, ImageID(\imgRegular))
    \hObjHiLite   = SelectObject_(\hDcHiLite, ImageID(\imgHilite))
    \hObjPressed  = SelectObject_(\hDcPressed, ImageID(\imgPressed))
    \hObjDisabled = SelectObject_(\hDcDisabled, ImageID(\imgDisabled))
    
    ReleaseDC_(#Null, hGenDC)
    InvalidateRect_(*IceButton\IDGadget, 0, 0)
    RetVal = #True
  EndWith
  
  ProcedureReturn RetVal
EndProcedure

Procedure FreeIceButton(Gadget)
  Protected SavText.s, RetVal
  Protected *IceButtons.ICEBUTTON_INFO : IceButtonID(*IceButtons, Gadget, #False)
  
  SetWindowLongPtr_(IceButtons()\IDGadget, #GWLP_WNDPROC, IceButtons()\OldWndProc)
  
  With *IceButtons\BtnInfo
    SelectObject_(\hDcRegular,  \hObjRegular)  : DeleteDC_(\hDcRegular)
    SelectObject_(\hDcHiLite,   \hObjHiLite)   : DeleteDC_(\hDcHiLite)
    SelectObject_(\hDcPressed,  \hObjPressed)  : DeleteDC_(\hDcPressed)
    SelectObject_(\hDcDisabled, \hObjDisabled) : DeleteDC_(\hDcDisabled)
    
    If \imgRegular  And IsImage(\imgRegular)   : FreeImage(\imgRegular)  : EndIf
    If \imgHilite   And IsImage(\imgHilite)    : FreeImage(\imgHilite)   : EndIf
    If \imgPressed  And IsImage(\imgPressed)   : FreeImage(\imgPressed)  : EndIf
    If \imgDisabled And IsImage(\imgDisabled)  : FreeImage(\imgDisabled) : EndIf
  EndWith
  
  SavText = *IceButtons\BtnInfo\sButtonText
  ;SetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE, GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) ! #BS_OWNERDRAW)
  SetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE, GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) ! #BS_USERBUTTON ! #BS_HATCHED)   ; #BS_OWNERDRAW Without #BS_DEFPUSHBUTTON
  SetWindowPos_(*IceButtons\IDGadget, #Null, 0, 0, 0, 0, #SWP_NOZORDER | #SWP_NOSIZE | #SWP_NOMOVE)
  
  FreeMemory(*IceButtons\BtnInfo)
  DeleteElement(IceButtons())
  
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
      SelectObject_(\hDcRegular,  \hObjRegular)  : DeleteDC_(\hDcRegular)
      SelectObject_(\hDcHiLite,   \hObjHiLite)   : DeleteDC_(\hDcHiLite)
      SelectObject_(\hDcPressed,  \hObjPressed)  : DeleteDC_(\hDcPressed)
      SelectObject_(\hDcDisabled, \hObjDisabled) : DeleteDC_(\hDcDisabled)
      ; FreeImage() done in MakeIceButtonImages()
    EndWith
  Else
    With *IceButton
      \PBGadget             = Gadget
      \IDGadget             = GadgetID(Gadget)
      \IDParent             = GetParent_(\IDGadget)
      \BtnInfo              = AllocateMemory(SizeOf(IBTN_INFO))
      \OldWndProc           = GetWindowLongPtr_(\IDGadget, #GWLP_WNDPROC)
      \BtnInfo\hRgn         = CreateRectRgn_(0, 0, DesktopScaledX(GadgetWidth(Gadget)), DesktopScaledY(GadgetHeight(Gadget)))
      \BtnInfo\sButtonText  = GetGadgetText(Gadget)
    EndWith
  EndIf
  
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
    
    \iRoundX = IceBtnTheme(Str(#IceBtn_RoundX))
    \iRoundY = IceBtnTheme(Str(#IceBtn_RoundY))
    
    ; DesktopScaledX(Y) is done in MakeIceButtonImages()
    MakeIceButtonImages(GadgetWidth(Gadget), GadgetHeight(Gadget), IceButtons())
    
    If Not (IsImage(\imgRegular))  : Debug "imgRegular is missing!"  : CancelOut = #True: EndIf
    If Not (IsImage(\imgHilite))   : Debug "imgHilite is missing!"   : CancelOut = #True: EndIf
    If Not (IsImage(\imgPressed))  : Debug "imgPressed is missing!"  : CancelOut = #True: EndIf
    If Not (IsImage(\imgDisabled)) : Debug "imgDisabled is missing!" : CancelOut = #True: EndIf
    
    If CancelOut = #True
      If \imgRegular  And IsImage(\imgRegular)  : FreeImage(\imgRegular)  : EndIf
      If \imgHilite   And IsImage(\imgHilite)   : FreeImage(\imgHilite)   : EndIf
      If \imgPressed  And IsImage(\imgPressed)  : FreeImage(\imgPressed)  : EndIf
      If \imgDisabled And IsImage(\imgDisabled) : FreeImage(\imgDisabled) : EndIf
      
      FreeMemory(IceButtons()\BtnInfo)
      DeleteElement(IceButtons())
      ProcedureReturn 0
    EndIf
    
    hGenDC        = GetDC_(#Null)
    \hDcRegular   = CreateCompatibleDC_(hGenDC)
    \hDcHiLite    = CreateCompatibleDC_(hGenDC)
    \hDcPressed   = CreateCompatibleDC_(hGenDC)
    \hDcDisabled  = CreateCompatibleDC_(hGenDC)
  
    \hObjRegular  = SelectObject_(\hDcRegular, ImageID(\imgRegular))
    \hObjHiLite   = SelectObject_(\hDcHiLite, ImageID(\imgHilite))
    \hObjPressed  = SelectObject_(\hDcPressed, ImageID(\imgPressed))
    \hObjDisabled = SelectObject_(\hDcDisabled, ImageID(\imgDisabled))
    
    ReleaseDC_(#Null, hGenDC)
    InvalidateRect_(IceButtons()\IDGadget, 0, 0)
    
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
  Protected *IceButtons.ICEBUTTON_INFO, OldWndProc, CursorPos.POINT, ps.PAINTSTRUCT, Rect.RECT
  Protected cX, cY, Margin = 6, Xofset, Yofset, HFlag, VFlag, Text.s, TextLen, TxtHeight, In_Button_Rect, hDC_to_use
  
  ForEach IceButtons()
   If IceButtons()\IDGadget = hWnd
     *IceButtons = @IceButtons()
     OldWndProc = *IceButtons\OldWndProc
     Break
   EndIf
  Next
  
  If *IceButtons = 0
    ProcedureReturn DefWindowProc_(hWnd, uMsg, wParam, lParam)
  EndIf
  
  Select uMsg
      
    Case #WM_DESTROY
      FreeIceButton(*IceButtons\PBGadget)
     
    Case #WM_TIMER
      Select wParam
        Case 124
          If GetAsyncKeyState_(#VK_LBUTTON) & $8000 <> $8000
            KillTimer_(hWnd, 124)
            *IceButtons\BtnInfo\bClickTimer = #False
            *IceButtons\BtnInfo\bHiLiteTimer = #False
            InvalidateRect_(hWnd, 0, 1)
          EndIf
        Case 123
          GetCursorPos_(@CursorPos)
          ScreenToClient_(*IceButtons\IDParent, @CursorPos)
          In_Button_Rect   = #True
          If CursorPos\x < DesktopScaledX(GadgetX(*IceButtons\PBGadget)) Or CursorPos\x > DesktopScaledX(GadgetX(*IceButtons\PBGadget) + GadgetWidth(*IceButtons\PBGadget))
            In_Button_Rect = #False
          EndIf
          If CursorPos\y < DesktopScaledY(GadgetY(*IceButtons\PBGadget)) Or CursorPos\y > DesktopScaledY(GadgetY(*IceButtons\PBGadget) + GadgetHeight(*IceButtons\PBGadget))
            In_Button_Rect = #False
          EndIf
          If Not In_Button_Rect
            KillTimer_(hWnd, 123)
            *IceButtons\BtnInfo\bMouseOver = #False
            *IceButtons\BtnInfo\bHiLiteTimer = #False
            InvalidateRect_(hWnd, 0, 1)
          Else
            Delay(1)
          EndIf
      EndSelect
      
    Case #WM_MOUSEMOVE
      GetCursorPos_(@CursorPos)
      ScreenToClient_(*IceButtons\IDParent, @CursorPos)
      In_Button_Rect     = #True
      If CursorPos\x < DesktopScaledX(GadgetX(*IceButtons\PBGadget)) Or CursorPos\x > DesktopScaledX(GadgetX(*IceButtons\PBGadget) + GadgetWidth(*IceButtons\PBGadget))
        In_Button_Rect   = #False
      EndIf
      If CursorPos\y < DesktopScaledY(GadgetY(*IceButtons\PBGadget)) Or CursorPos\y > DesktopScaledY(GadgetY(*IceButtons\PBGadget) + GadgetHeight(*IceButtons\PBGadget))
        In_Button_Rect   = #False
      EndIf
      If In_Button_Rect = #True And Not *IceButtons\BtnInfo\bMouseOver
        *IceButtons\BtnInfo\bMouseOver = #True
        *IceButtons\BtnInfo\bHiLiteTimer = #True
        SetTimer_(hWnd, 123, 50, #Null)
        InvalidateRect_(hWnd, 0, 1)
      EndIf
      
    Case #WM_LBUTTONDOWN
      If Not *IceButtons\BtnInfo\bClickTimer
        *IceButtons\BtnInfo\bClickTimer = #True
        SetTimer_(hWnd, 124, 100, #Null)
        If (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_PUSHLIKE = #BS_PUSHLIKE)
          *IceButtons\BtnInfo\bButtonState  = *IceButtons\BtnInfo\bButtonState ! 1
        EndIf
        InvalidateRect_(hWnd, 0, 1)
      EndIf
      
    Case #WM_ENABLE
      *IceButtons\BtnInfo\bButtonEnable = wParam
      InvalidateRect_(hWnd, 0, 1)
      ProcedureReturn 0
      
    Case #WM_WINDOWPOSCHANGED
      DeleteObject_(*IceButtons\BtnInfo\hRgn)
      *IceButtons\BtnInfo\hRgn = CreateRectRgn_(0, 0, DesktopScaledX(GadgetWidth(*IceButtons\PBGadget)), DesktopScaledY(GadgetHeight(*IceButtons\PBGadget)))
      ChangeIceButton(*IceButtons\PBGadget)   ; Or with UpdateIceButtonImages(IceButton())

      
    Case #WM_SETTEXT
      *IceButtons\BtnInfo\sButtonText = PeekS(lParam)
      DefWindowProc_(hWnd, uMsg, wParam, lParam)
      InvalidateRect_(hWnd, 0, 0)
      ProcedureReturn 1
           
    Case #BM_SETCHECK
      If (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_PUSHLIKE = #BS_PUSHLIKE)
        *IceButtons\BtnInfo\bButtonState = wParam
        InvalidateRect_(hWnd, 0, 0)
      EndIf
      
    Case #BM_GETCHECK
      ProcedureReturn *IceButtons\BtnInfo\bButtonState
          
    Case #WM_SETFONT
      *IceButtons\BtnInfo\iActiveFont = wParam
      InvalidateRect_(hWnd, 0, 0)
      
    Case #WM_PAINT
      cX                = DesktopScaledX(GadgetWidth(*IceButtons\PBGadget))
      cY                = DesktopScaledY(GadgetHeight(*IceButtons\PBGadget))
      Xofset            = 0
      Yofset            = 0
      
      GetCursorPos_(@CursorPos)
      ScreenToClient_(*IceButtons\IDParent, @CursorPos)
      In_Button_Rect     = #True
      If CursorPos\x < DesktopScaledX(GadgetX(*IceButtons\PBGadget)) Or CursorPos\x > DesktopScaledX(GadgetX(*IceButtons\PBGadget) + GadgetWidth(*IceButtons\PBGadget))
        In_Button_Rect   = #False
      EndIf
      If CursorPos\y < DesktopScaledY(GadgetY(*IceButtons\PBGadget)) Or CursorPos\y > DesktopScaledY(GadgetY(*IceButtons\PBGadget) + GadgetHeight(*IceButtons\PBGadget))
        In_Button_Rect   = #False
      EndIf
      
      If (*IceButtons\BtnInfo\bClickTimer And In_Button_Rect = #True)
        ; Invert Regular And pressed images during the Click Timer, to better see click action
        If *IceButtons\BtnInfo\bButtonState
          hDC_to_use    = *IceButtons\BtnInfo\hDcRegular
        Else
          hDC_to_use    = *IceButtons\BtnInfo\hDcPressed
        EndIf
        Xofset          = 1
        Yofset          = 1
      ElseIf *IceButtons\BtnInfo\bHiLiteTimer
        hDC_to_use      = *IceButtons\BtnInfo\hDcHiLite
      Else
        If *IceButtons\BtnInfo\bButtonEnable  = 0
          hDC_to_use    = *IceButtons\BtnInfo\hDcDisabled
        ElseIf *IceButtons\BtnInfo\bButtonState
          hDC_to_use    = *IceButtons\BtnInfo\hDcPressed
        Else
          hDC_to_use    = *IceButtons\BtnInfo\hDcRegular
        EndIf
      EndIf
      
      BeginPaint_(hWnd, @ps.PAINTSTRUCT)
      
      ; Calculate text height for multiline buttons, then adapt rectangle to center text vertically (DT_VCenter doesn't do the trick)
      ; It must be done before BitBlt() to be overwritten
      If (*IceButtons\BtnInfo\sButtonText <> "") And (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_MULTILINE = #BS_MULTILINE) 
        Text  = *IceButtons\BtnInfo\sButtonText
        TextLen = Len(Text)
        SelectObject_(ps\hdc, *IceButtons\BtnInfo\iActiveFont)
        SetBkMode_(ps\hdc, #TRANSPARENT)
        SetTextColor_(ps\hdc, *IceButtons\BtnInfo\iFrontColor)
        Rect\left       = Xofset + Margin
        Rect\top        = Yofset + Margin
        Rect\right      = cX + Xofset - Margin
        Rect\bottom     = cY + Yofset - Margin
        TxtHeight = DrawText_(ps\hdc, @Text, TextLen, @Rect, #DT_CENTER | #DT_VCENTER | #DT_WORDBREAK)
      EndIf
                
      SelectClipRgn_(ps\hdc, *IceButtons\BtnInfo\hRgn)
      BitBlt_(ps\hdc, 0, 0, cX, cY, hDC_to_use, 0, 0, #SRCCOPY)
      
      If *IceButtons\BtnInfo\sButtonText <> ""
        Text  = *IceButtons\BtnInfo\sButtonText
        TextLen = Len(Text)
        If (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & (#BS_LEFT | #BS_RIGHT) = (#BS_LEFT | #BS_RIGHT)) : HFlag | #DT_CENTER
        ElseIf (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_LEFT = #BS_LEFT)                         : HFlag | #DT_LEFT
        ElseIf (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_RIGHT = #BS_RIGHT)                       : HFlag | #DT_RIGHT
        Else                                                                                                       : HFlag | #DT_CENTER
        EndIf
        If (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & (#BS_TOP | #BS_BOTTOM) = (#BS_TOP | #BS_BOTTOM)) : VFlag | #DT_VCENTER
        ElseIf (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_TOP = #BS_TOP)                           : VFlag | #DT_TOP
        ElseIf (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_BOTTOM = #BS_BOTTOM)                     : VFlag | #DT_BOTTOM
        Else                                                                                                       : VFlag | #DT_VCENTER
        EndIf
        If (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_MULTILINE = #BS_MULTILINE) 
          VFlag | #DT_WORDBREAK
        Else  
          VFlag | #DT_SINGLELINE
        EndIf
        
        SelectObject_(ps\hdc, *IceButtons\BtnInfo\iActiveFont)
        SetBkMode_(ps\hdc, #TRANSPARENT)
        
        If IceButtons()\BtnInfo\bEnableShadow
          SetTextColor_(ps\hdc, *IceButtons\BtnInfo\iShadowColor)
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
          TxtHeight = DrawText_(ps\hdc, @Text, TextLen, @Rect, HFlag | VFlag)
        EndIf
        
        If *IceButtons\BtnInfo\bButtonEnable
          SetTextColor_(ps\hdc, *IceButtons\BtnInfo\iFrontColor)
        Else
          SetTextColor_(ps\hdc, *IceButtons\BtnInfo\iDisableFrontColor)
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
        TxtHeight = DrawText_(ps\hdc, @Text, TextLen, @Rect, HFlag | VFlag)

      EndIf
      EndPaint_(hWnd, @ps)
      ProcedureReturn #True
      
    Case #WM_PRINT
      cX                = DesktopScaledX(GadgetWidth(*IceButtons\PBGadget))
      cY                = DesktopScaledY(GadgetHeight(*IceButtons\PBGadget))
      
      If *IceButtons\BtnInfo\bButtonEnable  = 0
        hDC_to_use      = *IceButtons\BtnInfo\hDcDisabled
      ElseIf *IceButtons\BtnInfo\bButtonState
        hDC_to_use      = *IceButtons\BtnInfo\hDcPressed
      Else
        hDC_to_use      = *IceButtons\BtnInfo\hDcRegular
      EndIf
      
      ; Calculate text height for multiline buttons, then adapt rectangle to center text vertically (DT_VCenter doesn't do the trick)
      ; It must be done before BitBlt() to be overwritten
      If (*IceButtons\BtnInfo\sButtonText <> "") And (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_MULTILINE = #BS_MULTILINE) 
        Text  = *IceButtons\BtnInfo\sButtonText
        TextLen = Len(Text)
        SelectObject_(wParam, *IceButtons\BtnInfo\iActiveFont)
        SetBkMode_(wParam, #TRANSPARENT)
        SetTextColor_(wParam, *IceButtons\BtnInfo\iFrontColor)
        Rect\left       = Xofset + Margin
        Rect\top        = Yofset + Margin
        Rect\right      = cX + Xofset - Margin
        Rect\bottom     = cY + Yofset - Margin
        TxtHeight = DrawText_(wParam, @Text, TextLen, @Rect, #DT_CENTER | #DT_VCENTER | #DT_WORDBREAK)
      EndIf
      
      SelectClipRgn_(wParam, *IceButtons\BtnInfo\hRgn)
      BitBlt_(wParam, 0, 0, cX, cY, hDC_to_use, 0, 0, #SRCCOPY)
      
      If *IceButtons\BtnInfo\sButtonText <> ""
        Text           = *IceButtons\BtnInfo\sButtonText
        TextLen        = Len(Text)
        If (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & (#BS_LEFT | #BS_RIGHT) = (#BS_LEFT | #BS_RIGHT)) : HFlag | #DT_CENTER
        ElseIf (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_LEFT = #BS_LEFT)                         : HFlag | #DT_LEFT
        ElseIf (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_RIGHT = #BS_RIGHT)                       : HFlag | #DT_RIGHT
        Else                                                                                                       : HFlag | #DT_CENTER
        EndIf
        If (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & (#BS_TOP | #BS_BOTTOM) = (#BS_TOP | #BS_BOTTOM)) : VFlag | #DT_VCENTER
        ElseIf (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_TOP = #BS_TOP)                           : VFlag | #DT_TOP
        ElseIf (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_BOTTOM = #BS_BOTTOM)                     : VFlag | #DT_BOTTOM
        Else                                                                                                       : VFlag | #DT_VCENTER
        EndIf
        If (GetWindowLongPtr_(*IceButtons\IDGadget, #GWL_STYLE) & #BS_MULTILINE = #BS_MULTILINE) 
          VFlag | #DT_WORDBREAK
        Else  
          VFlag | #DT_SINGLELINE
        EndIf

        SelectObject_(wParam, *IceButtons\BtnInfo\iActiveFont)
        SetBkMode_(wParam, #TRANSPARENT)
        
        If IceButtons()\BtnInfo\bEnableShadow
          SetTextColor_(wParam, *IceButtons\BtnInfo\iShadowColor)
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
        
        If *IceButtons\BtnInfo\bButtonEnable
          SetTextColor_(wParam, *IceButtons\BtnInfo\iFrontColor)
        Else
          SetTextColor_(wParam, *IceButtons\BtnInfo\iDisableFrontColor)
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

;-
; -----------------------------------------------------------------------------
;- ----- Ice Buttons Public -----
; -----------------------------------------------------------------------------

Procedure IsIceButton(Gadget)
  Protected RetVal
  If Not (IsGadget(Gadget)) : ProcedureReturn RetVal : EndIf
  
  ForEach IceButtons()
    If IceButtons()\PBGadget = Gadget And IceButtons()\IDGadget = GadgetID(Gadget)
      RetVal = #True
      Break
    EndIf
  Next
  ProcedureReturn RetVal
EndProcedure

Procedure GetIceBtnThemeAttribute(Attribut)
  Protected RetVal
  
  Select Attribut
    Case #IceBtn_color, #IceBtn_BackColor, #IceBtn_DisableColor, #IceBtn_FrontColor, #IceBtn_DisableFrontColor, #IceBtn_EnableShadow, #IceBtn_ShadowColor, #IceBtn_RoundX, #IceBtn_RoundY
      RetVal = IceBtnTheme(Str(Attribut))
  EndSelect
  
  ProcedureReturn RetVal
EndProcedure

Procedure SetIceBtnThemeAttribute(Attribut, Value)
  Protected RetVal
  
  Select Attribut
    Case #IceBtn_color, #IceBtn_BackColor, #IceBtn_DisableColor, #IceBtn_FrontColor, #IceBtn_DisableFrontColor, #IceBtn_EnableShadow, #IceBtn_ShadowColor, #IceBtn_RoundX, #IceBtn_RoundY
      IceBtnTheme(Str(Attribut)) = Value
      RetVal = #True
  EndSelect
  
  SetIceButtonAttribute(#PB_All, Attribut, Value)
  
  ProcedureReturn RetVal
EndProcedure

Procedure GetIceButtonAttribute(Gadget, Attribut)
  IBProcedureReturnIf(Not (IsGadget(Gadget)))
  Protected RetVal
  Protected *IceButtons.ICEBUTTON_INFO : IceButtonID(*IceButtons, Gadget, #False)
  
  With *IceButtons\BtnInfo
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
  Protected RetVal
  
  With IceButtons()\BtnInfo 
    ForEach IceButtons()
      If IceButtons()\PBGadget = Gadget Or Gadget = #PB_All
        Select Attribut
          Case #IceBtn_color
            \iButtonColor         = Value
            
            If IceBtnTheme(Str(#IceBtn_BackColor)) = #PB_Default
              Protected WinParent = IBWindowPB(GetAncestor_(IceButtons()\IDGadget, #GA_ROOT))
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
    
          Case #IceBtn_BackColor
            \iButtonBackColor     = Value
          Case #IceBtn_DisableColor
            \iDisableBackColor    = Value
            
          Case #IceBtn_FrontColor
            \iFrontColor          = Value
            
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
            
          Case #IceBtn_DisableFrontColor
            \iDisableFrontColor   = Value
          Case #IceBtn_EnableShadow
            \bEnableShadow        = Value
          Case #IceBtn_ShadowColor
            \iShadowColor         = Value
          Case #IceBtn_RoundX
            \iRoundX              = Value
          Case #IceBtn_RoundY
            \iRoundY              = Value
        EndSelect
        
        If Not UpdateIceButtonImages(IceButtons())   ; or ChangeIceButton(Gadget)
         FreeMemory(IceButtons()\BtnInfo)
         DeleteElement(IceButtons())
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
  
  ForEach IceButtons()
    FreeIceButton(IceButtons()\PBGadget)
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
  
  ResetList(IceButtons())
  While NextElement(IceButtons())
    If Not (IsGadget(IceButtons()\PBGadget)) Or Not (IsWindow_(IceButtons()\IDGadget))
      DeleteElement(IceButtons())
    EndIf
  Wend
  
  PB_Object_EnumerateStart(PB_Gadget_Objects)
  While PB_Object_EnumerateNext(PB_Gadget_Objects, @Object)
    If GadgetType(Object) = #PB_GadgetType_Button
      AddIceButton = #True
      ResetList(IceButtons())
      While NextElement(IceButtons())
        If IceButtons()\PBGadget = Object And IceButtons()\IDGadget = GadgetID(Object)
          AddIceButton(Object, IceButtons(), #True)  ; UpdateIceButton = #True
          AddIceButton = #False
          Break
        EndIf
      Wend
      If AddIceButton
        AddElement(IceButtons())
        RetVal = AddIceButton(Object, IceButtons())
      EndIf
    EndIf
  Wend
  PB_Object_EnumerateAbort(PB_Gadget_Objects)
  
  ProcedureReturn RetVal
EndProcedure

;-
; -----------------------------------------------------------------------------
;- ----- Define Themes in DataSection -----
; -----------------------------------------------------------------------------

DataSection
  DarkBlue:
  Data.i #IceBtn_color, $FD6E0D
  Data.i #IceBtn_BackColor, $292521
  Data.i #IceBtn_DisableColor, #PB_Default
  Data.i #IceBtn_FrontColor, #White
  Data.i #IceBtn_DisableFrontColor, #PB_Default
  Data.i #IceBtn_EnableShadow, 1
  Data.i #IceBtn_ShadowColor, $292521
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
  Data.i #IceBtn_ShadowColor, $FF802B
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
  Data.i #IceBtn_RoundX, 8
  Data.i #IceBtn_RoundY, 8
  Data.i #IceBtn_END
EndDataSection

;-
; -----------------------------------------------------------------------------
;- ----- Demo example -----
; -----------------------------------------------------------------------------

CompilerIf (#PB_Compiler_IsMainFile)
  
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
  EndProcedure
  
  LoadFont(0, "", 9)
  LoadFont(1, "", 9, #PB_Font_Italic)
  
  ;- OpenWindow
  If OpenWindow(0, 0, 0, 360, 340, "Demo Ice Buttons", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    
    ; SetIceButtonTheme can be positioned anywhere, before or after ButtonGadget creation
    ;SetIceButtonTheme(#IceBtn_Theme_DarkBlue) : SetIceButtonAttribute(#IceBtn_FrontColor, #Red)
    SetGadgetFont(#PB_Default, FontID(0))
    ButtonGadget(0, 60, 20,  240, 60, "Apply Light Blue Theme")
    ButtonGadget(1, 60, 100, 240, 60, "Change Text Color and RoundXY for this  MultiLine IceButton Gadget", #PB_Button_MultiLine)
    ButtonGadget(2, 60, 180, 240, 60, "Toggle Button (ON)", #PB_Button_Toggle)
    SetGadgetState(2, #True)
    GadgetToolTip(2, "Toggle Button (ON/OFF)")
    ButtonGadget(3, 60, 260, 240, 60, "Disabled Button")
    DisableGadget(3, #True)
    
    SetGadgetData(0, #IceBtn_Theme_DarkBlue)
    SetIceButtonTheme(#IceBtn_Theme_DarkBlue)
    SetWindowColor(0, GetIceBtnThemeAttribute(#IceBtn_BackColor))
    
    BindEvent(#PB_Event_SizeWindow, @Resize_Window(), 0)
    PostEvent(#PB_Event_SizeWindow, 0, 0)
    
    WindowBounds(0, 300, 200, #PB_Ignore, #PB_Ignore)
      
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
                  Debug "IceButton Apply Dark Blue Theme. Theme #IceBtn_Theme_LightBlue = " + Str(GetIceButtonTheme())
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
                  Debug "IceButton Apply Light Blue Theme. Theme #IceBtn_Theme_DarkBlue = " + Str(GetIceButtonTheme())
              EndSelect
              
            Case 1   ; Change Text Button Color in Red or with the Text color from the theme attribute. And Change RoundXY
              If GetIceButtonAttribute(1, #IceBtn_FrontColor) = #Red
                SetGadgetFont(1, FontID(0))
                SetIceButtonAttribute(1, #IceBtn_FrontColor, GetIceBtnThemeAttribute(#IceBtn_FrontColor))
                SetIceButtonAttribute(1, #IceBtn_RoundX, GetIceBtnThemeAttribute(#IceBtn_RoundX))
                SetIceButtonAttribute(1, #IceBtn_RoundY, GetIceBtnThemeAttribute(#IceBtn_RoundY))
                Define Color = GetIceButtonAttribute(1, #IceBtn_FrontColor)
                Debug "IceButton RoundXY = " + Str(GetIceButtonAttribute(1, #IceBtn_RoundX)) + " * " + Str(GetIceButtonAttribute(1, #IceBtn_RoundY)) + " - Text Color RGB(" + Str(Red(Color)) + ", " + Str(Green(Color)) + ", " + Str(Blue(Color)) + ") - Font Normal"
              Else
                SetGadgetFont(1, FontID(1))
                SetIceButtonAttribute(1, #IceBtn_FrontColor, #Red)
                SetIceButtonAttribute(1, #IceBtn_RoundX, 24)
                SetIceButtonAttribute(1, #IceBtn_RoundY, 24)
                Define Color = GetIceButtonAttribute(1, #IceBtn_FrontColor)
                Debug "IceButton RoundXY = " + Str(GetIceButtonAttribute(1, #IceBtn_RoundX)) + " * " + Str(GetIceButtonAttribute(1, #IceBtn_RoundY)) + " - Text Color RGB(" + Str(Red(Color)) + ", " + Str(Green(Color)) + ", " + Str(Blue(Color)) + ") - Font Italic"
              EndIf
              
            Case 2   ; Toggle Button (ON/OFF)
              If GetGadgetState(2)
                SetGadgetText(2, "Toggle Button (ON)")
              Else
                SetGadgetText(2, "Toggle Button (OFF)")
              EndIf
              Debug "IceButton " + GetGadgetText(2) + " State = " + Str(GetGadgetState(2)) 
              
          EndSelect
      EndSelect
    ForEver

  EndIf
CompilerEndIf

; IDE Options = PureBasic 6.01 LTS (Windows - x64)
; EnableXP