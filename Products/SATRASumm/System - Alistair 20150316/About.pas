unit About;

interface

uses
  Forms, StdCtrls, Graphics, Classes, Controls,
  ExtCtrls, jpeg, SysUtils, General, Summs, CmnVars, Data.DB, 
   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus;

type
  TfmAboutBox = class(TForm)
    imgSummsIcon: TImage;
    lblVersion: TLabel;
    lblAdvantage: TLabel;
    lblAdvantage2: TLabel;
    qVersion: TFDQueryPlus;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ServerVersion;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAboutBox: TfmAboutBox;

implementation

uses
  SummsVars;

{$R *.DFM}

procedure TfmAboutBox.FormShow(Sender: TObject);
var
  Form: TForm;
begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  lblVersion.caption := 'Version ' + GetVerInfo(ExtractFileName(Application.EXEName));
  {$IFDEF WIN32}
  lblVersion.caption := lblVersion.caption + ' (32 bit)';
  {$ENDIF}
  {$IFDEF WIN64}
  lblVersion.caption := lblVersion.caption + ' (64 bit)';
  {$ENDIF}
  Serverversion;
end;


procedure TfmAboutBox.Serverversion;
var
  VersionInfo: string;

begin
  try
    qVersion.Open;
    VersionInfo := qVersion.FieldByName('Version').Value;
    qVersion.Close;
  except
    VersionInfo := 'No Info';
  end;

  lblAdvantage.caption := 'Advantage Server version : ' + VersionInfo;
end;

procedure TfmAboutBox.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  Caption := 'About ' + SystemName;
end;

end.
