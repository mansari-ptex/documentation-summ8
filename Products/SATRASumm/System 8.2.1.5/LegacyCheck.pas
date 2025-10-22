unit LegacyCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus, Buttons,
  ExtCtrls, ToolWin, ComCtrls, StdCtrls, Vcl.DBGrids;

type
  TfmLegacyCheck = class(TForm)
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    dbgLegacySynthetics: TDBGridPlus;
    qLegacySynthetics: TFDQueryPlus;
    dsLegacySynthetics: TDataSource;
    qLegacySyntheticsCode: TStringField;
    qLegacySyntheticsDescription: TStringField;
    pnlHeader: TPanel;
    lblNote: TLabel;
    gbTotals: TGroupBox;
    lblCount: TLabel;
    pnlHeader2: TPanel;
    lblNote2: TLabel;
    gbTotals2: TGroupBox;
    lblCount2: TLabel;
    dbgKnivesWithCutGap: TDBGridPlus;
    qKnivesWithCutGap: TFDQueryPlus;
    dsKnivesWithCutGap: TDataSource;
    qKnivesWithCutGapCode: TStringField;
    qKnivesWithCutGapDescription: TStringField;
    qKnivesWithCutGapLeather: TStringField;
    rgDoubleClick: TRadioGroup;
    Splitter1: TSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRefreshClick(Sender: TObject);
    procedure dbgLegacySyntheticsDblClick(Sender: TObject);
    procedure dbgLegacySyntheticsKeyPress(Sender: TObject; var Key: Char);
    procedure qLegacySyntheticsAfterOpen(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure qKnivesWithCutGapAfterOpen(DataSet: TDataSet);
    procedure dbgKnivesWithCutGapKeyPress(Sender: TObject; var Key: Char);
    procedure dbgKnivesWithCutGapDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLegacyCheck: TfmLegacyCheck;

implementation

uses General, PartDetails, KnifeSetDetails, OutOfMemory, Summs, SummsVars;

{$R *.dfm}

procedure TfmLegacyCheck.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmLegacyCheck.btnRefreshClick(Sender: TObject);
begin
  qLegacySynthetics.Close;
  qLegacySynthetics.Open;
  qKnivesWithCutGap.Close;
  qKnivesWithCutGap.Open;
end;

procedure TfmLegacyCheck.dbgLegacySyntheticsDblClick(Sender: TObject);
var
  fmPartDetails : TfmPartDetails;
  Code : string;
  Failed : boolean;

begin
  Code := qLegacySyntheticsCode.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Part', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmPartDetails := TfmPartDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;
      if not Failed then
      begin
        fmPartDetails.PassPartName(fmPartDetails, Code);
        if rgDoubleClick.itemIndex = 1 then
        begin
          fmPartDetails.btnEditClick(Sender);
          try
            fmPartDetails.tblpartsSLMAllowance.Value := False;
            application.Processmessages;
            fmPartDetails.btnSaveClick(Sender);
            application.Processmessages;
          except
          end;
          fmPartDetails.Close;
          qLegacySynthetics.next;
        end;
      end;
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmLegacyCheck.dbgLegacySyntheticsKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgLegacySyntheticsDblClick(Self);
end;

procedure TfmLegacyCheck.qLegacySyntheticsAfterOpen(DataSet: TDataSet);
begin
  //CJY qLegacySynthetics.FetchOptions.RecordCountMode set to cmTotal
  lblCount.Caption := intToStr(qLegacySynthetics.RecordCount);
end;

procedure TfmLegacyCheck.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  qLegacySynthetics.Open;
  qKnivesWithCutGap.Open;
end;

procedure TfmLegacyCheck.qKnivesWithCutGapAfterOpen(DataSet: TDataSet);
begin
  //CJY qKnivesWithCutGap.FetchOptions.RecordCountMode set to cmTotal
  lblCount2.Caption := intToStr(qKnivesWithCutGap.RecordCount);
end;

procedure TfmLegacyCheck.dbgKnivesWithCutGapKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgKnivesWithCutGapDblClick(Self);
end;

procedure TfmLegacyCheck.dbgKnivesWithCutGapDblClick(Sender: TObject);
var
  Code : string;
  Failed : boolean;
  fmKnifeSetDetails : TfmKnifeSetDetails;

begin
  Code := qKnivesWithCutGapCode.value;

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

end.
