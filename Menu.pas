// This is the unit responsible for all the Menus.
// Esta unit é responsavel por todos os menus.
unit Menu;
interface
Uses crt, GlobalVariables, BlockManager, EntityManager, Keyboard, MapCreator, LevelManager;
var keyer : integer;

  Procedure SetupMenu;  
  Procedure OpenMenu(ID : integer);  
  Procedure CloseMenu(ID : integer);
  Procedure MenuKey(k : integer);
  Procedure MenuAction;   
  Procedure ClearMenu;  
  Procedure RenderMenu;       
  Procedure MenuWrite(writeline:string);
  Procedure MenuSelected; 
  Procedure MenuClick(ID : integer);
  Procedure Switch(ID, i : integer);    
  Procedure changeKey(ID, changedKey, keyToChange : integer);

implementation

  // This creates the menus.
  // Aqui os menus são creados.
  Procedure SetupMenu;
  Begin
    With MainMenu do
    Begin
      x := 30;
      y := 10;
      opened := false;
      over := 0;
      noptions := 5;

      options[0].ID := 0;
      options[0].text := ' Resume Game ';  
      options[1].ID := 1;
      options[1].text := ' New Game    ';
      options[2].ID := 2;
      options[2].text := ' Save Game   ';
      options[3].ID := 4;
      options[3].text := ' Load Game   ';
      options[4].ID := 4;
      options[4].text := ' Settings    ';
      options[5].ID := 5;
      options[5].text := ' Quit Game   ';
    End;
    With GameMenu do
    Begin
      x := 30;
      y := 10;
      opened := true;
      over := 0;    
      noptions := 3;
      foptions := 0;

      options[0].ID := 0;
      options[0].text := ' New Game    ';
      options[1].ID := 1;
      options[1].text := ' Load Game   ';   
      options[2].ID := 2;
      options[2].text := ' Map Creator ';
      options[3].ID := 3;
      options[3].text := ' Quit Game   ';
    End;
    With NewGame do
    Begin
      x := 30;
      y := 10;
      opened := false;
      over := 1;
      noptions := KeyActionsAmount;
      foptions := 1;

      options[0].ID := 0;
      options[0].text := ' Number of Players ';
      options[1].ID := 1;                    
      options[1].text := '        1          ';
      options[2].ID := 2;
      options[2].text := '        2          ';
      options[3].ID := 3;                    
      options[3].text := '        3          ';
      options[4].ID := 4;
      options[4].text := '        4          ';
      options[5].ID := 5;
      options[5].text := '        5          ';
    End;
    With KeyboardSettings do
    Begin
      x := 30;
      y := 10;
      opened := false;
      over := 4;
      noptions := 3;
      foptions := 0;
    End;
  End;   

  // This opens or closes Menus.
  // Aqui os menus sao abertos ou fechados.
  Procedure MenuAction;
  Begin
    if ((not GameMenu.opened) AND (not NewGame.opened) AND (not KeyboardSettings.opened)) then
    Begin
      if (MainMenu.opened) then CloseMenu(1)
      Else OpenMenu(1);
    End;
  End;

  // This is what processes the menu opening.
  // Isto é o que processa o abrir dos menus.
  Procedure OpenMenu(ID : integer);
  Begin
    if (ID = 0) then
    Begin
      GameMenu.over := 0;
      GameMenu.opened := true;
      RenderMenu;
    End
    Else if (ID = 1) then
    Begin
      MainMenu.over := 0;
      MainMenu.opened := true;
      RenderMenu;
    End
    Else if (ID = 2) then
    Begin
      NewGame.over := 1;
      NewGame.opened := true;
      RenderMenu;
    End
    Else if (ID = 3) then
    Begin
      KeyboardSettings.over := 4;
      KeyboardSettings.opened := true;
      RenderMenu;
      keyer := 0;
    End;
  End;

  // This is what processed the closing of the menus.
  // Isto é o que processa o fechar dos menus.
  Procedure CloseMenu(ID : integer);
  Begin     
    if (ID = 0) then
    Begin
      GameMenu.over := 0;
      GameMenu.opened := false;
      ClearMenu;
    End   
    Else if (ID = 1) then
    Begin
      MainMenu.over := 0;
      MainMenu.opened := false;
      ClearMenu;
    End  
    Else if (ID = 2) then
    Begin
      NewGame.over := 1;
      NewGame.opened := false;
      ClearMenu;
    End
    Else if (ID = 3) then
    Begin   
      keyer := 0;
      KeyboardSettings.over := 4;
      KeyboardSettings.opened := false;
      ClearMenu;
    End;
  End;

  // This Procedure is what makes us able to navigate between the menu options.
  // Este procedimento é o que nos permite navegar pelas varias opcoes do menu.
  Procedure Switch(ID, i : integer);
  Begin
    if (ID = 0) then GameMenu.over := GameMenu.over + i
    else if (ID = 1) then MainMenu.over := MainMenu.over + i
    else if (ID = 2) then NewGame.over := NewGame.over + i
    else if (ID = 3) then KeyboardSettings.over := KeyboardSettings.over + i
    else if (ID = 999) then keyer := keyer + i;
    RenderMenu;
  End;

  // This detects what to do for each menu when a key is pressed.
  // Aqui deecta o que fazer para cada menu quando uma tecla é primida.
  Procedure MenuKey(k : integer);
  Begin
    if (MainMenu.opened) then
    Begin
      if ((k = 33619745) and (MainMenu.over > MainMenu.foptions)) then Switch(1, -1)
      else if ((k = 33619751) and (MainMenu.over < MainMenu.noptions)) then Switch(1, 1)
      else if (k = 7181) then MenuClick(0);
    End
    Else if (GameMenu.opened) then
    Begin
      if ((k = 33619745) and (GameMenu.over > MainMenu.foptions)) then Switch(0, -1)
      else if ((k = 33619751) and (GameMenu.over < GameMenu.noptions)) then Switch(0, 1)
      else if (k = 7181) then MenuClick(1);
    End
    Else if (NewGame.opened) then
    Begin
      if ((k = 33619745) and (NewGame.over > NewGame.foptions)) then Switch(2, -1)
      else if ((k = 33619751) and (NewGame.over < NewGame.noptions)) then Switch(2, 1)
      else if (k = 7181) then MenuClick(2);
    End
    Else if (KeyboardSettings.opened) then
    Begin
      if ((k = 33619745) and (KeyboardSettings.over > KeyboardSettings.foptions) and (not special)) then Switch(3, -1)
      else if ((k = 33619751) and (KeyboardSettings.over < (KeyboardSettings.noptions + 1)) and (not special)) then Switch(3, 1)
      else if ((k = 33619747) and (keyer > 0) and (not special)) then Switch(999, -1)
      else if ((k = 33619749) and (keyer < (NPlayers - 1)) and (not special)) then Switch(999, 1)
      else if (k = 7181) then MenuClick(3)
      else if (k = 283) then
      Begin
        special := false;
        Clrscr;
        RenderMenu;
      End
      Else if (special) then changeKey(keyer, k, KeyboardSettings.over);
    End;
  End;         

  // This changes the colors if the menu is selected.
  // Aqui as cores sao alteradas se o menu estiver aberto.
  Procedure MenuSelected;
  Begin
    TextBackground(LightGray);
    TextColor(Black);
  end;

  // This writes the menu text using the right colors.
  // Aqui é escrito o texto dos menus usando as cores certas.
  Procedure MenuWrite(writeline:string);
  Begin
    Writeln(writeline);
    TextBackground(0);
    TextColor(10);
  end;

  // This renders the menus.
  // Aqui os menus sao renderizados.
  Procedure RenderMenu;
  var i : integer; tep : String;
  Begin
    if (MainMenu.opened) then
    Begin
      for i := 0 to MainMenu.noptions do
      Begin
        GotoXY(MainMenu.x, MainMenu.y + i);
        if (MainMenu.over = i) then MenuSelected;
        TextColor(red);
        MenuWrite(MainMenu.options[i].text);
      End;
    End
    else if (GameMenu.opened) then
    Begin
      for i := 0 to GameMenu.noptions do
      Begin
        GotoXY(GameMenu.x, GameMenu.y + i);
        if (GameMenu.over = i) then MenuSelected;
        TextColor(red);
        MenuWrite(GameMenu.options[i].text);
      End;
    End
    Else if (NewGame.opened) then
    Begin
      for i := 0 to NewGame.noptions do
      Begin
        GotoXY(NewGame.x, NewGame.y + i);
        if (NewGame.over = i) then MenuSelected;
        TextColor(red);
        MenuWrite(NewGame.options[i].text);
      End;
    End
    Else if (KeyboardSettings.opened) then
    Begin
      for i := 0 to (NPlayers - 1) do
      Begin                 
        GotoXY(35, 2);
        Writeln('Key Settings');
        GotoXY(2 + (i * 16), 5);
        Str(i + 1, tep);
        Write('Player ', tep, ' Keys');    
        GotoXY(2 + (i * 16), 6);        
        if ((KeyboardSettings.over = 0) AND (keyer = i)) then MenuSelected;
        TextColor(red);
        MenuWrite('Up: ' + KeyEventToString(getKeyActions(i, 'u')));
        GotoXY(2 + (i * 16), 7);
        if ((KeyboardSettings.over = 1) AND (keyer = i)) then MenuSelected;
        TextColor(red);
        MenuWrite('Down: ' + KeyEventToString(getKeyActions(i, 'd')));
        GotoXY(2 + (i * 16), 8);
        if ((KeyboardSettings.over = 2) AND (keyer = i)) then MenuSelected;
        TextColor(red);
        MenuWrite('Left: ' + KeyEventToString(getKeyActions(i, 'l')));
        GotoXY(2 + (i * 16), 9);
        if ((KeyboardSettings.over = 3) AND (keyer = i)) then MenuSelected;
        TextColor(red);
        MenuWrite('Right: ' + KeyEventToString(getKeyActions(i, 'r')));  
        GotoXY(38, 12);
        if (KeyboardSettings.over = 4) then MenuSelected;
        TextColor(red);
        MenuWrite(' Done ');
      End;
      if (special) then
      Begin
        GotoXY(25, 10);
        Write('*/---------------------------\*');  
        GotoXY(25, 11);
        Write('*|      Press a key or       |*');
        GotoXY(25, 12);
        Write('*|       ESC to cancel       |*');
        GotoXY(25, 13);
        Write('*\---------------------------/*');
      End;
    End;
  End;

  // This clears the menus.
  // Aqui os menus sao apagados.
  Procedure ClearMenu;
  var ix, iy : integer;
  Begin
    for iy := MainMenu.y - 10 to MainMenu.y + 10 do
    Begin
      for ix := MainMenu.x - 10 to MainMenu.x + 10 do
      Begin  
        GotoXY(screen.x + ix, screen.y + iy);
        TextBackground(getBlockBColor(ix, iy));
        TextColor(getBlockTColor(ix, iy));
        write(getBlockSimbol(ix, iy));
        TextBackground(0);
        TextColor(10);
        GotoXY(2, screen.y + screen.height + 1);
      End;
    End;
  End;         

  // This is what reacts when the keys are changed on the Keyboard settings.
  // Isto é o que reage ao trocar de teclas no menu Keyboard Settings.
  Procedure changeKey(ID, changedKey, keyToChange : integer);
  Begin
    if (keyToChange = 0) then setKeyActions(ID, getKeyActions(ID, 'l'), getKeyActions(ID, 'r'), changedKey, getKeyActions(ID, 'd'))
    else if (keyToChange = 1) then setKeyActions(ID, getKeyActions(ID, 'l'), getKeyActions(ID, 'r'), getKeyActions(ID, 'u'), changedKey)
    else if (keyToChange = 2) then setKeyActions(ID, changedKey, getKeyActions(ID, 'r'), getKeyActions(ID, 'u'), getKeyActions(ID, 'd'))
    else if (keyToChange = 3) then setKeyActions(ID, getKeyActions(ID, 'l'), changedKey, getKeyActions(ID, 'u'), getKeyActions(ID, 'd'));
    special := false;
    Clrscr;
    RenderMenu;
  End;

  // This is called if you press an option.
  // Este procedimento é chamado quando uma opcao é selecionada.
  Procedure MenuClick(ID : integer);
  Begin
    if (ID = 0) then
    Begin
      Case MainMenu.over of
        0 : Begin
          MenuAction;
        End;
        1 : Begin
          CloseMenu(1);
          Clrscr;
          OpenMenu(2);
          gameReady := false; 
          CREATE := false;
        End;
        2 : Begin
          SaveDataFile; 
          CloseMenu(1);
        End;
        3 : Begin
          LoadDataFile;  
          CloseMenu(1);
        End;
        4 : Begin
          CloseMenu(1);
          Clrscr;
          OpenMenu(3);     
          RenderMenu;
        End;
        5 : Begin
          running := false;
        End;
      End;
    End
    Else if (ID = 1) then
    Begin
      Case GameMenu.over of
        0 : Begin
          CloseMenu(0);
          Clrscr;
          OpenMenu(2);
        End;
        1 : Begin
          CloseMenu(0);
          Clrscr;      
          LoadDataFile;  
          CloseMenu(1);
          changedLevel := true;
          MAPCHANGE := true;  
          gameReady := true;
        End; 
        2 : Begin 
          CloseMenu(0);
          Clrscr;
          StartMapCreator;
        End;
        3 : Begin
          running := false;
        End;
      End;
    End
    Else if (ID = 2) then
    Begin
      NPlayers := NewGame.options[NewGame.over].ID;
      CloseMenu(2);
      Clrscr;
      OpenMenu(3);
    End
    Else if (ID = 3) then
    Begin
      if (KeyboardSettings.over <> 4) then
      Begin
        special := true;
        RenderMenu;
      End
      Else
      Begin 
        if (not CREATE) then
        Begin
          CloseMenu(3);
          Clrscr;
          CREATE := true;    
          MAPCHANGE := true;
          needDisplay := true;
          changedLevel := true;
          currentLevel := 1;
        End
        Else
        Begin 
          CloseMenu(3);
          Clrscr;
          MAPCHANGE := true;
          needDisplay := true;
          reAssign;
        End;
      End;
    End;
  End;

end.
