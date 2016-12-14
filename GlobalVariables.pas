// This unit gives the program the capabiliy to have this variables in multiple units.
// Esta unidade permite nos ter variaveis para serem usadas em todas as units.
unit GlobalVariables;
interface   

     // screenrec record is used to stone position and size of the screen.
     // recorde screenrec é usado para guardar posicao e localizacao do ecra.
type screenrec = record
       x : integer;
       y : integer;
       width : integer;
       height : integer;
     End;
     // this is used to store what a key for a door is.
     // aqui é defenido o que é uma chave de uma porta.
     DoorKey = record
       ID : integer;
       x : integer;
       y : integer;
     End;
     // This is used to define menu options
     // Isto define as opcoes dos menus.
     Options = record
       ID : integer;
       text : String;
     End;
     // This defines menus.
     // Isto define menus.
     Menu = record
       options : Array[0..10] of Options;
       noptions : integer;
       x : integer;
       y : integer;
       over : integer; 
       foptions : integer;
       opened : Boolean;
     End;
     // This defines the actions fo the blocks.
     // Isto define uma acao de um bloco.
     blockaction = record
       x : integer;
       y : integer;
       level : integer;
       useAction : boolean;
     End;   
     // This defines where to move the doors.
     // Isto define para onde mover as portas.
     DoorAction = record
       xt : integer;
       yt : integer;
       opened : boolean;
     End;                 
     // blockType record defines a block and contains background color, text color, simbols and name.
     // recorde blockType define blocos e contem cor de fundo, cor de texto, caracter e nome.
     blockType = record  
       ID : integer;
       bColor : integer;
       tColor : integer;
       collidable : boolean;
       action : blockaction;
       door : DoorAction;
       Name : String;
       simbol : Char;
     End;
     // This is what defines the keys for each player.
     // Isto define as teclas para cada jogador.
     KeyboardActions = record
       ID : integer;
       up : integer;
       down : integer;
       left : integer;
       right : integer;
     End;  
     // EntityType record defines the mob/entity types, includes Name, ID, Damage and Life.
     // EntityType define a vida e o valor de ataque de um tipo de entidade.
     EntityType = record
       ID : integer;
       Damage : integer;
       Life : integer;
     End;  
     // EntityFullType defines an entity type with colors.
     // EntityFullType define uma entidade total.
     EntityFullType = record
       ID : integer;     
       Name : String;  
       keydoors : Array[0..20] of DoorKey;  
       EntType : EntityType;
       bColor : integer;
       tColor : integer;
       Simbol : Char;
     End;  
     // Entity record define a mob and includes Name, EntType, bColor, tColor, Simbol and KeyboardActions.
     // Entity define a entidade contento Name, EntType, bColor, tColor, Simbol and KeyboardActions.
     Entity = record
       Name : String;
       EntType : EntityType;
       KeyAction : KeyboardActions;
       keydoors : Array[0..20] of DoorKey;
       bColor : integer;
       tColor : integer;
       x : integer;
       y : integer;
       Simbol : Char;
       Visible : boolean;
       Updatable : boolean;
       Updates : Integer;
       isPlayer : boolean;
     End;   
     // This is for the XML reader. This defines the TAGNEEDs.
     // Isto é para o leitor de XML e define as TAGNEEDs.
     TagNeeds = record
       Name : String;
       DefaultValue : String;
       InputType : String;
     End;     
     // This is for the XML reader. This defines the SUBTAGs.
     // Isto é para o leitor de XML e define as SUBTAGs.
     SubTag = record
       Name : String;
       tagNeeds : Array[0..10] of TagNeeds;
     End;
     // This is for the XML reader. This defines the TAGs.
     // Isto é para o leitor de XML e define as TAGs.
     Tag = record               
       inUse : boolean;
       Name : String;
       usetagNeeds : boolean;
       tagNeeds : Array[0..10] of TagNeeds;           
       usesubTags : boolean;
       subTags : Array[0..10] of SubTag;
     End;  

     TagData = record
       name : String;
       value : String;
     End;

     codeTag = record
       name : String[250];
       dataAm, fromChar, toChar, fromLine, toLine : integer;  
       data : Array[0..20] of TagData;
     End; 

     TagDataType = record
       data : Array[0..20] of TagData;
     End;

     subTagsType = record
       subTag : Array[0..20] of codeTag;
     End;

     codeFullTag = record
       name : String[250];
       hasSub : boolean;                             
       data : Array[0..20] of TagData;
       dataAm, fromChar, toChar, fromLine, toLine, subAmount : integer;
       subTag : Array[0..20] of codeTag;
     End;

     codeFile = record
       code : Array[0..10000] of String[250];
     End;

     levelsdata = record
       id : integer;
       name : string;
       through : boolean;
     End;
     
  var tags : Array[0..200] of codeFullTag;
      tagamount, KeyActionsAmount, LevelsAmount, BlocksTypeAmount, EntityTypeAmount, EntityModelAmount : integer;
      processedCode : codeFile;   
      ShowLevel, ShowEachPlayerLife, ShowEachPlayerName : boolean;
      SeperatorCharacter : char;
      LevelInformation : Array[0..100] of levelsdata;


  // Screen contains the width, height and inicial x and y position for the game screen.
  // Screen contem largura, altura e posicao inicial em x e y do ecra de jogo.
  var screen : screenrec;
  // blocks is an array that holds all the blocks on the game.
  // blocks é uma variavel que contem todos os blocos do jogo.
  var blocks : Array[0..20] of blockType;
  // worldBlocks is THE MOST IMPORTANT ARRAY of the game, this holds all the world blocks.
  // worldBlocks é a ARRAY MAIS IMPORTANTE do jogo, contem todos os blocos presentes no mapa.
  var worldBlocks : Array[0..1794] of blockType;
  // This tells us when and if the map has been changed.
  // Esta variavel informa nos se o mapa foi alterado.
  var MAPCHANGE : boolean;
  // This is the current level that the player is on.
  // Esta variavel guarda o nevel actual do player.
  var currentLevel : Integer;
  // This array stores all the entity types available.
  // Esta array guarda todos os tipos de entidades disponiveis.
  var EntityTypes : Array[0..20] of EntityType;
  var EntityFullTypes : Array[0..20] of EntityFullType;
  // This array stores all the players keyboard settings.
  // Esta array guarda todas as definicoes do player.
  var Keys : Array[0..20] of KeyboardActions;
  // This array stores all the entities on the map.
  // Esta array guarda todas as entidades presentes no mapa.
  var entities : Array[0..100] of Entity;

  // This are all the
  var MainMenu, GameMenu, NewGame, KeyboardSettings : Menu;

  var NPlayers : Integer;
      
  // Running var is used to keep the information and an easy closing method for the game.
  // A variavel Running é usada para nos mantermos facilmente informados do estado do jogo e facilmente fechar o jogo.
  var changedLevel, running, needDisplay, gameReady, CREATE, special, inEditor : boolean;

  // This represents the exe Current Location.
  var gameDirectory : String;
  // This represents the resorces folder.
  var resDirectory : String; 
  // This stores the Tags.
  // Aqui sao guardadas as Tags.
  // var Tags : Array[0..10] of Tag;
  var Loading : boolean;

  Type PlayerLoadedData = Record
       level : integer;
       entities : Array[0..100] of Entity;
       End;
  Var PlayerDataFile : File of PlayerLoadedData;  
  Var PlayerData : PlayerLoadedData;

implementation

end.
