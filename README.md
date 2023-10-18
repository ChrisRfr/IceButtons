# IceButtons
**IceButton** Theme Library (for Dark or Light Theme Button), **Windows only**

IceButtons Windows library will add a theme to your ButtonGadget, ButtonImageGadget<br>
They'll still work in the same way as PureBasic Button, they're ButtonGadget, ButtonImageGadget

![Alt text](/Demo_IceButtons.png?raw=true "Demo Ice Buttons")<br>

![Alt text](/Build_IceButtons_Theme.png?raw=true "Build_IceButtons_Theme")<br>

## __How tu use:__ <br>
- Add: XIncludeFile "IceButtons.pbi"<br>
- And apply one of the themes With the function: SetIceButtonTheme(#IceBtn_Theme_DarkBlue) or SetIceButtonTheme(#IceBtn_Theme_LightBlue)<br>
- Easy, that's all :wink:<br>
- Note that you can SetIceButtonTheme(Theme) anywhere you like in your source, before or after creating the window, gadget's and buttons<br>

## __Theme attribute (defined in DataSection):__ <br>
- #IceBtn_col, Color<br/>
&emsp;Button color
- #IceBtn_BackColor, Color or #PB_Default<br/>
&emsp;Button background color, #PB_Default To get window color
- #IceBtn_DisableColor, Color or #PB_Default<br/>
&emsp;Disable Button color, #PB_Default To obtain the color by applying a deactivated filter To the button color
- #IceBtn_FrontColor, Color or #PB_Default<br/>
&emsp;Button text color, #PB_Default = White or Black depending on whether the button color is dark or light
- #IceBtn_DisableFrontColor, Color or #PB_Default<br/>
&emsp;Disable text color, #PB_Default To obtain the color by applying a deactivated filter To the button text color
- #IceBtn_EnableShadow, 0 or 1 (#False or #True)<br/>
&emsp;Disable or Enable text shadow
- #IceBtn_ShadowColor, Color or #PB_Default<br/>
&emsp;Button text shadow color, #PB_Default = White or Black depending on whether the button text color is dark or light
- #IceBtn_BorderColor, Color or #PB_Default<br/>
&emsp;Button border color, #PB_Default for the Button color<br/>
- #IceBtn_RoundX, Size<br/>
&emsp;Sizefrom 1 To X. For RoundBox(), the radius of the rounded corners in the X direction
- #IceBtn_RoundY, Size<br/>
&emsp;Size from 1 To Y. For RoundBox(), the radius of the rounded corners in the Y direction

## __Public Functions:__ <br>
- SetIceButtonTheme(#Theme)<br/>
&emsp;Apply, Change Theme<br>
&emsp; - Ex: SetIceButtonTheme(#IceBtn_Theme_DarkBlue) or SetIceButtonTheme(#IceBtn_Theme_LightBlue) or custom future Theme<br>
- GetIceButtonTheme()<br/>
&emsp;Get the current theme<br>
- IsIceButton(#Gadget)<br/>
&emsp;Is it an IceButton?<br>
- FreeIceButtonTheme()<br/>
&emsp;Free the theme, IceButton and associated resources and return to the standard ButtonGadget<br>
- SetIceBtnThemeAttribute(#Attribut, Value)<br/>
&emsp;Changes a theme attribute value<br>
&emsp; - Ex: SetIceBtnThemeAttribute(#IceBtn_color, #Blue) to change the theme Button color attribute in blue<br>
- GetIceBtnThemeAttribute(#Attribut)<br/>
&emsp;Returns a theme Attribute value<br>
&emsp; - Ex: GetIceBtnThemeAttribute(#IceBtn_color)<br>
- SetIceButtonAttribute(#Gadget, #Attribut, Value)<br/>
&emsp;Changes an IceButton attribute value<br>
&emsp; - Ex: SetIceButtonAttribute(#Gadget, #IceBtn_color, #Blue) to change the IceButton color in blue<br>
- GetIceButtonAttribute(#Gadget, #Attribut)<br/>
&emsp;Returns an IceButton attribute value<br>
&emsp; - Ex: GetIceButtonAttribute(#Gadget, #IceBtn_color)<br>

Enjoy :smile:
