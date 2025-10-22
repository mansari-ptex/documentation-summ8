unit SizeRelationshipWhereUsed;

interface

uses
  Classes, Controls, Forms, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DB, Grids, DBGridPlus, ExtCtrls, Buttons,
  ToolWin, ComCtrls, frxClass, frxDBSet, DBGrids, frxReportPlus;

type
  TfmSizeRelationshipWhereUsed = class(TForm)
    pnlPtWidKnf: TPanel;
    dbgPtWidKnfUsing: TDBGridPlus;
    dsPartWidthKnife: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qPartWidthKnife: TFDQueryPlus;
    qPartWidthKnifePart: TStringField;
    qPartWidthKnifeKnife: TStringField;
    qPartWidthKnifeWidth: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frSizeRelationshipWhereUsed: TfrxReportPlus;
    frdbPartWidthKnife: TfrxDBDataset;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassSizeRelationshipName(var Code: string);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgPtWidKnfUsingDblClick(Sender: TObject);
    procedure dbgPtWidKnfUsingKeyPress(Sender: TObject; var Key: Char);
    procedure dbgPtWidKnfUsingCellClick(Column: TColumn);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frSizeRelationshipWhereUsedBeforePrint(
      Sender: TfrxReportComponent);
    procedure frSizeRelationshipWhereUsedGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
    WhichField : string;
  public
    { Public declarations }
  end;

var
  fmSizeRelationshipWhereUsed: TfmSizeRelationshipWhereUsed;

implementation

uses
  Windows, Graphics, Summs, PartDetails, KnifeSetDetails, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmSizeRelationshipWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree
end;

procedure TfmSizeRelationshipWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmSizeRelationshipWhereUsed.PassSizeRelationshipName(var Code: string);
begin
  Caption := 'Where Used for Size Relationship : ' + Code;

  qPartWidthKnife.ParamByName('SizeRelationship').AsString := Code;
  qPartWidthKnife.Open;
end;

procedure TfmSizeRelationshipWhereUsed.frSizeRelationshipWhereUsedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frSizeRelationshipWhereUsed.PreviewOptions.AllowEdit := False;
  frSizeRelationshipWhereUsed.PreviewOptions.Buttons := frSizeRelationshipWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frSizeRelationshipWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frSizeRelationshipWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frSizeRelationshipWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSizeRelationshipWhereUsed.frSizeRelationshipWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmSizeRelationshipWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  frSizeRelationshipWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qPartWidthKnife.GetBookmark;
  qPartWidthKnife.DisableControls;

  frSizeRelationshipWhereUsed.PrintOptions.PrintMode := pmScale;
  frSizeRelationshipWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frSizeRelationshipWhereUsed.PrepareReport;

  try
    qPartWidthKnife.GotoBookmark(MyBookmark);
  except
  end;
  qPartWidthKnife.EnableControls;
  qPartWidthKnife.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frSizeRelationshipWhereUsed.ShowPreparedReport
  else
    frSizeRelationshipWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmSizeRelationshipWhereUsed.dbgPtWidKnfUsingDblClick(Sender: TObject);
var
  fmKnifeSetDetails : TfmKnifeSetDetails;
  fmPartDetails : TfmPartDetails;
  Code : string;
  Failed : boolean;

begin
  Code := '';

  if (WhichField = 'Part') then
    Code := qPartWidthKnifePart.Value;
  if (WhichField = 'Knife') then
    Code := qPartWidthKnifeKnife.Value;

  //this looks like a hard way to do it, but gets over the NULL problem of using .FieldValue

  Failed := false;
  if not (Code = '') and (WhichField = 'Part') then
  begin
    if not ExistingToFront('Part', Code) then
    begin
      Screen.cursor := crHourGlass;
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

  if not (Code = '') and (WhichField = 'Knife') and not Failed then
  begin
    if not ExistingToFront('Knife', Code) then
    begin
      Screen.cursor := crHourGlass;
      try
        fmKnifeSetDetails := TfmKnifeSetDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmKnifeSetDetails.PassKnifeName(fmKnifeSetDetails, Code);
    end;
  end;
end;

procedure TfmSizeRelationshipWhereUsed.dbgPtWidKnfUsingKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgPtWidKnfUsingDblClick(Self)
end;

procedure TfmSizeRelationshipWhereUsed.dbgPtWidKnfUsingCellClick(Column: TColumn);
begin
  WhichField:=Column.FieldName;
end;

procedure TfmSizeRelationshipWhereUsed.btnRefreshClick(Sender: TObject);
begin
  screen.cursor := crHourGlass;

  qPartWidthKnife.close;
  qPartWidthKnife.open;

  screen.cursor := crDefault;
end;

procedure TfmSizeRelationshipWhereUsed.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
