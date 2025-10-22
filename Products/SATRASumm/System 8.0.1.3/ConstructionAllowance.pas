unit ConstructionAllowance;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, ExtCtrls, Grids, Db,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus,
  FDTablePlus, ComCtrls, Times, CmnTypes, Buttons, XStringGrid, XStringGridPlus,
  ToolWin, ActnList, frxClass, Clipbrd, frxReportPlus, CutUtils;

type
  TfmConstructionAllowance = class(TForm)
    qCommonWidths: TFDQueryPlus;
    qCommonWidthsNo: TSmallintField;
    qCommonWidthsWidth: TStringField;
    qCommonWidthsSampleSize: TStringField;
    qCommonWidthsCommonIn: TIntegerField;
    qConParts: TFDQueryPlus;
    tbMain: TPanel;
    pnlTop: TPanel;
    pnlMain: TPanel;
    btnRefresh: TSpeedButton;
    sgSampleResults: TXStringGridPlus;
    sgCostedResults: TXStringGridPlus;
    qCuttingTimes: TFDQueryPlus;
    qGetData: TFDQueryPlus;
    qCuttingTimesCoeff: TIntegerField;
    qCuttingTimesTime: TFloatField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    btnCopy: TSpeedButton;
    frConstructionAllowance: TfrxReportPlus;
    frudsConstructionAllowance: TfrxUserDataSet;
    pnlWidth: TPanel;
    pnlWidthTitle: TPanel;
    cbWidths: TComboBox;
    pnlSizes: TPanel;
    rgSampleCosted: TRadioGroup;
    pnlSizesTitle: TPanel;
    btnSize: TButton;
    pnlAllowanceHeaders: TPanel;
    pnlHeader3: TPanel;
    pnlHeader2: TPanel;
    Panel2: TPanel;
    pnlHeader4: TPanel;
    redtClipboard: TRichEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure PassConstructionName(ConAllowForm : TfmConstructionAllowance; var Code: string);
    function Allowances(var SampleBasicAllowance, SampleAdjustedAllowance,
                            SampleSyntheticBasicAllowance, CostedBasicAllowance,
                            CostedAdjustedAllowance, CostedSyntheticBasicAllowance: real;
                        var SampleAdjInterlocks, CostedAdjInterlocks: RealArray): Boolean;
    procedure FillGrid;
    procedure cbWidthsChange(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgSampleResultsBeforeDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnRefreshClick(Sender: TObject);
    procedure rgSampleCostedClick(Sender: TObject);
    procedure sgCostedResultsBeforeDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure btnCopyClick(Sender: TObject);
    procedure ColumnTitlesItems;
    procedure frConstructionAllowanceBeforePrint(Sender: TfrxReportComponent);
    procedure frConstructionAllowanceGetValue(const VarName: string; var Value: Variant);
    procedure frudsConstructionAllowanceGetValue(const VarName: string;
      var Value: Variant);
    procedure btnSizeClick(Sender: TObject);
    procedure cbWidthsDropDown(Sender: TObject);
  private
    { Private declarations }
    BusyPrinting: boolean;
    fmConstructionAllowance: TfmConstructionAllowance;
    Construction: string;
    dmTimes: TdmTimes;
    Cols: integer;
    WidthNoArray: array of short;
    MadeInPairs: boolean;
  public
    { Public declarations }
  end;

implementation

uses
  SysUtils, Graphics, Dialogs, SummsVars, BasicAlw, Adjfact, Summs, OutOfMemory, General;

{$R *.DFM}

procedure TfmConstructionAllowance.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    qConParts.Close;
    qCommonWidths.Close;

    action := caFree;
  end;
end;

procedure TfmConstructionAllowance.PassConstructionName(ConAllowForm : TfmConstructionAllowance; var Code: string);
var
  i, WidthIndex: integer;
  KeepWidth: string;

begin
  Screen.cursor := crHourGlass;

  KeepWidth := cbWidths.Text;

  fmConstructionAllowance := ConAllowForm;
  Construction := Code;
  fmConstructionAllowance.Caption := 'Allowance for Construction : ' + Construction;

  qConParts.ParamByName('Code').AsString := Construction;
  qConParts.Open;

  rgSampleCosted.Items[0] := 'Sample (Size ' + qConParts.FieldByName('SampleSize').value + ')';
  rgSampleCosted.Items[1] := 'Costed (Size ' + qConParts.FieldByName('CostedSize').value + ')';
  MadeInPairs := qConParts.FieldByName('MadeInPairs').value;

  if not MadeInPairs then
    ColumnTitlesItems;  

  qCommonWidths.ParamByName('Code').AsString := Construction;
  qCommonWidths.Open;
  //CJY: Fetching all records to correct RecordCount (overhead partially offset
  //by iteration of now cached records)
  qCommonWidths.FetchAll;

  i := 0;
  cbWidths.Clear;

  //CJY: qCommonWidths.FetchOptions.RecordCountMode set to cmTotal
  SetLength(WidthNoArray, qCommonWidths.RecordCount);

  WidthIndex := -1;

  qCommonWidths.RecNo := 1; //CJY changed from qCommonWidths.First
  qCommonWidths.Prior; //CJY changed from qCommonWidths.First
  while not(qCommonWidths.eof) do
  begin
    cbWidths.Items.Add(qCommonWidthsWidth.Value);

    if KeepWidth = qCommonWidthsWidth.Value then
      WidthIndex := i;

    WidthNoArray[i] := qCommonWidthsNo.Value;
    inc(i);
    qCommonWidths.Next;
  end;

  if WidthIndex > -1 then
    cbWidths.ItemIndex := WidthIndex;

  qCommonWidths.Close;

  if (cbWidths.ItemIndex = -1) and (cbWidths.Items.Count = 1) then
  begin
    cbWidths.itemIndex := 0;
    cbWidthsChange(self);
  end;

  Screen.cursor := crDefault;
end;

procedure TfmConstructionAllowance.FillGrid;
var
  Caption, MatWidthStr, UnitsStr: string;
  i, j, k, LinesInGrid: integer;
  SampleBasicAllowance, SampleAdjustedAllowance, SampleMaterialCostPerPair: real;
  CostedBasicAllowance, CostedAdjustedAllowance, CostedMaterialCostPerPair: real;
  CostedSyntheticBasicAllowance, SampleSyntheticBasicAllowance: Real;
  SampleTime, CostedTime, LinearMultiplierAllowance, LinearMultiplierPrice: real;
  SampleTotalMaterialCostPerPair, SampleTotalMaterialCostPerBatchPairs, SampleTotalTime: real;
  CostedTotalMaterialCostPerPair, CostedTotalMaterialCostPerBatchPairs, CostedTotalTime: real;
  SampleAdjInterlocks, CostedAdjInterlocks: RealArray;
  SampleCaption, CostedCaption: real;
  ToFeet, SqFtToUnits: real;
  Part: string;
  AdjFactor: real;
  PartWidthNo: short;
  PartError, ConstructionError, NotAvailableSample, NotAvailableCosted, SecondLine: Boolean;
  NotAvailableSampleMC1, NotAvailableSampleMC10: boolean;
  NotAvailableCostedMC1, NotAvailableCostedMC10: boolean;
  Dummy: TTicketInts;
  CurrentColor: TColor;

begin
//CJY: There are 3 total fields on two string grids (6 fields in total) that should be unavailable
//  if any part is unavailable.  These flags are get to true to prevent them showing partial
//  total results.

  NotAvailableSampleMC1 := False;
  NotAvailableCostedMC1 := False;
  NotAvailableSampleMC10 := False;
  NotAvailableCostedMC10 := False;
  NotAvailableSample := False;
  NotAvailableCosted := False;
  Screen.cursor := crHourGlass;

  SampleTotalMaterialCostPerPair := 0;
  SampleTotalMaterialCostPerBatchPairs := 0;
  SampleTotalTime := 0;
  CostedTotalMaterialCostPerPair := 0;
  CostedTotalMaterialCostPerBatchPairs := 0;
  CostedTotalTime := 0;
  sgSampleResults.RowCount := 2;
  sgCostedResults.RowCount := 2;
  ConstructionError := FALSE;

  //CJY: Fetching all records to correct RecordCount (overhead partially offset
  //by iteration of now cached records)
  qConParts.FetchAll;

  //CJY: qConParts.FetchOptions.RecordCountMode set to cmTotal
  LinesInGrid := qConParts.RecordCount;
  i := 0;
  qConParts.RecNo := 1; //CJY changed from qConParts.First
  qConParts.Prior; //CJY changed from qConParts.First
//  CurrentColor := clMediumSkyBlue;
  //CJY: qConParts.FetchOptions.RecordCountMode set to cmTotal
//  for i := 1 to qConParts.RecordCount do
  while not(i = LinesInGrid) do
  begin
    inc(i);
    Part := qConParts.FieldByName('Part').asString;
    PartWidthNo := WidthNoArray[cbWidths.itemIndex];

    PartError := Allowances(SampleBasicAllowance, SampleAdjustedAllowance, SampleSyntheticBasicAllowance,
                            CostedBasicAllowance, CostedAdjustedAllowance, CostedSyntheticBasicAllowance,
                            SampleAdjInterlocks, CostedAdjInterlocks);

    if PartError then
      ConstructionError := TRUE;

    if Option_CuttingTimes and not PartError then
      AdjFactor := dmAdjFact.PartAdjFactor(Part, PartWidthNo)
    else
      Adjfactor := 0;

    qGetData.ParamByName('PartCode').AsString := Part;
    qGetData.ParamByName('WidthNo').value := PartWidthNo;
    qGetData.ParamByName('AdjFactor').value := AdjFactor;
    qGetData.ParamByName('SampleAdjustedAllowance').value := SampleAdjustedAllowance;
    qGetData.ParamByName('CostedAdjustedAllowance').value := CostedAdjustedAllowance;
    qGetData.ParamByName('SampleSyntheticBasicAllowance').AsFloat := SampleSyntheticBasicAllowance;
    qGetData.ParamByName('CostedSyntheticBasicAllowance').AsFloat := CostedSyntheticBasicAllowance;
    qGetData.paramByName('Construction').value := Construction;
    qGetData.Open;

    UnitsStr := 'Sq ' + qGetData.FieldByName('UnitAbbreviation').value;
    LinearMultiplierPrice := 1;
    LinearMultiplierAllowance := 1;

    if (qGetData.FieldByName('MaterialType').value = 'S') or (qGetData.FieldByName('MaterialType').value = 'R') then
    begin
      if qGetData.FieldByName('LinearMatPrice').Value and not qGetData.FieldByName('LinearAllowance').Value then
      begin
        LinearMultiplierPrice := qGetData.FieldByName('SubUnitsPerUnit').value / qGetData.FieldByName('MatWidth').value;
        LinearMultiplierAllowance := 1;
      end
      else if not qGetData.FieldByName('LinearMatPrice').Value and qGetData.FieldByName('LinearAllowance').Value then
      begin
        LinearMultiplierPrice := 1;
        LinearMultiplierAllowance := qGetData.FieldByName('SubUnitsPerUnit').value / qGetData.FieldByName('MatWidth').value;
      end
      else if qGetData.FieldByName('LinearMatPrice').Value and qGetData.FieldByName('LinearAllowance').Value then
      begin
        LinearMultiplierPrice := qGetData.FieldByName('SubUnitsPerUnit').value / qGetData.FieldByName('MatWidth').value;
        LinearMultiplierAllowance := qGetData.FieldByName('SubUnitsPerUnit').value / qGetData.FieldByName('MatWidth').value;
      end;
    end;

    if qGetData.FieldByName('SLMAllowance').value then
    begin
      SampleSyntheticBasicAllowance := SampleBasicAllowance;
      CostedSyntheticBasicAllowance := CostedBasicAllowance;
    end;

    ToFeet := qGetData.FieldByName('ToFeet').value;
    SqftToUnits := 1 / (ToFeet * ToFeet);

    if (qGetData.FieldByName('MaterialType').value = 'S') or (qGetData.FieldByName('MaterialType').value = 'R') then
    begin
      SampleBasicAllowance := SampleSyntheticBasicAllowance;
      CostedBasicAllowance := CostedSyntheticBasicAllowance;
      SampleAdjustedAllowance := SampleSyntheticBasicAllowance;
      CostedAdjustedAllowance := CostedSyntheticBasicAllowance;
    end;

    SampleMaterialCostPerPair := SampleAdjustedAllowance * SqftToUnits * qGetData.FieldByName('StandardPrice').value * LinearMultiplierPrice;
    CostedMaterialCostPerPair := CostedAdjustedAllowance * SqftToUnits * qGetData.FieldByName('StandardPrice').value * LinearMultiplierPrice;

    if Option_CuttingTimes and not PartError then
    begin

      dmTimes.CalculateAllTimes(TRUE, qGetData.FieldByName('StdBatchSize').value, qGetData, qCuttingTimes, 0, SampleAdjInterlocks, Dummy, TRUE);
      //CJY: If the CalculateAllTimes finds a min/max error set time to 0
      if not dmCutUtils.MessageShown then
      begin
        qCuttingTimes.Open;
        SampleTime := qCuttingTimes.FieldByName('Time').value;
        qCuttingTimes.Close;
      end
      else
        SampleTime := 0;

      dmTimes.CalculateAllTimes(FALSE, qGetData.FieldByName('StdBatchSize').value, qGetData, qCuttingTimes, 0, CostedAdjInterlocks, Dummy, TRUE);
      //CJY: If the CalculateAllTimes finds a min/max error set time to 0
      if not dmCutUtils.MessageShown then
      begin
        qCuttingTimes.Open;
        CostedTime := qCuttingTimes.FieldByName('Time').value;
        qCuttingTimes.Close;
      end
      else
        CostedTime := 0;

    end
    else
    begin
      SampleTime := 0;
      CostedTime := 0;
    end;

    sgSampleResults.Cells[0, i] := Part;
    sgSampleResults.Cells[1, i] := qGetData.FieldByName('Material').value;
    sgSampleResults.Cells[2, i] := UnitsStr;
    sgCostedResults.Cells[0, i] := qGetData.FieldByName('Code').Value;
    sgCostedResults.Cells[1, i] := qGetData.FieldByName('Material').value;
    sgCostedResults.Cells[2, i] := UnitsStr;

    for k := 0 to Cols - 1 do
    begin
      //sgSampleResults.CellColor[k, i] := CurrentColor;
      //sgCostedResults.CellColor[k, i] := CurrentColor;
    end;

    if not PartError then
    begin
       for j := 3 to Cols - 1 do
       begin
         case j of
           3 : begin
                 SampleCaption := SampleBasicAllowance * SqftToUnits;
                 CostedCaption := CostedBasicAllowance * SqftToUnits;
               end;
           4 : begin
                 SampleCaption := SampleAdjustedAllowance * SqftToUnits;
                 CostedCaption := CostedAdjustedAllowance * SqftToUnits;
               end;
           5 : begin
                 SampleCaption := SampleAdjustedAllowance * SqftToUnits * BatchSize;
                 CostedCaption := CostedAdjustedAllowance * SqftToUnits * BatchSize;
               end;
           6 : begin
                 SampleCaption := SampleMaterialCostperPair;
                 CostedCaption := CostedMaterialCostperPair;
                 SampleTotalMaterialCostPerPair := round(SampleTotalMaterialCostPerPair + (SampleMaterialCostPerPair * 10000));
                 CostedTotalMaterialCostPerPair := round(CostedTotalMaterialCostPerPair + (CostedMaterialCostPerPair * 10000));
               end;
           7 : begin
                 SampleCaption := SampleMaterialCostperPair * BatchSize;
                 CostedCaption := CostedMaterialCostperPair * BatchSize;
                 SampleTotalMaterialCostPerBatchPairs := round(SampleTotalMaterialCostPerBatchPairs + (SampleMaterialCostPerPair * 10000 * BatchSize));
                 CostedTotalMaterialCostPerBatchPairs := round(CostedTotalMaterialCostPerBatchPairs + (CostedMaterialCostPerPair * 10000 * BatchSize));
               end;
           8 : begin
                 SampleCaption := SampleTime;
                 CostedCaption := CostedTime;
                 SampleTotalTime := round(SampleTotalTime + (SampleTime * 10000));
                 CostedTotalTime := round(CostedTotalTime + (CostedTime * 10000));
               end;
         end;

         str(SampleCaption : 10 : 4, Caption);
         if (Caption = '    0.0000') then
         begin
           Caption := 'Unavailable';

           //CJY: Disable unavailable result totals
           case j of
             6: NotAvailableSampleMC1 := True;
             7: NotAvailableSampleMC10 := True;
             8: NotAvailableSample := True;
           end;

         end;
//         if (sgSampleResults.Cells[3, i] = 'Unavailable') and (j = 8) then
//           Caption := 'Unavailable';

         sgSampleResults.Cells[j, i] := Caption;
         str(CostedCaption : 10 : 4, Caption);
         if Caption = '    0.0000' then
         begin
           Caption := 'Unavailable';

           //CJY: Disable unavailable result totals
           case j of
             6: NotAvailableCostedMC1 := True;
             7: NotAvailableCostedMC10 := True;
             8: NotAvailableCosted := True;
           end;
         end;
//         if (sgCostedResults.Cells[3, i] = 'Unavailable') and (j = 8) then
//           Caption := 'Unavailable';
         sgCostedResults.Cells[j, i] := Caption;
       end;

       if qGetData.FieldByName('LinearAllowance').Value then
       begin
         Str(qGetData.FieldByName('MatWidth').Value: 6: 2, MatWidthStr);
         UnitsStr := '''' + qGetData.FieldByName('UnitAbbreviation').Value + ' x ' + MatWidthStr + ' ' + qGetData.FieldByName('SubUnitAbbreviation').Value + '''';
         SampleAdjustedAllowance := SampleSyntheticBasicAllowance * LinearMultiplierAllowance;
         CostedAdjustedAllowance := CostedSyntheticBasicAllowance * LinearMultiplierAllowance;

         sgSampleResults.RowCount := sgSampleResults.RowCount + 1;
         sgCostedResults.RowCount := sgCostedResults.RowCount + 1;
         inc(i);
         inc(LinesInGrid);
         sgSampleResults.Cells[2, i] := UnitsStr;
         sgCostedResults.Cells[2, i] := UnitsStr;

         SampleCaption := SampleAdjustedAllowance * SqftToUnits;
         str(SampleCaption : 10 : 4, Caption);
         if Caption = '    0.0000' then
         begin
           Caption := 'Unavailable';
           //CJY: Disable unavailable result totals
           case j of
             6: NotAvailableSampleMC1 := True;
             7: NotAvailableSampleMC10 := True;
             8: NotAvailableSample := True;
           end;
         end;
         sgSampleResults.Cells[4, i] := Caption;

         CostedCaption := CostedAdjustedAllowance * SqftToUnits;
         str(CostedCaption : 10 : 4, Caption);
         if Caption = '    0.0000' then
         begin
           Caption := 'Unavailable';
           //CJY: Disable unavailable result totals
           case j of
             6: NotAvailableCostedMC1 := True;
             7: NotAvailableCostedMC10 := True;
             8: NotAvailableCosted := True;
           end;
         end;
         sgCostedResults.Cells[4, i] := Caption;

         for k := 0 to Cols - 1 do
         begin
           //sgSampleResults.CellColor[k, i] := CurrentColor;
           //sgCostedResults.CellColor[k, i] := CurrentColor;
         end;
       end;
    end
    else
    begin
      sgSampleResults.Cells[3, i] := '***None***';
      sgCostedResults.Cells[3, i] := '***None***';
      for j := 4 to Cols - 1 do
      begin
        sgSampleResults.Cells[j, i] := '';
        sgCostedResults.Cells[j, i] := '';
      end;
    end;
    sgSampleResults.RowCount := sgSampleResults.RowCount + 1;
    sgCostedResults.RowCount := sgCostedResults.RowCount + 1;

//    if CurrentColor = clMediumSkyBlue then
//      CurrentColor := clSkyBlue
//    else
//      CurrentColor := clMediumSkyBlue;

    qGetData.close;
    qConParts.next;
  end;

  //sgSampleResults.CellProperties[5, sgSampleResults.Rowcount - 1].ParentFont := False;
  //sgSampleResults.CellProperties[5, sgSampleResults.Rowcount - 1].Font.Style := [];
  sgSampleResults.Cells[5, sgSampleResults.Rowcount - 1] := 'All Materials';
  //sgSampleResults.GroupCells(0, sgSampleResults.Rowcount - 1, 4, sgSampleResults.Rowcount - 1);

  //sgCostedResults.CellProperties[5, sgCostedResults.Rowcount - 1].ParentFont := False;
  //sgCostedResults.CellProperties[5, sgCostedResults.Rowcount - 1].Font.Style := [];
  sgCostedResults.Cells[5, sgCostedResults.Rowcount - 1] := 'All Materials';
  //sgCostedResults.GroupCells(0, sgCostedResults.Rowcount - 1, 4, sgCostedResults.Rowcount - 1);

  for k := 0 to Cols - 1 do
  begin
    //sgSampleResults.CellColor[k, sgSampleResults.Rowcount - 1] := clTotalBlue;
    //sgCostedResults.CellColor[k, sgCostedResults.Rowcount - 1] := clTotalBlue;
  end;

  //CJY: Check and show results if available

  if NotAvailableSampleMC1 then
    Caption := 'Unavailable'
  else
    str(SampleTotalMaterialCostPerPair / 10000 : 10 : 4, Caption);
  sgSampleResults.Cells[6, sgSampleResults.Rowcount - 1] := Caption;

  if NotAvailableCostedMC1 then
    Caption := 'Unavailable'
  else
    str(CostedTotalMaterialCostPerPair / 10000 : 10 : 4, Caption);
  sgCostedResults.Cells[6, sgCostedResults.Rowcount - 1] := Caption;

  if NotAvailableSampleMC10 then
    Caption := 'Unavailable'
  else
    str(SampleTotalMaterialCostPerBatchPairs / 10000 : 10 : 4, Caption);
  sgSampleResults.Cells[7, sgSampleResults.Rowcount - 1] := Caption;

  if NotAvailableCostedMC10 then
    Caption := 'Unavailable'
  else
    str(CostedTotalMaterialCostPerBatchPairs / 10000 : 10 : 4, Caption);
  sgCostedResults.Cells[7, sgCostedResults.Rowcount - 1] := Caption;

  if Option_CuttingTimes then
  begin
    if NotAvailableSample then
      Caption := 'Unavailable'
    else
      str(SampleTotalTime / 10000 : 10 : 4, Caption);
    sgSampleResults.Cells[8, sgSampleResults.Rowcount - 1] := Caption;
    if NotAvailableCosted then
      Caption := 'Unavailable'
    else
      str(CostedTotalTime / 10000 : 10 : 4, Caption);
    sgCostedResults.Cells[8, sgSampleResults.Rowcount - 1] := Caption;
  end;

  if ConstructionError then
  begin
    sgSampleResults.RowCount := sgSampleResults.RowCount - 1;
    sgCostedResults.RowCount := sgCostedResults.RowCount - 1;
  end;

  screen.cursor := crDefault;

  if ConstructionError then
    MessageDlgPos('One or more Part Allowances cannot be calculated.' + #13 +
               '(Try Alternative Material on Part to see error)', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

function TfmConstructionAllowance.Allowances(var SampleBasicAllowance, SampleAdjustedAllowance,
                                                 SampleSyntheticBasicAllowance, CostedBasicAllowance,
                                                 CostedAdjustedAllowance, CostedSyntheticBasicAllowance: real;
                                             var SampleAdjInterlocks, CostedAdjInterlocks: RealArray): Boolean;
var
  Allowance: AllowanceResult;
  Part, AltMaterial: string;
  IsError, MadeInPairs: Boolean;
  Error: string;
  WidthNo: integer;

begin
  IsError := FALSE;
  WidthNo := WidthNoArray[cbWidths.ItemIndex];

  Part := qConParts.FieldByName('Part').Value;
  AltMaterial := qConParts.FieldByName('AltMaterial').asString;

  //Sample Allowance
  Allowance := dmBasAll.AllowanceSingle(Part, AltMaterial, qConParts.FieldByName('SampleSize').asString,
                                        qConParts.FieldByName('CostedSize').asString, WidthNo, TRUE,
                                        qConParts.FieldByName('SLMAllowance').asBoolean);
  Error := Allowance.Error;
  if Error <> '' then
    IsError := TRUE;
  SampleBasicAllowance := Allowance.BasicAllowance;
  SampleAdjustedAllowance := Allowance.AdjustedAllowance;
  SampleSyntheticBasicAllowance := Allowance.SampleSyntheticBasicAllowance;
  SampleAdjInterlocks := Allowance.AdjInterlocks;

  //Costed Allowance
  Allowance := dmBasAll.AllowanceSingle(Part, AltMaterial, qConParts.FieldByName('SampleSize').asString,
                                        qConParts.FieldByName('CostedSize').asString, WidthNo, FALSE,
                                        qConParts.FieldByName('SLMAllowance').asBoolean);
  Error := Allowance.Error;
  if Error <> '' then
    IsError := TRUE;
  CostedBasicAllowance := Allowance.BasicAllowance;
  CostedAdjustedAllowance := Allowance.AdjustedAllowance;
  CostedSyntheticBasicAllowance := Allowance.CostedSyntheticBasicAllowance;
  CostedAdjInterlocks := Allowance.AdjInterlocks;

  Result := IsError;
end;

procedure TfmConstructionAllowance.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmConstructionAllowance.cbWidthsChange(Sender: TObject);
begin
  FillGrid;

  btnRefresh.enabled := TRUE;
  btnPrintPreview.enabled := TRUE;
  btnPrint.enabled := TRUE;
  btnCopy.enabled := TRUE;
end;

procedure TfmConstructionAllowance.cbWidthsDropDown(Sender: TObject);
begin
  if cbWidths.Items.Count = 0 then
    MessageDlgPos('There are no common widths for this contruction', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

procedure TfmConstructionAllowance.frConstructionAllowanceBeforePrint(Sender: TfrxReportComponent);
begin
  frConstructionAllowance.PreviewOptions.AllowEdit := False;
  frConstructionAllowance.PreviewOptions.Buttons := frConstructionAllowance.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frConstructionAllowance.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frConstructionAllowance.PreviewOptions.ZoomMode := zmDefault
  else
    frConstructionAllowance.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmConstructionAllowance.frConstructionAllowanceGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := Caption
  else if (VarName = 'SampleCosted') then
    Value := rgSampleCosted.Items[rgSampleCosted.ItemIndex]
  else if (VarName = 'Width') then
    Value := cbWidths.Text;

  if MadeInPairs then
  begin
  if (VarName = '1PrAlwTitle') then
    Value := '1 Pair'
  else if (VarName = 'xPrAlwTitle') then
    Value := IntToStr(BatchSize) + ' Pairs'
  else if (VarName = '1PrMatCostTitle') then
    Value := '1 Pair'
  else if (VarName = 'xPrMatCostTitle') then
    Value := IntToStr(BatchSize) + ' Pairs';
  end
  else
  begin
    if (VarName = '1PrAlwTitle') then
      Value := '1 Item'
    else if (VarName = 'xPrAlwTitle') then
      Value := IntToStr(BatchSize) + ' Items'
    else if (VarName = '1PrMatCostTitle') then
      Value := '1 Item'
    else if (VarName = 'xPrMatCostTitle') then
      Value := IntToStr(BatchSize) + ' Items'
  end;

  if (VarName = 'SmsTitle') then
  begin
    if Option_CuttingTimes then
      Value := 'Ams'
    else
      Value := '';
  end;
end;

procedure TfmConstructionAllowance.frudsConstructionAllowanceGetValue(
  const VarName: string; var Value: Variant);
var
  TheGrid: TXStringGridPlus;

begin
  if (frudsConstructionAllowance.RecNo = 0) then
    frudsConstructionAllowance.Next;

  if (rgSampleCosted.ItemIndex = 0) then
    TheGrid := sgSampleResults
  else
    TheGrid := sgCostedResults;

  if VarName = 'Part' then
    Value := TheGrid.Cells[0, frudsConstructionAllowance.RecNo]
  else if VarName = 'Material' then
    Value := TheGrid.Cells[1, frudsConstructionAllowance.RecNo]
  else if VarName = 'Units' then
    Value := TheGrid.Cells[2, frudsConstructionAllowance.RecNo]
  else if VarName = 'BasAlw' then
    Value := TheGrid.Cells[3, frudsConstructionAllowance.RecNo]
  else if VarName = '1PrAlw' then
    Value := TheGrid.Cells[4, frudsConstructionAllowance.RecNo]
  else if VarName = 'xPrAlw' then
    Value := TheGrid.Cells[5, frudsConstructionAllowance.RecNo]
  else if VarName = '1PrMatCost' then
    Value := TheGrid.Cells[6, frudsConstructionAllowance.RecNo]
  else if VarName = 'xPrMatCost' then
    Value := TheGrid.Cells[7, frudsConstructionAllowance.RecNo]
  else if VarName = 'Sms' then
    Value := TheGrid.Cells[8, frudsConstructionAllowance.RecNo];
end;

procedure TfmConstructionAllowance.btnPrintClick(Sender: TObject);
begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frConstructionAllowance.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  frudsConstructionAllowance.RangeEnd := reCount;
  if rgSampleCosted.ItemIndex = 0 then
    frudsConstructionAllowance.RangeEndCount := sgSampleResults.RowCount
  else
    frudsConstructionAllowance.RangeEndCount := sgCostedResults.RowCount;

  frConstructionAllowance.PrintOptions.PrintMode := pmScale;
  frConstructionAllowance.PrintOptions.PrintOnSheet := GetPaperSize;
  frConstructionAllowance.PrepareReport;

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frConstructionAllowance do
    begin
      ShowPreparedReport;
      if (((PreviewForm.Left + (PreviewForm.Width div 2)) > Application.MainForm.Width) or 
          (((PreviewForm.Left + (PreviewForm.Width div 2)) < 0))) then
        PreviewForm.Left := ((Application.MainForm.Width - PreviewForm.Width) div 2);
      if (((PreviewForm.Top + (PreviewForm.Height div 2)) > Application.MainForm.Height) or 
          (((PreviewForm.Top + (PreviewForm.Height div 2)) < 0))) then
        PreviewForm.Top := ((Application.MainForm.Height - PreviewForm.Height) div 2);
    end;
  end
  else
    frConstructionAllowance.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmConstructionAllowance.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;

  screen.cursor := crHourGlass;

  pnlHeader4.Visible := Option_CuttingTimes;
  if Option_CuttingTimes then
    Cols := 9
  else
    Cols := 8;

  sgSampleResults.ColCount := Cols;
  sgCostedResults.ColCount := Cols;

  sgSampleResults.Cells[0, 0] := 'Part';
  sgSampleResults.Cells[1, 0] := 'Material';
  sgSampleResults.Cells[3, 0] := 'Basic'; //Allowance
  sgSampleResults.Cells[4, 0] := '1 Pair'; // Allowance
  sgSampleResults.Cells[5, 0] := IntToStr(BatchSize) + ' Pairs'; //Allowance
  sgSampleResults.Cells[6, 0] := '1 Pair'; //Material Cost
  sgSampleResults.Cells[7, 0] := IntToStr(BatchSize) + ' Pairs'; //Material Cost
  sgCostedResults.Cells[0, 0] := 'Part';
  sgCostedResults.Cells[1, 0] := 'Material';
  sgCostedResults.Cells[3, 0] := 'Basic'; //Allowance
  sgCostedResults.Cells[4, 0] := '1 Pair'; // Allowance
  sgCostedResults.Cells[5, 0] := IntToStr(BatchSize) + ' Pairs'; //Allowance
  sgCostedResults.Cells[6, 0] := '1 Pair'; //Material Cost
  sgCostedResults.Cells[7, 0] := IntToStr(BatchSize) + ' Pairs'; //Material Cost

  if Option_CuttingTimes then
  begin
    sgSampleResults.Cells[8, 0] := 'Ams';
    sgCostedResults.Cells[8, 0] := 'Ams';
  end;
end;

procedure TfmConstructionAllowance.ColumnTitlesItems;
begin
  sgSampleResults.Cells[4, 0] := '1 Item'; // Allowance
  sgSampleResults.Cells[5, 0] := IntToStr(BatchSize) + ' Items'; //Allowance
  sgSampleResults.Cells[6, 0] := '1 Item'; //Material Cost
  sgSampleResults.Cells[7, 0] := IntToStr(BatchSize) + ' Items'; //Material Cost
  sgCostedResults.Cells[4, 0] := '1 Item'; // Allowance
  sgCostedResults.Cells[5, 0] := IntToStr(BatchSize) + ' Items'; //Allowance
  sgCostedResults.Cells[6, 0] := '1 Item'; //Material Cost
  sgCostedResults.Cells[7, 0] := IntToStr(BatchSize) + ' Items'; //Material Cost
end;

procedure TfmConstructionAllowance.sgSampleResultsBeforeDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  SelRect: TGridRect;

begin
  //Prevents the display of a blue focus bar in the grid.
  SelRect.Left := 0;
  SelRect.Top := 0;
  SelRect.Right := 0;
  SelRect.Bottom := 0;
  sgSampleResults.Selection := SelRect;
end;

procedure TfmConstructionAllowance.btnRefreshClick(Sender: TObject);
var
  ConstructionCode: string;
  i: integer;

begin
  sgSampleResults.RowCount := 2;
  sgCostedResults.RowCount := 2;

  for i := 0 to sgSampleResults.ColCount - 1 do
  begin
    sgSampleResults.Cells[i, 1] := '';
    sgCostedResults.Cells[i, 1] := '';
  end;

  ConstructionCode := qConParts.FieldByName('Construction').Value;
  PassConstructionName(fmConstructionAllowance, ConstructionCode);
  FillGrid;
end;

procedure TfmConstructionAllowance.btnSizeClick(Sender: TObject);
begin
  showmessage(inttostr(fmConstructionAllowance.height) + ' - ' + inttostr(fmConstructionAllowance.Width));
end;

procedure TfmConstructionAllowance.rgSampleCostedClick(Sender: TObject);
begin
  if rgSampleCosted.ItemIndex = 0 then
  begin
    sgSampleResults.visible := true;
    sgCostedResults.visible := false;
  end
  else
  begin
    sgSampleResults.visible := false;
    sgCostedResults.visible := true;
  end;
end;

procedure TfmConstructionAllowance.sgCostedResultsBeforeDrawCell(
  Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
var
  SelRect: TGridRect;

begin
  //Prevents the display of a blue focus bar in the grid.
  SelRect.Left := 0;
  SelRect.Top := 0;
  SelRect.Right := 0;
  SelRect.Bottom := 0;
  sgCostedResults.Selection := SelRect;
end;

procedure TfmConstructionAllowance.btnCopyClick(Sender: TObject);
const
  TAB = #9;
  LF = #10;
var
  r, c: integer;
  s: string;

begin
  if sgSampleResults.visible then
  begin
    s := '';
    for r := 1 to sgSampleResults.RowCount - 1 do
    begin
      for c := 0 to sgSampleResults.ColCount - 1 do
      begin
        s := s + sgSampleResults.Cells[c, r];
        if c < sgSampleResults.ColCount - 1 then
          s := s + TAB;
      end;
      s := s + LF;
    end;
  end
  else if sgCostedResults.visible then
  begin
    s := '';
    for r := 1 to sgCostedResults.RowCount - 1 do
    begin
      for c := 0 to sgCostedResults.ColCount - 1 do
      begin
        s := s + sgCostedResults.Cells[c, r];
        if c < sgCostedResults.ColCount - 1 then
          s := s + TAB;
      end;
      s := s + LF;
    end;
  end;

  //Copying s straight to clipboard loses
  //formatting so copy to TRichEdit first.
  //Also TRichEdit must be visible.
  redtClipboard.Visible := True;
  redtClipboard.Text := s;
  redtClipboard.Visible := False;
  Clipboard.AsText := redtClipboard.Text;
end;

end.

