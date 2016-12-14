unit XMLExecuter;
interface       
  Uses GlobalVariables, EntityManager, sysutils, crt, LevelManager;

  const ALPHA = ['A'..'Z', 'a'..'z']; 
                                  
  Function runTags : boolean;
  Function executeTag(tagType : String; tagContent : Array of TagData; tagContentAmount : integer; tagHasSub : boolean; subTags : Array of codeTag; tagSubAmount : integer) : boolean;

implementation

  Function runTags : boolean;
  var rti{, rtii, si } : integer;
      status : boolean;
  Begin
    status := true;
    for rti := 0 to tagamount do
      if (status) then status := executeTag(tags[rti].name, tags[rti].data, tags[rti].dataAm, tags[rti].hasSub, tags[rti].subTag, tags[rti].subAmount);
    runTags := status;
  End;

  Function executeTag(tagType : String; tagContent : Array of TagData; tagContentAmount : integer; tagHasSub : boolean; subTags : Array of codeTag; tagSubAmount : integer) : boolean;
  var l, r, u, d, i, tc, bc, life, damage, et, fx, fy, tx, ty, id : integer;
      collidable, sl, pl, pn, fgt : boolean;
      character : Char;
      name : String;
      data : levelsdata;
  Begin
    if (tagType = 'KeyAction') then
    Begin
      if ((tagContentAmount = 3) AND (KeyActionsAmount <= 4)) then
      Begin
        l := 101001155;
        r := 101001155;
        u := 101001155;
        d := 101001155;

        for i := 0 to tagContentAmount do
        Begin
          if (tagContent[i].name = 'Right') then
          Begin
            Try
              r := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                r := 101001159;
            end;
          End
          else if (tagContent[i].name = 'Left') then
          Begin
            Try
              l := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                l := 101001159;
            end;
          End
          else if (tagContent[i].name = 'Up') then
          Begin
            Try
              u := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                u := 101001159;
            end;
          End
          else if (tagContent[i].name = 'Down') then
          Begin
            Try
              d := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                d := 101001159;
            end;
          End;
        End;

        if ((l <> 101001155) AND (l <> 101001159) AND (r <> 101001155) AND (r <> 101001159) AND (u <> 101001155) AND (u <> 101001159) AND (d <> 101001155) AND (d <> 101001159)) then
        Begin
          setKeyActions(KeyActionsAmount, l, r, u, d);
          KeyActionsAmount := KeyActionsAmount + 1;
        End
        else
        Begin
          TextColor(4);
          writeln('The ' , tagType , ' doesnt have the required data to run! It needs a Left, Right, Up and Down value.');
          if (l = 101001155) then writeln(' - Left is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (l = 101001159) then writeln(' - Left is not numeric.');
          if (r = 101001155) then writeln(' - Right is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (r = 101001159) then writeln(' - Right is not numeric.');
          if (u = 101001155) then writeln(' - Up is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (u = 101001159) then writeln(' - Up is not numeric.');
          if (d = 101001155) then writeln(' - Down is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (d = 101001159) then writeln(' - Down is not numeric.');
          TextColor(7);

          executeTag := false;
          exit;
        End;

        executeTag := true;
        exit;
      End; 

      TextColor(4);
      if (KeyActionsAmount > 4) then writeln('The ' , tagType , ' has too many KeyActions, only 5 allowed.');
      if not (KeyActionsAmount > 3) then writeln('The ' , tagType , ' doesnt have the required data to run! It needs a Left, Right, Up and Down value.');
      TextColor(7);
      executeTag := false;
      exit;
    End
    Else if (tagType = 'EntityType') then
    Begin     
      if (tagContentAmount = 1) then
      Begin
        life := 101001155;
        damage := 101001155;

        for i := 0 to tagContentAmount do
        Begin
          if (tagContent[i].name = 'Damage') then
          Begin
            Try
               damage := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                damage := 101001159;
            end;
          End
          Else if (tagContent[i].name = 'Life') then
          Begin
            Try
               life := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                life := 101001159;
            end;
          End;
        End;

        if ((life <> 101001155) AND (life <> 101001159) AND (damage <> 101001155) AND (damage <> 101001159)) then
        Begin
          setEntity(EntityTypeAmount, damage, life);
          EntityTypeAmount := EntityTypeAmount + 1;
        End
        else
        Begin
          TextColor(4);
          writeln('The ' , tagType , ' doesnt have the required data to run! It needs a Damage and Life value.');
          if (damage = 101001155) then writeln(' - Damage is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (damage = 101001159) then writeln(' - Damage is not numeric.');      
          if (life = 101001155) then writeln(' - Life is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (life = 101001159) then writeln(' - Life is not numeric.');
          TextColor(7);

          executeTag := false;
          exit;
        End;

        executeTag := true;
        exit;
      End;

      executeTag := false;
      exit;
    End
    Else if (tagType = 'EntityModel') then
    Begin    
      if (tagContentAmount = 4) then
      Begin
        bc := 101001155;
        tc := 101001155;
        et := 101001155;    
        character := chr(146);
        name := 'not_supposed_to_be_used';

        for i := 0 to tagContentAmount do
        Begin
          if (tagContent[i].name = 'EntityType') then
          Begin
            Try
               et := StrToInt(tagContent[i].value);
               if (et >= EntityTypeAmount) then et := 101001158;
            except
              On E : EConvertError do
                et := 101001159;
            end;
          End
          Else if (tagContent[i].name = 'BackgroundColor') then
          Begin
            Try
               bc := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                bc := 101001159;
            end;
          End
          Else if (tagContent[i].name = 'TextColor') then
          Begin
            Try
               tc := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                tc := 101001159;
            end;
          End
          else if (tagContent[i].name = 'Character') then character := tagContent[i].value[1]
          else if (tagContent[i].name = 'Name') then name := tagContent[i].value;
        End;

        if ((et <> 101001155) AND (et <> 101001159)  AND (et <> 101001158) AND (tc <> 101001155) AND (tc <> 101001159) AND (bc <> 101001155)  AND (bc <> 101001159) AND (name <> 'not_supposed_to_be_used') AND (character <> chr(146))) then
        Begin
          setFullEntity(EntityModelAmount, et, bc, tc, character, name);
          EntityModelAmount := EntityModelAmount + 1;
        End
        else
        Begin
          TextColor(4);
          writeln('The ' , tagType , ' doesnt have the required data to run! It needs a EntityType, BackgroundColor, TextColor, Character and a Name value.');
          if (et = 101001155) then writeln(' - EntityType is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (et = 101001159) then writeln(' -  EntityType is not numeric.')
          else if (et = 101001158) then writeln(' -  The EntityType choosen is not available.');
          if (tc = 101001155) then writeln(' - TextColor is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (tc = 101001159) then writeln(' - TextColor is not numeric.');
          if (bc = 101001155) then writeln(' - BackgroundColor is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (bc = 101001159) then writeln(' - BackgroundColor is not numeric.');
          if (name = 'not_supposed_to_be_used') then writeln(' - Name is missing. Confirm if you are using the correnct Uppercase letters.');
          if (character = chr(146)) then writeln(' - Character is missing. Confirm if you are using the correnct Uppercase letters.');
          TextColor(7);

          executeTag := false;
          exit;
        End;

        executeTag := true;
        exit;
      End;

      executeTag := false;
      exit;
    End
    Else if (tagType = 'BlockType') then
    Begin
      if (tagContentAmount >= 3) then
      Begin
        collidable := false;
        tc := 101001155;
        bc := 101001155;
        character := chr(146);
        name := 'not_supposed_to_be_used';

        for i := 0 to tagContentAmount do
        Begin
          if (tagContent[i].name = 'TextColor') then
          Begin
            Try
              tc := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                tc := 101001159;
            end;
          End
          else if (tagContent[i].name = 'BackgroundColor') then
          Begin
            Try
              bc := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                bc := 101001159;
            end;
          End
          else if (tagContent[i].name = 'Collidable') then
          Begin
            if (tagContent[i].value = 'true') then collidable := true
            else if (tagContent[i].value = 'false') then collidable := false;
          End
          else if (tagContent[i].name = 'Character') then character := tagContent[i].value[1]
          else if (tagContent[i].name = 'Name') then name := tagContent[i].value;
        End;

        if ((tc <> 101001155) AND (tc <> 101001159) AND (bc <> 101001155)  AND (bc <> 101001159) AND (name <> 'not_supposed_to_be_used') AND (character <> chr(146))) then
        Begin     
          setBlock(BlocksTypeAmount, tc, bc, name, character, collidable);
          BlocksTypeAmount := BlocksTypeAmount + 1;
        End
        else
        Begin
          TextColor(4);
          writeln('The ' , tagType , ' doesnt have the required data to run! It needs a TextColor, BackgroundColor, Character and a Name value.');
          if (tc = 101001155) then writeln(' - TextColor is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (tc = 101001159) then writeln(' - TextColor is not numeric.');
          if (bc = 101001155) then writeln(' - BackgroundColor is missing. Confirm if you are using the correnct Uppercase letters.')
          else if (bc = 101001159) then writeln(' - BackgroundColor is not numeric.');
          if (name = 'not_supposed_to_be_used') then writeln(' - Name is missing. Confirm if you are using the correnct Uppercase letters.');
          if (character = chr(146)) then writeln(' - Character is missing. Confirm if you are using the correnct Uppercase letters.');
          TextColor(7);

          executeTag := false;
          exit;
        End;

        executeTag := true;
        exit;
      End;

      executeTag := false;
      exit;
    End
    Else if (tagType = 'Level') then
    Begin   
      name := 'not_supposed_to_be_used';
      fgt := true;
      fx := 101001155;
      fy := 101001155;
      tx := 101001155;
      ty := 101001155;
      id := 101001155;

      for i := 0 to tagContentAmount do
      Begin
        if (tagContent[i].name = 'FromX') then
        Begin  
            Try
              fx := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                fx := 101001159;
            end;
        End
        Else if (tagContent[i].name = 'FromY') then
        Begin
            Try
              fy := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                fy := 101001159;
            end;
        End
        Else if (tagContent[i].name = 'ToX') then
        Begin
            Try
              tx := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                tx := 101001159;
            end;
        End
        Else if (tagContent[i].name = 'ToY') then
        Begin
            Try
              ty := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                ty := 101001159;
            end;
        End
        Else if (tagContent[i].name = 'ForceGoThrough') then
        Begin
          if (tagContent[i].value = 'true') then fgt := true
          else if (tagContent[i].value = 'false') then fgt := false;
        End
        Else if (tagContent[i].name = 'ID') then
        Begin    
            Try
              id := StrToInt(tagContent[i].value);
            except
              On E : EConvertError do
                id := 101001159;
            end;
        End
        Else if (tagContent[i].name = 'Name') then name := tagContent[i].value;
      End;

      if ((fx <> 101001155) AND (fx <> 101001159) AND (fy <> 101001155)  AND (fy <> 101001159) AND (id <> 101001155)  AND (id <> 101001159) ) then
      Begin
        data.id := id;
        data.name := name;
        data.through := fgt;

        LevelsAmount := LevelsAmount + 1;
        
        executeTag := true;
        exit;
      End
      else
      Begin
        TextColor(4);
        writeln('The ' , tagType , ' doesnt have the required data to run! It needs a FromX, FromY, ToX, ToY and a ID value.');
        if (fx = 101001155) then writeln(' - FromX is missing. Confirm if you are using the correnct Uppercase letters.')
        else if (fx = 101001159) then writeln(' - FromX is not numeric.');
        if (fy = 101001155) then writeln(' - FromY is missing. Confirm if you are using the correnct Uppercase letters.')
        else if (fy = 101001159) then writeln(' - FromY is not numeric.');
        if (id = 101001155) then writeln(' - ID is missing. Confirm if you are using the correnct Uppercase letters.')
        else if (id = 101001159) then writeln(' - ID is not numeric.');
        TextColor(7);

        executeTag := true;
        exit;
      End;

      executeTag := false;
      exit;
    End
    Else if (tagType = 'ScoreBoard') then
    Begin
      sl := true;
      pl := true;
      pn := true;
      character := '/';

      for i := 0 to tagContentAmount do
      Begin
        if (tagContent[i].name = 'ShowLevel') then
        Begin
          if (tagContent[i].value = 'true') then sl := true
          else if (tagContent[i].value = 'false') then sl := false;
        End
        else if (tagContent[i].name = 'ShowEachPlayerLife') then
        Begin
          if (tagContent[i].value = 'true') then pl := true
          else if (tagContent[i].value = 'false') then pl := false;
        End
        else if (tagContent[i].name = 'ShowEachPlayerName') then
        Begin
          if (tagContent[i].value = 'true') then pn := true
          else if (tagContent[i].value = 'false') then pn := false;
        End
        else if (tagContent[i].name = 'SeperatorCharacter') then character := tagContent[i].value[1];
      End;

      ShowLevel := sl;
      ShowEachPlayerName := pl;
      ShowEachPlayerLife := pn;
      SeperatorCharacter := character;

      executeTag := true;
      exit;
    End;

    TextColor(4);
    writeln('Unabled to find ' , tagType ,'. This is a Unknown XML Tag.');
    TextColor(7);
    executeTag := false;
  End;

end.
