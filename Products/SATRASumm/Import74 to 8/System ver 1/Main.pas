unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, IniFiles, ShellAPI, Grids, DBGrids, jpeg, ExtCtrls,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,  FireDAC.VCLUI.Wait, FireDAC.Phys.ADS, FireDAC.Comp.UI;

type
  TfmUpgrade = class(TForm)
    adsSumms: TFDConnection;
    btnUpgrade: TButton;
    Image1: TImage;
    qStructure: TFDQuery;
    tblElements: TFDTable;
    tblElementTimes: TFDTable;
    tblCuttingElements: TFDTable;
    lblNote: TLabel;
    mElements: TMemo;
    mCuttingElements: TMemo;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    qStructure2: TFDQuery;
    qStructure3: TFDQuery;
    qStructure4: TFDQuery;
    qStructure5: TFDQuery;
    procedure btnUpgradeClick(Sender: TObject);
    procedure CuttingElements;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmUpgrade: TfmUpgrade;
  Reports: boolean;

implementation

{$R *.dfm}

procedure TfmUpgrade.btnUpgradeClick(Sender: TObject);
var
  Valid74database: Boolean;
  aucProperty: array[0..1] of ansichar;
  VerMajor, VerMinor: integer;
  Connected: Boolean;
  Ini: TIniFile;
  IniName, s: string;
  qSystem: TFDQuery;

begin
  btnUpgrade.enabled := False;

  Valid74database := False;

  Connected := False;
  try
    //Connect7;
    AdsSumms.DriverName := 'ADS';
    AdsSumms.Params.Values['ServerTypes'] := 'Remote';
    AdsSumms.Params.Values['Protocol'] := 'TCPIP';
    AdsSumms.Params.Values['Alias'] := 'SUMMS7';
    AdsSumms.Params.Values['User_name'] := 'ADSSYS';
    AdsSumms.Params.Values['Password'] := 'monster';

    AdsSumms.FetchOptions.RecordCountMode := cmFetched;
    AdsSumms.FetchOptions.AutoClose := false;

    AdsSumms.Connected := True;

    Connected := True;
  except
    messagedlg('Can not connect to Summs 7.4 Database', mtInformation, [mbOk], 0);
  end;

  if Connected then
  begin
    screen.Cursor := crHourGlass;

    qSystem := TFDQuery.Create(AdsSumms);
    qSystem.Connection := AdsSumms;
    qSystem.SQL.Add('select Version_Major, Version_Minor from system.dictionary');
    qSystem.Open;
    VerMajor := qSystem.FieldByName('Version_Major').Value;
    VerMinor := qSystem.FieldByName('Version_Minor').Value;
    qSystem.Close;
    qSystem.Free;

    if ((VerMajor = 7) and (VerMinor = 4)) then
      Valid74database := True;

    //Disconnect;
    AdsSumms.Connected := False;

    screen.Cursor := crDefault;
  end;

  if not Valid74Database then
    messagedlg('This is not a 7.4 database', mtError, [mbOk], 0)
  else
  begin
    if Connected then
    begin
      screen.Cursor := crHourGlass;

      //Adjust ini
      IniName := 'Ads.ini';
      Ini := TIniFile.Create(IniName);
      s := Ini.ReadString('Databases', 'Summs7', '');
      Ini.WriteString('Databases', 'Summs7', '');
      Ini.WriteString('Databases', 'SATRASUMM8', s);
      Ini.Free;

      //Reconnect to new alias
      AdsSumms.Connected := False;
      AdsSumms.Params.Values['Alias'] := 'SATRASUMM8';
      AdsSumms.Connected := True;

      qSystem := TFDQuery.Create(AdsSumms);
      qSystem.Connection := AdsSumms;
      qSystem.SQL.Add('EXECUTE PROCEDURE sp_ModifyDatabase(''Version_Major'', ''8'');');
      qSystem.SQL.Add('EXECUTE PROCEDURE sp_ModifyDatabase(''Version_Minor'', ''0'');');
      qSystem.ExecSQL;
      qSystem.Free;

      qStructure.ExecSQL;
      qStructure2.ExecSQL;
      qStructure3.ExecSQL;
      qStructure4.ExecSQL;
      qStructure5.ExecSQL;
      CuttingElements;

      //Disconnect;
      AdsSumms.Connected := False;

      screen.Cursor := crDefault;

      messagedlg('Update complete', mtInformation, [mbOk], 0);
      close;
    end;
  end;
end;

procedure TfmUpgrade.CuttingElements;
var
  s1, s2, s3, s4: String;
  r4: real;
  Code: integer;
  NoElements, i: integer;

begin
  tblElements.Open;
  tblElementTimes.Open;
  tblCuttingElements.Open;

  NoElements := mElements.Lines.Count div 4;
  for i := 1 to NoElements do
  begin
    s1 := mElements.Lines[((i - 1) * 4) + 0];
    s2 := mElements.Lines[((i - 1) * 4) + 1];
    s3 := mElements.Lines[((i - 1) * 4) + 2];
    s4 := mElements.Lines[((i - 1) * 4) + 3];
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

  NoElements := mCuttingElements.Lines.Count div 4;
  for i := 1 to NoElements do
  begin
    s1 := mCuttingElements.Lines[((i - 1) * 4) + 0];
    s2 := mCuttingElements.Lines[((i - 1) * 4) + 1];
    s3 := mCuttingElements.Lines[((i - 1) * 4) + 2];
    s4 := mCuttingElements.Lines[((i - 1) * 4) + 3];

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

end.

