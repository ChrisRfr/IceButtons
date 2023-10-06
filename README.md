# IceButtons
Ice Button Theme Library (for Dark or Light Theme Button)

IceButtons Windows library will add a theme to your ButtonGadget, IceButton<br>
They'll still work in the same way as PureBasic Button, they're ButtonGadgets

![Alt text](/Demo_IceButtons.png?raw=true "Demo Ice Buttons")<br>

![Alt text](/Build_IceButtons_Theme.png?raw=true "Build_IceButtons_Theme")<br>

## __How tu use:__ <br>
- Add: XIncludeFile "IceButtons.pbi"<br>
- And apply one of the themes With the function: SetIceButtonTheme(#IceBtn_Theme_DarkBlue) or SetIceButtonTheme(#IceBtn_Theme_LightBlue)<br>
- Easy, that's all :wink:<br>
- Note that you can SetIceButtonTheme(Theme) anywhere you like in your source, before or after creating the window, gadget's and buttons<br>

## __Theme attribute (defined in DataSection):__ <br>
- #IceBtn_color, Color : Button color
- #IceBtn_BackColor, Color Or #PB_Default : Button background color, #PB_Default To get window color
- #IceBtn_DisableColor, Color Or #PB_Default : Disable Button color, #PB_Default To obtain the color by applying a deactivated filter To the button color
- #IceBtn_FrontColor, Color Or #PB_Default : Button text color, #PB_Default = White Or Black depending on whether the button color is dark Or light
- #IceBtn_DisableFrontColor, Color Or #PB_Default : Disable text color, #PB_Default To obtain the color by applying a deactivated filter To the button text color
- #IceBtn_EnableShadow, 0 Or 1 : Disable Or Enable text shadow
- #IceBtn_ShadowColor, Color Or #PB_Default : Button text shadow color, #PB_Default = White Or Black depending on whether the button text color is dark Or light
- #IceBtn_RoundX, Size : from 1 To X. For RoundBox(), the radius of the rounded corners in the X direction
- #IceBtn_RoundY, Size : from 1 To Y. For RoundBox(), the radius of the rounded corners in the Y direction

## __Public Functions:__ <br>
- SetIceButtonTheme(Theme) : Apply, Change Theme<br>
.  - Ex: SetIceButtonTheme(#IceBtn_Theme_DarkBlue) or SetIceButtonTheme(#IceBtn_Theme_LightBlue) or custom future Theme<br>
- GetIceButtonTheme() : Get the current theme<br>
- IsIceButton(Gadget) : Is it an IceButton?<br>
- FreeIceButtonTheme() : Free the theme, IceButton and associated resources and return to the standard ButtonGadget<br>
- GetIceBtnThemeAttribute(Attribut) : Returns a theme Attribute value<br>
.  - Ex: GetIceBtnThemeAttribute(#IceBtn_color)<br>
- SetIceBtnThemeAttribute(Attribut, Value) : Changes a theme attribute value<br>
.  - Ex: SetIceBtnThemeAttribute(#IceBtn_color, #Blue) to change the theme Button color attribute in blue<br>
- GetIceButtonAttribute(Gadget, Attribut) : Returns an IceButton attribute value<br>
.  - Ex: GetIceButtonAttribute(#Gadget, #IceBtn_color)<br>
- SetIceButtonAttribute(Gadget, Attribut, Value) : Changes an IceButton attribute value<br>
.  - Ex: SetIceButtonAttribute(#Gadget, #IceBtn_color, #Blue) to change the IceButton color in blue<br>

Enjoy :smile:
