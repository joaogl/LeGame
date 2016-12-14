unit MapCreator;

interface      
Uses crt, GlobalVariables, keyboard, sysutils, LevelManager, EntityManager;
var xPosition, yPosition, xoffset, yoffset, gw, gh, linesOfCode : integer;
    needRender : boolean;
    levelCode : Array[0..100] of String;
    insideEditor, selected : boolean;

  Procedure StartMapCreator;   
  Procedure keyHit(k : Integer);    
  Procedure renderEditor;      
  Procedure renderAtLoc(x, y, color: Integer);

implementation

  Procedure StartMapCreator;
  var Done, render : boolean; stage, k : integer; key, n1, n2 : String;
  Begin
    linesOfCode := 0;
    Done := false;
    render := true;
    stage := 1;
    n1 := '';
    n2 := '';
    insideEditor := true;
    selected := false;
    Repeat 
      if (render) then
      Begin
        Clrscr;
        inEditor := true;
        writeln('This is the map creator.');
        writeln('Please add the first Map settings:');
        writeln('Map width: ', n1);
        if (stage = 1) then render := false;
      end;
      if (stage = 2) then
      begin 
        if (render) then
        Begin
          writeln('Map height: ', n2);
          render := false;
        end;
      End;
      k := PollKeyEvent;
      if (k <> 0) then
      Begin
        k := GetKeyEvent;
        k := TranslateKeyEvent(K);
        key := KeyEventToString(K);
        if (k <> 7181) then
        Begin
          Try
            if (stage = 1) then n1 := n1 + IntToStr(StrToInt(key))
            else n2 := n2 + IntToStr(StrToInt(key));
            render := true;
          except
            On E : EConvertError do
          end;
        End
        Else
        Begin
          if (stage = 1) then
          Begin
            if (StrToInt(n1) <= 78) then stage := 2
            else n1 := '';
            render := true;
          End
          Else
          Begin
            if (StrToInt(n2) <= 20) then done := true
            else n2 := '';
            render := true;
          End;
        End;
      End;
    Until done;
    Clrscr;

    needRender := true;
    xPosition := 5;
    yPosition := 5;
    SetupLevel(2, 2, StrToInt(n1), StrToInt(n2));
    xOffset := 2;
    yOffset := 2;
    // addCode('SetupLevel(2, 2, ', StrToInt(n1), ', ', StrToInt(n2)')');
    RenderFullLevel;
  End;     

  Procedure keyHit(k : Integer);
  Begin      
    renderAtLoc(xoffset + xPosition, yoffset + yPosition, 0);
    if (k = 283) then     // Esc
    Begin
      if (insideEditor) then insideEditor := false
      else insideEditor := true;
    End
    Else if (k = 7181) then     // Enter
    Begin  
      if (selected) then selected := false
      else selected := true;
    End
    else if ((k = 33619747) AND (insideEditor) AND (xPosition >= 0) AND (not collide(xPosition, yPosition,  - 1, 0))) then xPosition := xPosition - 1
    else if ((k = 33619749) AND (insideEditor) AND (xPosition >= 0) AND (not collide(xPosition, yPosition,  + 1, 0))) then xPosition := xPosition + 1
    else if ((k = 33619745) AND (insideEditor) AND (xPosition >= 0) AND (not collide(xPosition, yPosition, 0, - 1))) then yPosition := yPosition - 1
    else if ((k = 33619751) AND (insideEditor) AND (xPosition >= 0) AND (not collide(xPosition, yPosition, 0, + 1))) then yPosition := yPosition + 1;
    needRender := true;
  End;    

  Procedure renderEditor;
  Begin
    if (needRender) then
    Begin
      if (selected) then renderAtLoc(xoffset + xPosition, yoffset + yPosition, 4)
      else renderAtLoc(xoffset + xPosition, yoffset + yPosition, 2);
      needRender := false;
    End;
  End;    

  Procedure renderAtLoc(x, y, color: Integer);
  Begin
    GotoXY(x, y);
    TextBackground(color);
    write(' ');
    TextBackground(0);
    GotoXY(0, 0);
  End;  

  Procedure addCode(line : String);
  Begin
    levelCode[linesOfCode] := line;
    linesOfCode := linesOfCode + 1;
  End;

end.
