unit EntityManager;
interface
Uses crt, GlobalVariables, BlockManager;

  Procedure setPlayer(ID, keyID, entID, x, y, color : integer; name : String);
  Procedure setKeyActions(ID, l, r, top, bot : integer);
  Procedure setEntity(ID, dam, life: integer);    
  Procedure setFullEntity(ID, EntType, bColor, tColor : Integer; Simbol : Char; Name : String); 
  Procedure addEntity(fullID, x, y : integer);
  Procedure movePlayer(ID, mX, mY : integer);
  Procedure updateEntities;
  Procedure ClearPath(x, y : Integer);
  Procedure setEntityPos(ID, x, y : Integer);     
  Procedure setAllPlayersPos(x, y : integer);
  Function findKeyOwner(k : integer) : Integer;
  Function collide(x, y, mx, my : integer) : boolean;  
  Procedure searchArea(x, y : integer);    
  Procedure checkOpenDoor(x, y, ix, iy : integer);
  Procedure checkCloseDoor(x, y, ix, iy : integer);
  Function PlayerDistance(ix, iy, tx, ty : integer) : integer; 
  Function getPlayerStatus() : String;         
  Function getKeyActions(ID : integer; what : char) : integer;
  Procedure reAssign;                                  
  Function findFreeID : Integer;    
  Procedure moveEntity(ID, mX, mY : integer);
  Procedure removeEntity(ID : integer);

implementation
        
  Procedure updateEntities; 
  var i : integer;
  Begin
    for i := 0 to 100 do
    Begin
      if (Length(entities[i].Name) > 0) then
      Begin
        With entities[i] do
        Begin
          if (Updatable AND not isPlayer) then
          Begin     
            entities[i].Updates := entities[i].Updates + 1;
            if (entities[i].Updates = 2000) then
            Begin
              if (entities[i].EntType.life = 0) then removeEntity(i)
              Else
              Begin
                entities[i].Updates := 0;
                moveEntity(i, 1 , -1);
              End;
            End;
          End;
        End;
      End;
    End;
  End;  

  Procedure moveEntity(ID, mX, mY : integer);
  Begin
    With entities[ID] do
    Begin
      if not collide(x, y, mX, mY) then
      Begin
        ClearPath(x, y);
        x := x + mX;
        y := y + mY;
      End;
    End;
  End;
  
  Procedure reAssign;
  var i : integer;
  Begin
    for i := 0 to (NPlayers - 1) do
    Begin
      entities[i].KeyAction := Keys[entities[i].KeyAction.ID];
    End;
  End;

  Procedure setEntityPos(ID, x, y : Integer);
  Begin
    entities[ID].x := x;
    entities[ID].y := y;
  End;

  Procedure ClearPath(x, y : Integer);
  Begin  
      GotoXY(screen.x + x, screen.y + y);
      TextBackground(getBlockBColor(x, y));
      TextColor(getBlockTColor(x, y));
      if ((getBlockName(x, y) <> 'MDoor') AND (getBlockName(x, y) <> 'SDoor')) then write(getBlockSimbol(x, y))
      else write(' ');
      TextBackground(0);
      TextColor(10);
      GotoXY(2, screen.y + screen.height + 1);
  End;

  Procedure setPlayer(ID, keyID, entID, x, y, color : integer; name : String);
  var ent : Entity;
  Begin
    ent.Name := name;
    ent.EntType := EntityTypes[entID];
    ent.KeyAction := Keys[keyID];
    ent.bColor := color;
    ent.tColor := 0;
    ent.x := x;
    ent.y := y;
    ent.Simbol := ' ';
    ent.Visible := true;
    ent.Updatable := true;
    ent.isPlayer := true;
    ent.Updates := 0;

    entities[ID] := ent;
  End;           

  Procedure setFullEntity(ID, EntType, bColor, tColor : Integer; Simbol : Char; Name : String);
  var ent : EntityFullType;
  Begin
    ent.ID := ID;
    ent.Name := Name;
    ent.EntType := EntityTypes[EntType];
    ent.bColor := bColor;
    ent.tColor := tColor;
    ent.Simbol := Simbol;

    EntityFullTypes[ID] := ent;
  End;

  Procedure addEntity(fullID, x, y : integer);
  var ent, id : Entity;
  Begin
    With EntityFullTypes[fullID] do
    Begin
      ent.Name := Name;
      ent.EntType := EntType;
      ent.bColor := bColor;
      ent.tColor := tColor;
      ent.x := x;
      ent.y := y;
      ent.Simbol := Simbol;
      ent.Visible := true;
      ent.Updatable := true;
      ent.isPlayer := false;   
      ent.Updates := 0;

      id := findFreeID;
      if (id <> 999) then entities[id] := ent;
    End;
  End;
   
  Function findFreeID : Integer;
  var i, output : integer;
  Begin
    output := 999;
    for i := 0 to 100 do
    Begin
      if ((length(entities[i].Name) <= 0) AND (output = 999)) then output := i;
    End;
    findFreeID := output;
  End;

  Procedure movePlayer(ID, mX, mY : integer);
  Begin
    With entities[ID] do
    Begin
      if ((not collide(x, y, mX, mY)) AND Updatable) then
      Begin
        ClearPath(x, y);
        x := x + mX;
        y := y + mY;
      End;
      With getBlockAt(x, y).action do
      Begin
        if (useAction) then
        Begin
          if (level = currentLevel) then setEntityPos(ID, x, y)
          else
          Begin
            currentLevel := level;
            changedLevel := true;
          End;
        End;
      End;
      searchArea(x, y);
    End;
  End;
   
  Function PlayerDistance(ix, iy, tx, ty : integer) : integer;
  var a, b : integer;
  Begin
    if (ix > tx) then a := ix - tx
    else a := tx - ix;
    if (iy > ty) then b := iy - ty
    else b := ty - iy;
    PlayerDistance := Abs(a + b);
  end;

  Procedure searchArea(x, y : integer);
  var iy, ix : integer;
  Begin      
    for iy:=-2 to 2 do
    begin
      for ix:=-2 to 3 do
      begin
        checkOpenDoor(x, y, ix, iy);
      End;
    End;   
    for iy:=-3 to 3 do
    begin
      for ix:=-3 to 4 do
      begin
        checkCloseDoor(x, y, ix, iy);
      End;
    End;
  End;

  Procedure checkOpenDoor(x, y, ix, iy : integer);
  var checkedBlock : blockType;
  Begin
    checkedBlock := getBlockAt(x + ix, y + iy);
    if ((checkedBlock.name = 'MDoor') AND (checkedBlock.door.opened = false)) then
    Begin
      if (PlayerDistance(x, y, x + ix, y + iy) <= 2) then
      Begin
        openDoor(x + ix, y + iy);
      End;
    End;
  End;   

  Procedure checkCloseDoor(x, y, ix, iy : integer);
  var checkedBlock : blockType;
  Begin
    checkedBlock := getBlockAt(x + ix, y + iy);
    if ((checkedBlock.name = 'MDoor') AND (checkedBlock.door.opened = true)) then
    Begin   
      if (PlayerDistance(x, y, x + ix, y + iy) >= 3) then
      Begin
        closeDoor(x + ix, y + iy);
      End;
    End;
  End;   
   
  Procedure setKeyActions(ID, l, r, top, bot : integer);
  var key : KeyboardActions;
  Begin
    key.ID := ID; 
    key.left := l;
    key.right := r;
    key.up := top;
    key.down := bot;

    Keys[ID] := key;
  End;  
   
  Function getKeyActions(ID : integer; what : char) : integer;
  Begin
    if (what = 'l') then getKeyActions := Keys[ID].left
    else if (what = 'r') then getKeyActions := Keys[ID].right
    else if (what = 'u') then getKeyActions := Keys[ID].up
    else if (what = 'd') then getKeyActions := Keys[ID].down;
  End;

  Procedure setEntity(ID, dam, life: integer); 
  var ent : EntityType;
  Begin
    ent.ID := ID;
    ent.Damage := dam;
    ent.Life := life;

    EntityTypes[ID] := ent;
  End;

  Function findKeyOwner(k : integer) : Integer;
  var i, output : integer;
  Begin
    output := 9999;
    for i := 0 to 100 do
    Begin
      if (Length(entities[i].Name) > 0) then
      Begin
        With entities[i].KeyAction do
        Begin
          if (k = up) then output := i
          else if (k = right) then output := i
          else if (k = left) then output := i
          else if (k = down) then output := i;
        End;
      End;
    End;
    findKeyOwner := output;
  End;

  Function collide(x, y, mx, my : integer) : boolean;
  var return : boolean;
  Begin
    return := false;
    if (isBlockCollidable(x + mx, y + my)) then return := true;
    collide := return;
  End;
  
  Procedure setAllPlayersPos(x, y : integer);
  var i : integer;
  Begin
    for i := 0 to 100 do
    Begin
      if (Length(entities[i].Name) > 0) then
      Begin
        setEntityPos(i, x, y);
      End;
    End;
  End;     

  Function getPlayerStatus() : String;
  var i, w : integer; output, temp : String;
  Begin       
    Str(currentLevel, output);
    if (ShowLevel) then
    Begin
      output := 'Level ' + output;
      if (ShowEachPlayerLife OR ShowEachPlayerName) then output := output + ': ';
    End
    else output := '';
    w := 999;
    for i := 0 to 100 do
    Begin
      if (entities[i].isPlayer) then
      Begin
        With entities[i] do
        Begin
          temp := '';
          Str(EntType.Life, temp);
          if (w = 999) then
          Begin
            w := 0;
            // output := output + name + ' - Lifes: ' + temp + '';
            if (ShowEachPlayerName) then output := output + name;  
            if (ShowEachPlayerLife AND ShowEachPlayerName) then output := output + ' - ';
            if (ShowEachPlayerLife) then output := output + 'Lifes: ' + temp + '';
          End
          Else
          Begin  
            if (ShowEachPlayerLife OR ShowEachPlayerName) then output := output + ' ' + SeperatorCharacter + ' ';
            if (ShowEachPlayerName) then output := output + name;  
            if (ShowEachPlayerLife AND ShowEachPlayerName) then output := output + ' - ';
            if (ShowEachPlayerLife) then output := output + 'Lifes: ' + temp + '';
          End;
          if (w = 2) then
          Begin
            w := 0;  
            output := output + ''#13#10;
          End
          Else w := w + 1;
        End;
      End;
    End;
    getPlayerStatus := output;
  End;
  
  Procedure removeEntity(ID : integer);
  Begin
    ClearPath(entities[ID].x, entities[ID].y);
    entities[ID].Name := '';
    entities[ID].bColor := 0;
    entities[ID].tColor := 0;
    entities[ID].x := 0;
    entities[ID].y := 0;
    entities[ID].Simbol := ' ';
    entities[ID].Visible := false;
    entities[ID].Updatable := false;
    entities[ID].Updates := 0;
    entities[ID].isPlayer := false;
  End;

end.
