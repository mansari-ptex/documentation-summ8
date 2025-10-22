unit BasicAlw;

interface

uses
  Windows, Classes, Controls, Forms,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DB, AdjFact,
  CmnTypes, Const_Interlocking;

type
  AllowanceResult = record
    BasicAllowance: real;
    CostedSyntheticBasicAllowance, SampleSyntheticBasicAllowance: real;
    AdjustedAllowance: real;
    AdjInterlocks, CostedSynths, SampleSynths: RealArray;
    CostedKnives, SampleKnives: StringArray;
    NoInterlocks, PairMultiplier: integer;
    MaterialType: Char;
    Size: string;
    Error: string;
    TotalInterlockArea, TotalNettArea : real;
  end;
  GridArray = array of AllowanceResult;
  TdmBasAll = class(TDataModule)
    tblSizeRelnSizes: TFDTablePlus;
    tblSizeScaleSizes: TFDTablePlus;
    qAverageSizes: TFDQueryPlus;
    qBAForParts: TFDQueryPlus;
    qBAForPartsSeq: TFloatField;
    qBAForPartsTableLength: TFloatField;
    qBAForPartsBAQuadraticA: TFloatField;
    qBAForPartsBAQuadraticB: TFloatField;
    qBAForPartsBAQuadraticC: TFloatField;
    qBAForPartsFrequency: TSmallintField;
    qBAForPartsMatType: TStringField;
    qBAForPartsSkinSize: TFloatField;
    qBAForPartsMatLength: TFloatField;
    qBAForPartsMatWidth: TFloatField;
    qBAForPartsCutType: TStringField;
    qBAForPartsTrimmed: TBooleanField;
    qBAForPartsAreaCoeff: TSmallintField;
    qBAForPartsQualCoeff: TSmallintField;
    qBAForPartsToFeet: TFloatField;
    qBAForPartsSubUnitsPerUnit: TSmallintField;
    qBAForPartsKnifeType: TStringField;
    qBAForPartsInterlockAreaPrimeSynthetic: TFloatField;
    qBAForPartsInterlockAreaNonPrime: TFloatField;
    qBAForPartsGrossArea: TFloatField;
    qBAForPartsPieces: TSmallintField;
    qBAForPartsSampleSize: TStringField;
    qBAForPartsSampleSizeMm: TSmallintField;
    qBAForPartsScale: TStringField;
    qBAForPartsSizeRelationship: TStringField;
    qBAForPartsShoeSize: TStringField;
    qBAForPartsNumberOfKnives: TIntegerField;
    qBAForPartsAdjustedKnifeLength: TIntegerField;
    qBAForPartsNettArea: TFloatField;
    qBAForPartsSqFtPerPiece: TFloatField;
    qBAForPartsKnifeCutGap: TSmallintField;
    qKnifeSetExists: TFDQueryPlus;
    qKnifeSetExistsACount: TIntegerField;
    qKnifeSetExistsSLMAllowance: TBooleanField;
    qBAForPartsMadeInPairs: TBooleanField;
    qBAForPartsLinearAllowance: TBooleanField;
    qBAForPartsKnife: TStringField;
    qBAForPartsMatCode: TStringField;
    qBAForPartsUnitAbbreviation: TStringField;
    qBAForPartsSubUnitAbbreviation: TStringField;
    qDropTemp: TFDQueryPlus;
    qBAForPartsAdjustedKnifeSize: TStringField;
    function AllowanceSingle(PartCode, AltMaterial, SampleSize, CostedSize: string;
                             WidthNo: short;
                             Sample, SLMAllowance: boolean): AllowanceResult;
    procedure PassAllowanceTicketQuery(qAverageSizesIn: TFDQueryPlus);
    procedure AllowanceAllCosts(PartCode: String;
                                WidthNo: short;
                                var CostingGrid: GridArray;
                                var NumberOfSizes: integer;
                                var MatCode, UnitsStr: string);
    function Allowances(PartCode, AltMaterial: string;
                        WidthNo: short;
                        Sample, Grid, Ticket: Boolean;
                        qBA: TFDQueryPlus): AllowanceResult;
    function CommonBasicAllowance(NumberOfKnives: integer;
                                  MaterialAreaSqFt: real;
                                  var GrossAreaArray, InterlockAreaArray,
                                  PiecesArray: RealArray;
                                  qBA: TFDQueryPlus): real;
    function AdjustedAllowance(PartCode, AltMaterial: string; WidthNo, AreaCoeff, QualCoeff: short;
                               BasicAllowance: real; MaterialType: Char): real;
    function CalcAdjAlw(AreaCoeff, QualCoeff, AdjFactor: integer; BasicAllowance: real): real;
    function QuadraticResult(Sizemm: integer;
                             qBA: TFDQueryPlus): real;
    procedure SizeAdjustment(var Multiplier: real;
                             Sample, Ticket: Boolean;
                             qBA: TFDQueryPlus);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    InUse: boolean;
  public
    { Public declarations }
    function ChangeAllConnections(Connection: TFDCustomConnection): boolean;
    procedure RevertAllConnections();
  end;

var
  dmBasAll: TdmBasAll;
  ConnectionNest: Array of TFDCustomConnection;

implementation

uses
  SysUtils, Math, General, SummsVars, Summs; //Summs added for XE5 conversion

{$R *.DFM}

const
  Metres_To_Cms = 100;              //Constants for BasicAllowance
  Cms_To_Inches = 0.3937;
  SqInches_To_SqFeet = 1/144;

procedure Quicksort(var SortIt, SI1, SI2: RealArray;
                        LoIndex, HiIndex: integer);
var
  Lo, Hi: integer;
  Temp, mid: real;

begin
  Lo := LoIndex;
  Hi := HiIndex;
  Mid := SortIt[(Lo + Hi) div 2];
  repeat
    while SortIt[Lo] < Mid do
      Inc(Lo);       //to reverse final order of array
    while SortIt[Hi] > Mid do
      Dec(Hi);       //simply swap these > and < signs.
    if Lo <= Hi then
    begin
      Temp := SortIt[Lo];
      SortIt[Lo] := SortIt[Hi];
      SortIt[Hi] := Temp;

      Temp := SI1[Lo];
      SI1[Lo] := SI1[Hi];
      SI1[Hi] := Temp;

      Temp := SI2[Lo];
      SI2[Lo] := SI2[Hi];
      SI2[Hi] := Temp;

      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;

  if Hi > LoIndex then
    QuickSort(SortIt, SI1, SI2, LoIndex, Hi);
  if Lo < HiIndex then
    QuickSort(SortIt, SI1, SI2, Lo, HiIndex);
end;

procedure RemoveSmallest(var NumberOfKnives: integer;
                         var GrossAreaArray, InterlockAreaArray, PiecesArray: RealArray);
var
  i: integer;

begin
  NumberOfKnives := NumberOfKnives - 1;
  for i := 1 to NumberOfKnives do
  begin
    GrossAreaArray[i] := GrossAreaArray[i + 1];
    InterlockAreaArray[i] := InterlockAreaArray[i + 1];
    PiecesArray[i] := PiecesArray[i + 1];
  end;
end;

function CalcBasicPutUp(qBA: TFDQueryPlus): real;
var
//  i: integer;
  BasicPutUp, PatternItems: real;

begin
  {Basic putup is calculated based on the number of UNIQUE knives on a Part. It
  is responsible for tightening the allowance when there are more pieces to
  absorb the waste.}
  PatternItems := 0;

  //CJY:Begin removing dependence on RecordCount
  qBA.RecNo := 1; //CJY changed from qBA.First
  qBA.Prior; //CJY changed from qBA.First
  while not qBA.eof do
  begin
    PatternItems := PatternItems + (1 / qBA.FieldByName('Pieces').Value);
    qBA.Next;
  end;
{
  //CJY: Would require qBA.FetchOptions.RecordCountMode set to cmTotal
  qBA.RecNo := 1; //CJY changed from qBA.First
  qBA.Prior; //CJY changed from qBA.First
  for i := 1 to qBA.RecordCount do
  begin
    PatternItems := PatternItems + (1 / qBA.FieldByName('Pieces').Value);
    qBA.Next;
  end;
}
  //CJY:End
  {Calculate Basic Put-Up percentages using curve fitting constants.}

  BasicPutUp := 24.1411 / Power(PatternItems, 0.149546);

  {There is a maximum value for Basic Put-Up percentages}

  if (BasicPutUp > 24.1411) then
    BasicPutUp := 24.1411;

  Result := BasicPutUp;
end;

function TdmBasAll.CommonBasicAllowance(NumberOfKnives: integer;
                                        MaterialAreaSqFt: real;
                                        var GrossAreaArray, InterlockAreaArray,
                                            PiecesArray: RealArray;
                                        qBA: TFDQueryPlus): real;
var
  i, j, PairMultiplier: integer;
  AreaAbsorbedConstant, AreaDifference, BasicAllowance, BasicPutUp, EdgeWaste, Increase,
  InterlockAreaAdjustment, LineMin, NewInterlockArea, PatternItems, RemainingInterlockArea,
  RunnerPatPercentageConstant, SmallSkinUplift, TotalInterlockArea, TotalGrossArea, TotalRatio: real;
  AreaAbsorbedArray, UpliftPercentageArray: RealArray;
  MaterialType: Char;
  Trimmed: boolean;

begin
  BasicAllowance := 0;
  PatternItems := 0;
  TotalInterlockArea := 0;
  TotalGrossArea := 0;

  for i := 1 to NumberOfKnives do
  begin
    TotalInterlockArea := TotalInterlockArea + (InterlockAreaArray[i] / PiecesArray[i]);
    TotalGrossArea := TotalGrossArea + (GrossAreaArray[i] / PiecesArray[i]);
  end;

  BasicPutUp := CalcBasicPutUp(qBA);

  {Adjust Basic Put Up for different types of material because synthetic materials and skins which have been trimmed are easier to cut}

  MaterialType := qBA.FieldByName('MatType').AsString[1];
  Trimmed := qBA.FieldByName('Trimmed').value;
  if qBA.FieldByName('MadeInPairs').value then
    PairMultiplier := 2
  else
    PairMultiplier := 1;

  if (MaterialType in Synthetics) then
    BasicPutUp := BasicPutUp-5   //5% Adjustment
  else if (MaterialType in Leathers) and (Trimmed=True) then
    BasicPutUp := BasicPutUp-3;   //3% Adj

  {Make two curve fitting constants - calculations to match look-up tables}

  RunnerPatPercentageConstant := 57.431 / Power(MaterialAreaSqFt, 0.64412);
  AreaAbsorbedConstant := 2.54321 * Power(MaterialAreaSqFt, 0.338347);

  RemainingInterlockArea := TotalInterlockArea;

  SetLength(AreaAbsorbedArray, NumberOfKnives + 1);
  SetLength(UpliftPercentageArray, NumberOfKnives + 1);

  i := 0;
  repeat
    inc(i);
    EdgeWaste := RunnerPatPercentageConstant * Power(InterlockAreaArray[i], 0.5);
    UpliftPercentageArray[i] := EdgeWaste + BasicPutUp;

    LineMin := AreaAbsorbedConstant * Power(InterlockAreaArray[i], 0.72);
    if LineMin > 1.2 then
      LineMin := 1.2;
    AreaAbsorbedArray[i] := (LineMin+InterlockAreaArray[i]) / PiecesArray[i];

    RemainingInterlockArea := RemainingInterlockArea - AreaAbsorbedArray[i];
  until (i = NumberOfKnives) or (RemainingInterlockArea <= 0);

  if (RemainingInterlockArea < 0) then
    AreaAbsorbedArray[i] := AreaAbsorbedArray[i] + RemainingInterlockArea;

  for j := 1 to i do
   BasicAllowance := BasicAllowance + (AreaAbsorbedArray[j] * (1 + UpliftPercentageArray[j] / 100));

  {Do small skin check for leather materials only}
  TotalRatio := (InterlockAreaArray[NumberOfKnives] * 100 / MaterialAreaSqFt);
  if (TotalRatio > 8.6) then
  begin
    SmallSkinUplift := (TotalRatio - 8.4) * 0.0789;
    AreaDifference := TotalGrossArea - TotalInterlockArea;
    InterlockAreaAdjustment := AreaDifference * SmallSkinUplift;

    NewInterlockArea := TotalInterlockArea + InterlockAreaAdjustment;
    if (NewInterlockArea > TotalGrossArea) then
      NewInterlockArea := TotalGrossArea;

    Increase := BasicAllowance / TotalInterlockArea;
    BasicAllowance := NewInterlockArea * Increase;
  end;

  Result := BasicAllowance * PairMultiplier;
end;

function TdmBasAll.AllowanceSingle(PartCode, AltMaterial, SampleSize, CostedSize: string;
                                   WidthNo: short;
                                   Sample, SLMAllowance: boolean): AllowanceResult;
var
  MatCode, SizeStr, SQLString, WidthNoStr, sPatternRes: string;

begin
  if AltMaterial = '' then
    MatCode := 'P.Material'
  else
    MatCode := '''' + QS(AltMaterial) + '''';

  WidthNoStr := IntToStr(WidthNo);
  sPatternRes := 'CONVERT(' + IntToStr(PATTERNRES) + ', SQL_DOUBLE)';

  //N.B.  ShoeSize and Seq appear in the following queries because they are needed in the grid query.  Delphi did not allow the use
  //of FieldByName in addition to fields declared.  Some fields HAD to be declared because of links so a mixture would have been necessary.

  if SLMAllowance then
    SizeStr := '''' + SampleSize + ''''
  else
    SizeStr := 'SRS.KnifeSize';

  if Sample then
  begin
    SQLString := 'SELECT PWK.Seq, PWK.Knife, PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BAQuadraticC, PWK.Frequency, ' +
                        'M.Type AS MatType, M.Code AS MatCode, M.LinearAllowance, P.SLMAllowance, ' +
                        '(SELECT SqFtPerPiece / KS.Pieces ' +
	                      ' FROM LayplanPlans LPP, LayPlanSets LPS ' +
		                    ' WHERE LPP.KnifeCode = LPS.KnifeCode AND ' +
			                  '       LPP.KnifeSizeScale = LPS.KnifeSizeScale AND ' +
 		                    '       LPP.KnifeSize = LPS.KnifeSize AND ' +
			                  '       LPP.MaterialLength = LPS.MaterialLength AND ' +
			                  '       LPP.MaterialWidth = LPS.MaterialWidth AND ' +
			                  '       LPP.MaterialCutGap = LPS.MaterialCutGap AND ' +
  			                '       ((LPP.MaterialCodeRestrictive = LPS.MaterialCodeRestrictive) OR ' +
			                  '        (LPP.MaterialCodeRestrictive IS NULL AND LPS.MaterialCodeRestrictive IS NULL)) AND ' +
			                  '       LPP.Seq = LPS.SelectedNo AND ' +
		                    '       LPS.KnifeCode = PWK.Knife AND ' +
			                  '       LPS.KnifeSizeScale = SSSS.Scale AND ' +
		                    '       LPS.KnifeSize = SRS.KnifeSize AND ' +
			                  '       LPS.MaterialLength = ROUND(IIF(M.Type = ''R'', ' + FloatToStr(ROLLLENGTH_FT) +
                        ', (M.Length * (MU.ToFeet / MU.SubUnitsPerUnit))) / (' + sPatternRes +
                        ' / CONVERT(12000, SQL_DOUBLE)), 0) AND ' +
			                  '       LPS.MaterialWidth = ROUND(M.Width * (MU.ToFeet / MU.SubUnitsPerUnit) / (' + sPatternRes +
                        ' / CONVERT(12000, SQL_DOUBLE)), 0) AND ' +
			                  '       LPS.MaterialCutGap = M.CutGap AND ' +
			                  '       ((M.CutType <> ''R'' AND LPS.MaterialCodeRestrictive IS NULL) OR ' +
			                  '        (M.CutType = ''R'' AND LPS.MaterialCodeRestrictive = M.Code)) AND ' +
                        '       M.Code = ' + MatCode + ' AND ' +
                    		'       MU.Code = M.Units' +
                        ') as SqFtPerPiece, ' +
                        'M.SkinSize, M.Length AS MatLength, ' +
                        'M.Width AS MatWidth, M.CutType, M.Trimmed, M.AreaCoeff, M.QualCoeff, MU.ToFeet, MU.SubUnitsPerUnit, MU.UnitAbbreviation, MU.SubUnitAbbreviation, ' +
                        'KS.Type AS KnifeType, KS.CutGap as KnifeCutGap, K.InterlockAreaPrimeSynthetic, K.InterlockAreaNonPrime, K.GrossArea, K.NettArea, KS.Pieces, ' +
                        'P.SampleSize, P.MadeInPairs, SSSS.Length AS SampleSizeMm, SSSS.Scale, PWK.SizeRelationship, SSSS.Size AS ShoeSize, SSSS.Seq, ' +
                        'SRS.KnifeSize AS AdjustedKnifeSize, COUNT(PWK2.Knife) AS NumberOfKnives ' +
                 'FROM Params PM, Parts P, Material M, PtWidKnf PWK, PtWidKnf PWK2, MatUnits MU, ' +
                      'Knives K, KnifeSets KS, SizeRelationshipSizes SRS, SizeScaleSizes SSSS, SizeScaleSizes SSSSA ' +
                 'WHERE P.Code = ''' + QS(PartCode) + ''' AND M.Code = ' + MatCode + ' AND PWK.Part = ''' + QS(PartCode) +
                       ''' AND PWK.WidthNo = ' + WidthNoStr + ' AND PWK2.Part = ''' + QS(PartCode) + ''' AND PWK2.WidthNo = ' +
                        WidthNoStr + ' AND MU.Code = M.Units AND K.Code = PWK.Knife AND SSSS.Scale = P.SizeScale AND ' +
                       'SSSS.Size = ''' + SampleSize + ''' AND (SSSSA.Scale = P.SizeScale AND SSSSA.Seq = SSSS.Seq + PWK.SizeAdjustment) AND' +
//                       ' SSSSA.Size IN (SELECT Size FROM SizeRangeSizes WHERE Scale = P.SizeScale AND Range = P.SizeRange) AND ' +
                       ' SRS.Scale = P.SizeScale AND ' +
                       ' SRS.Range = P.SizeRange AND ' +
                       ' SRS.Relationship = PWK.SizeRelationship AND ' +
                       ' SRS.ShoeSize = SSSSA.Size AND ' +
                       'K.SizeScale = KS.SizeScale AND K.MeasuredSize = ' + SizeStr + ' AND KS.Code = PWK.Knife ' +
                 'GROUP BY PWK.Seq, PWK.Knife, PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BAQuadraticC, PWK.Frequency, M.Type, M.Code, M.LinearAllowance, ' +
                          'SqFtPerPiece, M.SkinSize, M.Length, M.Width, M.CutType, M.Trimmed, M.AreaCoeff, M.QualCoeff, MU.ToFeet, ' +
                          'MU.SubUnitsPerUnit, MU.UnitAbbreviation, MU.SubUnitAbbreviation, KS.Type, KS.CutGap, K.InterlockAreaPrimeSynthetic, K.InterlockAreaNonPrime, K.GrossArea, K.NettArea, ' +
                          'KS.Pieces, P.SampleSize, P.MadeInPairs, SSSS.Length, SSSS.Scale, PWK.SizeRelationship, SSSS.Size, SSSS.Seq, SRS.KnifeSize, P.SLMAllowance ' +
                 'Order By PWK.Seq, PWK.Seq';
  end
  else
  begin
    SQLString := 'SELECT PWK.Seq, PWK.Knife, PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BAQuadraticC, PWK.Frequency, ' +
                        'M.Type AS MatType, M.Code AS MatCode, M.LinearAllowance, P.SLMAllowance, ' +
                        '(SELECT SqFtPerPiece / KS.Pieces ' +
	                      ' FROM LayplanPlans LPP, LayPlanSets LPS ' +
		                    ' WHERE LPP.KnifeCode = LPS.KnifeCode AND ' +
			                  '       LPP.KnifeSizeScale = LPS.KnifeSizeScale AND ' +
 		                    '       LPP.KnifeSize = LPS.KnifeSize AND ' +
			                  '       LPP.MaterialLength = LPS.MaterialLength AND ' +
			                  '       LPP.MaterialWidth = LPS.MaterialWidth AND ' +
			                  '       LPP.MaterialCutGap = LPS.MaterialCutGap AND ' +
  			                '       ((LPP.MaterialCodeRestrictive = LPS.MaterialCodeRestrictive) OR ' +
			                  '        (LPP.MaterialCodeRestrictive IS NULL AND LPS.MaterialCodeRestrictive IS NULL)) AND ' +
			                  '       LPP.Seq = LPS.SelectedNo AND ' +
		                    '       LPS.KnifeCode = PWK.Knife AND ' +
			                  '       LPS.KnifeSizeScale = SSSS.Scale AND ' +
		                    '       LPS.KnifeSize = SRS.KnifeSize AND ' +
			                  '       LPS.MaterialLength = ROUND(IIF(M.Type = ''R'', ' + FloatToStr(ROLLLENGTH_FT) +
                        ', (M.Length * (MU.ToFeet / MU.SubUnitsPerUnit))) / (' + sPatternRes +
                        ' / CONVERT(12000, SQL_DOUBLE)), 0) AND ' +
			                  '       LPS.MaterialWidth = ROUND(M.Width * (MU.ToFeet / MU.SubUnitsPerUnit) / (' + sPatternRes +
                        ' / CONVERT(12000, SQL_DOUBLE)), 0) AND ' +
			                  '       LPS.MaterialCutGap = M.CutGap AND ' +
			                  '       ((M.CutType <> ''R'' AND LPS.MaterialCodeRestrictive IS NULL) OR ' +
			                  '        (M.CutType = ''R'' AND LPS.MaterialCodeRestrictive = M.Code)) AND ' +
                        '       M.Code = ' + MatCode + ' AND ' +
                    		'       MU.Code = M.Units' +
                        ') as SqFtPerPiece, ' +
                        'M.SkinSize, M.Length AS MatLength, ' +
                        'M.Width AS MatWidth, M.CutType, M.Trimmed, M.AreaCoeff, M.QualCoeff, MU.ToFeet, MU.SubUnitsPerUnit, MU.UnitAbbreviation, MU.SubUnitAbbreviation, ' +
                        'KS.Type AS KnifeType, KS.CutGap as KnifeCutGap, K.InterlockAreaPrimeSynthetic, K.InterlockAreaNonPrime, K.GrossArea, K.NettArea, KS.Pieces, ' +
                        'P.SampleSize, SSSS.Length AS SampleSizeMm, SSSS.Scale, PWK.SizeRelationship, P.MadeInPairs, ' +
                        'SSSS.Size AS ShoeSize, SSSS.Seq, SRS.KnifeSize AS AdjustedKnifeSize, COUNT(PWK2.Knife) AS NumberOfKnives ' +
                 'FROM Params PM, Parts P, Material M, PtWidKnf PWK, PtWidKnf PWK2, MatUnits MU, ' +
                      'Knives K, KnifeSets KS, SizeRelationshipSizes SRS, SizeScaleSizes SSSS, SizeScaleSizes SSSC, ' +
                      'SizeScaleSizes SSSCA ' +
                 'WHERE P.Code = ''' + QS(PartCode) + ''' AND M.Code = ' + MatCode + ' AND PWK.Part = ''' + QS(PartCode) + ''' AND PWK.WidthNo = ' +
                        WidthNoStr + ' AND PWK2.Part = ''' + QS(PartCode) + ''' AND PWK2.WidthNo = ' + WidthNoStr + ' AND MU.Code = M.Units ' +
                        ' AND K.Code = PWK.Knife AND SSSS.Scale = P.SizeScale AND SSSS.Size = ''' + SampleSize + ''' AND SSSC.Scale = P.SizeScale' +
                        ' AND SSSC.Size = ''' + CostedSize + ''' AND (SSSCA.Scale = P.SizeScale AND SSSCA.Seq = SSSC.Seq + PWK.SizeAdjustment) ' +
      //                  'AND SSSCA.Size IN (SELECT Size FROM SizeRangeSizes WHERE Scale = P.SizeScale AND Range = P.SizeRange) AND ' +
                        'AND SRS.Scale = P.SizeScale AND ' +
                        ' SRS.Range = P.SizeRange AND ' +
                        ' SRS.Relationship = PWK.SizeRelationship AND ' +
                        ' SRS.ShoeSize = SSSCA.Size AND ' +
                        'K.SizeScale = KS.SizeScale AND K.MeasuredSize = ' + SizeStr + ' AND KS.Code = PWK.Knife ' +
                 'GROUP BY PWK.Seq, PWK.Knife, PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BAQuadraticC, PWK.Frequency, M.Type, M.Code, M.LinearAllowance, SqFtPerPiece, M.SkinSize, ' +
                          'M.Length, M.Width, M.CutType, M.Trimmed, M.AreaCoeff, M.QualCoeff, MU.ToFeet, MU.SubUnitsPerUnit, MU.UnitAbbreviation, MU.SubUnitAbbreviation, KS.Type, KS.CutGap, ' +
                          'K.InterlockAreaPrimeSynthetic, K.InterlockAreaNonPrime, K.GrossArea, K.NettArea, KS.Pieces, P.SampleSize, P.MadeInPairs, SSSS.Length, ' +
                          'SSSS.Scale, PWK.SizeRelationship, SSSS.Size, SSSS.Seq, SRS.KnifeSize, P.SLMAllowance ' +
                 'Order By PWK.Seq, PWK.Seq';
  end;

  qBAForParts.SQL.Text := SQLString;
  qBAForParts.Open;
  qBAForParts.RecNo := 1; //CJY changed from qBAForParts.First
  qBAForParts.Prior; //CJY changed from qBAForParts.First

  Result := Allowances(PartCode, AltMaterial, WidthNo, Sample, False, False, qBAForParts);
  qBAForParts.Close;
end;

procedure TdmBasAll.PassAllowanceTicketQuery(qAverageSizesIn: TFDQueryPlus);
begin
  qAverageSizes := qAverageSizesIn;
end;

procedure TdmBasAll.AllowanceAllCosts(PartCode: String;
                                      WidthNo: short;
                                      var CostingGrid: GridArray;
                                      var NumberOfSizes: integer;
                                      var MatCode, UnitsStr: string);
var
  MatCodeStr, SQLString, WidthNoStr: string;
  MyBookmark: TBookmark;
  MatWidthStr, sPatternRes, ThisSize: string;
  SqFtToUnits: real;

begin
  if MatCode = '' then
    MatCodeStr := ', Parts P ' +
                  ' WHERE P.Code = ''' + QS(PartCode) + ''' AND M.Code = P.Material AND MU.Code = M.Units; '
  else
    MatCodeStr := ' WHERE M.Code = ''' + MatCode + ''' AND MU.Code = M.Units; ';

  WidthNoStr := IntToStr(WidthNo);

  sPatternRes := 'CONVERT(' + IntToStr(PATTERNRES) + ', SQL_DOUBLE)';

  SQLString := 'DECLARE Divisor Double, Multiplier Double; ' +

               'DECLARE MCode Char(20); ' +
               'DECLARE MAdjLength Double, MAdjWidth Double, MLength Double, MWidth Double, MSkinSize Double; ' +
               'DECLARE MCutGap Integer, MAreaCoeff Integer, MQualCoeff Integer, MSubUnitsPerUnit Integer;' +
               'DECLARE MCutType Char(1), MType Char(1); ' +
               'DECLARE MUnitAbbreviation Char(4), MSubUnitAbbreviation Char(4); ' +
               'DECLARE MTrimmed Logical; ' +
               'DECLARE MLinearAllowance Logical; ' +
               'DECLARE MToFeet Double; ' +

               'DECLARE PartCode Char(20); ' +
               'DECLARE PartSizeScale Char(20); ' +
               'DECLARE PartSampleSize Char(10); ' +
               'DECLARE PartSizeRange Char(20); ' +
               'DECLARE PartMadeInPairs Logical; ' +
               'DECLARE PartSLMAllowance Logical; ' +

               'DECLARE ParamTableLength Double; ' +
               'DECLARE ParamBAQuadraticA Double; ' +
               'DECLARE ParamBAQuadraticB Double; ' +
               'DECLARE ParamBAQuadraticC Double; ' +

               'DECLARE MatTab CURSOR AS ' +
               '  SELECT M.Code, M."Type", M.SkinSize, M.Length, M.Width, M.CutGap, M.CutType, M.LinearAllowance, ' +
               '  M.AreaCoeff, M.QualCoeff, M.Trimmed, MU.ToFeet, MU.SubUnitsPerUnit, MU.UnitAbbreviation, ' +
               '  MU.SubUnitAbbreviation ' +
               '  FROM Material M, MatUnits MU ' + MatCodeStr +

               'DECLARE PartTab CURSOR AS ' +
               '  SELECT * FROM Parts WHERE Code =  ''' + QS(PartCode) + '''; ' +

               'DECLARE ParamTab CURSOR AS ' +
               '  SELECT * FROM Params; ' +

               'DECLARE SizeTab CURSOR AS ' +
               '  SELECT Size ' +
               '  FROM SizeRangeSizes ' +
               '  WHERE Scale = PartSizeScale AND Range = PartSizeRange; ' +

               'DECLARE SizeCur CURSOR AS ' +
               '  SELECT SRS.Size, SRS.Seq, SRS."Range" ' +
               '  FROM SizeRangeSizes SRS, Parts P ' +
               '  WHERE P.Code = ''' + QS(PartCode) + ''' AND SRS."Range" = P.SizeRange ' +
               '  Order By SRS.Seq, SRS.Seq; ' +

               'DECLARE NumKnives Integer; ' +
               'SET NumKnives = (SELECT COUNT(Knife) FROM PtWidKnf WHERE Part =  ''' + QS(PartCode) + ''' AND WidthNo = ' + WidthNoStr + '); ' +

               'Divisor = ' + sPatternRes + ' / CONVERT(12000, SQL_DOUBLE); ' +

               'OPEN MatTab; ' +
               'IF FETCH MatTab THEN ' +
               '  Multiplier = MatTab.ToFeet / MatTab.SubUnitsPerUnit; ' +
               '  MCode = MatTab.Code; ' +
               '  MType = MatTab."Type"; ' +
               '  MLinearAllowance = MatTab.LinearAllowance; ' +
               '  MSkinSize = MatTab.SkinSize; ' +
               '  MTrimmed = MatTab.Trimmed; ' +
               '  MAreaCoeff = MatTab.AreaCoeff; ' +
               '  MQualCoeff = MatTab.QualCoeff; ' +
               '  MLength = MatTab.Length; ' +
               '  MWidth = MatTab.Width; ' +
               '  MAdjLength = ROUND(IIF(MatTab."Type" = ''R'', ' + FloatToStr(ROLLLENGTH_FT) + ' , (MatTab.Length * Multiplier)) / Divisor, 0); ' +
               '  MAdjWidth = ROUND(MatTab.Width * Multiplier / Divisor, 0); ' +
               '  MCutGap = MatTab.CutGap; ' +
               '  MCutType = MatTab.CutType; ' +
               '  MToFeet = MatTab.ToFeet; ' +
               '  MSubUnitsPerUnit = MatTab.SubUnitsPerUnit; ' +
               '  MUnitAbbreviation = MatTab.UnitAbbreviation; ' +
               '  MSubUnitAbbreviation = MatTab.SubUnitAbbreviation; ' +
               'END; ' +

               'OPEN PartTab; ' +
               'IF FETCH PartTab THEN ' +
               '  PartCode = PartTab.Code; ' +
               '  PartSizeScale = PartTab.SizeScale; ' +
               '  PartSampleSize = PartTab.SampleSize; ' +
               '  PartSizeRange = PartTab.SizeRange; ' +
               '  PartMadeInPairs = PartTab.MadeInPairs; ' +
               '  PartSLMAllowance = PartTab.SLMAllowance; ' +
               'END; ' +

               'OPEN ParamTab; ' +
               'IF FETCH ParamTab THEN ' +
               '  ParamTableLength = ParamTab.TableLength; ' +
               '  ParamBAQuadraticA = ParamTab.BAQuadraticA; ' +
               '  ParamBAQuadraticB = ParamTab.BAQuadraticB; ' +
               '  ParamBAQuadraticC = ParamTab.BAQuadraticC; ' +
               'END; ' +

               'CREATE TABLE #Temp (Knife Char(20), TableLength Double, BAQuadraticA Double, BAQuadraticB Double, ' +
               '  BAQuadraticC Double, Frequency Short, MatType Char(1), MatCode char(20), LinearAllowance Logical, ' +
               '  SLMAllowance Logical, SkinSize Double, MatLength Double, MatWidth Double, CutType Char(1), ' +
               '  Trimmed Logical, AreaCoeff Short, QualCoeff Short, ToFeet Double, SubUnitsPerUnit Short, ' +
               '  UnitAbbreviation Char(4), SubUnitAbbreviation Char(4), KnifeType Char(1), InterlockAreaPrimeSynthetic Double, ' +
               '  InterlockAreaNonPrime Double, GrossArea Double, NettArea Double, Pieces Short, SampleSize Char(10), ' +
               '  MadeInPairs Logical, SampleSizeMm Short, Scale Char(20), SizeRelationship Char (20), ShoeSize Char(10), Seq Double, ' +
               '  AdjustedKnifeSize Char(10), KnifeCutGap Short, NumberOfKnives Integer, SqFtPerPiece Double); ' +

               'OPEN SizeCur; ' +
               'WHILE FETCH SizeCur DO ' +
               '  INSERT INTO #Temp(Knife, TableLength, BAQuadraticA, BAQuadraticB, BAQuadraticC, Frequency, MatType, MatCode, ' +
               '    LinearAllowance, SLMAllowance, SkinSize, MatLength, MatWidth, CutType, Trimmed, AreaCoeff, ' +
               '    QualCoeff, ToFeet, SubUnitsPerUnit, UnitAbbreviation, SubUnitAbbreviation, KnifeType, InterlockAreaPrimeSynthetic, ' +
               '    InterlockAreaNonPrime, GrossArea, NettArea, Pieces, SampleSize, MadeInPairs, SampleSizeMm, Scale, SizeRelationship, ' +
               '    ShoeSize, Seq, AdjustedKnifeSize, KnifeCutGap, NumberOfKnives, SqFtPerPiece) ' +
               '    SELECT K.Code, ParamTableLength, ParamBAQuadraticA, ParamBAQuadraticB, ParamBAQuadraticC, PWK.Frequency, MType, MCode, ' +
               '      MLinearAllowance, PartSLMAllowance, MSkinSize, MLength, MWidth, MCutType, MTrimmed, MAreaCoeff, MQualCoeff, ' +
               '      MToFeet, MSubUnitsPerUnit, MUnitAbbreviation, MSubUnitAbbreviation, KS.Type, K.InterlockAreaPrimeSynthetic, ' +
               '      K.InterlockAreaNonPrime, K.GrossArea, K.NettArea, KS.Pieces, PartSampleSize, PartMadeInPairs, SSSS.Length, SSSS.Scale, ' +
               '      PWK.SizeRelationship, SSSC.Size, SRS.Seq, SRS.KnifeSize, KS.CutGap, NumKnives, ' +
               '       (SELECT SqFtPerPiece / KS.Pieces ' +
               '        FROM LayplanPlans LPP, LayPlanSets LPS ' +
               '        WHERE LPP.KnifeCode = LPS.KnifeCode AND LPP.KnifeSizeScale = LPS.KnifeSizeScale AND LPP.KnifeSize = LPS.KnifeSize AND  ' +
               '          LPP.MaterialLength = LPS.MaterialLength AND LPP.MaterialWidth = LPS.MaterialWidth AND ' +
               '          LPP.MaterialCutGap = LPS.MaterialCutGap AND ((LPP.MaterialCodeRestrictive = LPS.MaterialCodeRestrictive) OR ' +
               '          (LPP.MaterialCodeRestrictive IS NULL AND LPS.MaterialCodeRestrictive IS NULL)) AND LPP.Seq = LPS.SelectedNo AND ' +
               '          LPS.KnifeCode = PWK.Knife AND LPS.KnifeSizeScale = SSSS.Scale AND LPS.KnifeSize = SRS.KnifeSize AND ' +
               '          LPS.MaterialLength = MAdjLength AND LPS.MaterialWidth = MAdjWidth AND LPS.MaterialCutGap = MCutGap AND ' +
               '          ((MCutType <> ''R'' AND LPS.MaterialCodeRestrictive IS NULL) OR ' +
               '          (MCutType = ''R'' AND LPS.MaterialCodeRestrictive = MCode))) as SqFtPerPiece ' +
               '    FROM PtWidKnf PWK, Knives K, KnifeSets KS, SizeRelationshipSizes SRS, SizeScaleSizes SSSS, SizeScaleSizes SSSC, SizeScaleSizes SSSCA ' +
               '    WHERE PWK.Part =  ''' + QS(PartCode) + ''' AND PWK.WidthNo = ' + WidthNoStr + ' AND K.Code = PWK.Knife AND SSSS.Scale = PartSizeScale AND ' +
               '      SSSS.Size = PartSampleSize AND SSSC.Scale = PartSizeScale AND SSSC.Size = SizeCur.Size AND ' +
               '     (SSSCA.Scale = PartSizeScale AND SSSCA.Seq = SSSC.Seq + PWK.SizeAdjustment) AND ' + //SSSCA.Size IN ' +
{               '     (SELECT Size ' +
               '      FROM SizeRangeSizes ' +
               '      WHERE Scale = PartSizeScale) AND Range = PartSizeRange) AND  SRS.Scale = PartSizeScale AND ' +}
               '     SRS.Relationship = PWK.SizeRelationship AND  SRS.ShoeSize = SSSCA.Size AND K.SizeScale = KS.SizeScale AND ' +
               '     ((PartSLMAllowance = FALSE AND K.MeasuredSize = SRS.KnifeSize) OR (PartSLMAllowance = TRUE AND K.MeasuredSize = PartSampleSize)) AND ' +
               '     KS.Code = PWK.Knife; ' +
               'END WHILE; ';

  qBAForParts.SQL.Text := SQLString;
  qBAForParts.ExecSQL;

  SQLString := 'SELECT * ' +
               'FROM #Temp';

  qBAForParts.SQL.Text := SQLString;
  qBAForParts.Open;

  NumberOfSizes := 0;

  //CJY: Fetching all records to correct RecordCount (overhead partially offset
  //by iteration of now cached records)
  qBAForParts.FetchAll;
  //CJY: qBAForParts.FetchOptions.RecordCountMode set to cmTotal
  SetLength(CostingGrid, qBAForParts.RecordCount + 1);

  qBAForParts.RecNo := 1; //CJY changed from qBAForParts.First
  qBAForParts.Prior; //CJY changed from qBAForParts.First
  ThisSize := qBAForParts.FieldByName('ShoeSize').Value;
  MatCode := qBAForParts.FieldByName('MatCode').Value;
  if qBAForParts.FieldByName('LinearAllowance').Value then
  begin
    Str(qBAForParts.FieldByName('MatWidth').Value: 6: 2, MatWidthStr);
    UnitsStr := '(''' + qBAForParts.FieldByName('UnitAbbreviation').Value + ' ' + ' x ' + MatWidthStr + ' ' +
      qBAForParts.FieldByName('SubUnitAbbreviation').Value + ''')';
  end
  else
    UnitsStr := '(Sq ' + qBAForParts.FieldByName('UnitAbbreviation').Value + ')';

  while not(qBAForParts.eof) do
  begin
    MyBookmark := qBAForParts.GetBookmark;
    qBAForParts.Filter := 'ShoeSize = ''' + qBAForParts.FieldByName('ShoeSize').Value + '''';
    qBAForParts.Filtered := True;

    SqFtToUnits := 1 / (qBAForParts.FieldByName('ToFeet').Value * qBAForParts.FieldByName('ToFeet').Value);
    inc(NumberOfSizes);
    //CJY: qBAForParts.FetchOptions.RecordCountMode set to cmTotal
    if (qBAForParts.FieldByName('SLMAllowance').Value) or (qBAForParts.RecordCount = qBAForPartsNumberOfKnives.Value) then
    begin
      CostingGrid[NumberOfSizes] := Allowances(PartCode, '', WidthNo, False, True, False, qBAForParts);
      CostingGrid[NumberOfSizes].AdjustedAllowance := CostingGrid[NumberOfSizes].AdjustedAllowance * SqFtToUnits;
    end
    else
    begin
      CostingGrid[NumberOfSizes].BasicAllowance := 0;
      CostingGrid[NumberOfSizes].CostedSyntheticBasicAllowance := 0;
      CostingGrid[NumberOfSizes].SampleSyntheticBasicAllowance := 0;
      CostingGrid[NumberOfSizes].AdjustedAllowance := 0;
      CostingGrid[NumberOfSizes].AdjInterlocks := nil;
      CostingGrid[NumberOfSizes].CostedSynths := nil;
      CostingGrid[NumberOfSizes].SampleSynths := nil;
      CostingGrid[NumberOfSizes].CostedKnives := nil;
      CostingGrid[NumberOfSizes].SampleKnives := nil;
      CostingGrid[NumberOfSizes].NoInterlocks := 0;
      CostingGrid[NumberOfSizes].MaterialType := 'S';
      CostingGrid[NumberOfSizes].Size := qBAForParts.FieldByName('ShoeSize').Value;
      CostingGrid[NumberOfSizes].Error := '';
      CostingGrid[NumberOfSizes].TotalInterlockArea := 0;
      CostingGrid[NumberOfSizes].TotalNettArea := 0;
    end;
    qBAForParts.Filtered := False;

    qBAForParts.GotoBookmark(MyBookmark);
    qBAForParts.FreeBookmark(MyBookmark);
    while (ThisSize = qBAForParts.FieldByName('ShoeSize').Value) and not(qBAForParts.eof) do
      qBAForParts.Next;
    ThisSize := qBAForParts.FieldByName('ShoeSize').Value;
  end;

  qBAForParts.Close;
  qBAForParts.Disconnect;  //AdsCloseSQLStatement replaced by Disconnect when converted to FireDac
  try
    qDropTemp.ExecSQL;
  except
  end;
end;

function TdmBasAll.Allowances(PartCode, AltMaterial: string;
                              WidthNo: short;
                              Sample, Grid, Ticket: Boolean;
                              qBA: TFDQueryPlus): AllowanceResult;

var
  i, j, m, CurrentSeq, NumberOfKnives, NumberInPair, PairMultiplier: integer;
  AdjAlw, BasicAllowanceExcSmallest, BasicAllowanceIncSmallest, BasicAllw, MaterialAreaSqFt,
  MaterialLengthInches, TableLength, MaterialWidthInches, Multiplier, InterlockArea,
  UnitsToSqFeet, SubUnitsToInches: real;
  AdjInterlocks, InterlockAreaArray, PiecesArray, GrossAreaArray, NettAreaArray: RealArray;
  MaterialType: char;
  InvalidData: string;
  AreaCoeff, QualCoeff: short;
  Count: short;
  SampleSyntheticBasicAllowance, CostedSyntheticBasicAllowance, LinearMultiplier, SqFtPerPiece, TotalInterlockArea, TotalNettArea: real;
  AllSampleSynthetics, AllCostedSynthetics, SLMAllowance: boolean;

begin
  //Wait until previous use complete.
  while InUse do
    application.processmessages;

  try
    InUse := true;

    //CJY: qBA.FetchOptions.RecordCountMode set to cmTotal (if required on the fly)
    //CJY: Fetching all records to correct qBA.RecordCount as uncertain of query input
    if not (qBA.FetchOptions.RecordCountMode = cmTotal) then
    begin
      qBA.FetchOptions.RecordCountMode := cmTotal;
      qBA.Refresh;
    end;
    qBA.FetchAll;

    InvalidData := '';
    if Ticket then
    begin
      //CJY: qAverageSizes.FetchOptions.RecordCountMode set to cmTotal
      if qAverageSizes.RecordCount = 0 then
        InvalidData := 'There are no Knives for this Width.';
    end
    else
      //CJY: qBA.FetchOptions.RecordCountMode set to cmTotal (if required on the fly)
      if qBA.RecordCount = 0 then
      begin
        qKnifeSetExists.ParamByName('PartCode').Value := PartCode;
        qKnifeSetExists.ParamByName('WidthNo').Value := WidthNo;
        qKnifeSetExists.Open;
        if (not qKnifeSetExistsSLMAllowance.Value) and (qKnifeSetExistsACount.Value > 0) then
        begin
          TableLength := 0;
          NumberOfKnives := qKnifeSetExistsACount.Value;
          MaterialType := 'S';
          AreaCoeff := 100;
          QualCoeff := 100;
          AllSampleSynthetics := True;
          AllCostedSynthetics := True;
          AdjInterlocks := 0;
          TotalInterlockArea := 0;
          TotalNettArea := 0;

          SetLength(AdjInterlocks, NumberOfKnives + 1);
          Allowances.MaterialType := 'S';
          Allowances.SampleSyntheticBasicAllowance := 0;
          Allowances.CostedSyntheticBasicAllowance := 0;
          Allowances.BasicAllowance := 0;
          Allowances.NoInterlocks := 0;
          Allowances.AdjustedAllowance := 0;
        end
        else
          InvalidData := 'There are no Knives of Sample Size' + #13 + 'OR' + #13 + 'There are no Knives for this Width' + #13 + 'OR' + #13 + 'Adjusted Size(s) fall outside of Size Range';
        qKnifeSetExists.Close;
      end
      else
      begin
        //CJY: qBA.FetchOptions.RecordCountMode set to cmTotal (if required on the fly)
        if not(qBA.RecordCount = qBA.FieldByName('NumberOfKnives').Value) then
        begin
          Allowances.Size := qBA.FieldByName('ShoeSize').Value;
          //CJY Error Bypass
          //InvalidData := 'Sample Size not available for all Knives' + #13 + 'OR' + #13 + 'Sample/Costed Size Adjusted beyond Size Scale limits';
        end;
      end;

    if InvalidData = '' then
    begin
      //CJY: qBA.FetchOptions.RecordCountMode set to cmTotal (if required on the fly)
      if not(qBA.RecordCount = 0) then
      begin
        TableLength := qBA.FieldByName('TableLength').Value;
        NumberOfKnives := qBA.FieldByName('NumberOfKnives').Value;    //get number of knife records
        MaterialType := qBA.FieldByName('MatType').AsString[1];
        AreaCoeff := qBA.FieldByName('AreaCoeff').Value;
        QualCoeff := qBA.FieldByName('QualCoeff').Value;
        if (not Option_LegacySynthetics) and (MaterialType in Synthetics) then       
          SLMAllowance := False
        else          
          SLMAllowance := qBA.FieldByName('SLMAllowance').Value;

        if qBA.FieldByName('MadeInPairs').Value then
          PairMultiplier := 2
        else
          PairMultiplier := 1;

        LinearMultiplier := 1;
//        if Grid and qBA.FieldByName('LinearAllowance').Value then
//          LinearMultiplier := qBA.FieldByName('SubUnitsPerUnit').Value / qBA.FieldByName('MatWidth').Value

        {Make Arrays}

        Allowances.MaterialType := MaterialType;
        Allowances.PairMultiplier := PairMultiplier;

        if Grid then
          Allowances.Size := qBA.FieldByName('ShoeSize').Value;

        m := 0;

        SetLength(AdjInterlocks, NumberOfKnives + 1);

        qBA.RecNo := 1; //CJY changed from qBA.First
        qBA.Prior; //CJY changed from qBA.First

        Count := 0;
        NumberOfKnives := 0;
        while not(qBA.Eof) do
        begin
          inc(Count);
          NumberOfKnives := NumberOfKnives + qBA.FieldByName('Frequency').Value;   // get actual number of knives once frequencies are used.
  //Have to do this first and separately so the sizes of the following arrays can be set correctly.

          qBA.Next;
        end;

        qBA.RecNo := 1; //CJY changed from qBA.First
        qBA.Prior; //CJY changed from qBA.First

        if not(Ticket and not SLMAllowance) then
        begin
          SetLength(InterlockAreaArray, NumberOfKnives + 1);
          SetLength(GrossAreaArray, NumberOfKnives + 1);
          SetLength(NettAreaArray, NumberOfKnives + 1);
          SetLength(PiecesArray, NumberOfKnives + 1);

          if Sample then
          begin
            SetLength(Result.SampleKnives, NumberOfKnives);
            SetLength(Result.SampleSynths, Count);
          end
          else
          begin
            SetLength(Result.CostedKnives, NumberOfKnives);
            SetLength(Result.CostedSynths, Count);
          end;

          if SLMAllowance then
          begin
            AllSampleSynthetics := False;
            AllCostedSynthetics := False;
          end
          else
          begin
            AllSampleSynthetics := True;
            AllCostedSynthetics := True;
          end;
          //CJY: qBA.FetchOptions.RecordCountMode set to cmTotal (if required on the fly)
          if not(qBA.RecordCount = qBA.FieldByName('NumberOfKnives').Value) then
          begin
            if Sample then
              AllSampleSynthetics := False
            else
              AllCostedSynthetics := False;
          end;

          SampleSyntheticBasicAllowance := 0;
          CostedSyntheticBasicAllowance := 0;

          i := 0;
          Count := 0;
          while (i < NumberOfKnives) do
          begin
            //Need to calculate a Multiplier even for Layplanned allowances because InterlockAreas etc are used in that
            //waste calculation - the whole idea of InterlockAreas for layplanned allowances should go in later releases
            //so that it is not necessary to assess patterns for leather to begin with
            qAverageSizes.Filter := 'KnifeIndex = ' + IntToStr(round(qBA.FieldByName('Seq').Value));
            qAverageSizes.Filtered := True;

            SizeAdjustment(Multiplier, Sample, Ticket, qBA);        //Adjusts for size
            qAverageSizes.Filtered := False;

            for j := 1 to qBA.FieldByName('Frequency').Value do
            begin
              inc(i);

              if (qBA.FieldByName('KnifeType').Value = 'P') or (qBA.FieldByName('KnifeType').Value = 'S') then
                InterlockArea := qBA.FieldByName('InterlockAreaPrimeSynthetic').Value
              else
                InterlockArea := qBA.FieldByName('InterlockAreaNonPrime').Value;

              InterlockAreaArray[i] := InterlockArea * Multiplier;
              if SLMAllowance and (InterlockAreaArray[i] = 0) then
                InvalidData := 'Knife: ' + qBA.FieldByName('Knife').Value + ' - Interlock area is zero.';
              if (MaterialType in ['L', 'W', 'K']) and (qBA.FieldByName('KnifeCutGap').Value <> 0) then
                InvalidData := 'Part: ' + PartCode + ' - Cut gap on Leather.';
              PiecesArray[i] := qBA.FieldByName('Pieces').Value;
              GrossAreaArray[i] := qBA.FieldByName('GrossArea').Value * Multiplier;
              NettAreaArray[i] := qBA.FieldByName('NettArea').Value * Multiplier;
            end;
            inc(Count);

            if not SLMAllowance then
            begin
              if not qBA.FieldByName('SqFtPerPiece').IsNull then
                SqFtPerPiece := qBA.FieldByName('SqFtPerPiece').Value
              else
                SqFtPerPiece := -1;

              NumberInPair := PairMultiplier * qBA.FieldByName('Frequency').Value;

              if not Grid then
              begin
                if Sample or Ticket then
                begin
                  if SqFtPerPiece > 0 then
                  begin
                    Result.SampleKnives[Count - 1] := qBA.FieldByName('Knife').Value;
                    Result.SampleSynths[Count - 1] := SqFtPerPiece * NumberInPair;
                    SampleSyntheticBasicAllowance := SampleSyntheticBasicAllowance + Result.SampleSynths[Count - 1];
                  end
                  else
                    AllSampleSynthetics := False;
                end
                else
                begin
                  if SqFtPerPiece > 0 then
                  begin
                    Result.CostedKnives[Count - 1] := qBA.FieldByName('Knife').Value;
                    Result.CostedSynths[Count - 1] := SqFtPerPiece * NumberInPair;
                    CostedSyntheticBasicAllowance := CostedSyntheticBasicAllowance + Result.CostedSynths[Count - 1];
                  end
                  else
                    AllCostedSynthetics := False;
                end;
              end
              else
                SampleSyntheticBasicAllowance := SampleSyntheticBasicAllowance + (SqFtPerPiece * NumberInPair);

              AdjInterlocks[Count] := NettAreaArray[Count] * 1.1;
            end
            else
              AdjInterlocks[Count] := InterlockArea * Multiplier;

            qBA.Next;
          end;

          if (Sample or Ticket) then
          begin
            if AllSampleSynthetics then
              Allowances.SampleSyntheticBasicAllowance := SampleSyntheticBasicAllowance
            else
              Allowances.SampleSyntheticBasicAllowance := 0;
          end
          else
          begin
            if AllCostedSynthetics then
              Allowances.CostedSyntheticBasicAllowance := CostedSyntheticBasicAllowance
            else
              Allowances.CostedSyntheticBasicAllowance := 0;
          end;

          //Calculate Total Interlock/Nett Areas
          TotalInterlockArea := 0;
          TotalNettArea := 0;
          for i := 1 to NumberOfKnives do
          begin
            TotalInterlockArea := TotalInterlockArea + (InterlockAreaArray[i] / PiecesArray[i]);
            TotalNettArea := TotalNettArea + (NettAreaArray[i] / PiecesArray[i]);
          end;

          UnitsToSqFeet := qBA.FieldByName('ToFeet').Value * qBA.FieldByName('ToFeet').AsFloat;
          SubUnitsToInches := qBA.FieldByName('ToFeet').Value * 12 / qBA.FieldByName('SubUnitsPerUnit').Value;

          if (MaterialType in Leathers) then
            MaterialAreaSqFt := qBA.FieldByName('SkinSize').Value * UnitsToSqFeet
          else
          begin
            if (MaterialType='R') then
              MaterialLengthInches := TableLength * Metres_To_Cms * Cms_To_Inches
            else if (MaterialType='S') then
              MaterialLengthInches := qBA.FieldByName('MatLength').Value * SubUnitsToInches;
            MaterialWidthInches := qBA.FieldByName('MatWidth').Value * SubUnitsToInches;
            MaterialAreaSqFt := MaterialLengthInches * MaterialWidthInches * SqInches_To_SqFeet
          end;

          if MaterialAreaSqFt = 0 then
            InvalidData := 'The Material Area is zero.';

          if SLMAllowance then
          begin
            {Only calculate if data is valid}
            if InvalidData = '' then
            begin
             {Sort arrays into ascending order of Interlock Area}

              QuickSort(InterlockAreaArray, PiecesArray, GrossAreaArray, 1, NumberOfKnives);

              BasicAllowanceIncSmallest := CommonBasicAllowance(NumberOfKnives, MaterialAreaSqFt,
                                                                GrossAreaArray, InterlockAreaArray,
                                                                PiecesArray, qBA);
              if (NumberOfKnives > 1) then
              begin
                RemoveSmallest(NumberOfKnives, GrossAreaArray, InterlockAreaArray, PiecesArray);
                BasicAllowanceExcSmallest := CommonBasicAllowance(NumberOfKnives, MaterialAreaSqFt,
                                                                  GrossAreaArray, InterlockAreaArray,
                                                                  PiecesArray, qBA);
              end
              else
                BasicAllowanceExcSmallest := 0;

                {Now must compare the two BasicAllowances and keep the largest}

              if (BasicAllowanceIncSmallest>BasicAllowanceExcSmallest) then
                BasicAllw := BasicAllowanceIncSmallest
              else
                BasicAllw := BasicAllowanceExcSmallest;

              {7.5% is added to the Basic Allowance for Restrictive Cutting
              (where there is a pattern of some sort on the material which the cutter must follow}

              if (qBA.FieldByName('CutType').Value = 'R') then
                BasicAllw := BasicAllw * 1.075;

              {7% is added for SheepSkin (Wool) due to its fleecy nature}

              if (MaterialType = 'W') then
                BasicAllw := BasicAllw * 1.07;
            end;
          end
          else if Sample or Grid then
            BasicAllw := SampleSyntheticBasicAllowance
          else
            BasicAllw := CostedSyntheticBasicAllowance;

          Allowances.BasicAllowance := BasicAllw;

          Allowances.NoInterlocks := m;

          if (MaterialType in Leathers) then
            AdjAlw := AdjustedAllowance(PartCode, AltMaterial, WidthNo, AreaCoeff, QualCoeff,
                                                              BasicAllw, MaterialType)
          else
            AdjAlw := BasicAllw;
        end;

        if not Grid and not SLMAllowance then
        begin
          //Every layplanned knife has its own NettArea at the correct size because it has been individually digitised.
          //Therefore numerous knives with the same code are returned by qBA (qBAForTickets). To get the 'average'
          //NettArea for calculating Times I am adding up all NettAreas for these groups of Knives and then
          //dividing by the number of Knives.  N.B. This code will change if Times are ever done properly.

          //For layplanned Synthetics we have decided to use NettArea * 1.1 (= +10%) as the interlock area until full
          //and proper times can be calculated.
          i := 0;
          Count := 0;
          InterlockArea := 0;
          CurrentSeq := qBA.FieldByName('Seq').Value;
          while not(qBA.Eof) do
          begin
            if (qBA.FieldByName('Seq').Value = CurrentSeq) then
            begin
              InterlockArea := InterlockArea + (qBA.FieldByName('NettArea').Value * 1.1);
              inc(Count);
            end
            else
            begin
              CurrentSeq := qBA.FieldByName('Seq').Value;
              inc(i);
              AdjInterlocks[i] := InterlockArea / Count;
              InterlockArea := 0;
              Count := 0;
              qBA.Prior;
            end;
            qBA.Next;
          end;
        end;
      end;
    end;

    Allowances.AdjustedAllowance := AdjAlw * LinearMultiplier;
    Allowances.AdjInterlocks := AdjInterlocks;
    Allowances.Error := InvalidData;
    Allowances.TotalInterlockArea := TotalInterlockArea;
    Allowances.TotalNettArea := TotalNettArea;
  finally
    InUse := false;
  end;
end;

function TdmBasAll.AdjustedAllowance(PartCode, AltMaterial: string; WidthNo, AreaCoeff, QualCoeff: short;
                                     BasicAllowance: real; MaterialType: Char): real;
var
  PartAdjustmentFactor: short;

begin
  if (MaterialType in Leathers) then
  begin
    PartAdjustmentFactor := dmAdjFact.PartAdjFactor(PartCode, WidthNo);

    Result := CalcAdjAlw(AreaCoeff, QualCoeff, PartAdjustmentFactor, BasicAllowance);
  end
  else
    Result := BasicAllowance;
end;

function TdmBasAll.CalcAdjAlw(AreaCoeff, QualCoeff, AdjFactor: integer; BasicAllowance: real): real;
var
  AreaAdj, QualAdj: real;

begin
  AreaAdj := 100 / AreaCoeff;
  QualAdj := 100 / (QualCoeff + (AdjFactor * (100 - QualCoeff) / 15));
  Result := BasicAllowance * AreaAdj * QualAdj;
end;

function TdmBasAll.QuadraticResult(Sizemm: integer;
                                   qBA: TFDQueryPlus): real;
var
   a, b, c: real;

begin
  a := qBA.FieldByName('BAQuadraticA').Value;
  b := qBA.FieldByName('BAQuadraticB').Value;
  c := qBA.FieldByName('BAQuadraticC').Value;

  QuadraticResult := (a * sizemm * sizemm) + (b * sizemm) + c;
end;

procedure TdmBasAll.SizeAdjustment(var Multiplier: real;
                                   Sample, Ticket: boolean;
                                   qBA: TFDQueryPlus);

var
  AdjustedCosted, AdjustedSample, CostedKnifeSizeQuad, SampleKnifeSizeQuad, SampleSizeQuad: real;
  CostedKnifeSizeInMm: integer;

begin
//The overriding size of the knife is the one given by Sample Size.  It doesn't matter
//what the original size of the knife was.

  SampleSizeQuad := QuadraticResult(qBA.FieldByName('SampleSizeMm').Value, qBA);

//If the Sample size appears in the relationship and is not 1 to 1 then an adjustment
//must be calculated for it (from SampleSize to SampleKnifeSize)
  if (Sample) then
  begin
    if not(qBA.FieldByName('SampleSize').Value = qBA.FieldByName('AdjustedKnifeSize').Value) then
    begin
      SampleKnifeSizeQuad := QuadraticResult(qBA.FieldByName('AdjustedKnifeLength').value, qBA);
      AdjustedSample := SampleKnifeSizeQuad / SampleSizeQuad;
    end
    else AdjustedSample := 1;

//Otherwise AdjustedSample must be 1.

    Multiplier := AdjustedSample;
  end;

  if not(Sample) then
  begin
    if Ticket then
      CostedKnifeSizeInMm := round(qAverageSizes.FieldByName('Average').Value)
    else
      CostedKnifeSizeInMm := qBA.FieldByName('AdjustedKnifeLength').Value;

    CostedKnifeSizeQuad := QuadraticResult(CostedKnifeSizeInMm, qBA);
    AdjustedCosted := CostedKnifeSizeQuad / SampleSizeQuad;

    Multiplier := AdjustedCosted;
  end;
end;

procedure TdmBasAll.DataModuleCreate(Sender: TObject);
begin
  InUse := false;
end;

function TdmBasAll.ChangeAllConnections(Connection: TFDCustomConnection): boolean;
var
  i, iConn: integer;
  TestConn: TFDConnection;

begin
  i := 0;
  iConn := 0;
  while iConn < Length(ConnectionNest) do
  begin
    if ConnectionNest[iConn].Connected then
      ConnectionNest[iConn - i] := ConnectionNest[iConn]
    else
      Inc(i);
    Inc(iConn);
  end;

  iConn := iConn - i;
  SetLength(ConnectionNest, iConn);

  Result := False;

  if (iConn = 0) or
     ((iConn > 0) and (ConnectionNest[iConn - 1].CliHandle <> Connection.CliHandle)) then
  begin
    SetLength(ConnectionNest, iConn + 1);
    ConnectionNest[iConn] := Connection;

    //CJY ChangeAllConnections changes all the connections to the same connection
    //    to workaround transaction issues. Externally you can set this unit to
    //    use the same connection as the rest of the processthat calls this unit.
    for i := 0 to ComponentCount - 1 do
    begin
      if (Components[i] is TFDQueryPlus) then
        TFDQueryPlus(Components[i]).Connection := Connection
      else
      if (Components[i] is TFDTable) or
         (Components[i] is TFDTablePlus) then
        TFDTablePlus(Components[i]).Connection := Connection;
    end;

    Result := True;
  end;
end;

procedure TdmBasAll.RevertAllConnections();
var
  i, iConn: integer;
  Connection: TFDCustomConnection;
  TestConn: TFDConnection;

begin
  iConn := Length(ConnectionNest);

  if iConn > 0 then
  begin
    Connection := ConnectionNest[iConn - 1];
    SetLength(ConnectionNest, iConn - 1);
  end
  else
    Connection := fmSumms.ConnectionSumms;

  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TFDQueryPlus) then
      TFDQueryPlus(Components[i]).Connection := Connection
    else
    if (Components[i] is TFDTable) or
       (Components[i] is TFDTablePlus) then
      TFDTablePlus(Components[i]).Connection := Connection;
  end;
end;

end.

