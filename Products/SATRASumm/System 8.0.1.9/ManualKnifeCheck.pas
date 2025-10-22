unit ManualKnifeCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus, Buttons,
  ExtCtrls, ToolWin, ComCtrls, StdCtrls, Vcl.DBGrids;

type
  TfmManualKnifeCheck = class(TForm)
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    dbgManualKnives: TDBGridPlus;
    qManualKnives: TFDQueryPlus;
    dsManualKnives: TDataSource;
    pnlHeader: TPanel;
    lblNote: TLabel;
    gbManualCount: TGroupBox;
    lblCount: TLabel;
    qCount: TFDQueryPlus;
    qCountKnifeCount: TIntegerField;
    qManualKnivesKnifeCode: TStringField;
    qManualKnivesPartCode: TStringField;
    qManualKnivesMType: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRefreshClick(Sender: TObject);
    procedure dbgManualKnivesDblClick(Sender: TObject);
    procedure dbgManualKnivesKeyPress(Sender: TObject; var Key: Char);
    procedure qManualKnivesAfterOpen(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmManualKnifeCheck: TfmManualKnifeCheck;

implementation

uses general, KnifeSetDetails, OutOfMemory, Summs, SummsVars;

{$R *.dfm}

procedure TfmManualKnifeCheck.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmManualKnifeCheck.btnRefreshClick(Sender: TObject);
begin
  qCount.Close;
  qCount.open;
  qManualKnives.Close;
  qManualKnives.open;
end;

procedure TfmManualKnifeCheck.dbgManualKnivesDblClick(Sender: TObject);
var
  fmKnifeSetDetails: TfmKnifeSetDetails;
  Code: string;
  Failed: boolean;

begin
  Code := qManualKnivesKnifeCode.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Knife', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmKnifeSetDetails := TfmKnifeSetDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;
      if not Failed then
        fmKnifeSetDetails.PassKnifeName(fmKnifeSetDetails, Code);
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmManualKnifeCheck.dbgManualKnivesKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgManualKnivesDblClick(Self);
end;

procedure TfmManualKnifeCheck.qManualKnivesAfterOpen(DataSet: TDataSet);
begin
  lblCount.Caption := IntToStr(qCountKnifeCount.Value);
end;

procedure TfmManualKnifeCheck.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  btnRefresh.Click;
end;

end.
