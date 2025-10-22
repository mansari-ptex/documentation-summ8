unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  Data.DB, FireDAC.Comp.Client, FDConnectionPlus, Vcl.StdCtrls, FireDAC.Phys.ADS, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, FireDAC.DApt, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FDQueryPlus, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TfmMain = class(TForm)
    ConnectionSumms: TFDConnectionPlus;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    dbgMaterials: TDBGrid;
    dsMaterials: TDataSource;
    tblMaterials: TFDTable;
    tblMaterialsCode: TStringField;
    tblMaterialsNEWCode: TStringField;
    qRefIntRestrict: TFDQueryPlus;
    qRefIntCascade: TFDQueryPlus;
    qUpdate: TFDQueryPlus;
    lblNote: TLabel;
    Image1: TImage;
    pnlLeft: TPanel;
    cbAgree: TCheckBox;
    cbRestart: TCheckBox;
    cbBackup: TCheckBox;
    btnUpdate: TButton;
    procedure dbgMaterialsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure tblMaterialsCalcFields(DataSet: TDataSet);
    procedure btnUpdateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function Connection(TheConnection: TFDConnectionPlus; AliasName, UserName, Password: string): Boolean;
    procedure Connect;
    procedure ResetConnection;
    function CurrentVersion: string;
    function CheckConditions: Boolean;
    function UpdatedCode(Code: string): string;
    procedure CreateUpdateQuery;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  System.StrUtils;


{$R *.dfm}


procedure TfmMain.btnUpdateClick(Sender: TObject);
begin
  if CheckConditions then
  begin
    cbBackup.Enabled := False;
    cbRestart.Enabled := False;
    cbAgree.Enabled := False;
    btnUpdate.Enabled := False;

    CreateUpdateQuery;

    tblMaterials.Close;

    ResetConnection;
    qRefIntCascade.ExecSQL;
    ResetConnection;
    if qUpdate.SQL.Count <> 0 then
      qUpdate.ExecSQL;
    ResetConnection;
    qRefIntRestrict.ExecSQL;
    ResetConnection;

    tblMaterials.Open;

    messagedlg('Rename complete', mtInformation, [mbOk], 0);
  end
  else
    messagedlg('You must agree to the conditions first', mtInformation, [mbOk], 0);
end;


function TfmMain.CheckConditions: Boolean;
begin
  Result := cbBackup.Checked and cbRestart.Checked and cbAgree.Checked;
end;


procedure TfmMain.Connect;
var
  Connected: Boolean;

begin
  Connected := False;
  try
    Connected := Connection(ConnectionSumms, 'SATRASUMM8', 'ADSSYS', 'monster');
  except
    messagedlg('Can not connect to a SATRASumm 8 Database', mtInformation, [mbOk], 0);
  end;

  if Connected then
  begin
    if (CurrentVersion <> '8.3') then
    begin
      messagedlg('This is not a 8.3 database', mtError, [mbOk], 0);
      Connected := False;
    end
    else
    begin
      cbAgree.Enabled := True;
      btnUpdate.Enabled := True;
      tblMaterials.Open;
    end;
  end;

  if Connected then
  begin
    cbAgree.Enabled := True;
    btnUpdate.Enabled := True;
    tblMaterials.Open;
  end
  else
    Close;
end;


function TfmMain.Connection(TheConnection: TFDConnectionPlus; AliasName, UserName, Password: string): Boolean;
var
  s: string;

begin
  try
    TheConnection.DriverName := 'ADS';
    TheConnection.Params.Values['ServerTypes'] := 'Remote';
    TheConnection.Params.Values['Protocol'] := 'TCPIP';
    TheConnection.Params.Values['Alias'] := AliasName;
    TheConnection.Params.Values['User_name'] := UserName;
    TheConnection.Params.Values['Password'] := Password;

    TheConnection.FetchOptions.RecordCountMode := cmVisible;
    TheConnection.FetchOptions.AutoClose := false;
    TheConnection.ResourceOptions.MacroCreate := false;
    TheConnection.ResourceOptions.MacroExpand := false;

    TheConnection.Connected := True;
  except on E: EDataBaseError do
    begin
      if (E is EFDDBEngineException) then
      begin
        if (E as EFDDBEngineException).ErrorCode = 6420 then
        begin
          s := 'This system requires the Advantage Database Server to be running.' + #13 + #13 +
               'Ensure Advantage running and try again.';
        end
        else if (E as EFDDBEngineException).ErrorCode = 7078 then
          s := 'Incorrect User Name or Password.' + #13 + #13 +
               'Please try again.'
        else if (((E as EFDDBEngineException).ErrorCode = 5121) or
                 ((E as EFDDBEngineException).ErrorCode = 5004) or
                 ((E as EFDDBEngineException).ErrorCode = 5021)) then
          s := 'Invalid or missing Alias (' + AliasName + ').'
        else if ((E as EFDDBEngineException).ErrorCode = 6414) then
        begin
          {$IFDEF WIN64}
            s := 'ACE64.DLL is the incorrect version.';
          {$ELSE}
            s := 'ACE32.DLL is the incorrect version.';
          {$ENDIF}
        end
        else
          s := E.message;
        TheConnection.Connected := False;
      end
      else
      begin
        if (Pos('Cannot load vendor library', E.Message) > 0) then
        begin
          {$IFDEF WIN64}
            s := 'ACE64.DLL is missing or the incorrect version.';
          {$ELSE}
            s := 'ACE32.DLL is missing or the incorrect version.';
          {$ENDIF}
        end
        else
          s := E.message;
      end;

      ShowMessage(s);
    end;
  end;

  Result := TheConnection.Connected;
end;


function TfmMain.CurrentVersion: string;
var
  qSystem: TFDQuery;
  VerMajor, VerMinor: integer;
  sMajor, sMinor: string;

begin
  qSystem := TFDQuery.Create(ConnectionSumms);

  qSystem.Connection := ConnectionSumms;
  qSystem.SQL.Add('select Version_Major, Version_Minor from system.dictionary');
  qSystem.Open;
  VerMajor := qSystem.FieldByName('Version_Major').Value;
  VerMinor := qSystem.FieldByName('Version_Minor').Value;
  qSystem.Close;

  qSystem.Free;

  str(VerMajor : 1, sMajor);
  str(VerMinor : 1, sMinor);

  Result := sMajor + '.' + sMinor;
end;


procedure TfmMain.dbgMaterialsDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  //Changes
  if tblMaterials.FieldByName('Code').AsString <> tblMaterials.FieldByName('NewCode').AsString then
    dbgMaterials.Canvas.Brush.Color := clYellow;

  //New Code too long
  if (DataCol = 1) and (Length(tblMaterials.FieldByName('NewCode').AsString) > 20) then
    dbgMaterials.Canvas.Brush.Color := clRed;

  dbgMaterials.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;


procedure TfmMain.FormShow(Sender: TObject);
begin
  Connect;
end;


procedure TfmMain.CreateUpdateQuery;
var
  s: string;

begin
  dsMaterials.DataSet := nil;

  qUpdate.SQL.Clear;

  tblMaterials.First;
  while not tblMaterials.EOF do
  begin
    if tblMaterials.FieldByName('Code').AsString <> tblMaterials.FieldByName('NewCode').AsString then
    begin
       s := 'UPDATE Material ';
       s := s + 'SET Code = ''' + tblMaterials.FieldByName('NewCode').AsString + ''' ';
       s := s + 'WHERE Code = ''' + tblMaterials.FieldByName('Code').AsString + '''; ';

       qUpdate.SQL.Add(s);
    end;

    tblMaterials.Next;
  end;

  dsMaterials.DataSet := tblMaterials;
end;


procedure TfmMain.ResetConnection;
begin
  ConnectionSumms.Connected := False;
  sleep(200);
  if not Connection(ConnectionSumms, 'SATRASUMM8', 'ADSSYS', 'monster') then
    showmessage('Error Resetting connection');
end;


procedure TfmMain.tblMaterialsCalcFields(DataSet: TDataSet);
var
  s: string;
  Update: Boolean;

begin
  Update := True;

  s := DataSet.FieldByName('Code').AsString;

  if (copy(s, 1, 4) = 'TEST') or
     (pos('DUMMY', s) > 0) or
     (pos('CUSTOM', s) > 0) or
     (pos('BC ', s) = 1) or
     (pos('NC ', s) = 1) then
    Update := False;

  if s = 'NC 11-3043/3046' then
    s := 'NC 11-3043 /3046'
  else if Update then
    s := UpdatedCode(s);

  DataSet.FieldByName('NEWCode').AsString := s;
end;


function TfmMain.UpdatedCode(Code: string): string;
var
  FirstChar: ShortInt;
  i: ShortInt;
  s: string;

begin
  FirstChar := -1;

  i := -1;
  while (i < Length(Code)) and (FirstChar = -1) do
  begin
    inc(i);

    if pos(copy(Code, i, 1), '0123456789-') = 0 then
      FirstChar := i;
  end;

  if (FirstChar >= 0) and (copy(Code, FirstChar, 1) <> ' ') then
    s := copy(Code, 0, FirstChar - 1) + ' ' + rightStr(Code, Length(Code) - FirstChar + 1)
  else
    s := Code;

  Result := s;
end;


end.
