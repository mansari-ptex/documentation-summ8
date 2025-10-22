unit Encryption;

interface

uses Math;

function GenerateCodeToSATRA: string;
function GenerateCodeFromSATRA(CodeIn: string): string;

implementation

function GenerateCodeToSATRA: string;
var
  i, j, k, l: integer;
  s, ss: string;
  Code: integer;

begin
  Randomize;
  ss := '';

  for i := 1 to 8 do
  begin
    j := RandomRange(0, 9);
    str(j, s);
    ss := ss + s;
  end;

  k := 0;
  for i := 1 to 8 do
  begin
    val(copy(ss, i, 1), j, Code);
    k := k + j;
  end;
  l := k mod 7;
  str(l, s);
  ss := ss + s;
  l := k mod 10;
  str(l, s);
  ss := ss + s;

  Result := ss;
end;

function GenerateCodeFromSATRA(CodeIn: string): string;
var
  Valid: Boolean;
  i, j, k, l: integer;
  s, ss, ss2: string;
  Code: integer;
  CheckDigit7, CheckDigit10: integer;

begin
  ss := CodeIn;

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

    if Valid then
    begin
      k := 0;
      for i := 1 to 8 do
      begin
        val(copy(ss, i, 1), j, Code);
        k := k + j;
      end;
      l := k mod 7;
      CheckDigit7 := l;
      val(copy(ss, 9, 1), j, Code);
      if l <> j then
        Valid := False;
      l := k mod 10;
      CheckDigit10 := l;
      val(copy(ss, 10, 1), j, Code);
      if l <> j then
        Valid := False;
    end;
  end;

  if Valid then
  begin
    k := 0;
    ss2 := '';

    //Each Character
    for i := 1 to 8 do
    begin
      val(copy(ss, 1, i), j, Code);
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

      k := k + j;
    end;

    l := k mod 7;
    str(l, s);
    ss2 := ss2 + s;
    l := k mod 10;
    str(l, s);
    ss2 := ss2 + s;
  end
  else
    ss2 := 'Invalid Request Code';

  Result := ss2;
end;

end.
