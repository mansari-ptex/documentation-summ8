unit PartsWhereUsed;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus,
  Buttons, ToolWin, ComCtrls, frxClass, frxDBSet, Vcl.DBGrids, frxReportPlus;

type
  TfmPartsWhereUsed = class(TForm)
    pnlConstructionsUsing: TPanel;
    dbgConPartsUsing: TDBGridPlus;
    dsConParts: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qConstructionParts: TFDQueryPlus;
    qConstructionPartsConstruction: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frPartsWhereUsed: TfrxReportPlus;
    frdbConstructionParts: TfrxDBDataset;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure PassPartName(var Code: string);                               
    procedure btnPrintClick(Sender: TObject);
    procedure dbgConPartsUsingDblClick(Sender: TObject);
    procedure dbgConPartsUsingKeyPress(Sender: TObject; var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frPartsWhereUsedBeforePrint(Sender: TfrxReportComponent);
    procedure frPartsWhereUsedGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPartsWhereUsed: TfmPartsWhereUsed;

implementation

uses
  Windows, Graphics, Summs, ConstructionDetails, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmPartsWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree
end;

procedure TfmPartsWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmPartsWhereUsed.PassPartName(var Code: string);
begin
  Caption := 'Where Used for Part : ' + Code;

  qConstructionParts.ParamByName('Part').AsString := Code;
  qConstructionParts.Open;
end;

procedure TfmPartsWhereUsed.frPartsWhereUsedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frPartsWhereUsed.PreviewOptions.AllowEdit := False;
  frPartsWhereUsed.PreviewOptions.Buttons := frPartsWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frPartsWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frPartsWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frPartsWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmPartsWhereUsed.frPartsWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmPartsWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  frPartsWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qConstructionParts.GetBookmark;
  qConstructionParts.DisableControls;

  frPartsWhereUsed.PrintOptions.PrintMode := pmScale;
  frPartsWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frPartsWhereUsed.PrepareReport;

  qConstructionParts.GotoBookmark(MyBookmark);
  qConstructionParts.EnableControls;
  qConstructionParts.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frPartsWhereUsed.ShowPreparedReport
  else
    frPartsWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmPartsWhereUsed.dbgConPartsUsingDblClick(Sender: TObject);
var
  fmConstructionDetails: TfmConstructionDetails;
  Code : string;
  Failed : boolean;

begin
  Code := qConstructionPartsConstruction.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Construction', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmConstructionDetails := TfmConstructionDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmConstructionDetails.PassConstructionName(fmConstructionDetails, Code)
    end;
  end;
end;

procedure TfmPartsWhereUsed.dbgConPartsUsingKeyPress(Sender: TObject;
                                                     var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgConPartsUsingDblClick(Self);
end;

procedure TfmPartsWhereUsed.btnRefreshClick(Sender: TObject);
begin
 qConstructionParts.close;
 qConstructionParts.open;
end;

procedure TfmPartsWhereUsed.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
