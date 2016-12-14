{
value  color
  0    Black
  1    Blue
  2    Green
  3    Cyan
  4    Red
  5    Magenta
  6    Brown
  7    White
  8    Grey
  9    Light Blue
 10    Light Green
 11    Light Cyan
 12    Light Red
 13    Light Magenta
 14    Yellow
 15    High-intensity white
}
                 
// Main Program.
// Programa Principal.
Program LeDeff ;
// Unit LevelManager is Responsable for all the Blocks and Block Renders in the game. 
// Unit keyboard is used to get more functions about the keyboard.  
// GlobalVariables unit contains global variables.       
// EntityManager unit is responsable for all the entities in the game including bot's and players.
// Menu unit is the unit responsable for all the menus in the game.
// ExternalSource unit is responsible for all the external data for the game. ex. scripts.
// Unit LevelManager é responsavel por todos os grafismos relacionados com blocos para o jogo.
// Unit keyboard é usada para obter mais funcoens para o teclado.
// a Unit GlobalVariables é usada para nos permitir ter variaveis globais.
// A unit EntityManager é responsavel por todas as entidades no jogo incluindo os bots e jogadores.
// A unit Menu é responsavel por todos os menus no jogo.
// A unit ExternalSource é responsavel por todas as informacoes externas ao jogo, como, scripts.
Uses crt, LevelManager, keyboard, GlobalVariables, EntityManager, Menu, MapCreator, ExternalSource;

// k var is used to hold the raw key code of the key pressed on the keyboard.
// tempSSS is a variable used for random and usually temporary values.
// i variable is used for for loops.
// A variavel k é usada para guardar a ultima tecla primida contendo informação não processada.
// A variavel tempSSS é usada para guard informacao normalmente temporaria.
// A variavel i é usada para for loops.
var k : TKeyEvent; tempSSS : String; i : integer;
    state : boolean;

// This Procedure is called when a key as been pressed.
// Este procedimento é chamado quando uma tecla é primida.
Procedure updateKeyBoard;
// this variable is used to store the owner of the key pressed if any.
// esta variavel é usada para guardar o dono da tecla primida se existir.
var owner : integer;
Begin
 // this checks if there is any menu open, if so, it will send the update to it.
 // aqui verificamos se algum menu está aberto e se estiver, envia o update para  mesmo.
 if (MainMenu.opened OR GameMenu.opened OR NewGame.opened OR KeyboardSettings.opened) then MenuKey(k)
 Else
 Begin
   // Here we try to find the owner of the key pressed.
   // Aqui verificamos o dono da tecla primida.
   owner := findKeyOwner(k);
   if (owner <> 9999) then
   Begin                    
     // If there is any owner, this is, if the key pressed is valid move the player.
     // Se existir algum dono, isto é, se a tecla primida for valida, move o player.
     if (k = entities[owner].KeyAction.up) then movePlayer(owner, 0, -1)
     else if (k = entities[owner].KeyAction.down) then movePlayer(owner, 0, 1)
     else if (k = entities[owner].KeyAction.left) then movePlayer(owner, -1, 0)
     else if (k = entities[owner].KeyAction.right) then movePlayer(owner, 1, 0);
     // After the movement it should render the players.
     // Apos o movimento deve renderizar os jogadores.
     renderEntities;
   End;
 End;
End;

Begin
  // Here we just print a message so slower computers dont get a black screen while the game is loading.
  // Aqui escrevemos uma mensagem para que computadores mais lentos nao obtenham um ecra preto enquanto o jogo carrega.
  writeln('Game Loading...');

  KeyActionsAmount := 0;
  BlocksTypeAmount := 0;
  EntityTypeAmount := 0;
  EntityModelAmount := 0;
  LevelsAmount := 0;

  ShowLevel := true;
  ShowEachPlayerName := true;
  ShowEachPlayerLife := true;
  SeperatorCharacter := '/';

  writeln('Setting up Tag Types...');
  // setupTagTypes;   
  writeln('Done setting up Tag Types...');  
  state := setupExternalSources();
  if (not state) then
  Begin
    writeln('Closed.');
    readkey;
    exit;
  End;

  if (KeyActionsAmount < 1) then
  Begin 
    TextColor(4);
    writeln('No Key Actions where found.');  
    writeln('Closing Game.');
    writeln('Closed.');
    TextColor(7);
    readkey;
    exit;
  End;

  // We set the running to true because its running.
  // Defenimos running para verdadeiro porque esta a correr.
  running := true;

  // This initializes the keyboard listener.
  // Aqui iniciamos o leitor para o teclado.
  InitKeyBoard;

  // Turning off the cursor.
  // Desligar o cursor.
  cursoroff;

  // this is how many players are going to be created, if 999, it tells the game to ask the player how many to create.
  // isto é o numero de players que vao ser criados, se for 999 o jogo vai pedir ao player quantos jogadores tem que criar.
  NPlayers := 999;

  // Setting to the first level.
  // Defenir para o primeiro nivel.
  currentLevel := 1;

  // Let's set this to true to force the map to be rendered.
  // MAPCHANGE forces the game to render the level.
  // changedLevel forces the game to clear and render everything again.
  // needDisplay forces the game to render the players information.
  // Vamos defenir para verdadeiro para que force o jogo a ser desenhado.
  // MAPCHANGE forca o jogo a renderizar o nivel.
  // changedLevel forca o jogo a limpar e renderizar o nivel de novo.
  // needDisplay forca o jogo a renderizar as informacoes dos jogadores.
  MAPCHANGE := true;
  changedLevel := true;
  needDisplay := true;

  // Clear the screen to make the loading message disapear.
  // Limpar o ecra para fazer desaparecer a mensagem de loading.
  Clrscr;

  // Defines the menus.
  // Define os menus.
  SetupMenu;

  // This tells the game that is not ready to start being played.
  // Isto informa o jogo que nao está pronto para ser jogado.
  gameReady := false;
      
  // Here the Menus needed are rendered.
  // Aqui os menus necessarios são renderizados.
  RenderMenu;

  // Game Loop, used to keep the game running while the running values is true.
  // Game Loop, utilizado para manter o jogo a correr enquanto a variavel running for verdadeira.
  Repeat
    Repeat
      // Used to get the last key event.
      // Usado para obter a ultima tecla primida.
      k := PollKeyEvent;
      // if the game is ready to be played lets do some stuff.
      // se o jogo estiver pronto a ser corrido vamos fazer algumas coisas.
      if (gameReady) then
      Begin
        // if the level as been changed go in.
        // se o nivel foi alterado entra neste if.
        if (changedLevel) Then
        Begin
          // This creates the map content for the level.
          // Aqui é gerado o conteudo do mapa.
          startLevel();
          // This once more forces the game to be rendered.
          // Aqui mais uma vez força o nivel a ser renderizado.
          MAPCHANGE := true;
        End;

        // If the map has been changed render it.
        // Se o mapa for alterado desenha-o.
        if (MAPCHANGE) Then
        Begin
          // This renders the all level.
          // Isto renderiza o nivel todo.
          RenderFullLevel;
          // This renders all the players.
          // Isto renderiza todos os jogadores.
          renderEntities;
          // By setting this to false it means it is done.
          // Ao defenir para falso significa que esta feito.
          MAPCHANGE := false;
          // This renders the Menus.
          // Aqui renderizamos os menus.
          RenderMenu;
        End;
        // Render the players info if needed.
        // Renderiza as informacoes dos players se necessario.
        if (needDisplay OR changedLevel) then
        Begin
          // This tells the program that is done and then it clears the space needed.
          // Isto limpa o ecra e informa o programa que está feito.
          changedLevel := false;
          needDisplay := false;
          GotoXY(2, screen.y + screen.height + 3);
          DelLine;
          GotoXY(2, screen.y + screen.height + 2);
          DelLine;
          GotoXY(2, screen.y + screen.height + 1);
          DelLine;
          // This writes the player informations.
          // Isto escreve as informacoes dos jogadores.
          Write(getPlayerStatus);
        End;            
        if not (MainMenu.opened OR GameMenu.opened OR NewGame.opened OR KeyboardSettings.opened) then
        Begin
          updateEntities;
          renderEntities;
        End;
      End
      Else
      Begin
        // if its ready, create the players.
        // se estiver pronto, criar os jogadores.
        if ((NPlayers <> 999) AND (CREATE)) then
        Begin
          // This defines the players.
          // Isto define os jogadores.
          for i := 0 to (NPlayers - 1) do
          Begin
            // Let's define the players.
            // Vamos defenir os players.
            Str((i + 1), tempSSS);
            setPlayer(i, i, 0, 0, 0, i + 1, 'Player ' + tempSSS);
            gameReady := true;
          End;
          // This clears the unused player.
          // Isto limpa os jogadores que nao estao em utilizacao.
          for i := NPlayers to 5 do
          Begin
            if (entities[i].isPlayer) then
            Begin
              entities[i].isPlayer := false;
              entities[i].name := '';
            End;
          End;
        End;
      End;
      if (inEditor) then renderEditor;
    // If there is something pressed, leave the Repeat.
    // Se alguma tecla for primida, sai do repeat.
    Until (k <> 0);
    // Used to get and translate the last key event.
    // Usado para obter e traduzir a ultima tecla primida.
    k := GetKeyEvent;
    k := TranslateKeyEvent(K);

    // if escape key is pressed open or close menus.
    // se a tecla escape é primida fecha ou abre menus.
    if ((k = 283) and (not special) and (not inEditor)) then MenuAction
    else if (inEditor) then keyHit(k)
    else updateKeyBoard;
    // writeln('Key: ', k);
  Until (not running);
  // This closes the keyboard listener.
  // Assim fechamos o leitor de teclado.
  DoneKeyBoard;     
  // This is just to warn us that the game as been closed.
  // Apenas serve para nos avisar que o jogo foi fechado.    
  Writeln('Game Closed');
End.
