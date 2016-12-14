Unit LevelManager;
Interface     
uses crt, BlockManager, GlobalVariables, EntityManager;

  Procedure SetupLevel(x, y, w, h : integer);   
  Procedure Render(x, y, tc, bc : Integer; simbol : char);
  Procedure RenderFullLevel();      
  Procedure RenderParcialLevel(xF, yF, xS, yS : Integer);
  Procedure startLevel();
  Procedure addQuad(xF, yF, xS, yS, tc, bc : integer);   
  Procedure addRoom(xF, yF, xS, yS, tc, bc, dx, dy, ds :integer);
  Procedure addDoor(x, y, ds :integer);
  Procedure addWall(xWall, yWall, xWallSize, yWallSize, tc, bc :integer; s, o : char);

  Procedure setBlock(ID, tc, bc : Integer; n : String;  s : char; isCollidable : boolean);

  Procedure renderEntities();
  Procedure setFinishPoint(x, y, l : integer);  
  Procedure ClearArtEntities;             

  Procedure LoadDataFile;  
  Procedure SaveDataFile;

Implementation

  Procedure setBlock(ID, tc, bc : Integer; n : String;  s : char; isCollidable : boolean);
  Begin
    setLibBlock(ID, tc, bc, n, s, isCollidable);
  End;

  Procedure SetupLevel(x, y, w, h : integer);
  var xx,yy : integer;
  Begin
       screen.x := x;
       screen.y := y;
       screen.width := w;
       screen.height := h;

       for yy := 0 to screen.height do
       Begin
         for xx := 0 to screen.width do
         Begin
              setBlockAt(xx, yy, 0);
         End;
       End;
       addQuad(0, 0, (screen.width - 1), screen.height, 3, 0);
       ClearArtEntities;
  End;

  Procedure Render(x, y, tc, bc : Integer; simbol : char);
  Begin
    if (screen.width > 0) Then
    Begin
      GotoXY(screen.x + x, screen.y + y);
      TextBackground(bc);
      TextColor(tc);
      write(simbol);     
      TextBackground(0);
      TextColor(10);
      GotoXY(2, screen.y + screen.height + 1);
    End;
  End;

  Procedure RenderFullLevel();
  var x, y : Integer;
  Begin   
    for y := 0 to screen.height do
    Begin
      for x := 0 to (screen.width - 1) do
      Begin
        Render(x, y, getBlockTColor(x, y), getBlockBColor(x, y), getBlockSimbol(x, y));
      End;
    End;
  End;  
                        
  Procedure renderEntities();
  var i : integer;
  Begin
    for i := 0 to 100 do
    Begin
      if (Length(entities[i].Name) > 0) then
      Begin
        With entities[i] do
        Begin
          if (Visible) then Render(x, y, tColor, bColor, Simbol);
        End;
      End;
    End;
  End;

  Procedure RenderParcialLevel(xF, yF, xS, yS : Integer);
  var x, y : Integer;
  Begin
    if (yF < screen.y) then yF := screen.y
    else if (yF > screen.height) then yF := screen.height
    else if (xF < screen.x) then xF := screen.x
    else if (xF > screen.width) then xF := screen.width;

    for y := yF to yS do
    Begin
      for x := xF to xS do
      Begin
        Render(x, y, getBlockTColor(x,y), getBlockBColor(x,y), getBlockSimbol(x,y));
      End;
    End;
  End;
      
  Procedure addQuad(xF, yF, xS, yS, tc, bc : integer);
  Begin                                          
    addWall(xF, yF + yS, xS, 0, tc, bc, '|', '_'); 
    addWall(xF, yF + 1, 0, yS - 1, tc, bc, '|', '_');
    addWall(xF + xS, yF + 1, 0, yS - 1, tc, bc, '|', '_');
    addWall(xF + 1, yF, xS - 2, 0, tc, bc, '|', '_');
  End;          
      
  Procedure addDoor(x, y, ds :integer);
  var door1, door2 : blockType;
  Begin
    door1 := getBlockAt(x, y);
    door2 := getBlockAt(x, y + 1);
    if (door2.name = 'TempWall') then
    Begin
      door1.tColor := 14;
      door1.name := 'MDoor';
      door2.tColor := 14;   
      door2.name := 'SDoor';
      With door1.door do
      Begin
        xt := x;
        yt := y - 1;
        opened := false;
      End;
      With door2.door do
      Begin
        xt := x;
        yt := y + 2;  
        opened := false;
      End;
      setBlockTempAt(x, y, door1);
      setBlockTempAt(x, y + 1, door2);
    End
    Else
    Begin 
      door2 := getBlockAt(x + 1, y);
      door1.tColor := 14;
      door1.name := 'MDoor';
      door2.tColor := 14;   
      door2.name := 'SDoor';
      With door1.door do
      Begin
        xt := x - 1;
        yt := y;     
        opened := false;
      End;
      With door2.door do
      Begin
        xt := x + 2;
        yt := y;   
        opened := false;
      End;
      setBlockTempAt(x, y, door1);
      setBlockTempAt(x + 1, y, door2);
    End;
  End;

  Procedure addRoom(xF, yF, xS, yS, tc, bc, dx, dy, ds :integer);
  Begin                       
    addQuad(xF, yF, xS, yS, tc, bc);
    addDoor(dx, dy, ds);
  End;        

  Procedure addWall(xWall, yWall, xWallSize, yWallSize, tc, bc :integer; s, o : char);
  var ix,iy:integer; tempblocks, tempblockt : blockType;
  Begin                           
    tempblocks.tColor := tc;
    tempblockt.tColor := tc;
    tempblocks.bColor := bc;
    tempblockt.bColor := bc;
    tempblocks.Name := 'TempWall';
    tempblockt.Name := 'TempWall';
    tempblocks.Simbol := s;
    tempblockt.Simbol := o;
    tempblocks.collidable := true;
    tempblockt.collidable := true;
    for iy:=0 to yWallSize do
    begin
      for ix:=0 to xWallSize do
      begin
        if (xWallSize > 0) then setBlockTempAt(xWall + ix, yWall + iy, tempblockt)
        else setBlockTempAt(xWall + ix, yWall + iy, tempblocks);
      end;
    end;
  end; 
            
  Procedure setFinishPoint(x, y, l : integer);
  Begin              
    setBlockAt(x, y, 4);
    setBlockAction(x, y, 0, 0, l);
  End;

  Procedure ClearArtEntities;
  var i : integer;
  Begin
    for i := 0 to 100 do
    Begin
      if (not entities[i].isPlayer) then entities[i].Name := '';
    End;
  End;

  Procedure LoadDataFile;
  Begin
       Assign(PlayerDataFile, 'SavedInfo.dat' );  
       Reset(PlayerDataFile);
       While Not eof (PlayerDataFile) do
       Begin
            Read(PlayerDataFile, PlayerData);
       end;   
       Close(PlayerDataFile);
       Loading := true;
       // startLevel;
       changedLevel := true;
  End;

  Procedure SaveDataFile;
  Begin
       Assign (PlayerDataFile, 'SavedInfo.dat' );
       Rewrite (PlayerDataFile);
       PlayerData.level := currentLevel;
       PlayerData.entities := entities;
       Write(PlayerDataFile, PlayerData);
       Close(PlayerDataFile);
  End;

  Procedure startLevel();
  Begin
    if (Loading) then currentLevel := PlayerData.level;
    Case currentLevel of
      1 : Begin
        // Let's define the windows specs and send the screen data to the LevelManager Unit.
        // Vamos defenir os tamanhos da janela e informar a unit LevelManager das informacoes do ecra.
        SetupLevel(2, 2, 78, 20);

        setAllPlayersPos(3, 3);
        setFinishPoint(73, 19, currentLevel + 1);
          
        setBlockAt(5, 6, 3);
        setBlockAt(5, 7, 3);
        setBlockAt(5, 8, 3);
        setBlockAt(5, 9, 3);
        setBlockAt(5, 10, 3);
        setBlockAt(5, 11, 3);
        setBlockAt(5, 12, 3);
        setBlockAt(5, 13, 3);
        setBlockAt(5, 14, 3);
        setBlockAt(5, 15, 3);
        setBlockAt(5, 16, 3);
        setBlockAt(5, 17, 3);
        setBlockAt(5, 18, 3);

        addWall(12, 2, 0, 17, 4, 0, '|', '_');

        addRoom(0, 0, 5, 5, 4, 0, 2, 5, 2);
        addRoom(69, 10, 8, 10, 2, 0, 69, 12, 2);

        
        addEntity(0, 20, 15);
      End;
      2 : Begin
        // Let's define the windows specs and send the screen data to the LevelManager Unit.
        // Vamos defenir os tamanhos da janela e informar a unit LevelManager das informacoes do ecra.
        SetupLevel(2, 2, 78, 20);

        setAllPlayersPos(3, 3);
        setFinishPoint(73, 19, currentLevel + 1);
          
        addRoom(0, 0, 5, 5, 4, 0, 2, 5, 2);
        addRoom(69, 10, 8, 10, 2, 0, 69, 12, 2);
         
        addEntity(0, 20, 15);
      End;
      Else
      Begin
        SetupLevel(2, 2, 78, 20);   
        setAllPlayersPos(3, 3);
      End;
    End;  
    if (Loading) then
    Begin
      entities := PlayerData.entities;
      Loading := false;
    End;
  End;

End.
