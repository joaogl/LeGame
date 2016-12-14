unit FileReader;
interface
  uses SysUtils;
  Function ReadFile(fileToRead : String) : String;

implementation                

  Function ReadFile(fileToRead : String) : String;
  var F : TextFile; temp, full : String;
  Begin
    full := '';  
    temp := '';
    AssignFile(F, fileToRead + '.txt');
    Reset(F);
    Repeat
      Readln(F, temp);
      if (length(full) > 0) then full := full + #13#10 + temp
      else full := temp;
      temp := '';
    Until Eof(F);
    CloseFile(F);
    ReadFile := full;
  End;

end.
