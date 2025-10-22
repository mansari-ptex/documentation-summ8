unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  Data.DB, FireDAC.Comp.Client, FDConnectionPlus, Vcl.StdCtrls, FireDAC.Phys.ADS, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, FireDAC.DApt, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FDQueryPlus, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    ConnectionSumms: TFDConnectionPlus;
    btnUpgrade: TButton;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qChangeVersion: TFDQueryPlus;
    Image1: TImage;
    lblNote: TLabel;
    qStructure: TFDQueryPlus;
    procedure btnUpgradeClick(Sender: TObject);
  private
    { Private declarations }
    function Connection(TheConnection: TFDConnectionPlus; AliasName, UserName, Password: string): Boolean;
    function CurrentVersion: string;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation


{$R *.dfm}


procedure TfmMain.btnUpgradeClick(Sender: TObject);
var
  Connected: Boolean;

begin
  btnUpgrade.enabled := False;

  Connected := False;
  try
    Connected := Connection(ConnectionSumms, 'SATRASUMM8', 'ADSSYS', 'monster');
  except
    messagedlg('Can not connect to a SATRASumm 8 Database', mtInformation, [mbOk], 0);
  end;

  if Connected then
  begin
    if (CurrentVersion <> '8.1') then
      messagedlg('This is not a 8.1 database', mtError, [mbOk], 0)
    else
    begin
      screen.Cursor := crHourGlass;

      qChangeVersion.ExecSQL;
      qStructure.ExecSQL;

      screen.Cursor := crDefault;

      messagedlg('Update complete.' + #13#10#13#10 +
                 'If you wish to use the Legacy Cutting times you must ' + #13#10 +
                 'update the times in Parameters to match your Summs 7 ' + #13#10 +
                 'database and ensure that Base level is correctly set.', mtInformation, [mbOk], 0);
      close;
    end;
  end;
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


end.


