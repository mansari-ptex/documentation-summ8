unit Cututils_Summs7;

interface

uses
  Classes, Forms, FireDAC.Comp.Client, DBTables, cmnTypes;

type
  TdmCutUtils_Summs7 = class(TDataModule)
    procedure AddCElement(Name, Category, Reason: String; Adj, Freq, BSdivPPJ: Real; Seq: integer; LevelBase, DoAll: Boolean);
    procedure Answers2LeaElements(Name: string; Sample: Boolean; ActualBatchSize: integer;
                                  qInputs, qKnivesForValue: TFDQuery; QualCoeff: integer;
                                  LevelBase, DoAll, FromTicket: Boolean; NumSizes: real);
    procedure Answers2SynElements(Name: String; Sample: boolean; ActualBatchSize: integer;
                                  qInputs, qKnivesForValue: TFDQuery; LevelBase, DoAll,
                                  FromTicket: Boolean; NumSizes: real);
    procedure Value_ElementsAndTotals(Name: String; Sample: Boolean; qInputs, qOutputs, qKnivesForValue: TFDQuery; LevelBase: Boolean);
    procedure Values_Total_asSms(Name: String;
                                 Sample: Boolean;
                                 ActualBatchSize: integer;
                                 qInputs, qOutputs, qKnivesForValue: TFDQuery;
                                 LevelBase: Boolean;
                                 MinQual, MaxQual, Rest, Cont: integer;
                                 FromTicket: Boolean;
                                 NumSizes: real);

  private
    { Private declarations }
    SQ1, SQ2, SQ3, SQ4, SQ5, SQ6TRUE, SQ6FALSE, SQ7TRUE, SQ7FALSE, SQ8, SQT: string;
    SQ7STRUE, SQ7SFALSE: string;
    SQ7MTRUE, SQ7MFALSE: string;
    SQ7CTRUE, SQ7CFALSE: string;
    SQ7PTRUE, SQ7PFALSE: string;
    SQ7TTRUE, SQ7TFALSE: string;
    SDataCutting: string;
  public
    { Public declarations }
  end;

var
  dmCutUtils_Summs7: TdmCutUtils_Summs7;

implementation

uses
  Db, General, CutUtils2_Summs7
  {$IFNDEF SATRADATA}
  , SummsVars
  {$ENDIF}
  ;

{$R *.DFM}

const
  INCHES_TO_CMS = 2.54;
  CMS_TO_INCHES = 0.393700787;  {1 / 2.54}
  SQFT_TO_SQINCHES = 144;
  SQDC_TO_SQFT = 0.1076;
  METRES_TO_CMS = 100;
  INCHES_TO_FEET = 0.083333333;  {1 / 12}

procedure TdmCutUtils_Summs7.AddCElement(Name, Category, Reason: String; Adj, Freq, BSdivPPJ: Real; Seq: integer; LevelBase, DoAll: Boolean);
var
  sAdj, sFreq, sSeq, sBSdivPPJ: string;
  sTrue, sFalse: string;

begin
  if Freq <> 0 then
  begin
    if not LevelBase then
      //Standard
      Adj := Adj * 0.75;

    str(Seq, sSeq);
    str(-Adj : 14 : 8, sAdj);
    str(Freq : 14 : 8, sFreq);
    str(BSdivPPJ : 14 : 8, sBSdivPPJ);

    if dmCutUtils_Summs7.Owner.Name = 'fmSumms' then
    begin
      if DoAll then
      begin
        SQ1 := SQ1 + ' WHEN ''' + Reason + ''' THEN ' + sSeq;
        SQ2 := SQ2 + ' WHEN ''' + Reason + ''' THEN ''' + Category + '''';
        SQ4 := SQ4 + ' WHEN ''' + Reason + ''' THEN ' + sAdj;
        SQ5 := SQ5 + ' WHEN ''' + Reason + ''' THEN Time + ' + sAdj;
        SQ6TRUE := SQ6TRUE + ' WHEN ''' + Reason + ''' THEN ' + SFreq;
        if Freq <> 1 then
          SQ6FALSE := SQ6FALSE + ' WHEN ''' + Reason + ''' THEN ' + sBSdivPPJ + ' * ' + sFreq
        else
          SQ6FALSE := SQ6FALSE + ' WHEN ''' + Reason + ''' THEN ' + sBSdivPPJ
      end;

      if Adj <> 0 then
      begin
        sTrue := ' WHEN ''' + Reason + ''' THEN ' + SFreq + ' * (Time + ' + sAdj + ')';
        sFalse := ' WHEN ''' + Reason + ''' THEN ' + sBSdivPPJ + ' * ' + sFreq + ' * (Time + ' + sAdj + ')';
      end
      else
      begin
        sTrue := ' WHEN ''' + Reason + ''' THEN ' + SFreq + ' * Time';
        sFalse := ' WHEN ''' + Reason + ''' THEN ' + sBSdivPPJ + ' * ' + sFreq + ' * Time';
      end;
      SQ7TRUE := SQ7TRUE + sTrue;
      SQ7FALSE := SQ7FALSE + sFalse;
      if Category = 'S' then
      begin
        SQ7STRUE := SQ7STRUE + sTrue;
        SQ7SFALSE := SQ7SFALSE + sFalse;
      end
      else if Category = 'M' then
      begin
        SQ7MTRUE := SQ7MTRUE + sTrue;
        SQ7MFALSE := SQ7MFALSE + sFalse;
      end
      else if Category = 'C' then
      begin
        SQ7CTRUE := SQ7CTRUE + sTrue;
        SQ7CFALSE := SQ7CFALSE + sFalse;
      end
      else if Category = 'P' then
      begin
        SQ7PTRUE := SQ7PTRUE + sTrue;
        SQ7PFALSE := SQ7PFALSE + sFalse;
      end;
      SQ8 := SQ8 + 'OR (Reason = ''' + Reason + ''') ';
    end
    else if (dmCutUtils_Summs7.Owner.name = 'fmSdata') or (dmCutUtils_Summs7.Owner.name = 'fmUpgradeToSData6') then
    begin
      SDataCutting := SDataCutting +
        'INSERT INTO Elements4CuttingValues' + #13 +
        'SELECT ''' + QS(Name) + ''', ' + sSeq + ', Element, ''' +  Category + ''',' + sAdj + ', ' + sFreq + #13 +
        'FROM DefaultHandlingElements' + #13 +
        'WHERE Reason = ''' + Reason + ''';' + #13 + #13;
    end;
  end;
end;

procedure TdmCutUtils_Summs7.Answers2LeaElements(Name: string; Sample: Boolean; ActualBatchSize: integer;
                                          qInputs, qKnivesForValue: TFDQuery; QualCoeff: integer;
                                          LevelBase, DoAll, FromTicket: Boolean; NumSizes: real);
var
   Pieces, AllowedArea, CuttableArea, InterlockArea, TotalInterlockArea,
   AveInterlockArea, NoKnives, NoLargeKnives, NoKnivesAdj, NoPunches,
   NoPairs, NoThins, NoBands, NoMarks, NoClears,
   Coefficient, NoCutts, ClearFreq, QualityAdj, Konst, ComplexFactor,
   SizeRatio, Freq, Adj: Real;
   El: String;
   CoefficientAndAdjFactor, AdjFactor: integer;
   KnifeFreqAndIncludedKnives: integer;
   KnifeFreq: real;
   NoIncludedKnives: integer;
   NoIncs: real;
   FreqAdj: real;
   BSdivPPJ: real;
   AASampleForTickets: real;
   Sizes: real;
   OffSet: integer;
   PairsMultiplier: SmallInt;
   Summs7PairsPerJob: Real;

begin
  Summs7PairsPerJob := qInputs.FieldByName('UnitsPerJob').value;

  //---General calculations---
  TotalInterlockArea := 0;   NoKnives := 0;
  NoLargeKnives := 0;        NoKnivesAdj := 0;
  NoPunches := 0;            NoPairs := 0;
  NoThins := 0;              NoBands := 0;
  NoMarks := 0;              NoClears := 0;
  NoIncs := 0;               KnifeFreq := 0;
  OffSet := 0;
//  BSdivPPJ := ActualBatchSize / qInputs.FieldByName('PairsPerJob').value;
  BSdivPPJ := ActualBatchSize / Summs7PairsPerJob;

  if qInputs.FieldByName('MadeInPairs').AsBoolean then
    PairsMultiplier := 2
  else
    PairsMultiplier := 1;

  if FromTicket then
    Sizes := NumSizes
  else
    Sizes := qInputs.FieldByName('Sizes').AsFloat;

  //qKnivesForValue.first;
  qKnivesForValue.RecNo := 1; //TAH changed from qKnivesForValue.First
  qKnivesForValue.Prior;      //TAH changed from qKnivesForValue.First
  while not(qKnivesForValue.Eof) do
  begin
    KnifeFreqAndIncludedKnives := qKnivesForValue.FieldByName('Freq').value;
    if KnifeFreqAndIncludedKnives > 100 then
    begin
      //Frequency from Summs in the form (NoIncludedKnives * 100) + Frequency
      KnifeFreq := KnifeFreqAndIncludedKnives mod 100;
      NoIncludedKnives := round(KnifeFreqAndIncludedKnives / 100);
    end
    else
    begin
      KnifeFreq := qKnivesForValue.FieldByName('Freq').value;
      NoIncludedKnives := 0;
    end;

    NoKnives := NoKnives + KnifeFreq;
    NoIncs := NoIncs + (KnifeFreq * NoIncludedKnives);
    InterlockArea := qKnivesForValue.FieldByName('NettArea').AsFloat * 1.1;

    if (InterlockArea > 0.6) then
      NoLargeKnives := NoLargeKnives + KnifeFreq;

    //Press Cutting
    Pieces := qKnivesForValue.FieldByName('Pieces').AsFloat;
    NoPunches := NoPunches + (KnifeFreq * qKnivesForValue.FieldByName('Punches').AsFloat);
    if qKnivesForValue.FieldByName('Pair').AsString = 'Y' then
      NoPairs := NoPairs + KnifeFreq;
    if qKnivesForValue.FieldByName('Thin').AsString = 'Y' then
      NoThins := NoThins + KnifeFreq;
    NoBands := NoBands + (KnifeFreq * qKnivesForValue.FieldByName('Bands').AsFloat);
    NoMarks := NoMarks + (KnifeFreq * qKnivesForValue.FieldByName('Marks').AsFloat);
    NoClears := NoClears + (KnifeFreq * qKnivesForValue.FieldByName('Clears').AsFloat);

    TotalInterlockArea := TotalInterlockArea + (KnifeFreq * (InterlockArea/Pieces));
    NoKnivesAdj := NoKnivesAdj + (KnifeFreq * (1 / Pieces));
    qKnivesForValue.Next;
  end;

  NoBands := NoBands + NoIncs;
  NoKnivesAdj := NoKnivesAdj + NoIncs;

  if NoKnives <> 0 then
    AveInterlockArea := TotalInterlockArea / (NoKnives + NoIncs)
  else
    AveInterlockArea := 0;

  //Allowed area in feet
  //(The figure SUMMS uses as AA has had Area Coefficient effect removed
  // - see FILLINTABLES in TIMES)
  if Sample then
    if FromTicket then
    begin
      AASampleForTickets := qInputs.FieldByName('BasicAllowance').value * (100 / (QualCoeff +
                           (qInputs.FieldByName('AdjFactorResult').Value * (100 - QualCoeff) / 15)));
      AllowedArea := AASampleForTickets *
//                     qInputs.FieldByName('PairsPerJob').AsFloat
                     Summs7PairsPerJob
    end
    else
      AllowedArea := qInputs.FieldByName('AASample').AsFloat *
//                     qInputs.FieldByName('PairsPerJob').AsFloat
                     Summs7PairsPerJob
  else
    AllowedArea := qInputs.FieldByName('AACosted').AsFloat *
//                   qInputs.FieldByName('PairsPerJob').AsFloat;
                   Summs7PairsPerJob;

  //Required when used with Summs8 allowances (TAH Sept 2020)
  if not (Sample and FromTicket) then
    AllowedArea := AllowedArea * PairsMultiplier;

  //Cuttable area in square feet
  if qInputs.FieldByName('Units').AsString = 'I' then
    CuttableArea := qInputs.FieldByName('Area').AsFloat
  else
    CuttableArea := qInputs.FieldByName('Area').AsFloat * SQDC_TO_SQFT;

  //---Set Up time---
  Freq := AllowedArea / 250;
  if Freq > int(Freq) then
    Freq := int(Freq) + 1;

  AddCElement(Name, 'S', 'L_FETCH/RETURN', 0, Freq, BSdivPPJ, 1, LevelBase, DoAll);
  AddCElement(Name, 'S', 'L_UNTIE/COUNT', 0, Freq, BSdivPPJ, 2, LevelBase, DoAll);
  AddCElement(Name, 'S', 'L_FETCH/RETURN_KNIVES', 0, Freq, BSdivPPJ, 3, LevelBase, DoAll);
  AddCElement(Name, 'S', 'L_FETCH_BOXES', 0, Freq, BSdivPPJ, 4, LevelBase, DoAll);
  AddCElement(Name, 'S', 'L_CLERICAL', 0, Freq, BSdivPPJ, 5, LevelBase, DoAll);
  AddCElement(Name, 'S', 'L_SETUP_MACHINE', 0, 1, BSdivPPJ, 6, LevelBase, DoAll);

  {---Material handling time---}
  //Replenish time
  if CuttableArea <> 0 then
    Freq := AllowedArea / CuttableArea
  else
    Freq := 0;

  if ((qInputs.FieldByName('CuttingType').AsString = 'M') or
      (qInputs.FieldByName('CuttingType').AsString = 'R')) then
    El := 'L_REPLENISH_MATCH_MARKED'
  else if ((qInputs.FieldByName('CuttingType').AsString = 'S') or
           (qInputs.FieldByName('CuttingType').AsString = 'E')) then
    El := 'L_REPLENISH';
  AddCElement(Name, 'M', El, 0, Freq, BSdivPPJ, 7, LevelBase, DoAll);

  //Roll skin time
  if CuttableArea > 6 then
    Freq := AllowedArea / CuttableArea
  else
    Freq := 0;

  Adj := (18 - CuttableArea) * 0.019 / 1.22; //Used to include 22% allowance
  AddCElement(Name, 'M', 'L_ROLL_SKIN', Adj, Freq, BSdivPPJ, 8, LevelBase, DoAll);

  //Move skin time
  if ((qInputs.FieldByName('CuttingType').AsString = 'M') or
      (qInputs.FieldByName('CuttingType').AsString = 'R')) then
    Freq := AllowedArea
  else if ((qInputs.FieldByName('CuttingType').AsString = 'S') or
           (qInputs.FieldByName('CuttingType').AsString = 'E')) then
    Freq := AllowedArea / 2;

  AddCElement(Name, 'M', 'L_MOVE_SKIN', 0, Freq, BSdivPPJ, 9, LevelBase, DoAll);

  //---Cutting time---
  CoefficientAndAdjFactor := qInputs.FieldByName('Coefficient').value;
  if CoefficientAndAdjFactor > 100 then
  begin
    //Coefficient from Summs in the form (Coefficent * 100) + Adjfactor
    Coefficient := QualCoeff;
    AdjFactor := CoefficientAndAdjFactor mod 100;
    if AdjFactor > 13 then
       AdjFactor := Adjfactor - 100;
  end
  else
  begin
    //Coefficient from Data in the form (Coefficent)
    Coefficient := CoefficientAndAdjFactor;
    AdjFactor := 0;
  end;

  //Adjust Coefficient (Standard pattern conversion)
  Coefficient := Coefficient + ((AdjFactor * (100 - Coefficient)) / 15);

//  NoCutts := qInputs.FieldByName('PairsPerJob').AsFloat * PairsMultiplier * NoKnivesAdj;
  NoCutts := Summs7PairsPerJob * PairsMultiplier * NoKnivesAdj;
  if NoKnives <> 0 then
    ClearFreq := NoClears / NoKnives
  else
    ClearFreq := 0;

  QualityAdj := 100 - Coefficient;
  if not qInputs.FieldByName('Trimmed').value then
    QualityAdj := QualityAdj + 5;
  QualityAdj := (100 + QualityAdj) / 100;
  Konst := 5.71;
  if AveInterlockArea < 0.45 then
    Konst := Konst + 9.56 * (0.45 - AveInterlockArea);

  //Place knife time
  {$IFNDEF SATRADATA}
  if DifficultLeatherFacility then
    FreqAdj := 1 + ((qInputs.FieldByName('DegreeDifficulty').AsFloat - 3) * 0.05)
  else
    FreqAdj := 1;    //Default when DegDiff not used is a DegDiff of 3, which equates to a FreqAdj of 1.
  {$ELSE}
  FreqAdj := 1 + ((qInputs.FieldByName('DegreeDifficulty').AsFloat - 3) * 0.05);
  {$ENDIF}

  Freq := FreqAdj * NoCutts * QualityAdj;
  Adj := ((0.45 - AveInterlockArea)*Konst)/60 / 1.22; //Used to include 22% allowance
  Adj := Adj / FreqAdj; //Divide by Adjustment because Adjustment is only meant for
                        //original element and so will be cancelled out on Adj later.

  if qInputs.FieldByName('MaterialType').AsString = 'K' then
    El := 'L_PICK/PLACE_KNIFE_KIPS'
  else if qInputs.FieldByName('CuttingType').AsString = 'E' then
    El := 'L_PICK/PLACE_KNIFE_EXHAUSTIVE'
  else
    El := 'L_PICK/PLACE_KNIFE_SELECTIVE';

  AddCElement(Name, 'C', El, Adj, Freq, BSdivPPJ, 10, LevelBase, DoAll);

  //Extra place knife time for sheepskin
  if qInputs.FieldByName('MaterialType').AsString = 'W' then
    Freq := NoCutts * QualityAdj
  else
    Freq := 0;

  AddCElement(Name, 'C', 'L_EXTRA_PLACE_SHEEPSKIN', 0, Freq, BSdivPPJ, 11, LevelBase, DoAll);

  //Activate Press time
//Summs 7 was A, P
//Summs 8 is P, S, T, always S on conversion
//I ASSUME they are all MANUAL - yes checked with Garry - what if customer has 'A' set and wants to use Summs 7 times?
//  if qInputs.FieldByName('CuttingMethodLeather').AsString = 'A' then
//  begin
//    Freq := NoCutts;
//    El :='L_ACTIVATE_PRESS_AUTO';
//  end
//  else if qInputs.FieldByName('CuttingMethodLeather').AsString = 'P' then
  begin
    Freq := NoCutts * (1 - ((0.45 - AveInterlockArea) * 0.44));
    El := 'L_ACTIVATE_PRESS_MANUAL';
  end;
  AddCElement(Name, 'C', El, 0, Freq, BSdivPPJ, 12, LevelBase, DoAll);

  //Inspect time
  Freq := NoCutts * (1.0 + ((100 - Coefficient) / 100));
  if qInputs.FieldByName('CuttingType').AsString = 'E' then
    Freq := Freq / 15
  else if qInputs.FieldByName('MaterialType').AsString = 'K' then
    Freq := Freq / 10;

  if ((qInputs.FieldByName('CuttingType').AsString = 'M') or
      (qInputs.FieldByName('CuttingType').AsString = 'R')) then
  begin
    Adj := 0;
    El := 'L_INSPECT_CUT_PIECE_M/M';
  end
  else if ((qInputs.FieldByName('CuttingType').AsString = 'S') or
           (qInputs.FieldByName('CuttingType').AsString = 'E')) then
  begin
    Adj := (0.45 - AveInterlockArea) * 0.022 / 1.22; //Used to include 22% allowance
    El := 'L_INSPECT_CUT_PIECE';
  end;
  AddCElement(Name, 'C', El, Adj, Freq, BSdivPPJ, 15 + OffSet, LevelBase, DoAll);

  //Double bump time
//  Freq := qInputs.FieldByName('PairsPerJob').AsFloat * PairsMultiplier * NoLargeKnives;
  Freq := Summs7PairsPerJob * PairsMultiplier * NoLargeKnives;
  AddCElement(Name, 'C', 'L_DOUBLE_PRESS_STRIKE', 0, Freq, BSdivPPJ, 16 + OffSet, LevelBase, DoAll);

  //Thin cut time
//  Freq := qInputs.FieldByName('PairsPerJob').AsFloat * PairsMultiplier * NoThins;
  Freq := Summs7PairsPerJob * PairsMultiplier * NoThins;
  AddCElement(Name, 'C', 'L_THIN_KNIFE_EXTRACT', 0, Freq, BSdivPPJ, 17 + OffSet, LevelBase, DoAll);

  //Punch cut time
//  Freq := qInputs.FieldByName('PairsPerJob').AsFloat * PairsMultiplier * NoPunches;
  Freq := Summs7PairsPerJob * PairsMultiplier * NoPunches;
  AddCElement(Name, 'C', 'L_PUNCH_KNIFE_EXTRACT', 0, Freq, BSdivPPJ, 18 + OffSet, LevelBase, DoAll);

  //Change knife time
//  SizeRatio := (Sizes / qInputs.FieldByName('PairsPerJob').AsFloat) + 1;
  SizeRatio := (Sizes / Summs7PairsPerJob) + 1;
  if qInputs.FieldByName('CuttingType').AsString = 'E' then
    Freq := NoCutts * (1 - ((Coefficient - 80) * 0.045))
  else if qInputs.FieldByName('CuttingType').AsString = 'S' then
  begin
    if ((qInputs.FieldByName('MaterialType').AsString = 'L') or
        (qInputs.FieldByName('MaterialType').AsString = 'W')) then
      Freq := NoCutts * (1 - ((Coefficient - 80) * 0.0425))
    else if qInputs.FieldByName('MaterialType').AsString = 'K' then
      Freq := NoCutts * (1 - ((Coefficient - 80) * 0.045));
  end
  else if ((qInputs.FieldByName('CuttingType').AsString = 'M') or
           (qInputs.FieldByName('CuttingType').AsString = 'R')) then
    Freq := NoCutts;
  Freq := (Freq + (Sizes * NoKnivesAdj)) * SizeRatio;
  AddCElement(Name, 'C', 'L_CHANGE_KNIFE', 0, Freq, BSdivPPJ, 19 + OffSet, LevelBase, DoAll);

  //Pair knife time
//  Freq := qInputs.FieldByName('PairsPerJob').AsFloat * PairsMultiplier * NoPairs;
  Freq := Summs7PairsPerJob * PairsMultiplier * NoPairs;
  AddCElement(Name, 'C', 'L_PAIRS_KNIVES', 0, Freq, BSdivPPJ, 20 + OffSet, LevelBase, DoAll);

  //Clear knife time
  if ClearFreq <> 0 then
    Freq := NoCutts * (1 + ((100 - Coefficient) / 100)) / ClearFreq
  else
    Freq := 0;
  if ((qInputs.FieldByName('CuttingType').AsString = 'M') or
      (qInputs.FieldByName('CuttingType').AsString = 'R')) then
    Adj := 0
  else if ((qInputs.FieldByName('CuttingType').AsString = 'S') or
           (qInputs.FieldByName('CuttingType').AsString = 'E')) then
    Adj := (0.45 - AveInterlockArea) * 0.016 * ClearFreq / 1.22; //Used to include 22% allowance
  AddCElement(Name, 'C', 'L_CLEAR_KNIFE', Adj, Freq, BSdivPPJ, 21 + OffSet, LevelBase, DoAll);

  //---Cut Part handling time---
  //Band time
  AddCElement(Name, 'P', 'L_STRAIGHTEN_COMPONENTS', 0, NoKnives, BSdivPPJ, 22 + OffSet, LevelBase, DoAll);
  AddCElement(Name, 'P', 'L_PLACE_TICKET_AND_BAND', 0, NoBands, BSdivPPJ, 23 + OffSet, LevelBase, DoAll);
  //Mark time
  AddCElement(Name, 'P', 'L_MARK_COMPONENTS', 0, NoMarks, BSdivPPJ, 24 + OffSet, LevelBase, DoAll);
  //Aside time
  AddCElement(Name, 'P', 'L_ASIDE_TO_BOX', 0, NoKnives, BSdivPPJ, 25 + OffSet, LevelBase, DoAll);
  //Count time
  AddCElement(Name, 'P', 'L_COUNT_COMPONENTS', 0, NoKnives + NoIncs, BSdivPPJ, 26 + OffSet, LevelBase, DoAll);
end;

procedure TdmCutUtils_Summs7.Answers2SynElements(Name: String; Sample: Boolean; ActualBatchSize: integer;
                                          qInputs, qKnivesForValue: TFDQuery; LevelBase, DoAll,
                                          FromTicket: Boolean; NumSizes: real);
                                          
var
   Divisor, Pieces, AllowedArea, MaterialWidth, MaterialLength, MaterialArea, KnifeDepth,
   TotalRollLength, MaxTableLength, CuttableArea, InterlockArea,
   TotalInterlockArea, AveInterlockArea, NoKnives, NoLargeKnives, NoKnivesAdj,
   NoPunches, NoPairs, NoThins, NoBands, NoMarks, NoClears, SwatheFreq,
   SwatheArea, NoCutts, ClearFreq, Konst, StrokeAdj, Freq, Adj: Real;
   El: String;
   KnifeFreqAndIncludedKnives: integer;
   KnifeFreq: real;
   NoIncludedKnives: integer;
   NoIncs: integer;
   BSdivPPJ: real;
   AASampleForTickets: real;
   Sizes: real;
   FullSynthetic: boolean;
   PairsMultiplier: SmallInt;
   Summs7PairsPerJob: Real;

begin
  Summs7PairsPerJob := qInputs.FieldByName('UnitsPerJob').value;

  //---General calculations---
  TotalInterlockArea := 0;
  NoKnives := 0;          NoLargeKnives := 0;
  NoKnivesAdj := 0;       NoPunches := 0;
  NoPairs := 0;           NoThins := 0;
  NoBands := 0;           NoMarks := 0;
  NoClears := 0;          NoIncs := 0;
//  BSdivPPJ := ActualBatchSize / qInputs.FieldByName('PairsPerJob').value;
  BSdivPPJ := ActualBatchSize / Summs7PairsPerJob;

  if qInputs.FieldByName('MadeInPairs').AsBoolean then
    PairsMultiplier := 2
  else
    PairsMultiplier := 1;

  if qInputs.FindField('SLMAllowance') = nil then
    FullSynthetic := False
  else
    FullSynthetic := not(qInputs.FieldByName('SLMAllowance').Value);

  if FromTicket then
    Sizes := NumSizes
  else
    Sizes := qInputs.FieldByName('Sizes').AsFloat;

  //qKnivesForValue.first;
  qKnivesForValue.RecNo := 1; //TAH changed from qKnivesForValue.First
  qKnivesForValue.Prior;      //TAH changed from qKnivesForValue.First
  while not qKnivesForValue.Eof do
  begin
    KnifeFreqAndIncludedKnives := qKnivesForValue.FieldByName('Freq').value;
    if KnifeFreqAndIncludedKnives > 100 then
    begin
      //Frequency from Summs in the form (NoIncludedKnives * 100) + Frequency
      KnifeFreq := KnifeFreqAndIncludedKnives mod 100;
      NoIncludedKnives := round(KnifeFreqAndIncludedKnives / 100);
    end
    else
    begin
      KnifeFreq := KnifeFreqAndIncludedKnives;
      NoIncludedKnives := 0;
    end;

    NoKnives := NoKnives + KnifeFreq;
    NoIncs := NoIncs + NoIncludedKnives;
    InterlockArea := qKnivesForValue.FieldByName('NettArea').AsFloat * 1.1;
    if InterlockArea > 0.6 then
      NoLargeKnives := NoLargeKnives + KnifeFreq;
    Pieces := qKnivesForValue.FieldByName('Pieces').AsFloat;
    NoPunches := NoPunches + (KnifeFreq * qKnivesForValue.FieldByName('Punches').AsFloat);
    if qKnivesForValue.FieldByName('Pair').AsString = 'Y' then
      NoPairs := NoPairs + KnifeFreq;
    if qKnivesForValue.FieldByName('Thin').AsString = 'Y' then
      NoThins := NoThins + KnifeFreq;
    NoBands := NoBands + (KnifeFreq * qKnivesForValue.FieldByName('Bands').AsFloat);
    NoMarks := NoMarks + (KnifeFreq * qKnivesForValue.FieldByName('Marks').AsFloat);
    NoClears := NoClears + (KnifeFreq * qKnivesForValue.FieldByName('Clears').AsFloat);
    if Pieces <> 0 then
    begin
      TotalInterlockArea := TotalInterlockArea +
                           (KnifeFreq * (InterlockArea/Pieces));
      NoKnivesAdj := NoKnivesAdj + (KnifeFreq * (1 / Pieces));
    end;
    qKnivesForValue.Next;
  end;

  NoBands := NoBands + NoIncs;
  NoKnivesAdj := NoKnivesAdj + NoIncs;

  if NoKnives <> 0 then
    AveInterlockArea := TotalInterlockArea / (NoKnives + NoIncs)
  else
    AveInterlockArea := 0;

  //Allowed area in feet
  if Sample then
    if FromTicket then
    begin
      AASampleForTickets := qInputs.FieldByName('BasicAllowance').value;
//      AllowedArea := AASampleForTickets * qInputs.FieldByName('PairsPerJob').AsFloat
      AllowedArea := AASampleForTickets * Summs7PairsPerJob
    end
    else if FullSynthetic then
//      AllowedArea := qInputs.FieldByName('AASampleSynth').AsFloat * qInputs.FieldByName('PairsPerJob').AsFloat
      AllowedArea := qInputs.FieldByName('AASampleSynth').AsFloat * Summs7PairsPerJob
    else
//      AllowedArea := qInputs.FieldByName('AASample').AsFloat * qInputs.FieldByName('PairsPerJob').AsFloat
      AllowedArea := qInputs.FieldByName('AASample').AsFloat * Summs7PairsPerJob
  else if FullSynthetic then
//      AllowedArea := qInputs.FieldByName('AACostedSynth').AsFloat * qInputs.FieldByName('PairsPerJob').AsFloat
      AllowedArea := qInputs.FieldByName('AACostedSynth').AsFloat * Summs7PairsPerJob
    else
//      AllowedArea := qInputs.FieldByName('AACosted').AsFloat * qInputs.FieldByName('PairsPerJob').AsFloat;
      AllowedArea := qInputs.FieldByName('AACosted').AsFloat * Summs7PairsPerJob;

  //Required when used with Summs8 allowances (TAH Sept 2020)
  if not (Sample and FromTicket) then
    AllowedArea := AllowedArea * PairsMultiplier;

  //Material Width & Length in feet, Knife depth in inches
  if qInputs.FieldByName('Units').AsString = 'I' then
  begin
    MaterialLength := qInputs.FieldByName('LengthInches').AsFloat * INCHES_TO_FEET;
    MaterialWidth := qInputs.FieldByName('WidthInches').AsFloat * INCHES_TO_FEET;
    KnifeDepth := qInputs.FieldByName('Depth').AsFloat;
  end
  else
  begin
    MaterialLength := qInputs.FieldByName('Length').AsFloat *
                      CMS_TO_INCHES * INCHES_TO_FEET;
    MaterialWidth := qInputs.FieldByName('Width').AsFloat *
                      CMS_TO_INCHES * INCHES_TO_FEET;
    KnifeDepth := qInputs.FieldByName('Depth').AsFloat * CMS_TO_INCHES;
  end;

  //Max table length in feet
  MaxTableLength := qInputs.FieldByName('MaxTableLength').AsFloat *
                    METRES_TO_CMS * CMS_TO_INCHES * INCHES_TO_FEET;

  //Total Roll length in feet
  if MaterialWidth <> 0 then
    TotalRollLength := AllowedArea / MaterialWidth
  else
    TotalRollLength := 0;

  //Area in feet
  if qInputs.FieldByName('MaterialType').AsString = 'R' then
  begin
    MaterialLength := TotalRollLength;
    MaterialArea := MaterialLength * MaterialWidth;
    if (MaterialLength / qInputs.FieldByName('Layers').AsFloat) > MaxTableLength then
      MaterialLength := MaxTableLength;
  end
  else if qInputs.FieldByName('MaterialType').AsString = 'S' then
    MaterialArea := AllowedArea;

  //Cuttable area in square feet
  CuttableArea := MaterialLength * MaterialWidth;

  //---Set Up time---
  if qInputs.FieldByName('MaterialType').AsString = 'R' then
  begin
    if qInputs.FieldByName('FeedSystem').AsString = 'G' then
    begin
      //Gantry
      if MaxTableLength<>0 then
         Freq := TotalRollLength / (MaxTableLength*qInputs.FieldByName('Layers').AsFloat)
      else
         Freq := 0;
      if Freq > int(Freq) then
         Freq := int(Freq) + 1;
      El := 'S_LAYUP_GANTRY';
    end
    else
    begin
      //Clips
      Freq := 1;
      El := 'S_LAYUP_CLIPS';
    end;
  end
  else
  begin
    Freq := 1;
    El := 'S_LAYUP_SHEETS';
  end;
  AddCElement(Name, 'S', El, 0, Freq, BSdivPPJ, 1, LevelBase, DoAll);

  //Subsequent layers for gantry
  if ((qInputs.FieldByName('MaterialType').AsString = 'R') and
      (qInputs.FieldByName('FeedSystem').AsString = 'G')) then
  begin
    Freq := Freq * (qInputs.FieldByName('Layers').AsFloat - 1);
    AddCElement(Name, 'S', 'S_LAYUP_OTHER_LAYERS_GANTRY', 0, Freq, BSdivPPJ, 2, LevelBase, DoAll);
  end;

  AddCElement(Name, 'S', 'S_FETCH/RETURN_KNIVES', 0, 1, BSdivPPJ, 3, LevelBase, DoAll);
  AddCElement(Name, 'S', 'S_FETCH_BOXES', 0, 1, BSdivPPJ, 4, LevelBase, DoAll);
  AddCElement(Name, 'S', 'S_CLERICAL', 0, 1, BSdivPPJ, 5, LevelBase, DoAll);
  AddCElement(Name, 'S', 'S_SETUP_MACHINE', 0, 1, BSdivPPJ, 6, LevelBase, DoAll);

  //---Material handling time---
  if MaterialWidth <> 0 then
  begin
    if Sample then
    begin
      if FromTicket then
        Divisor := AASampleForTickets
      else if FullSynthetic then
        Divisor := qInputs.FieldByName('AASampleSynth').AsFloat
      else
        Divisor := qInputs.FieldByName('AASample').AsFloat;
    end
    else if FullSynthetic then
      Divisor := qInputs.FieldByName('AACostedSynth').AsFloat
    else
      Divisor := qInputs.FieldByName('AACosted').AsFloat;

    //Required when used with Summs8 allowances (TAH Sept 2020)
    if not (Sample and FromTicket) then
      Divisor := Divisor * PairsMultiplier;

    if not(Divisor = 0) then
//      SwatheFreq := qInputs.FieldByName('PairsPerJob').AsFloat /
      SwatheFreq := Summs7PairsPerJob /
                   ((MaterialWidth * 1.3 * qInputs.FieldByName('Layers').AsFloat)
                   / Divisor)
    else
      SwatheFreq := 0;
  end
  else
    SwatheFreq := 0;

  //Replenish time
  if CuttableArea <> 0 then
    Freq := MaterialArea / (qInputs.FieldByName('Layers').AsFloat * CuttableArea)
  else
    Freq := 0;

  if qInputs.FieldByName('MaterialType').AsString = 'R' then
  begin
    if qInputs.FieldByName('FeedSystem').AsString = 'G' then
       Freq := 0;
    El := 'S_REPLENISH_CLIPS';
  end
  else if qInputs.FieldByName('MaterialType').AsString = 'S' then
    El := 'S_REPLENISH_SHEETS';
  AddCElement(Name, 'M', El, 0, Freq, BSdivPPJ, 7, LevelBase, DoAll);

  //Feed through time
  Freq := 1 + SwatheFreq;
  AddCElement(Name, 'M', 'S_FEED_THROUGH_MATERIAL', 0, Freq, BSdivPPJ, 8, LevelBase, DoAll);

  //Realign time
  if ((qInputs.FieldByName('MaterialType').AsString = 'R') and
      (qInputs.FieldByName('FeedSystem').AsString = 'G')) then
    Freq := SwatheFreq / 5
  else
    Freq := 0;
  AddCElement(Name, 'M', 'S_REALIGN_MATERIAL', 0, Freq, BSdivPPJ, 9, LevelBase, DoAll);

  //Waste time
  if qInputs.FieldByName('MaterialType').AsString = 'R' then
  begin
    Freq := (1 + (SwatheFreq / 8)) * MaterialWidth / 4.5;
    AddCElement(Name, 'M', 'S_CHOP_WASTE_AND_ASIDE_VAR', 0, Freq, BSdivPPJ, 10, LevelBase, DoAll);
    AddCElement(Name, 'M', 'S_CHOP_WASTE_AND_ASIDE_CONST', 0, Freq, BSdivPPJ, 11, LevelBase, DoAll);
  end;

  //---Cutting time---
  SwatheArea := MaterialWidth * 1.3;
//  NoCutts := qInputs.FieldByName('PairsPerJob').AsFloat * PairsMultiplier * NoKnivesAdj /
  NoCutts := Summs7PairsPerJob * PairsMultiplier * NoKnivesAdj /
             qInputs.FieldByName('Layers').AsFloat;
  if NoKnives <> 0 then
    ClearFreq := NoClears / NoKnives
  else
    ClearFreq := 0;
  Konst := 5.71;
  if (AveInterlockArea < 0.45) then
    Konst := Konst + (9.56 * (0.45 - AveInterlockArea));

  //Knife time
  if SwatheArea <> 0 then
    Freq := (Sizes * NoKnivesAdj) +
            ((AllowedArea / qInputs.FieldByName('Layers').AsFloat) / SwatheArea)
  else
    Freq := 0;
  AddCElement(Name, 'C', 'S_CHANGE_KNIFE', 0, Freq, BSdivPPJ, 12, LevelBase, DoAll);

  //Double bump time
//  Freq := qInputs.FieldByName('PairsPerJob').AsFloat * PairsMultiplier * NoLargeKnives /
  Freq := Summs7PairsPerJob * PairsMultiplier * NoLargeKnives /
          qInputs.FieldByName('Layers').AsFloat;
  AddCElement(Name, 'C', 'S_DOUBLE_PRESS_STRIKE', 0, Freq, BSdivPPJ, 13, LevelBase, DoAll);

  //Thin cut time
//  Freq := qInputs.FieldByName('PairsPerJob').AsFloat * PairsMultiplier * NoThins /
  Freq := Summs7PairsPerJob * PairsMultiplier * NoThins /
          qInputs.FieldByName('Layers').AsFloat;
  AddCElement(Name, 'C', 'S_THIN_KNIFE_EXTRACT', 0, Freq, BSdivPPJ, 14, LevelBase, DoAll);

  //Punch cut time
//  Freq := qInputs.FieldByName('PairsPerJob').AsFloat * PairsMultiplier * NoPunches /
  Freq := Summs7PairsPerJob * PairsMultiplier * NoPunches /
          qInputs.FieldByName('Layers').AsFloat;
  AddCElement(Name, 'C', 'S_PUNCH_KNIFE_EXTRACT', 0, Freq, BSdivPPJ, 15, LevelBase, DoAll);

  //Press time
  StrokeAdj := ((KnifeDepth - 1.5) * 0.67) / 60;
  if not LevelBase then
    StrokeAdj := StrokeAdj * 4/3; //Add 1/3 so its taken off again automatically
                                  //because StrokeAdj NOT affected by level
  Freq := NoCutts;
  Adj := ((((0.45 - AveInterlockArea) * Konst) / 60) - StrokeAdj) / 1.22; //Used to include 22% allowance

//Summs 7 was A, P
//Summs 8 is P, T, always P on conversion
//I ASSUME they are all MANUAL - yes checked with Garry - what if customer has 'A' set and wants to use Summs 7 times?
//  if (qInputs.FieldByName('CuttingMethodSynthetic').AsString = 'P') then
    El := 'S_PLACE_KNIFE_CUT/ASIDE_MANUAL';
//  else if qInputs.FieldByName('CuttingMethodSynthetic').AsString = 'A' then
//    El := 'S_PLACE_KNIFE_CUT/ASIDE_AUTO';
  AddCElement(Name, 'C', El, Adj, Freq, BSdivPPJ, 16, LevelBase, DoAll);

  //Clear knife time
  if ClearFreq <> 0 then
    Freq := NoCutts / ClearFreq
  else
    Freq := 0;
  AddCElement(Name, 'C', 'S_CLEAR_KNIFE', 0, Freq, BSdivPPJ, 17, LevelBase, DoAll);

  //---Cut Part handling time---
  //Band time
  AddCElement(Name, 'P', 'S_STRAIGHTEN_COMPONENTS', 0, NoKnives, BSdivPPJ, 18, LevelBase, DoAll);
  AddCElement(Name, 'P', 'S_PLACE_TICKET_AND_BAND', 0, NoBands, BSdivPPJ, 19, LevelBase, DoAll);
  //Mark time
  AddCElement(Name, 'P', 'S_MARK_COMPONENTS', 0, NoMarks, BSdivPPJ, 20, LevelBase, DoAll);
  //Aside time
  AddCElement(Name, 'P', 'S_ASIDE_TO_BOX', 0, NoKnives, BSdivPPJ, 21, LevelBase, DoAll);
end;

procedure TdmCutUtils_Summs7.Value_ElementsAndTotals(Name: String; Sample: Boolean;
                                              qInputs, qOutputs, qKnivesForValue: TFDQuery; LevelBase: Boolean);
var
  MaterialType: string;
  SQLString: string;

begin
  if (dmCutUtils_Summs7.Owner.name = 'fmSdata') or (dmCutUtils_Summs7.Owner.name = 'fmUpgradeToSData6') then
  begin
    dmCutUtils2_Summs7.qRemoveCuttingElements.paramByName('ValName').value := Name;
    dmCutUtils2_Summs7.qRemoveCuttingElements.execSQL;
    SDataCutting := '';
  end
  else if dmCutUtils_Summs7.Owner.Name = 'fmSumms' then
  begin
    //Start Strings
    SQ1 :=      'SELECT CASE Reason';
    SQ2 :=      ' CASE Reason';
    SQ3 :=      ' Element,' +
                ' Description,' +
                ' Time as Bms,';
    SQ4 :=      ' CASE Reason';
    SQ5 :=      ' CASE Reason';
    SQ6TRUE :=  ' CASE PerBatch' +
                ' WHEN 1 THEN' +
                ' CASE Reason';
    SQ6FALSE := ' WHEN 0 THEN' +
                ' CASE Reason';
    SQ7TRUE :=  ' CASE PerBatch' +
                ' WHEN 1 THEN' +
                ' CASE Reason';
    SQ7FALSE := ' WHEN 0 THEN' +
                ' CASE Reason';
    SQ7STRUE := SQ7TRUE;
    SQ7MTRUE := SQ7TRUE;
    SQ7CTRUE := SQ7TRUE;
    SQ7PTRUE := SQ7TRUE;
    SQ7SFALSE := SQ7FALSE;
    SQ7MFALSE := SQ7FALSE;
    SQ7CFALSE := SQ7FALSE;
    SQ7PFALSE := SQ7FALSE;
    SQ8 :=      ' FROM Elements_Summs7 ' +
                'WHERE (Reason = '''') ';
  end;

  MaterialType := qInputs.FieldByName('MaterialType').AsString;
  if ((MaterialType = 'L') or (MaterialType = 'W') or (MaterialType = 'K')) then
    Answers2LeaElements(Name, Sample, qInputs.FieldByName('StdBatchSize').value, qInputs, qKnivesForValue, qInputs.FieldByName('QualCoeff').value, LevelBase, TRUE, False, 0)
  else if ((MaterialType = 'R') or (MaterialType = 'S')) then
    Answers2SynElements(Name, Sample, qInputs.FieldByName('StdBatchSize').value, qInputs, qKnivesForValue, LevelBase, TRUE, False, 0);

  if (dmCutUtils_Summs7.Owner.name = 'fmSdata') or (dmCutUtils_Summs7.Owner.name = 'fmUpgradeToSData6') then
  begin
    dmCutUtils2_Summs7.qAddCuttingElement.SQL.Text := SDataCutting;
    dmCutUtils2_Summs7.qAddCuttingElement.ExecSQL; // execSQLscript;
  end
  else if dmCutUtils_Summs7.Owner.Name = 'fmSumms' then
  begin
    //End Strings
    SQ1 := SQ1 +             ' END as Seq, ';
    SQ2 := SQ2 +             ' END as Category, ';
    SQ4 := SQ4 +             ' END as Adj, ';
    SQ5 := SQ5 +             ' END as AdjBms, ' +
                             ' PerBatch, ';
    SQ6TRUE := SQ6TRUE +     ' END ';
    SQ6FALSE := SQ6FALSE +   ' END ' +
                             ' END as BatchFreq, ';

    SQ7TTRUE := SQ7TRUE +    ' END ';
    SQ7TFALSE := SQ7FALSE +  ' END ' +
                             ' END ';

    SQ7STRUE := SQ7STRUE +   ' END ';
    SQ7SFALSE := SQ7SFALSE + ' END ' +
                             ' END ';
    SQ7MTRUE := SQ7MTRUE +   ' END ';
    SQ7MFALSE := SQ7MFALSE + ' END ' +
                             ' END ';
    SQ7CTRUE := SQ7CTRUE +   ' END ';
    SQ7CFALSE := SQ7CFALSE + ' END ' +
                             ' END ';
    SQ7PTRUE := SQ7PTRUE +   ' END ';
    SQ7PFALSE := SQ7PFALSE + ' END ' +
                             ' END ';

    SQ7TRUE := SQ7TRUE +     ' END ';
    SQ7FALSE := SQ7FALSE +   ' END ' +
                             ' END as Time ';

    //Totals
    SQT := 'SELECT 0 as Seq, ''S'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Bms, 0.0 as Adj, 0.0 as AdjBms, ' +
           '0 as PerBatch, 0.0 as BatchFreq, SUM(' +
           SQ7STRUE +
           SQ7SFALSE +
           ') as Time ' +
           SQ8 +
           'UNION ' +

           'SELECT 0 as Seq, ''M'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Bms, 0.0 as Adj, 0.0 as AdjBms, ' +
           '0 as PerBatch, 0.0 as BatchFreq, SUM(' +
           SQ7MTRUE +
           SQ7MFALSE +
           ') as Time ' +
           SQ8 +
           'UNION ' +

           'SELECT 0 as Seq, ''C'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Bms, 0.0 as Adj, 0.0 as AdjBms, ' +
           '0 as PerBatch, 0.0 as BatchFreq, SUM(' +
           SQ7CTRUE +
           SQ7CFALSE +
           ') as Time ' +
           SQ8 +
           'UNION ' +

           'SELECT 0 as Seq, ''P'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Bms, 0.0 as Adj, 0.0 as AdjBms, ' +
           '0 as PerBatch, 0.0 as BatchFreq, SUM(' +
           SQ7PTRUE +
           SQ7PFALSE +
           ') as Time ' +
           SQ8 +
           'UNION ' +

           'SELECT 0 as Seq, ''T'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Bms, 0.0 as Adj, 0.0 as AdjBms, ' +
           '0 as PerBatch, 0.0 as BatchFreq, SUM(' +
           SQ7TTRUE +
           SQ7TFALSE +
           ') as Time ' +
           SQ8 +
           'UNION ' +

           SQ1 + SQ2 + SQ3 + SQ4 + SQ5 + SQ6TRUE + SQ6FALSE + SQ7TRUE + SQ7FALSE + SQ8;

    qOutputs.SQL.Text := SQT;
    qOutputs.open;
  end;

  if (dmCutUtils_Summs7.Owner.name = 'fmSdata') or (dmCutUtils_Summs7.Owner.name = 'fmUpgradeToSData6') then
  begin
    //Additional Cutting Elements
    dmCutUtils2_Summs7.qAdditionalCuttingElements.paramByName('ValName').value := Name;
    dmCutUtils2_Summs7.qAdditionalCuttingElements.execSQL;

    //ReIndex
    //This should have been 'normal' query but trying to pass General to
    //2nd part of the query gives arise to eroneous 7201 errors.

    SQLString := 'UPDATE Elements4CuttingValues ' +
                 'SET Seq = (' +
                 '           SELECT ((COUNT(E4V.Seq) * 10000) + Elements4CuttingValues.Seq) ' +
                 '           FROM Elements4CuttingValues E4V ' +
                 '           WHERE (E4V.Value = ''' + QS(Name) + ''') AND ' +
                 '                 ((E4V.Seq - (TRUNCATE(E4V.Seq / 10000, 0) * 10000)) <= Elements4CuttingValues.Seq) AND ' +
                 '                 (Elements4CuttingValues.Value = E4V.Value) ' +
                 '           ) ' +
                 'WHERE Value = ''' + QS(Name) + ''';' + #13 +
                 'UPDATE Elements4CuttingValues ' +
                 'SET Seq = TRUNCATE(Seq / 10000, 0) ' +
                 'WHERE Value = ''' + QS(Name) + ''';';
    dmCutUtils2_Summs7.qReIndexCuttingElements.SQL.Text := SQLString;

    dmCutUtils2_Summs7.qReIndexCuttingElements.ExecSQL; //execSQLscript;
  end;
end;

procedure TdmCutUtils_Summs7.Values_Total_asSms(Name: String;
                                         Sample: Boolean;
                                         ActualBatchSize: integer;
                                         qInputs, qOutputs, qKnivesForValue: TFDQuery;
                                         LevelBase: Boolean;
                                         MinQual, MaxQual, Rest, Cont: integer;
                                         FromTicket: Boolean;
                                         NumSizes: real);
var
  MaterialType: string;
  QualCoeff: integer;
  s, SQLString: string;
  sRest, sCont: string;

begin
  str((100 + Rest) / 100, sRest);
  str((100 + Cont) / 100, sCont);

  SQLString := '';
  for QualCoeff := MinQual to MaxQual do
  begin
    str(QualCoeff, s);

    //Start Strings
    SQ7TRUE :=  ' CASE PerBatch' +
                ' WHEN 1 THEN' +
                ' CASE Reason';
    SQ7FALSE := ' WHEN 0 THEN' +
                ' CASE Reason';
    SQ8 :=      ' FROM Elements_Summs7 ' +
                'WHERE (Reason = '''') ';

    MaterialType := qInputs.FieldByName('MaterialType').AsString;
    if ((MaterialType = 'L') or (MaterialType = 'W') or (MaterialType = 'K')) then
      Answers2LeaElements(Name, Sample, ActualBatchSize, qInputs, qKnivesForValue, QualCoeff, LevelBase, FALSE, FromTicket, Numsizes)
    else if ((MaterialType = 'R') or (MaterialType = 'S')) then
      Answers2SynElements(Name, Sample, ActualBatchSize, qInputs, qKnivesForValue, LevelBase, FALSE, FromTicket, NumSizes);

    //End Strings
    SQ7TTRUE := SQ7TRUE +    ' END ';
    SQ7TFALSE := SQ7FALSE +  ' END ' +
                             ' END ';

    //Totals
    SQT := 'SELECT ' + s + ' as Coeff, SUM(' +
           SQ7TTRUE +
           SQ7TFALSE +
           ') * ' + sRest + ' * ' + sCont + ' as Time ' + SQ8;

    SQLString := SQLString + SQT + #13;

    if QualCoeff < MaxQual then
      SQLString := SQLString + ' UNION ' + #13;
  end;

  qOutputs.SQL.Text := SQLString;
end;

end.

