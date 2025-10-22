unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, IniFiles, ShellAPI, Grids, DBGrids, jpeg, ExtCtrls,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Phys.ADS, FireDAC.Comp.UI, Vcl.ComCtrls,
  FireDAC.Comp.DataMove;

type
  TVersion = record
    Major: integer;
    Minor: integer;
  end;

  TInterlockingParameters = record
    Amended: Boolean;
    InterlockTolerance: integer;
    LayplanTolerance: integer;
  end;

  TfmUpgrade = class(TForm)
    adsSumms7: TFDConnection;
    btnImport: TButton;
    Image1: TImage;
    tblElements: TFDTable;
    tblElementTimes: TFDTable;
    tblCuttingElements: TFDTable;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysADSDriverLink: TFDPhysADSDriverLink;
    adsSumms8: TFDConnection;
    reElements: TRichEdit;
    reCuttingElements: TRichEdit;
    qImport: TFDQuery;
    edtSumms8Dic: TEdit;
    edtSumms7Dic: TEdit;
    reHelp: TRichEdit;
    lblSumms7Dic: TLabel;
    lblSumms8Dic: TLabel;
    edtPassword7: TEdit;
    edtPassword8: TEdit;
    lblPassword7: TLabel;
    lblPassword8: TLabel;
    tblParameters: TFDTable;
    qKnivesCorrect: TFDQuery;
    lblHelp: TLabel;
    lblWarning: TLabel;
    procedure btnImportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    function DatabaseVersion(Connection: TFDConnection): TVersion;
    procedure ConnectToDatabase(Connection: TFDConnection; UserName, Password: string; Major, Minor: integer);
    procedure ReadResources;
    procedure FillCuttingElements;
    function CheckInterlockingParameters: TInterlockingParameters;
    procedure AddFormattedText(re: TRichEdit; const AText: string; AStyle: TFontStyles);
    procedure ReadDictionaries;
    function FilenameFromEnvironment(Filename: string): string;
    function GetDictionary(Ini: TIniFile; Alias: string): string;
    procedure MatchUsers(Connection7, Connection8: TFDConnection);
  public
    { Public declarations }
  end;

var
  fmUpgrade: TfmUpgrade;

implementation

{$R *.dfm}

procedure TfmUpgrade.btnImportClick(Sender: TObject);
var
  SystemError: Boolean;
  InterlockingParameters: TInterlockingParameters;
  s: string;

begin
  SystemError := False;
  ConnectToDatabase(adsSumms7, 'adssys', 'monster', 7, 4);
  ConnectToDatabase(adsSumms8, 'adssys', 'monster', 8, 0);
  if (not adsSumms7.Connected) or  (not adsSumms8.Connected) then
    SystemError := True;
  if adsSumms7.Connected then
    adsSumms7.Connected := False;
  if adsSumms8.Connected then
    adsSumms8.Connected := False;

  if SystemError then
  begin
    messagedlg('Problems connecting to the databases. Check your ADS.INI settings and that you have the correct DLLS', mtError, [mbOk], 0);
    Close;
  end
  else
  begin
    ConnectToDatabase(adsSumms7, 'supervisor', edtPassword7.Text, 7, 4);
    ConnectToDatabase(adsSumms8, 'supervisor', edtPassword8.Text, 8, 0);

    if not adsSumms7.connected then
      messagedlg('Invalid SATRASumm 7.4 password or not a 7.4 Database', mtInformation, [mbOk], 0)
    else if not adsSumms8.connected then
      messagedlg('Invalid SATRASumm 8.0 password or not an 8.0 Database', mtInformation, [mbOk], 0)
    else
    begin
      adsSumms7.Connected := False;
      adsSumms8.Connected := False;

      if messagedlg('WARNING: This will wipe your existing' + sLineBreak +
                    'SATRASumm 8 database and may take ' + sLineBreak +
                    'several hours to complete. Continue?', mtConfirmation,
                    [mbYes, mbNo], 0) = mrYes then
      begin
        btnImport.Visible := False;
        lblHelp.Visible := False;
        lblWarning.Visible := True;
        Repaint;

        ConnectToDatabase(adsSumms7, 'adssys', 'monster', 7, 4);
        ConnectToDatabase(adsSumms8, 'adssys', 'monster', 8, 0);

        if not adsSumms7.connected then
          messagedlg('Cannot connect to a SATRASumm 7.4 Database', mtInformation, [mbOk], 0)
        else if not adsSumms8.connected then
          messagedlg('Cannot connect to a SATRASumm 8.0 Database', mtInformation, [mbOk], 0)
        else
        begin
          screen.Cursor := crHourGlass;

          qImport.Params.ParamByName('Summs7Dic').Value := edtSumms7Dic.Text;
          qImport.execSQL;
          ReadResources;
          FillCuttingElements;
          InterlockingParameters := CheckInterlockingParameters;
          MatchUsers(adsSumms7, adsSumms8);

          qKnivesCorrect.ExecSQL;

          screen.Cursor := crDefault;

          s := 'Some knives may need reassessing due to improvements in version 8.' + slineBreak +
               'See Pattern Assessment for list. Expect minor changes to allowances.';
          messagedlg(s, mtInformation, [mbok], 0);

          s := 'Update complete. All user passwords in the' + sLineBreak + sLineBreak +
               'new database reset to default of ''SATRA''';
          if InterlockingParameters.Amended then
            s := s + sLineBreak + sLineBreak +
                 'WARNING: Interlocking Parameters reset correctly (Originally ' +
                 intToStr(InterlockingParameters.InterlockTolerance) + ' , ' +
                 intToStr(InterlockingParameters.LayplanTolerance) + ')' + sLineBreak +
                 'Please recalculate all allowances - CONTACT SATRA FOR MORE INFORMATION';

          messagedlg(s, mtInformation, [mbOk], 0);
        end;

        btnImport.Visible := True;
        lblHelp.Visible := True;
        lblWarning.Visible := False;
        Repaint;
      end;
    end;
  end;
end;

procedure TfmUpgrade.ReadDictionaries;
var
  AdsIni: TIniFile;
  AdsFileName: string;

begin
  AdsFileName := FileNameFromEnvironment('ads.ini');
  if AdsFileName <> '' then
  begin
    AdsIni := TIniFile.Create(AdsFileName);
    edtSumms7Dic.Text := GetDictionary(AdsIni, 'Summs7');
    edtSumms8Dic.Text := GetDictionary(AdsIni, 'SATRASumm8');
    AdsIni.Free;
  end;
end;

function TfmUpgrade.GetDictionary(Ini: TIniFile; Alias: string): string;
var
  s: string;

begin
  s := Ini.ReadString('Databases', Alias, '');
  if Length(s) > 2 then
  begin
    if copy(s, Length(s) - 1, 2) = ';D' then
      s := copy(s, 1, Length(s) - 2);
  end;

  Result := s;
end;

function TfmUpgrade.DatabaseVersion(Connection: TFDConnection): TVersion;
var
  qSystem: TFDQuery;
  Version: TVersion;

begin
  qSystem := TFDQuery.Create(Connection);
  qSystem.Connection := Connection;
  qSystem.SQL.Add('select Version_Major, Version_Minor from system.dictionary');
  qSystem.Open;
  Version.Major := qSystem.FieldByName('Version_Major').Value;
  Version.Minor := qSystem.FieldByName('Version_Minor').Value;
  qSystem.Close;
  qSystem.Free;

  Result := Version;
end;

procedure TfmUpgrade.ConnectToDatabase(Connection: TFDConnection; UserName, Password: string; Major, Minor: integer);
var
  db: string;
  Version: TVersion;

begin
  db := 'Database=';
  if Connection.Name = 'adsSumms7' then
    db := db + edtSumms7Dic.Text
  else if Connection.Name = 'adsSumms8' then
    db := db + edtSumms8Dic.Text;

  Connection.Params.Clear;
  Connection.Params.Add(db);
  Connection.Params.Add('ServerTypes=Remote');
  Connection.Params.Add('Protocol=TCPIP');
  Connection.Params.Add('User_name=''' + UserName + '''');
  Connection.Params.Add('Password=''' + Password + '''');
  Connection.Params.Add('DriverID=ADS');

  try
    Connection.Connected := True;
    Version := DatabaseVersion(Connection);
    if not ((Version.Major = Major) and (Version.Minor = Minor)) then
      Connection.Connected := False;
  except
    Connection.Connected := False;
  end;
end;

procedure TfmUpgrade.ReadResources;
var
  RS: TResourceStream;

begin
  RS := TResourceStream.CreateFromID(HInstance, 100, RT_RCDATA);
  try
    reElements.Lines.LoadFromStream(RS);
  finally
    RS.Free;
  end;
  RS := TResourceStream.CreateFromID(HInstance, 101, RT_RCDATA);
  try
    reCuttingElements.Lines.LoadFromStream(RS);
  finally
    RS.Free;
  end;
end;

procedure TfmUpgrade.FillCuttingElements;
var
  s1, s2, s3, s4: String;
  r4: real;
  Code: integer;
  NoElements, i: integer;

begin
  tblElements.Open;
  tblElementTimes.Open;
  tblCuttingElements.Open;

  NoElements := reElements.Lines.Count div 4;
  for i := 1 to NoElements do
  begin
    s1 := reElements.Lines[((i - 1) * 4) + 0];
    s2 := reElements.Lines[((i - 1) * 4) + 1];
    s3 := reElements.Lines[((i - 1) * 4) + 2];
    s4 := reElements.Lines[((i - 1) * 4) + 3];
    val(s4, r4, Code);

    tblElements.Insert;
    tblElements.FieldByName('Code').Value := s1;
    tblElements.FieldByName('Description').Value := s2;
    tblElements.FieldByName('CuttingCategory').Value := s3;
    tblElements.Post;

    tblElementTimes.Insert;
    tblElementTimes.FieldByName('Code').Value := s1;
    tblElementTimes.FieldByName('Time').Value := r4;
    tblElementTimes.Post;
  end;

  NoElements := reCuttingElements.Lines.Count div 4;
  for i := 1 to NoElements do
  begin
    s1 := reCuttingElements.Lines[((i - 1) * 4) + 0];
    s2 := reCuttingElements.Lines[((i - 1) * 4) + 1];
    s3 := reCuttingElements.Lines[((i - 1) * 4) + 2];
    s4 := reCuttingElements.Lines[((i - 1) * 4) + 3];

    tblCuttingElements.Insert;
    tblCuttingElements.FieldByName('ElementNo').Value := s1;
    tblCuttingElements.FieldByName('Reason').Value := s2;
    tblCuttingElements.FieldByName('Element').Value := s3;
    if s4 = 'True' then
      tblCuttingElements.FieldByName('Use').Value := True
    else
      tblCuttingElements.FieldByName('Use').Value := False;
    tblCuttingElements.Post;
  end;

  tblCuttingElements.Close;
  tblElementTimes.Close;
  tblElements.Close;
end;

function TfmUpgrade.CheckInterlockingParameters: TInterlockingParameters;
var
  InterlockTolerance, LayplanTolerance: integer;
  Amended: Boolean;

begin
  Amended := False;

  tblParameters.Open;

  InterlockTolerance := tblParameters.FieldByName('InterlockingToleranceInterlock').Value;
  LayplanTolerance := tblParameters.FieldByName('InterlockingToleranceLayplans').Value;

  if (InterlockTolerance <> 1000) or (LayplanTolerance <> 100) then
  begin
    tblParameters.Edit;
    tblParameters.FieldByName('InterlockingToleranceInterlock').Value := 1000;
    tblParameters.FieldByName('InterlockingToleranceLayplans').Value := 100;
    tblParameters.Post;

    Amended := True;
  end;

  tblParameters.Close;

  Result.Amended := Amended;
  Result.InterlockTolerance := InterlockTolerance;
  Result.LayplanTolerance := LayplanTolerance;
end;

procedure TfmUpgrade.FormCreate(Sender: TObject);
begin
  ReadDictionaries;

  AddFormattedText(rehelp, 'The usual Advantage files to use are ' +
                           'set in the ADS.ini file, see examples below ' +
                           'highlighting the file names. This ' +
                           'routine can be used to import any SATRASumm 7.4 ' +
                           'database into any SATRASumm 8.0 database.' +
                           sLineBreak + sLineBreak, []);
  AddFormattedText(rehelp, 'Summs7=', []);
  AddFormattedText(rehelp, 'C:\Program Files (x86)\SATRA-ADS\SATRASumm7\SATRASumm7Database\Summs.add', [fsBold]);
  AddFormattedText(rehelp, ';D' + sLineBreak, []);
  AddFormattedText(rehelp, 'SATRASumm8=', []);
  AddFormattedText(rehelp, 'C:\Program Files (x86)\SATRA-ADS\SATRASumm8\SATRASumm8Database\Summs.add', [fsBold]);
  AddFormattedText(rehelp, ';D' + sLineBreak, []);
end;

procedure TfmUpgrade.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    SelectNext(ActiveControl, True, True);
    if ActiveControl = btnImport then
      btnImport.Click;
  end;
end;

procedure TfmUpgrade.AddFormattedText(re: TRichEdit; const AText: string; AStyle: TFontStyles);
begin
  re.SelStart := reHelp.GetTextLen;
  re.SelLength := 0;
  re.SelAttributes.Style := AStyle;
  re.SelText := AText;
end;

function TfmUpgrade.FilenameFromEnvironment(Filename: string): string;
var
  SPPath: array[0..255] of char;
  PathPtr: PChar;
  FullFilename: string;

begin
  if SearchPath(nil, PChar(FileName), nil, 255, SPPath, PathPtr)>0 then
    FullFileName := StrPas(SPPath)
  else
    FullFileName := '';

  Result := FullFileName;
end;

procedure TfmUpgrade.MatchUsers(Connection7, Connection8: TFDConnection);

  function ReadNormalUsers(Connection: TFDConnection): TStringList;
  var
    slUsers: TStringList;
    qSystem: TFDQuery;
    User: string;

  begin
    slUsers := TStringList.Create;
    slUsers.Sorted := True;

    qSystem := TFDQuery.Create(Connection);
    qSystem.Connection := Connection;
    qSystem.SQL.Add('select * from system.users');
    qSystem.Open;

    qSystem.RecNo := 1;
    qSystem.Prior;
    while not qSystem.eof do
    begin
      User := qSystem.FieldByName('Name').value;

      if (User <> 'ADSSYS') and (User <> 'SUPERVISOR') then
        slUsers.Add(User);

      qSystem.Next;
    end;

    qSystem.Close;
    qSystem.Free;

    Result := slUsers;
  end;

  procedure RemoveUsers(Connection: TFDConnection; Users: TStringList);
  var
    qSystem: TFDQuery;
    i: integer;

  begin
    if Users.Count > 0 then
    begin
      qSystem := TFDQuery.Create(Connection);
      qSystem.Connection := Connection;
      for i := 0 to Users.Count - 1 do
        qSystem.SQL.Add('EXECUTE PROCEDURE sp_DropUser(''' + Users[i] + ''');');
      qSystem.ExecSQL;
      qSystem.Free;
    end;
  end;

var
  Users: TStringList;
  qSystem, qSystem2: TFDQuery;
  i: integer;
  GroupName: string;

begin
  Users := ReadNormalUsers(Connection8);
  RemoveUsers(Connection8, Users);
  Users := ReadNormalUsers(Connection7);

  if Users.Count > 0 then
  begin
    qSystem := TFDQuery.Create(Connection8);
    qSystem.Connection := Connection8;
    for i := 0 to Users.Count - 1 do
    begin
      qSystem.SQL.Add('EXECUTE PROCEDURE sp_CreateUser(''' + Users[i] + ''', ''SATRA'', NULL);');


      qSystem2 := TFDQuery.Create(Connection7);
      qSystem2.Connection := Connection7;
      qSystem2.SQL.Add('select * from system.UserGroupMembers where user_name = ''' + Users[i] + '''');
      qSystem2.Open;

      qSystem2.RecNo := 1;
      qSystem2.Prior;
      while not qSystem2.eof do
      begin
        GroupName := qSystem2.FieldByName('Group_Name').value;

        if not (((Length(GroupName) >= 3) and (Copy(GroupName, 1, 3) = 'DB:')) or
                ((Length(GroupName) >= 7) and (Copy(GroupName, 1, 7) = 'SERVER:'))) then
          qSystem.SQL.Add('EXECUTE PROCEDURE sp_AddUserToGroup(''' + Users[i] + ''', ''' + GroupName + ''');');

        qSystem2.Next;
      end;
    end;

    qSystem2.Close;
    qSystem2.Free;

    qSystem.ExecSQL;
    qSystem.Free;
  end;
end;

end.

