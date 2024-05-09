#Requires AutoHotkey v2.0
ResizableGUI(ClosePrevious:=1,Data:='enter your text here',Title:='Resizable Gui',x:=0,y:=0,w:=900,h:=600,
Font:='Courier New',FontColor:='Blue',FontSize:='14',BGColor:='White')
{
    static EditWindow := 0

    static main := Gui('+Resize')

    if (ClosePrevious)
        main.destroy()

    main := Gui('+Resize',Title)

    main.backcolor:= BGColor
    main.OnEvent('Escape',(*) => main.destroy)
    main.OnEvent('Size',(GuiObj,MinMax,Width,Height) => main['Data'].Move(,,Width-30,Height-25))
    
    if (Font = "0")
        main.SetFont('s12 cBlue q5', 'Courier New')
    else
        main.SetFont('s' FontSize ' c' FontColor ' q5',Font)
    
    main.AddEdit('vData -Wrap  HScroll', Data).Opt('Background' BGColor)

    if (x = "0") and (y = "0")
        main.Show('w' w ' h' h)
    else
        main.Show('w' w ' h' h ' x' x ' y' y)
    return 
}