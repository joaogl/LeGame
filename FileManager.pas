unit FileManager;
interface    
  uses SysUtils, GlobalVariables, Dos;
  Procedure getMainPath();
  Function WriteFile(fileToWrite, input : String) : boolean;  
  Function WriteNewFile(fileToWrite, input : String) : boolean;
  Function ReadFile(fileToRead : String) : String;  
  Function ExistFile(fileToCheck : String) : boolean;
  Function ExistTextFile(fileToCheck : String) : boolean;
  Procedure DeleteFile(fileToDelete : String);
  Procedure CreateDirectory(dirToCreate : String);   
  Function CreateBlocksCodeFile() : boolean;

implementation
   
  Procedure getMainPath();      
  var path : String; i : integer; done : boolean;
  Begin
    done := false;
    path := paramstr(0);
    for i := length(path) DOWNTO 1 do
    Begin
      if ((not done) AND(Copy(path, length(path), 1) <> '\')) then Delete(path, length(path), 1)
      Else done := true;
    End;
    gameDirectory := path;
    resDirectory := path + 'GameData\';
  End;

  Function WriteFile(fileToWrite, input : String) : boolean;
  var F : TextFile; state : boolean;
  Begin
    AssignFile(F, fileToWrite + '.txt');
    {$I+}
    try
      Append(F);
      Write(F, input);
      Flush(F);
      CloseFile(F);  
      state := true;
    except
      on E: EInOutError do
      begin  
        writeln('Could not write to ', fileToWrite);    
        state := false;
      end;
    end;
    WriteFile := state;
  End;   

  Function WriteNewFile(fileToWrite, input : String) : boolean;
  var F : TextFile; state : boolean;
  Begin
    AssignFile(F, fileToWrite + '.txt');
    {$I+}
    try
      Rewrite(F);
      Write(F, input);
      Flush(F);
      CloseFile(F);  
      state := true;
    except
      on E: EInOutError do
      begin  
        writeln('Could not write to ', fileToWrite);    
        state := false;
      end;
    end;
    WriteNewFile := state;
  End;   

  Function ReadFile(fileToRead : String) : String;
  var F : TextFile; temp, full : String;
  Begin
    full := '';  
    temp := '';
    AssignFile(F, fileToRead + '.txt');
    try
      Reset(F);
      Repeat
        Readln(F, temp);
        if (length(full) > 0) then full := full + #13#10 + temp
        else full := temp;
        temp := '';
      Until Eof(F);
      CloseFile(F); 
    except
      on E: EInOutError do
      Begin    
        writeln('Could not read ', fileToRead);
      End;
    End;
    ReadFile := full;
  End;

  Function ExistTextFile(fileToCheck : String) : boolean;
  var F : TextFile;
  Begin
    AssignFile(F, fileToCheck + '.txt');
    try
      Reset(F);
      CloseFile(F);
      ExistTextFile := true;
    except
      on E: EInOutError do
      Begin
        writeln('Could not find ', fileToCheck);
        ExistTextFile := false;
      End;
    End;
  End; 

  Function ExistFile(fileToCheck : String) : boolean;
  var F : TextFile;
  Begin
    AssignFile(F, fileToCheck);
    try
      Reset(F);
      CloseFile(F);
      ExistFile := true;
    except
      on E: EInOutError do
      Begin
        writeln('Could not find ', fileToCheck);
        ExistFile := false;
      End;
    End;
  End; 

  Procedure DeleteFile(fileToDelete : String); 
  var F : TextFile;
  Begin
    Assign(F, fileToDelete + '.txt'); 
    try
      Erase(F);
    except
      on E: EInOutError do
      Begin      
        writeln('Could not delete ', fileToDelete);
      End;
    End;
  End;          

  Procedure CreateDirectory(dirToCreate : String);
  var NewDir : PathStr;
  Begin                  
    NewDir := FSearch(dirToCreate, GetEnv(''));
    if NewDir = '' then CreateDir(dirToCreate);
  End;      

  Function CreateBlocksCodeFile : boolean;
  var fileCode, f : String; state : boolean;
  Begin
    f := resDirectory + 'Blocks';
    state := WriteNewFile(f, '# Block structure:  ID, Text Color, Background Color, Name, Character, Collidable.'#13#10);
    if (state) then state := WriteFile(f, '# BlockCollidable Dirt {       - BlockType(BlockCollidable or BlockNotCollidable) BlockName'#13#10);
    if (state) then state := WriteFile(f, '#   0,                         - Text Color'#13#10);
    if (state) then state := WriteFile(f, '#   0,                         - Background Color'#13#10);
    if (state) then state := WriteFile(f, '#   " "                        - Character'#13#10);
    if (state) then state := WriteFile(f, '# }'#13#10);
    if (state) then state := WriteFile(f, '#'#13#10);
    if (state) then state := WriteFile(f, '# Colors'#13#10);
    if (state) then state := WriteFile(f, '#  0    Black'#13#10);
    if (state) then state := WriteFile(f, '#  1    Blue'#13#10);
    if (state) then state := WriteFile(f, '#  2    Green'#13#10);
    if (state) then state := WriteFile(f, '#  3    Cyan'#13#10);
    if (state) then state := WriteFile(f, '#  4    Red'#13#10);
    if (state) then state := WriteFile(f, '#  5    Magenta'#13#10);
    if (state) then state := WriteFile(f, '#  6    Brown'#13#10);
    if (state) then state := WriteFile(f, '#  7    White'#13#10);
    if (state) then state := WriteFile(f, '#  8    Grey'#13#10);
    if (state) then state := WriteFile(f, '#  9    Light Blue'#13#10);
    if (state) then state := WriteFile(f, '# 10    Light Green'#13#10);
    if (state) then state := WriteFile(f, '# 11    Light Cyan'#13#10);
    if (state) then state := WriteFile(f, '# 12    Light Red'#13#10);
    if (state) then state := WriteFile(f, '# 13    Light Magenta'#13#10);
    if (state) then state := WriteFile(f, '# 14    Yellow'#13#10);
    if (state) then state := WriteFile(f, '# 15    High-intensity white'#13#10); 
    if (state) then state := WriteFile(f, #13#10);
    if (state) then state := WriteFile(f, 'BlockNotCollidable Void {'#13#10);
    if (state) then state := WriteFile(f, '  0,'#13#10);
    if (state) then state := WriteFile(f, '  0,'#13#10);
    if (state) then state := WriteFile(f, '  " "'#13#10);
    if (state) then state := WriteFile(f, '}'#13#10);
    if (state) then state := WriteFile(f, #13#10);
    if (state) then state := WriteFile(f, 'BlockNotCollidable Grass {'#13#10);
    if (state) then state := WriteFile(f, '  0,'#13#10);
    if (state) then state := WriteFile(f, '  2,'#13#10);
    if (state) then state := WriteFile(f, '  " "'#13#10);
    if (state) then state := WriteFile(f, '}'#13#10);   
    if (state) then state := WriteFile(f, #13#10);
    if (state) then state := WriteFile(f, 'BlockNotCollidable Dirt {'#13#10);
    if (state) then state := WriteFile(f, '  0,'#13#10);
    if (state) then state := WriteFile(f, '  6,'#13#10);
    if (state) then state := WriteFile(f, '  " "'#13#10);
    if (state) then state := WriteFile(f, '}'#13#10);     
    if (state) then state := WriteFile(f, #13#10);
    if (state) then state := WriteFile(f, 'BlockCollidable Wall {'#13#10);
    if (state) then state := WriteFile(f, '  6,'#13#10);
    if (state) then state := WriteFile(f, '  0,'#13#10);
    if (state) then state := WriteFile(f, '  "|"'#13#10);
    if (state) then state := WriteFile(f, '}'#13#10);     
    if (state) then state := WriteFile(f, #13#10);
    if (state) then state := WriteFile(f, 'BlockNotCollidable FinishPoint {'#13#10);
    if (state) then state := WriteFile(f, '  0,'#13#10);
    if (state) then state := WriteFile(f, '  6,'#13#10);
    if (state) then state := WriteFile(f, '  " "'#13#10);
    if (state) then state := WriteFile(f, '}'#13#10);
    CreateBlocksCodeFile := state;
  End;

end.
