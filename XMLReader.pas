unit XMLReader;
interface
  uses crt, GlobalVariables, FileManager, SysUtils;

  var statage, s1 : integer;
  const ALPHA = ['A'..'Z', 'a'..'z'];

  Function getBlockCode(name : String) : boolean;
  Function ReadXMLFile(FileFrom : String) : codeFile;
  Function FilterXMLFile(localCode : codeFile) : codeFile; 
  Function PreInterpretXMLFile(ccode : codeFile) : boolean;
  Procedure printCode(thecode : codeFile);
  Procedure printTags();            
  Function confirmClosingTag(localCode, name : String[250]; ii : integer) : boolean;    
  Function TagReader : boolean;
  Function analyzer(fromLine, fromChar, toLine, toChar : integer; inSub : boolean; tagID, subTagID : integer) : boolean;

implementation

  // Function to put everything rolling.
  Function getBlockCode(name : String) : boolean;
  var f : String;
      fromFile, t1, t2 : codeFile;
      i : integer;
  Begin
    // Setting the file to read.
    f := resDirectory + name + '.xml';
    // Checking if the file exists
    if (ExistFile(f)) then writeln(name , ' file found')
    Else
    Begin
      writeln(name , ' file missing.');
      writeln('Insufficient data to open game. Closing...');    
      getBlockCode := false;
      exit;
    End; 

    for i := 0 to 10000 do
    Begin
      fromFile.code[i] := ' ';
      t1.code[i] := ' ';
      t2.code[i] := ' ';
    End;
                    
    // Reading the Code from the file
    fromFile := ReadXMLFile(f);
    // Filtering the Code (removing comments spaces etc.)
    t1 := FilterXMLFile(fromFile);
    t2 := FilterXMLFile(t1);

    processedCode := t2;

    // Printing the code without being interpreted.
    // printCode(t1);

    // Debug stuff.
    if (s1 > 0) then writeln(name , ' file successfully loaded to the memory.')
    else
    Begin
      writeln('Failed to load ' , name , ' file.');
      getBlockCode := false;
      exit;
    End;

    // Starting to PreInterpret file.
    writeln('Starting to interpret ' , name , ' file');
    if (PreInterpretXMLFile(t2)) then writeln(name , ' file successfully preinterpreted.')
    else
    Begin
      writeln(name , ' file failed to be preinterpreted.');
      writeln('Closing...');  
      getBlockCode := false;
      exit;
    End;

    // Printing the code tags.
    // printTags;

    getBlockCode := true;
  End;
  
  // Function to Group and organize the TAGS.
  Function PreInterpretXMLFile(ccode : codeFile) : boolean;
  var i, ii, iii, subtagamount, pointer : integer;
      inTag, inSubTag, done, isFound : boolean;
      tempName : String;
  Begin
    // Setting everything up to run the code.
    tagamount := 0;
    subtagamount := -1;
    inTag := false;
    inSubTag := false;
    // Go through all the code lines
    for i := 0 to s1 do
    Begin
      // Reseting the tag name.
      tempName := '';

      // Go through all the characters of the line
      for ii := 0 to length(ccode.code[i]) do
      Begin

        // if it starts by <[char] it means its a XML Tag.
        if ((ccode.code[i][ii] = '<') AND (ccode.code[i][ii + 1] <> ' ')  AND (ccode.code[i][ii + 1] <> '/') AND (not (inTag))) then
        Begin
          // Inform the program that this is a tag.
          inTag := true;
          // Inform also that we havent got the name of the tag.
          done := false;
          // Going again through all the lines this time searching for the name.
          for iii := (ii + 1) to length(ccode.code[i]) do
          Begin
            // If its not done and the next char its a space it means the name is over.
            if (not(done) AND (ccode.code[i][iii] = ' ')) then
            Begin
              // Because the name is over set this to true.
              done := true;

              // If we are inside a subTag
              if (inSubTag) then
              Begin
                // Go to the next subTag.
                subtagamount := subtagamount + 1;
                // Report now many subtags there are on this tag.
                tags[tagamount].subAmount := subtagamount;  
                // And register it.
                tags[tagamount].subTag[subtagamount].name := tempName;     
                isFound := false;
                pointer := ii + length(tempName) + 2;
                Repeat
                  if ((ccode.code[i][pointer] in ALPHA) AND (ord(ccode.code[i][pointer]) <> 21) AND (ord(ccode.code[i][pointer]) <> 26) AND (ord(ccode.code[i][pointer]) <> 27)) then isFound := true
                  else pointer := pointer + 1;
                Until (isFound);
                tags[tagamount].subTag[subtagamount].fromChar := pointer;
                tags[tagamount].subTag[subtagamount].fromLine := i;
              End
              Else
              Begin
                // If its not a subTag register it has a tag.
                tags[tagamount].name := tempName;          
                isFound := false;
                pointer := ii + length(tempName) + 2;
                Repeat
                  if (ccode.code[i][pointer] in ALPHA) then isFound := true
                  else pointer := pointer + 1;
                Until (isFound);
                tags[tagamount].fromChar := pointer;
                tags[tagamount].fromLine := i;
              End;
            End
            Else
            Begin
              // if its not done and the next char isn't a space it means we are still inside the name so keep writing it.
              if not (ccode.code[i][iii] = '<') then tempName := tempName + ccode.code[i][iii];
            End;
          End;
        End;

        // If we have reached a /> it means that its the end of a tag.
        if ((ccode.code[i][ii] = '/') AND (ccode.code[i][ii + 1] = '>') AND (inTag)) then
        Begin
          // If we are inside a subTag
          if (inSubTag) then 
          Begin    
            // Register the end of it.
            tags[tagamount].subTag[subtagamount].toChar := ii - 1;
            tags[tagamount].subTag[subtagamount].toLine := i;
          End
          Else
          Begin
            // If its not a subTag register the end of the tag.
            tags[tagamount].toChar := ii - 1;
            tags[tagamount].toLine := i;
            tagamount := tagamount + 1;
          End;
          // After the end of the tag set this to false to inform the program that we left.
          inTag := false;
        End
        // Check if this is the closing tag of our current tag. ex. </Level>
        else if ((inSubTag) AND (length(ccode.code[i]) > 3) AND (confirmClosingTag(ccode.code[i], tags[tagamount].name, ii))) then
        Begin
          // Move to the next tag.
          tagamount := tagamount + 1;  
          subtagamount := -1;
          inTag := false;
          inSubTag := false;
        End
        // If the line ends with > it means this tag will have subTags.
        else if ((ccode.code[i][ii] = '>') AND (inTag) AND not (inSubTag)) then
        Begin
          // Register the end of the tag
          tags[tagamount].toChar := ii - 1;
          tags[tagamount].toLine := i;
          // Inform the program that we will join the subTags of this tag.
          tags[tagamount].hasSub := true;
          inTag := false;
          inSubTag := true;
        End;
      End;
    End;
    // At the end, this program adds a nil array entry so just ignore it.
    if (tagamount > 0) then tagamount := tagamount - 1;
    PreInterpretXMLFile := true;
  End;           

  // Function to confirm that we have a closing Tag of a certain tag.
  Function confirmClosingTag(localCode, name : String[250]; ii : integer) : boolean;
  var i, char, startpoint : integer;
      good : boolean;
  Begin
    // if the name of the tag is not empty.
    if (length(name) > 0) then
    Begin
      // Char will act has stages for our code to be interpreted.
      char := 0;
      // Is this closing tag still usable? start it with yes until something tells u the opposit.
      good := true;
      // Go through all the charaters again.
      for i := ii to length(localCode) do
      Begin
        // if we are still in the first stage and we find the < char move to the next stage.
        if ((localCode[i] = '<') AND (char = 0)) then char := 1  
        // if we are still in the second stage and we find the / char move to the next stage.
        else if ((localCode[i] = '/') AND (char = 1)) then
        Begin
          // The next stage will be confirming if the closing tag name is the same as the opening tag name.
          // For this reason we'll need our current position.
          startpoint := i;
          char := 2;
        End
        // If the name is the same keep going.
        else if ((char = 2) AND ((i - startpoint) <= length(name)) AND (localCode[i] = name[i - startpoint]) AND good) then good := true
        // If not, discard it.
        else if ((char = 2) AND ((i - startpoint) <= length(name)) AND (localCode[i] <> name[i - startpoint]) AND good) then good := false;

        // if after the name is checked there is a > its the end of our closing tag.
        if (good AND (char = 2) AND ((i - startpoint) > length(name)) AND (localCode[i] = '>')) then
        Begin
          confirmClosingTag := true;
          exit;
        End
        // If there is anything besides a space it will prevent the function from working.
        else if (good AND (char = 2) AND ((i - startpoint) > length(name)) AND (localCode[i] <> ' ')) then
        Begin
          confirmClosingTag := false;
          exit;
        End;
      End;
    end;
    confirmClosingTag := false;
  End;

  // Function to Read the XML and remove all the unnecessary code.
  Function FilterXMLFile(localCode : codeFile) : codeFile;
  var hasSomething, comment : boolean;
      line, pline, chari, i, ii, ignoreUntil : integer;
      fCode : codeFile;
  Begin
    for i := 0 to 10000 do
    Begin
      fCode.code[i] := ' ';
    End;

    // Setting the comments to false
    comment := false;
    // To read from the first line
    line := s1;

    // Reading line by line and removing useless characters. (comments, spaces and empty lines)
    pline := 0;
    // From 0 (begining of the file) to line (end of the file)
    for i := 0 to line do
    Begin
      // Does this line contain anything?
      hasSomething := false;  
      // chari is our character position on the final code array
      chari := 0;

      ignoreUntil := 0;

      // Form 0 to the end of the localCode line.
      for ii := 0 to length(localCode.code[i]) do
      Begin
        // If there is an ENTER it will be ignored
        if ((localCode.code[i][ii] <> #0)) then
        Begin
          // If the first character is a space, ignore it.
          if not ((chari = 1) AND (localCode.code[i][ii] = #32)) then
          Begin
            // If there are two spaces together, ignore them.
            if not ((localCode.code[i][ii] = #32) AND (localCode.code[i][ii + 1] = #32)) then
            Begin
              // If there is a tab
              if (localCode.code[i][ii] = #9) then
              Begin
                // And if its not on the first character.
                if not (chari = 1) then
                Begin
                  // Change it to a space
                  fcode.code[pline][chari] := ' ';
                  hasSomething := true;
                  chari := chari + 1;
                End;
              End
              Else
              Begin
                // If a comment tag is found set the comment boolean to true
                if ((localCode.code[i][ii] = '<') AND (localCode.code[i][ii + 1] = '!') AND (localCode.code[i][ii + 2] = '-') AND (localCode.code[i][ii + 3] = '-')) then comment := true;
                // If a closing comment tag is found set the comment boolean to false
                if ((localCode.code[i][ii] = '-') AND (localCode.code[i][ii + 1] = '-') AND (localCode.code[i][ii + 2] = '>')) then
                Begin
                  // Set the ignoreUntil to the end of the comment tag.
                  comment := false;
                  ignoreUntil := ii + 2;
                End;

                // If its not a comment
                if not (comment) then
                Begin
                  // If the ignoreUntil is = 0 (not set) or if the current character is after the last character of the comment closing tag
                  if ((ignoreUntil = 0) OR (ii > ignoreUntil)) then
                  Begin
                    // If there isnt a tab just write the localCode content to the Final Code array.
                    fcode.code[pline][chari] := localCode.code[i][ii];
                    hasSomething := true;
                    chari := chari + 1;
                  End
                  Else hasSomething := false;
                End;
              End;
            End;
          End;
        End;
      End;
      // If there is something on the line move to the next one.
      if (hasSomething) then
      Begin
           pline := pline + 1;
      End;
    End;
    s1 := pline;
    FilterXMLFile := fcode;
  End; 

  // Function to Read the XML file.
  Function ReadXMLFile(FileFrom : String) : codeFile;
  var F : TextFile;
      temp : String;
      line, i : integer;
      localCode : codeFile;
  Begin        
    // To read from the first line
    line := 0;

    for i := 0 to 10000 do
    Begin
      localCode.code[i] := '';
    End;

    // Assigning the file
    AssignFile(F, FileFrom);
    // Reading the file
    try
      Reset(F);
      Repeat
        temp := '';
        // Reading line by line
        Readln(F, temp);
        // Storing the line inside an array
        localCode.code[line] := temp;
        // Going to next line
        line := line + 1;
      Until Eof(F);
      CloseFile(F);
    except
      on E: EInOutError do
      Begin    
        // If it does throw an error, write it
        writeln('Could not read ', FileFrom);
      End;
    End;
    s1 := line;
    ReadXMLFile := localCode;
  End;      
              
  // Writing the pure Code
  Procedure printCode(thecode : codeFile);
  var i : integer;
  Begin
    writeln;
    writeln('== CODE ==');
    writeln;
    // Going through all the lines and writing them.
    for i := 0 to s1 do
    Begin
      writeln(thecode.code[i]);
    End; 
    writeln; 
    writeln('== END OF CODE ==');
    writeln;
  End;  
              
  // Writing the tags
  Procedure printTags();
  var i, ii : integer;
  Begin  
    writeln;
    writeln('== TAGS ==');
    writeln;
    // Going through all the tags and writing them.
    for i := 0 to tagamount do
    Begin
      writeln(tags[i].name , ' FL: ' , tags[i].fromLine , ' FC: ' , tags[i].fromChar , ' TL: ' , tags[i].toLine , ' TC: ' , tags[i].toChar);
      // If this tag has subtags, go through them all and write them too.
      if (tags[i].hasSub) then
      Begin
        for ii := 0 to tags[i].subAmount do
          writeln('  - ' , tags[i].subTag[ii].name , ' FL: ' , tags[i].subTag[ii].fromLine , ' FC: ' , tags[i].subTag[ii].fromChar , ' TL: ' , tags[i].subTag[ii].toLine , ' TC: ' , tags[i].subTag[ii].toChar);
      End;
    End;  
    writeln; 
    writeln('== END OF TAGS ==');
    writeln;
  End;

  Function TagReader : boolean;
  var rti, rtii, si : integer;
  Begin
    for rti := 0 to tagamount do
    Begin
      if not (analyzer(tags[rti].fromLine, tags[rti].fromChar, tags[rti].toLine, tags[rti].toChar, false, rti, 0)) then
      Begin
        TagReader := false;
        exit;
      End;
      if (tags[rti].hasSub) then
      Begin
        for rtii := 0 to tags[rti].subAmount do
        Begin
          if not (analyzer(tags[rti].subTag[rtii].fromLine, tags[rti].subTag[rtii].fromChar, tags[rti].subTag[rtii].toLine, tags[rti].subTag[rtii].toChar, true, rti, rtii)) then
          Begin
            TagReader := false;
            exit;
          End;
        End;
      End;
    End;
    tagReader := true;
  End;

  Function analyzer(fromLine, fromChar, toLine, toChar : integer; inSub : boolean; tagID, subTagID : integer) : boolean;
  var ai, aii, ifrom, ito, currentData, stage : integer;
      tempname : String;
  Begin
    currentData := 0;
    stage := 0;    
    tempname := '';
    for ai := fromLine to toLine do
    Begin 
      ifrom := 0;
      ito := length(processedCode.code[ai]);
      if (ai = fromLine) then ifrom := fromChar;
      if (ai = toLine) then ito := toChar;

      for aii := ifrom to ito do
      Begin
        if ((ord(processedCode.code[ai][aii]) <> 21) AND (ord(processedCode.code[ai][aii]) <> 26) AND (ord(processedCode.code[ai][aii]) <> 27)) then
        Begin
          if ((stage = -1) AND (not (processedCode.code[ai][aii] = ' '))) then stage := 0;

          if (stage = 0) then
          Begin
            if ((processedCode.code[ai][aii] = '=') OR (processedCode.code[ai][aii] = ' ')) then
            Begin
              if (inSub) then tags[tagID].subTag[subTagID].data[currentData].name := tempname
              else tags[tagID].data[currentData].name := tempname;
              tempname := '';
              if (processedCode.code[ai][aii] = '=') then stage := 1;
            End
            Else
            Begin
              if (processedCode.code[ai][aii] in ALPHA) then tempname := tempname + processedCode.code[ai][aii];
            End;
          End
          Else if ((stage = 1) AND (processedCode.code[ai][aii] = '"')) then stage := 2
          Else if (stage = 2) then
          Begin
            if (processedCode.code[ai][aii] = '"') then
            Begin
              if (inSub) then
              Begin
                tags[tagID].subTag[subTagID].data[currentData].value := tempname;
                tags[tagID].subTag[subTagID].dataAm := currentData;
              End
              Else
              Begin
                tags[tagID].data[currentData].value := tempname;  
                tags[tagID].dataAm := currentData;
              End;
              currentData := currentData + 1;
              tempname := '';
              stage := -1;
            End
            Else tempname := tempname + processedCode.code[ai][aii];
          End;
        End;
      End;
    End;
    analyzer := true;
  End;

end.
