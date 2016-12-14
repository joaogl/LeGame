unit ExternalSource;
interface     
  Uses FileManager, GlobalVariables, XMLReader, XMLExecuter;

  Function setupExternalSources() : boolean;
  Function loadFile(name : String) : boolean;
  // Procedure setupTagTypes();

implementation
                  
  Function setupExternalSources() : boolean;
  var state : boolean;
  Begin
    state := true;
    writeln('Getting game paths.');
    getMainPath;
    writeln('Creating game paths if needed.');
    CreateDirectory(resDirectory); 
    writeln;
    writeln('== | Moving to nonstandard Procedures | ==');    
    writeln;

    state := loadFile('GameData');
    // state := loadFile('Defaults');
    // if (state) then state := loadFile('Levels');

    writeln;
    writeln('== | Nonstandard Procedures Over | ==');  
    writeln;

    if (state) then
    Begin
      writeln('Loading Done.');
      writeln('Opening Game.');
    End;

    setupExternalSources := state;
  End;      

  Function loadFile(name : String) : boolean;
  var i : integer;
  Begin
    for i := 0 to 10000 do
    Begin
      processedCode.code[i] := ' ';
    End;
    writeln('Loading ' , name , '.');
    if (getBlockCode(name)) then
    Begin          
      writeln(name , ' is ready to be preexecuted.');
      if (TagReader) then writeln(name , ' has been preexecuted.')
      else
      Begin 
        writeln('Game was forced to close.');
        loadFile := false;
        exit;
      End;
      writeln(name , ' is ready to be executed.');
      if (runTags) then writeln(name , ' has been executed.')
      else
      Begin 
        writeln('Game was forced to close.');
        loadFile := false;
        exit;
      End;
    End
    Else
    Begin
      writeln('Game was forced to close.');  
      loadFile := false;
      exit;
    End;                                     
    loadFile := true;
  End;

  {Procedure setupTagTypes();
  var tagNeed : Array[0..10] of tagNeeds; subTag : Array[0..10] of SubTag; i : integer;
  Begin
    for i := 0 to 10 do
    Begin
      Tags[i].inUse := false;
      tagNeed[i].Name := '';
      tagNeed[i].DefaultValue := '';
      tagNeed[i].InputType := '';
    End;
    for i := 0 to 10 do
    Begin
      subTag[i].Name := '';
      subTag[i].tagNeeds := tagNeed;
    End;

    With Tags[0] do
    Begin
      Name := 'KeyAction';
      inUse := true;
      tagNeed[0].Name := 'LEFT';
      tagNeed[0].DefaultValue := '7777';
      tagNeed[0].InputType := 'Integer';

      tagNeed[1].Name := 'RIGHT';
      tagNeed[1].DefaultValue := '8292';
      tagNeed[1].InputType := 'Integer';

      tagNeed[2].Name := 'UP';
      tagNeed[2].DefaultValue := '4471';
      tagNeed[2].InputType := 'Integer';

      tagNeed[3].Name := 'DOWN';
      tagNeed[3].DefaultValue := '8051';
      tagNeed[3].InputType := 'Integer';

      usetagNeeds := true;
      tagNeeds := tagNeed; 
      usesubTags := false;
    End; 

    for i := 0 to 10 do
    Begin
      tagNeed[i].Name := '';
      tagNeed[i].DefaultValue := '';
      tagNeed[i].InputType := '';
    End;

    With Tags[1] do
    Begin
      Name := 'EntityType';  
      inUse := true;

      tagNeed[0].Name := 'Damage';
      tagNeed[0].DefaultValue := '1';
      tagNeed[0].InputType := 'Integer';

      tagNeed[1].Name := 'Life';
      tagNeed[1].DefaultValue := '3';
      tagNeed[1].InputType := 'Integer';

      usetagNeeds := true;
      tagNeeds := tagNeed; 
      usesubTags := false;
    End;      

    for i := 0 to 10 do
    Begin
      tagNeed[i].Name := '';
      tagNeed[i].DefaultValue := '';
      tagNeed[i].InputType := '';
    End;

    With Tags[2] do
    Begin
      Name := 'EntityModel'; 
      inUse := true;

      tagNeed[0].Name := 'EntityType';
      tagNeed[0].DefaultValue := '0';
      tagNeed[0].InputType := 'Integer';

      tagNeed[1].Name := 'BackgroundColor';
      tagNeed[1].DefaultValue := '3';
      tagNeed[1].InputType := 'Integer';

      tagNeed[2].Name := 'TextColor';
      tagNeed[2].DefaultValue := '0';
      tagNeed[2].InputType := 'Integer';

      tagNeed[3].Name := 'Character';
      tagNeed[3].DefaultValue := ' ';
      tagNeed[3].InputType := 'Char';

      tagNeed[4].Name := 'Name';
      tagNeed[4].DefaultValue := 'Mob Level 1';
      tagNeed[4].InputType := 'String';

      usetagNeeds := true;
      tagNeeds := tagNeed; 
      usesubTags := false;
    End;   

    for i := 0 to 10 do
    Begin
      tagNeed[i].Name := '';
      tagNeed[i].DefaultValue := '';
      tagNeed[i].InputType := '';
    End;

    With Tags[3] do
    Begin
      Name := 'BlockType';   
      inUse := true;

      tagNeed[0].Name := 'BackgroundColor';
      tagNeed[0].DefaultValue := '3';
      tagNeed[0].InputType := 'Integer';

      tagNeed[1].Name := 'TextColor';
      tagNeed[1].DefaultValue := '0';
      tagNeed[1].InputType := 'Integer';

      tagNeed[2].Name := 'Collidable';
      tagNeed[2].DefaultValue := 'false';
      tagNeed[2].InputType := 'boolean';

      tagNeed[3].Name := 'Character';
      tagNeed[3].DefaultValue := ' ';
      tagNeed[3].InputType := 'Char';

      tagNeed[4].Name := 'Name';
      tagNeed[4].DefaultValue := 'Mob Level 1';
      tagNeed[4].InputType := 'String';

      usetagNeeds := true;
      tagNeeds := tagNeed; 
      usesubTags := false;
    End;  

    for i := 0 to 10 do
    Begin
      tagNeed[i].Name := '';
      tagNeed[i].DefaultValue := '';
      tagNeed[i].InputType := '';
    End;

    With Tags[4] do
    Begin
      Name := 'Level';   
      inUse := true;

      tagNeed[0].Name := 'fromX';
      tagNeed[0].DefaultValue := '2';
      tagNeed[0].InputType := 'Integer';

      tagNeed[1].Name := 'fromY';
      tagNeed[1].DefaultValue := '2';
      tagNeed[1].InputType := 'Integer';

      tagNeed[2].Name := 'toX';
      tagNeed[2].DefaultValue := '78';
      tagNeed[2].InputType := 'Integer';

      tagNeed[3].Name := 'toY';
      tagNeed[3].DefaultValue := '20';
      tagNeed[3].InputType := 'Integer';

      usetagNeeds := true;
      tagNeeds := tagNeed; 
      usesubTags := true;   

      for i := 0 to 10 do
      Begin
        tagNeed[i].Name := '';
        tagNeed[i].DefaultValue := '';
        tagNeed[i].InputType := '';
      End;

      subTag[0].Name := 'spawn';

      tagNeed[0].Name := 'x';
      tagNeed[0].DefaultValue := '3';
      tagNeed[0].InputType := 'Integer';

      tagNeed[1].Name := 'y';
      tagNeed[1].DefaultValue := '3';
      tagNeed[1].InputType := 'Integer';

      subTag[0].tagNeeds := tagNeed;

      for i := 0 to 10 do
      Begin
        tagNeed[i].Name := '';
        tagNeed[i].DefaultValue := '';
        tagNeed[i].InputType := '';
      End;

      subTag[1].Name := 'finish';

      tagNeed[0].Name := 'x';
      tagNeed[0].DefaultValue := '3';
      tagNeed[0].InputType := 'Integer';

      tagNeed[1].Name := 'y';
      tagNeed[1].DefaultValue := '3';
      tagNeed[1].InputType := 'Integer';

      tagNeed[2].Name := 'target';
      tagNeed[2].DefaultValue := '10';
      tagNeed[2].InputType := 'Integer';

      subTag[1].tagNeeds := tagNeed;


      subTags := subTag;
    End;
  End;   }

end.
