unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles;

type
  TfmMain = class(TForm)
    btnNext: TButton;
    edtDatabaseLocation: TEdit;
    lblExamples: TLabel;
    Memo1: TMemo;
    procedure btnNextClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

procedure TfmMain.btnNextClick(Sender: TObject);
var
  TheAlias, TheDictionary, TheDir, TheDatabase: string;
  TheIni: TIniFile;
  i: integer;

begin
  TheAlias := ParamStr(1);
  TheDictionary := ParamStr(2) + '.add';

  TheDir := ParamStr(3);
  for i := 4 to ParamCount do
    TheDir := TheDir + ' ' + ParamStr(i);
  if Length(TheDir) > 0 then
    if copy(TheDir, Length(TheDir), 1) <> '\' then
      TheDir := TheDir + '\';

  TheDatabase := edtdatabaseLocation.text;
  if Length(TheDatabase) > 0 then
    if copy(TheDatabase, Length(TheDatabase), 1) <> '\' then
      TheDatabase := TheDatabase + '\';
  TheDatabase := TheDatabase + TheDictionary + ';D';

  TheIni := TIniFile.Create(TheDir + 'Ads.ini');
  TheIni.WriteString('Databases', TheAlias, TheDatabase);
  TheIni.Free;

  close;
end;

end.
