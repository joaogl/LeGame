// This unit is the manager to all block releated in the game.
// Esta unit gere tudo o que tem a ver com blocos no jogo.
unit BlockManager;
interface
// Uses GlobalVariables to have access to the global variables...
// Uses GlobalVaraibles para ter acesso ás variavels globais...
uses crt, GlobalVariables;  

  // This renders a specific block.
  // Aqui renderizamos um bloco especifico.
  Procedure Render(x, y, tc, bc : Integer; simbol : char);
  // Using this method you can add more blocks to the game.
  // There is a proxy for this method called setBlock on the LevelManager Unit.
  // Usando este procedimento podemos adicionar um novo bloco ao jogo.
  // Existe uma proxy para esta funcao presente na Unit LevelManager chamada setBlock.
  Procedure setLibBlock(IDs, tc, bc : Integer; n : String;  s : char; isCollidable : boolean);
  // This method adds a Temporary block to the map.
  // Esta funcao adiciona um bloco temporario ao mapa.
  Procedure setBlockTempAt(x, y : Integer; block : blockType);
  // This method adds a game block to the map.
  // Esta funcao adiciona um bloco ao mapa.
  Procedure setBlockAt(x, y, ID : Integer);
  // This method gets us the block at a certain location on the map.
  // Esta funcao retorna o bloco presente numa certa localizacao no mapa.
  Function getBlockAt(x, y : Integer) : blockType;
  // This method gets us the block text color at a certain location on the map.
  // Esta funcao retorna a cor do texto de um bloco presente numa certa localizacao no mapa.
  Function getBlockTColor(x, y : Integer): Integer;   
  // This method gets us the block background color at a certain location on the map.
  // Esta funcao retorna a cor de fundo de um bloco presente numa certa localizacao no mapa.
  Function getBlockBColor(x, y : Integer): Integer;      
  // This method gets us the block name at a certain location on the map.
  // Esta funcao retorna o nome de um bloco presente numa certa localizacao no mapa.
  Function getBlockName(x, y : Integer): String; 
  // This method gets us the block simbol at a certain location on the map.
  // Esta funcao retorna o simbolo de um bloco presente numa certa localizacao no mapa.
  Function getBlockSimbol(x, y : Integer): Char;      
  // This method tells us if the block is collidable
  // Esta funcao informa-nos se um bloco é colidivel.
  Function isBlockCollidable(x, y : Integer): boolean;
  // This procedures gives an action to a block, like teleporting and what so ever.
  // Este procedimento dá uma acao a um bloco como teleports e etc's.
  Procedure setBlockAction(x, y, tx, ty, tl : Integer);   
  // This procedure removes the action of a block.
  // Este procedimento remove a acao de um bloco.
  Procedure removeBlockAction(x, y : Integer);
  // This opens a door.
  // Aqui abrimos uma porta.
  Procedure openDoor(x, y : Integer);   
  // This fechamos a door.
  // Aqui fechamos uma porta.
  Procedure closeDoor(x, y : Integer);

implementation 
                          
  // This renders a specific block.
  // Aqui renderizamos um bloco especifico.
  Procedure Render(x, y, tc, bc : Integer; simbol : char);
  Begin
    GotoXY(screen.x + x, screen.y + y);
    TextBackground(bc);
    TextColor(tc);
    write(simbol);
    TextBackground(0);
    TextColor(10);
    GotoXY(2, screen.y + screen.height + 1);
  End;
        
  // Using this method you can add more blocks to the game.
  // There is a proxy for this method called setBlock on the LevelManager Unit.
  // Usando este procedimento podemos adicionar um novo bloco ao jogo.
  // Existe uma proxy para esta funcao presente na Unit LevelManager chamada setBlock.
  Procedure setLibBlock(IDs, tc, bc : Integer; n : String;  s : char; isCollidable : boolean);
  Begin
    With blocks[IDs] do
    Begin
         ID := IDs;
         tColor := tc;
         bColor := bc;
         collidable := isCollidable;
         Name := n;
         Simbol := s;
         action.useAction := false;
    End;
  End;   
       
  // This method adds a Temporary block to the map.
  // Esta funcao adiciona um bloco temporario ao mapa.  
  Procedure setBlockTempAt(x, y : Integer; block : blockType);
  Begin      
    worldBlocks[x + y * screen.width] := block;
  End;
                   
  // This method adds a game block to the map.
  // Esta funcao adiciona um bloco ao mapa.
  Procedure setBlockAt(x, y, ID : Integer);
  Begin      
    worldBlocks[x + y * screen.width] := blocks[ID];
  End;
                 
  // This method gets us the block at a certain location on the map.
  // Esta funcao retorna o bloco presente numa certa localizacao no mapa.
  Function getBlockAt(x, y : Integer) : blockType;
  Begin      
    getBlockAt := worldBlocks[x + y * screen.width];
  End; 
                         
  // This method gets us the block text color at a certain location on the map.
  // Esta funcao retorna a cor do texto de um bloco presente numa certa localizacao no mapa.
  Function getBlockTColor(x, y : Integer): Integer;
  Begin
    getBlockTColor := getBlockAt(x, y).tColor;
  End; 
                                           
  // This method gets us the block background color at a certain location on the map.
  // Esta funcao retorna a cor de fundo de um bloco presente numa certa localizacao no mapa.
  Function getBlockBColor(x, y : Integer): Integer;
  Begin
    getBlockBColor := getBlockAt(x, y).bColor;
  End;
                            
  // This method gets us the block name at a certain location on the map.
  // Esta funcao retorna o nome de um bloco presente numa certa localizacao no mapa.
  Function getBlockName(x, y : Integer): String;
  Begin
    getBlockName := getBlockAt(x, y).name;
  End;
          
  // This method gets us the block simbol at a certain location on the map.
  // Esta funcao retorna o simbolo de um bloco presente numa certa localizacao no mapa.
  Function getBlockSimbol(x, y : Integer): Char;
  Begin
    getBlockSimbol := getBlockAt(x, y).Simbol;
  End;
                                      
  // This method tells us if the block is collidable
  // Esta funcao informa-nos se um bloco é colidivel.
  Function isBlockCollidable(x, y : Integer): boolean;
  Begin
    isBlockCollidable := getBlockAt(x, y).collidable;
  End;

  // This procedures gives an action to a block, like teleporting and what so ever.
  // Este procedimento dá uma acao a um bloco como teleports e etc's.
  Procedure setBlockAction(x, y, tx, ty, tl : Integer);
  var temp : blocktype;
  Begin
    temp := getBlockAt(x, y);
    With temp.action do
    Begin
      x := tx;
      y := ty;
      level := tl;
      useAction := true;
    End;
    setBlockTempAt(x, y, temp);
  End;

  // This procedure removes the action of a block.
  // Este procedimento remove a acao de um bloco.
  Procedure removeBlockAction(x, y : Integer);
  Begin   
    With getBlockAt(x, y).action do            
    Begin
      useAction := false;
    End;
  End;

  // This opens a door.
  // Aqui abrimos uma porta.
  Procedure openDoor(x, y : Integer);   
  var door1, door2 : blockType;
  Begin                
    door1 := getBlockAt(x, y);    
    door2 := getBlockAt(x, y + 1);   
    if (door2.name = 'SDoor') then
    Begin 
      With door1 do
      Begin   
        Render(x, y, 0, 0, ' ');
        Render(door.xt, door.yt, tColor, bColor, simbol);
        door.opened := true;
        collidable := false;
      End;
      With door2 do
      Begin 
        Render(x, y + 1, 0, 0, ' '); 
        Render(door.xt, door.yt, tColor, bColor, simbol);  
        door.opened := true;    
        collidable := false;
      End;    
      setBlockTempAt(x, y, door1);
      setBlockTempAt(x, y + 1, door2);
    End
    Else
    Begin  
      door2 := getBlockAt(x + 1, y); 
      With door1 do
      Begin   
        Render(x, y, 0, 0, ' ');   
        Render(door.xt, door.yt, tColor, bColor, simbol);
        door.opened := true;    
        collidable := false;
      End;
      With door2 do
      Begin 
        Render(x + 1, y, 0, 0, ' '); 
        Render(door.xt, door.yt, tColor, bColor, simbol);  
        door.opened := true;   
        collidable := false;
      End;      
      setBlockTempAt(x, y, door1);
      setBlockTempAt(x + 1, y, door2);
    End;
  End;
                          
  // This fechamos a door.
  // Aqui fechamos uma porta.
  Procedure closeDoor(x, y : Integer);
  var door1, door2 : blockType;
  Begin                
    door1 := getBlockAt(x, y);    
    door2 := getBlockAt(x, y + 1);   
    if (door2.name = 'SDoor') then
    Begin 
      With door1 do
      Begin   
        Render(x, y, tColor, bColor, simbol);
        Render(door.xt, door.yt, getBlockTColor(door.xt, door.yt), getBlockBColor(door.xt, door.yt), getBlockSimbol(door.xt, door.yt));
        door.opened := false;
        collidable := true;
      End;
      With door2 do
      Begin 
        Render(x, y + 1, tColor, bColor, simbol);
        Render(door.xt, door.yt, getBlockTColor(door.xt, door.yt), getBlockBColor(door.xt, door.yt), getBlockSimbol(door.xt, door.yt));
        door.opened := false;
        collidable := true;
      End;    
      setBlockTempAt(x, y, door1);
      setBlockTempAt(x, y + 1, door2);
    End
    Else
    Begin  
      door2 := getBlockAt(x + 1, y); 
      With door1 do
      Begin   
        Render(x, y, tColor, bColor, simbol);
        Render(door.xt, door.yt, getBlockTColor(door.xt, door.yt), getBlockBColor(door.xt, door.yt), getBlockSimbol(door.xt, door.yt));
        door.opened := false;
        collidable := true;
      End;
      With door2 do
      Begin 
        Render(x + 1, y, tColor, bColor, simbol);
        Render(door.xt, door.yt, getBlockTColor(door.xt, door.yt), getBlockBColor(door.xt, door.yt), getBlockSimbol(door.xt, door.yt));
        door.opened := false;
        collidable := true;
      End;      
      setBlockTempAt(x, y, door1);
      setBlockTempAt(x + 1, y, door2);
    End;
  End;

end.
