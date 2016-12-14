unit FileWritter;
interface      
  uses SysUtils;
  Procedure WriteFile(fileToWrite, input  : String);

implementation                

  Procedure WriteFile(fileToWrite, input : String);
  var F : TextFile; temp, full : String;
  Begin
    AssignFile(F, fileToWrite + '.txt');
    Rewrite(F);
    Write(F, input);
    Flush(F);
    CloseFile(F);
  End;

end.
