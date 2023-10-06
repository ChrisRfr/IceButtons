# IceButtons
Ice Button Theme Library (for Dark or Light Theme Button)

IceButtons Windows library will add a theme to your ButtonGadget, IceButton
They'll still work in the same way as PureBasic Button, they're ButtonGadgets

## __How tu use:__ <br>
- Add: XIncludeFile "IceButtons.pbi"
- And apply one of the themes With the function: SetIceButtonTheme(#IceBtn_Theme_DarkBlue) or SetIceButtonTheme(#IceBtn_Theme_LightBlue)
Easy, that's all :wink:
Note that you can SetIceButtonTheme(Theme) anywhere you like in your source, before or after creating the window, gadget's and buttons

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
- SetIceButtonTheme(Theme) : Apply, Change Theme
. . . - Ex: SetIceButtonTheme(#IceBtn_Theme_DarkBlue) or SetIceButtonTheme(#IceBtn_Theme_LightBlue) or custom future Theme
- GetIceButtonTheme() : Get the current theme
- IsIceButton(Gadget) : Is it an IceButton?
- FreeIceButtonTheme() : Free the theme, IceButton and associated resources and return to the standard ButtonGadget
- GetIceBtnThemeAttribute(Attribut) : Returns a theme Attribute value
. . . - Ex: GetIceBtnThemeAttribute(#IceBtn_color)
- SetIceBtnThemeAttribute(Attribut, Value) : Changes a theme attribute value
. . . - Ex: SetIceBtnThemeAttribute(#IceBtn_color, #Blue) to change the theme Button color attribute in blue
- GetIceButtonAttribute(Gadget, Attribut) : Returns an IceButton attribute value
. . . - Ex: GetIceButtonAttribute(#Gadget, #IceBtn_color)
- SetIceButtonAttribute(Gadget, Attribut, Value) : Changes an IceButton attribute value
. . . - Ex: SetIceButtonAttribute(#Gadget, #IceBtn_color, #Blue) to change the IceButton color in blue