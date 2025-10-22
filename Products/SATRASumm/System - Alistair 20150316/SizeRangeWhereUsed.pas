unit SizeRangeWhereUsed;

interface

uses
  Classes, Controls, Forms, DB, Grids, DBGridPlus, ExtCtrls, Buttons, ToolWin,
  ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus,
  FDTablePlus, frxClass, frxDBSet, Vcl.DBGrids, frxReportPlus;

type
  TfmSizeRangeWhereUsed = class(TForm)
    pnlParts: TPanel;
    dbgParts: TDBGridPlus;
    dsParts: TDataSource;
    pnlConstructions: TPanel;
    dbgConstructions: TDBGridPlus;
    dsConstructions: TDataSource;
    pnlRelationships: TPanel;
    dbgSizeRelationships: TDBGridPlus;
    dsSizeRelationships: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    qParts: TFDQueryPlus;
    qConstructions: TFDQueryPlus;
    qSizeRelationships: TFDQueryPlus;
    qPartsCode: TStringField;
    qConstructionsConstruction: TStringField;
    qSizeRelationshipsRelationship: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frSizeRangesWhereUsed: TfrxReportPlus;
    frdbParts: TfrxDBDataset;
    frdbConstructions: TfrxDBDataset;
    frdbSizeRelationships: TfrxDBDataset;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassSizeRangeName(var Code: string);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgPartsDblClick(Sender: TObject);
    procedure dbgPartsKeyPress(Sender: TObject; var Key: Char);
    procedure dbgConstructionsDblClick(Sender: TObject);
    procedure dbgConstructionsKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSizeRelationshipsDblClick(Sender: TObject);
    procedure dbgSizeRelationshipsKeyPress(Sender: TObject;
      var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frSizeRangesWhereUsedBeforePrint(Sender: TfrxReportComponent);
    procedure frSizeRangesWhereUsedGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSizeRangeWhereUsed: TfmSizeRangeWhereUsed;

implementation

uses
  Windows, Graphics, Summs, PartDetails, ConstructionDetails, SizeRelationshipDetails,
  OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmSizeRangeWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree
end;

procedure TfmSizeRangeWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmSizeRangeWhereUsed.PassSizeRangeName(var Code: string);

begin
  Caption := 'Where Used for Size Range : ' + Code;

  qParts.ParamByName('SizeRange').AsString := Code;
  qParts.Open;

  qConstructions.ParamByName('SizeRange').AsString := Code;
  qConstructions.Open;

  qSizeRelationships.ParamByName('SizeRange').AsString := Code;
  qSizeRelationships.Open;
end;

procedure TfmSizeRangeWhereUsed.frSizeRangesWhereUsedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frSizeRangesWhereUsed.PreviewOptions.AllowEdit := False;
  frSizeRangesWhereUsed.PreviewOptions.Buttons := frSizeRangesWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frSizeRangesWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frSizeRangesWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frSizeRangesWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSizeRangeWhereUsed.frSizeRangesWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmSizeRangeWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark, MyBookmark2, MyBookmark3: TBookmark;

begin
  frSizeRangesWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qParts.GetBookmark;
  MyBookmark2 := qConstructions.GetBookmark;
  MyBookmark3 := qSizeRelationships.GetBookmark;
  qParts.DisableControls;
  qConstructions.DisableControls;
  qSizeRelationships.DisableControls;

  frSizeRangesWhereUsed.PrintOptions.PrintMode := pmScale;
  frSizeRangesWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frSizeRangesWhereUsed.PrepareReport;

  try
    qParts.GotoBookmark(MyBookmark);
  except
  end;
  qParts.EnableControls;
  qParts.FreeBookmark(MyBookmark);

  try
    qConstructions.GotoBookmark(MyBookmark2);
  except
  end;
  qConstructions.EnableControls;
  qConstructions.FreeBookmark(MyBookmark2);

  try
    qSizeRelationships.GotoBookmark(MyBookmark3);
  except
  end;
  qSizeRelationships.EnableControls;
  qSizeRelationships.FreeBookmark(MyBookmark3);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frSizeRangesWhereUsed.ShowPreparedReport
  else
    frSizeRangesWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmSizeRangeWhereUsed.dbgPartsDblClick(Sender: TObject);
var
  fmPartDetails : TfmPartDetails;
  Code:string;
  Failed:boolean;

begin
  Code := qPartsCode.value;

  if not(Code = '') then
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
        fmPartDetails.PassPartName(fmPartDetails, Code);
    end;
  end;
end;

procedure TfmSizeRangeWhereUsed.dbgPartsKeyPress(Sender: TObject;
                                                 var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgPartsDblClick(Self);
end;

procedure TfmSizeRangeWhereUsed.dbgConstructionsDblClick(Sender: TObject);
var
  fmConstructionDetails: TfmConstructionDetails;
  Code : string;
  Failed : boolean;

begin
  Code := qConstructionsConstruction.value;

  if not(Code = '') then
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
        fmConstructionDetails.PassConstructionName(fmConstructionDetails, Code);
    end;
  end;
end;

procedure TfmSizeRangeWhereUsed.dbgConstructionsKeyPress(Sender: TObject;
                                                         var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgConstructionsDblClick(Self);
end;

procedure TfmSizeRangeWhereUsed.dbgSizeRelationshipsDblClick(Sender: TObject);
var
  fmSizeRelationshipDetails: TfmSizeRelationshipDetails;
  Code : string;
  Failed : boolean;

begin
  Code := qSizeRelationshipsRelationship.value;

  if not(Code = '') then
  begin
    if not ExistingToFront('Size Relationships', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmSizeRelationshipDetails := TfmSizeRelationshipDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmSizeRelationshipDetails.PassSizeRelationshipName(fmSizeRelationshipDetails, Code);
    end;
  end;
end;

procedure TfmSizeRangeWhereUsed.dbgSizeRelationshipsKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgSizeRelationshipsDblClick(Self);
end;

procedure TfmSizeRangeWhereUsed.btnRefreshClick(Sender: TObject);
begin
  screen.cursor := crHourGlass;

  qParts.close;
  qParts.open;
  qConstructions.close;
  qConstructions.open;
  qSizeRelationships.close;
  qSizeRelationships.open;

  screen.cursor := crDefault;
end;

procedure TfmSizeRangeWhereUsed.FormCreate(Sender: TObject);
var
  AddToHeight, AddToWidth: integer;

begin
  AutoColor(Self);
end;

end.
