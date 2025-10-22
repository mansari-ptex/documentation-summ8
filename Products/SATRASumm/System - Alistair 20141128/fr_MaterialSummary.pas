unit fr_MaterialSummary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, frxDBSet, General, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, frxReportPlus;

type
  TfmfrMaterialSummary = class(TForm)
    frdbTicketDetails: TfrxDBDataset;
    frdbTicketMaterials: TfrxDBDataset;
    frMaterialSummary: TfrxReportPlus;
    qTicketMaterials: TFDQueryPlus;
    qTicketMaterialsMaterialCode: TStringField;
    qTicketMaterialsMaterialDescriptionCount: TIntegerField;
    qTicketMaterialsCalcMatDesc: TStringField;
    qTicketDetails: TFDQueryPlus;
    qTicketDetailsMaterialCode: TStringField;
    qTicketDetailsWeekNo: TSmallintField;
    qTicketDetailsSequenceNo: TSmallintField;
    qTicketDetailsTicketNo: TSmallintField;
    qTicketDetailsPartCode: TStringField;
    qTicketDetailsTotalPairs: TSmallintField;
    qTicketDetailsMaterialDescription: TStringField;
    qTicketDetailsMaterialType: TStringField;
    qTicketDetailsMaterialLength: TFloatField;
    qTicketDetailsMaterialWidth: TFloatField;
    qTicketDetailsMaterialQualCoeff: TIntegerField;
    qTicketDetailsMaterialAreaCoeff: TIntegerField;
    qTicketDetailsMaterialUnits: TStringField;
    qTicketDetailsMaterialUnitAbbreviation: TStringField;
    qTicketDetailsMaterialSubUnitsPerUnit: TSmallintField;
    qTicketDetailsMaterialUnitsToFeet: TFloatField;
    qTicketDetailsBasicAllowance: TFloatField;
    qTicketDetailsAdjustedAllowance: TFloatField;
    qTicketDetailsConstruction: TStringField;
    qTicketDetailsFullTicketNumber: TStringField;
    qTicketDetailsAreaUsed: TFloatField;
    qTicketDetailsQualityArea: TStringField;
    qTicketDetailsTagNo: TStringField;
    qTicketDetailsMeasure: TStringField;
    qTicketDetailsFullMatCode: TStringField;
    procedure frMaterialSummaryBeforePrint(Sender: TfrxReportComponent);
    procedure frMaterialSummaryGetValue(const VarName: string;
      var Value: Variant);
    procedure qTicketMaterialsCalcFields(DataSet: TDataSet);
    procedure qTicketDetailsCalcFields(DataSet: TDataSet);
    procedure MakeMaterialSummary(SQLString: string;
                                  Preview: boolean);
    procedure qTicketDetailsAfterScroll(DataSet: TDataSet);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmfrMaterialSummary: TfmfrMaterialSummary;

implementation

uses
  Summs, OutOfMemory;

{$R *.dfm}

procedure TfmfrMaterialSummary.frMaterialSummaryBeforePrint(
  Sender: TfrxReportComponent);
begin
  frMaterialSummary.PreviewOptions.AllowEdit := False;
  frMaterialSummary.PreviewOptions.Buttons := frMaterialSummary.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frMaterialSummary.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frMaterialSummary.PreviewOptions.ZoomMode := zmDefault
  else
    frMaterialSummary.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmfrMaterialSummary.frMaterialSummaryGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'mTagNoTitle') then
    Value := TicketTranslation[8];
end;

procedure TfmfrMaterialSummary.qTicketDetailsAfterScroll(DataSet: TDataSet);
begin
  //CJY Refresh not required as only updating filter value
  qTicketMaterials.Filtered := False;
  qTicketMaterials.Filter := 'MaterialCode = ''' + qTicketDetailsMaterialCode.Value + '''';
  qTicketMaterials.Filtered := True;

  //CJY skipping first / last row and Filtered
//  if qTicketMaterials.Active then
//    qTicketMaterials.Refresh;
end;

procedure TfmfrMaterialSummary.qTicketDetailsCalcFields(DataSet: TDataSet);
var
  Measure: real;
  mMem, mMemTitle: TfrxMemoView;

begin
  qTicketDetailsFullTicketNumber.Value := InttoStr(qTicketDetailsWeekNo.Value) + '/' +
                                          InttoStr(qTicketDetailsSequenceNo.Value) + '/' +
                                          InttoStr(qTicketDetailsTicketNo.Value);

  if (qTicketDetailsMaterialType.Value = 'R') then
    Measure := (qTicketDetailsAdjustedAllowance.value * qTicketDetailsTotalPairs.Value) *
               qTicketDetailsMaterialSubUnitsPerUnit.value / qTicketDetailsMaterialWidth.value
  else if (qTicketDetailsMaterialType.Value = 'S') then
    Measure := (qTicketDetailsAdjustedAllowance.value * qTicketDetailsTotalPairs.Value)   //check these figures later
  else
    Measure := (qTicketDetailsAdjustedAllowance.value * qTicketDetailsTotalPairs.Value);   //check these figures later

  qTicketDetailsAreaUsed.Value := Measure / (qTicketDetailsMaterialUnitsToFeet.Value * qTicketDetailsMaterialUnitsToFeet.Value);
  qTicketDetailsQualityArea.Value := IntToStr(qTicketDetailsMaterialQualCoeff.value) + '/' +
    IntToStr(qTicketDetailsMaterialAreaCoeff.value);

  if (qTicketDetailsMaterialType.Value = 'R') then
  begin
    fmSumms.qMaterialUnits.FindKey([qTicketDetailsMaterialUnits.Value]);
    qTicketDetailsMeasure.Value :='Length' + '(' + fmSumms.qMaterialUnits.FieldByName('UnitAbbreviation').value + ')';
  end
  else
  begin
    fmSumms.qMaterialUnits.FindKey([qTicketDetailsMaterialUnits.Value]);
    qTicketDetailsMeasure.Value := 'Area' + '(Sq. ' + fmSumms.qMaterialUnits.FieldByName('UnitAbbreviation').value + ')'
  end;

  mMemTitle := frMaterialSummary.FindObject('mQualityAreaTitle') as TfrxMemoView;
  mMem := frMaterialSummary.FindObject('mQualityArea') as TfrxMemoView;

  if (qTicketDetails.FieldByName('MaterialType').Value = 'K') or
    (qTicketDetails.FieldByName('MaterialType').Value = 'L')  or
    (qTicketDetails.FieldByName('MaterialType').Value = 'W') then
  begin
    qTicketDetailsFullMatCode.Value := qTicketDetailsMaterialCode.Value + 'L';
    mMemTitle.Visible := True;
    mMem.Visible := True;
  end
  else
  begin
    qTicketDetailsFullMatCode.Value := qTicketDetailsMaterialCode.Value + qTicketDetailsMaterialType.Value;
    mMemTitle.Visible := False;
    mMem.Visible := False;
  end;
  qTicketDetailsFullMatCode.Value := qTicketDetailsFullMatCode.Value + qTicketDetails.FieldByName('MaterialUnits').Value;
end;

procedure TfmfrMaterialSummary.qTicketMaterialsCalcFields(DataSet: TDataSet);
begin
  if qTicketMaterials.FieldByName('MaterialDescriptionCount').Value = 1 then
    qTicketMaterialsCalcMatDesc.Value := qTicketDetails.FieldByName('MaterialDescription').Value
  else
    qTicketMaterialsCalcMatDesc.Value := '***VARIOUS***';
end;

procedure TfmfrMaterialSummary.MakeMaterialSummary(SQLString: string;
                                                   Preview: boolean);
begin
  screen.Cursor := crHourGlass;

  qTicketMaterials.SQL.Text := 'SELECT DISTINCT TT.MaterialCode, COUNT(DISTINCT TT.MaterialDescription) as MaterialDescriptionCount ' +
                               'FROM TicketTickets TT ' +
                               'WHERE TT.Print = TRUE AND (' + SQLString + ') ' +
                               'GROUP BY 1';

  qTicketDetails.SQL.Text := 'SELECT TT.MaterialCode, TT.WeekNo, TT.SequenceNo, TT.TicketNo, TT.PartCode, ' +
                             'TT.TotalPairs, TT.MaterialDescription, ' +
                             'TT.MaterialType, TT.MaterialUnits, TT.MaterialUnitsToFeet, TT.MaterialLength, ' +
                             'TT.MaterialWidth, TT.MaterialQualCoeff, TT.MaterialAreaCoeff, ' +
                             'TT.MaterialUnitAbbreviation, TT.MaterialSubUnitsPerUnit, ' +
                             'TT.BasicAllowance, TT.AdjustedAllowance, TS.Construction, TS.TagNo ' +
                             'FROM TicketTickets TT, TicketSequences TS ' +
                             'WHERE TT.WeekNo = TS.WeekNo AND TT.SequenceNo = TS.SequenceNo AND (' +
                                    SQLString + ') AND TT.Print = TRUE ' +
                             'Order By TT.MaterialCode, TT.MaterialCode, TT.WeekNo, TT.SequenceNo, TT.TicketNo';

  fmfrMaterialSummary.qTicketDetails.Open;
  fmfrMaterialSummary.qTicketMaterials.Open;

  screen.Cursor := crDefault;

  //CJY fmfrMaterialSummary.qTicketDetails.FetchOptions.RecordCountMode set to cmTotal
  if fmfrMaterialSummary.qTicketDetails.RecordCount = 0 then
    messagedlg('No Created Tickets Selected', mtInformation, [mbOK], 0)
  else
  try
    frMaterialSummary.PrintOptions.PrintMode := pmScale;
    frMaterialSummary.PrintOptions.PrintOnSheet := GetPaperSize;
    frMaterialSummary.PrepareReport;
    if Preview then
      frMaterialSummary.ShowPreparedReport
    else
      frMaterialSummary.Print;
  except
    fmMemoryError.showError(self);
  end;

  fmfrMaterialSummary.qTicketMaterials.Close;
  fmfrMaterialSummary.qTicketDetails.Close;
end;

end.
