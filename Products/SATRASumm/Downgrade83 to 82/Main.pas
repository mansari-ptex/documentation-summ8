unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, Data.DB,
  FireDAC.Comp.Client, FDConnectionPlus, FireDAC.Comp.DataSet, Vcl.StdCtrls,
  FireDAC.Phys.ADS, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TfmDowngrade = class(TForm)
    btnDowngrade: TButton;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure btnDowngradeClick(Sender: TObject);
  private
    { Private declarations }
    procedure Connection();
  public
    { Public declarations }
  end;

var
  fmDowngrade: TfmDowngrade;

implementation



{$R *.dfm}


procedure TfmDowngrade.btnDowngradeClick(Sender: TObject);
begin
  Connection();
  Close;
end;


procedure TfmDowngrade.Connection();
var
  TheConnection: TFDConnectionPlus;
  qSystem: TFDQuery;
  AliasName, UserName, Password: string;
  VerMajor, VerMinor: integer;
  sMajor, sMinor: string;
  DataVersion: string;
  s: string;

begin
  AliasName := 'SATRASUMM8';
  Username := 'AdsSys';
  Password := 'monster';

  try
    TheConnection := TFDConnectionPlus.Create(Self);

    TheConnection.DriverName := 'ADS';
    TheConnection.Params.Values['ServerTypes'] := 'Remote';
    TheConnection.Params.Values['Protocol'] := 'TCPIP';
    TheConnection.Params.Values['Alias'] := AliasName;
    TheConnection.Params.Values['User_name'] := UserName;
    TheConnection.Params.Values['Password'] := Password;

    TheConnection.Connected := True;

    qSystem := TFDQuery.Create(TheConnection);

    qSystem.Connection := TheConnection;
    qSystem.SQL.Add('select Version_Major, Version_Minor from system.dictionary');
    qSystem.Open;
    VerMajor := qSystem.FieldByName('Version_Major').Value;
    VerMinor := qSystem.FieldByName('Version_Minor').Value;
    qSystem.Close;

    qSystem.Free;

    str(VerMajor : 1, sMajor);
    str(VerMinor : 1, sMinor);
    DataVersion := sMajor + '.' + sMinor;

    if (DataVersion = '8.3') then
    begin
      if messagedlg('Downgrade 8.3 database to 8.2 database?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        try
          qSystem := TFDQuery.Create(TheConnection);
          qSystem.Connection := TheConnection;
          qSystem.SQL.Add('EXECUTE PROCEDURE sp_ModifyDatabase(''VERSION_MINOR'', ''2''); ');
          qSystem.ExecSQL;
          qSystem.Free;
        except
          messagedlg('Error downgrading database to 8.2', mtInformation, [mbOk], 0);
        end;
      end;
    end
    else
       messagedlg('This is not a 8.3 database', mtInformation, [mbOk], 0);

    TheConnection.Free;
  except on E: EDataBaseError do
    begin
      if (E is EFDDBEngineException) then
      begin
        if (E as EFDDBEngineException).ErrorCode = 6420 then
        begin
          showmessage('Advantage Database Server not detected');
        end
        else if (E as EFDDBEngineException).ErrorCode = 7078 then
          s := 'Incorrect User Name or Password.' + #13 + #13 +
               'Please try again.'
        else if (((E as EFDDBEngineException).ErrorCode = 5121) or
                 ((E as EFDDBEngineException).ErrorCode = 5004) or
                 ((E as EFDDBEngineException).ErrorCode = 5021)) then        //I don't think we get here any more - different errors occur
          s := 'Invalid or missing Alias (' + AliasName + ').'
        else if ((E as EFDDBEngineException).ErrorCode = 6414) then          //I don't think we get here any more - different errors occur
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
    end
    else
      raise;
  end;
end;


end.
