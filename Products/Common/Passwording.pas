unit Passwording;

interface

uses Math;

function GenerateNewPassword: AnsiString;
function Encrypt(ss: AnsiString): AnsiString;
function Decode(ss: AnsiString): AnsiString;

implementation

function GenerateNewPassword: AnsiString;
var
  i, j: integer;
  s, ss: AnsiString;

begin
  Randomize;
  ss := '';

  for i := 1 to 8 do
  begin
    j := RandomRange(0, 9);
    str(j, s);
    ss := ss + s;
  end;

  Result := ss;
end;

function Encrypt(ss: AnsiString): AnsiString;
var
  i, j, k: integer;
  s, ss2: AnsiString;
  Code: integer;
  CheckDigit7, CheckDigit10: integer;

begin
  k := 0;
  for i := 1 to 8 do
  begin
    val(copy(ss, i, 1), j, Code);
    k := k + j;
  end;
  CheckDigit7 := k mod 7;
  str(CheckDigit7, s);
  ss := ss + s;
  CheckDigit10 := k mod 10;
  str(CheckDigit10, s);
  ss := ss + s;

  //Each Character
  ss2 := '';
  for i := 1 to 8 do
  begin
    val(copy(ss, i, 1), j, Code);
    case i of
      1: j := j + 6 + CheckDigit7;
      2: j := j + 3;
      3: j := j + 4;
      4: j := j + 1 + CheckDigit10;
      5: j := j + 1 + CheckDigit7;
      6: j := j + 2;
      7: j := j + 7 + CheckDigit7 + CheckDigit10;
      8: j := j + 6;
    end;
    j := j mod 10;
    str(j, s);
    ss2 := ss2 + s;
  end;

  //Add Check Digits
  ss2 := ss2 + ss[9] + ss[10];

  Result := ss2;
end;

function Decode(ss: AnsiString): AnsiString;
var
  Valid: Boolean;
  i, j: integer;
  s, ss2: AnsiString;
  Code: integer;
  CheckDigit7, CheckDigit10: integer;

begin
  Valid := True;
  if Length(ss) <> 10 then
    Valid := False
  else
  begin
    for i := 1 to 10 do
    begin
      if ((ss[i] < '0') or (ss[i] > '9')) then
        Valid := False;
    end;
  end;

  if Valid then
  begin
    //Read Checkdigits
    val(copy(ss, 9, 1), CheckDigit7, Code);
    val(copy(ss, 10, 1), CheckDigit10, Code);

    //Each Character
    ss2 := '';
    for i := 1 to 8 do
    begin
      val(copy(ss, i, 1), j, Code);
      case i of
        1: j := j - 6 - CheckDigit7;
        2: j := j - 3;
        3: j := j - 4;
        4: j := j - 1 - CheckDigit10;
        5: j := j - 1 - CheckDigit7;
        6: j := j - 2;
        7: j := j - 7 - CheckDigit7 - CheckDigit10;
        8: j := j - 6;
      end;
      j := j + 100;
      j := j mod 10;
      str(j, s);
      ss2 := ss2 + s;
    end;
  end
  else
    ss2 := 'Invalid Request Code';

  Result := ss2;
end;

end.
