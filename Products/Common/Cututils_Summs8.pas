unit Cututils_Summs8;

interface

uses
  Classes, Forms, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, cmnTypes, Dialogs;

type
  TdmCutUtils_Summs8 = class(TDataModule)
    procedure AddCElement(Name, Category, Reason: String; Freq, Per: Real; BatchSize, NoInUnit: integer; DoAll: Boolean);
    procedure Answers2LeaElements(Name: string; Sample: Boolean; ActualBatchSize: integer;
                                  qInputs, qKnivesForOperation: TFDQuery; QualCoeff: integer;
                                  DoAll, FromTicket: Boolean; NumSizes: integer);
    procedure Answers2SynElements(Name: String; Sample: boolean; ActualBatchSize: integer;
                                  qInputs, qKnivesForOperation: TFDQuery; DoAll,
                                  FromTicket: Boolean; NumSizes: integer);
    procedure Operation_ElementsAndTotals(Name: String; Sample: Boolean; qInputs, qOutputs, qKnivesForOperation: TFDQuery);
    procedure Operations_Total_asSms(Name: String;
                                 Sample: Boolean;
                                 ActualBatchSize: integer;
                                 qInputs, qOutputs, qKnivesForOperation: TFDQuery;
                                 MinQual, MaxQual, Rest, Cont: integer;
                                 FromTicket: Boolean;
                                 NumSizes: integer);

  private
    { Private declarations }
    SQ1, SQ2, SQ3, SQ4, SQ5, SQ6, SQ7, SQ8, SQT: string;
    SQ7S: string;
    SQ7M: string;
    SQ7C: string;
    SQ7P: string;
    SQ7T: string;
    Cutting: string;
  public
    { Public declarations }
    MessageShown: boolean;
  end;

var
  dmCutUtils_Summs8: TdmCutUtils_Summs8;
  Seq: integer;

implementation

uses
  Db, General, CutUtils2_Summs8
  {$IFNDEF TIMELINE}
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

procedure TdmCutUtils_Summs8.AddCElement(Name, Category, Reason: String; Freq, Per: Real; BatchSize, NoInUnit: integer; DoAll: Boolean);
var
  sFreq, sPer, sSeq, sBatchSize, sNoInUnit: string;
  s7: string;

begin
  inc(Seq);

  if Freq > 5000 then
  begin
    Freq := 5000;
    if Application.MainForm.Name = 'fmSumms' then
    begin
      if not MessageShown then
      begin
        messagedlg('Element frequency too big', mtWarning, [mbOk], 0);
        MessageShown := true;
      end;
    end
    else
      messagedlg('Element frequency too big - set to maximum' + #13 + 'Time unreliable', mtWarning, [mbOk], 0);
  end
  else if Freq < -5000 then
  begin
    Freq := -5000;
    if Application.MainForm.Name = 'fmSumms' then
    begin
      messagedlg('Element frequency too small', mtWarning, [mbOk], 0);
      MessageShown := true;
    end
    else
      messagedlg('Element frequency too small - set to minimum', mtWarning, [mbOk], 0);
  end;

  if Freq <> 0 then
  begin
    str(Seq, sSeq);
    str(Freq : 14 : 8, sFreq);
    str(Per : 14 : 8, sPer);
    str(BatchSize : 14, sBatchSize);
    str(NoInUnit : 14, sNoInUnit);

    if dmCutUtils_Summs8.Owner.Name = 'fmSumms' then
    begin
      if DoAll then
      begin
        SQ1 := SQ1 + #13 + ' WHEN ''' + Reason + ''' THEN ' + sSeq;
        SQ2 := SQ2 + #13 + ' WHEN ''' + Reason + ''' THEN ''' + Category + '''';
        SQ4 := SQ4 + #13 + ' WHEN ''' + Reason + ''' THEN ' + sFreq;
        SQ5 := SQ5 + #13 + ' WHEN ''' + Reason + ''' THEN ' + sPer;
        SQ6 := SQ6 + #13 + ' WHEN ''' + Reason + ''' THEN ' + sBatchSize + ' * ' + sNoInUnit + ' * ' + sFreq + ' / ' + sPer;
      end;

      s7 := #13 + ' WHEN ''' + Reason + ''' THEN ' + sBatchSize + ' * ' + sNoInUnit + ' * ' + sFreq + ' / ' + sPer + ' * Time';
      SQ7 := SQ7 + s7;
      if Category = 'S' then
        SQ7S := SQ7S + s7
      else if Category = 'M' then
        SQ7M := SQ7M + s7
      else if Category = 'C' then
        SQ7C := SQ7C + s7
      else if Category = 'P' then
        SQ7P := SQ7P + s7;

      SQ8 := SQ8 + 'OR (Reason = ''' + Reason + ''') ' +#13;
    end
    else if (dmCutUtils_Summs8.Owner.name = 'fmMain') then
    begin
      Cutting := Cutting +
        'INSERT INTO Elements4Operations (Operation, Seq, Element, Quantity, Every)' + #13 +
        'SELECT ''' + QS(Name) + ''', ' + sSeq + ', Element, ' + sFreq + ', ' + sPer + #13 +
        'FROM CuttingElements' + #13 +
        'WHERE Reason = ''' + Reason + ''' AND Use = True;' + #13 + #13;
    end;
  end;
end;

procedure TdmCutUtils_Summs8.Answers2LeaElements(Name: string; Sample: Boolean; ActualBatchSize: integer;
                                          qInputs, qKnivesForOperation: TFDQuery; QualCoeff: integer;
                                          DoAll, FromTicket: Boolean; NumSizes: integer);
var
   Pieces, AllowedArea, CuttableArea, NettArea, NoComponents, NoPeels,
   NoTools, NoBands, NoMarks, NoClears, Coefficient, ComplexFactor, Freq, Per: Real;
   El: String;
   CoefficientAndAdjFactor, AdjFactor: integer;
   KnifeFreqAndIncludedKnives: integer;
   KnifeFreq: integer;
   NoIncludedKnives: integer;
   NoIncs: real;
   BatchSize: integer;
   SinglesPerJob: integer;
   AASampleForTickets: real;
   Sizes: integer;
   NoInUnit: SmallInt;
   LeatherGrade: integer;
   MaxCutsPerFetch: integer;
   NoCuts, NoCutsWithLargeKnives, NoCutsVeryDiffPosn: real;
   NoComponentsWithBands, NoComponentsWithMarks, NoFetchesPerPair: real;
   MinimumNoFetches, CutsPerJob, CutsPerFetch: real;
   LargestNettArea: real;
   VeryDiffPosn: Boolean;

begin
  Seq := 0;

  NoComponents := 0;
  NoPeels := 0;
  NoTools := 0;              NoBands := 0;
  NoMarks := 0;              NoClears := 0;
  NoIncs := 0;               KnifeFreq := 0;
  NoCuts := 0;               NoFetchesPerPair := 0;
  NoCutsWithLargeKnives := 0;
  NoCutsVeryDiffPosn := 0;
  NoComponentsWithBands := 0;
  NoComponentsWithMarks := 0;
  LargestNettArea := 0;
  BatchSize := ActualBatchSize;

  if qInputs.FieldByName('MadeInPairs').AsBoolean then
    NoInUnit := 2
  else
    NoInUnit := 1;
  SinglesPerJob := qInputs.FieldByName('UnitsPerJob').value * NoInUnit;

  if FromTicket then
    Sizes := NumSizes
  else
    Sizes := qInputs.FieldByName('Sizes').value;

  qKnivesForOperation.first;
  while not(qKnivesForOperation.Eof) do
  begin
    KnifeFreqAndIncludedKnives := qKnivesForOperation.FieldByName('Freq').value;
    if KnifeFreqAndIncludedKnives > 100 then
    begin
      //Frequency from Summs in the form (NoIncludedKnives * 100) + Frequency
      KnifeFreq := KnifeFreqAndIncludedKnives mod 100;
      NoIncludedKnives := round(KnifeFreqAndIncludedKnives / 100);
    end
    else
    begin
      KnifeFreq := qKnivesForOperation.FieldByName('Freq').value;
      NoIncludedKnives := 0;
    end;

    NoComponents := NoComponents + KnifeFreq;
    NoIncs := NoIncs + (KnifeFreq * NoIncludedKnives);

    Pieces := qKnivesForOperation.FieldByName('Pieces').AsFloat;
    NettArea := qKnivesForOperation.FieldByName('NettArea').AsFloat;
    VeryDiffPosn := qKnivesForOperation.FieldByName('VeryDiffPosn').Value;

    NoPeels := NoPeels + (KnifeFreq * qKnivesForOperation.FieldByName('Peels').AsFloat);
    NoClears := NoClears + (KnifeFreq * qKnivesForOperation.FieldByName('Clears').AsFloat);
    if qKnivesForOperation.FieldByName('Thin').AsString = 'Y' then
      NoTools := NoTools + KnifeFreq;
    NoBands := NoBands + (KnifeFreq * qKnivesForOperation.FieldByName('Bands').AsFloat);
    NoMarks := NoMarks + (KnifeFreq * qKnivesForOperation.FieldByName('Marks').AsFloat);

    if qKnivesForOperation.FieldByName('Bands').Value > 0 then
      NoComponentsWithBands := NoComponentsWithBands + KnifeFreq;
    if qKnivesForOperation.FieldByName('Marks').Value > 0 then
      NoComponentsWithMarks := NoComponentsWithMarks + KnifeFreq;

    NoCuts := NoCuts + (KnifeFreq * (1 / Pieces));
    if NettArea > 0.55 then
      NoCutsWithLargeKnives := NoCutsWithLargeKnives + (KnifeFreq * (1 / Pieces));
    if VeryDiffPosn then
      NoCutsVeryDiffPosn := NoCutsVeryDiffPosn + (KnifeFreq * (1 / Pieces));

    if qKnivesForOperation.FieldByName('CutsLR').AsString = 'Y' then
      NoFetchesPerPair := NoFetchesPerPair + (KnifeFreq * 1)
    else
      NoFetchesPerPair := NoFetchesPerPair + (KnifeFreq * NoInUnit);

    if NettArea > LargestNettArea then
      LargestNettArea := NettArea;

    qKnivesForOperation.Next;
  end;

  //Following assumptions made for Included Knives from SATRASumm
  NoComponents := NoComponents + NoIncs;
  NoBands := NoBands + NoIncs;
  NoMarks := NoMarks + NoIncs;
  NoCuts := NoCuts + NoIncs;
  if NoBands > 0 then
    NoComponentsWithBands := NoComponentsWithBands + NoIncs;
  if NoMarks > 0 then
    NoComponentsWithMarks := NoComponentsWithMarks + NoIncs;

  //Allowed area in feet
  //(The figure SUMMS uses as AA has had Area Coefficient effect removed
  // - see FILLINTABLES in TIMES)
  if Sample then
    if FromTicket then
    begin
      AASampleForTickets := qInputs.FieldByName('BasicAllowance').value / NoInUnit * (100 / (QualCoeff +
                           (qInputs.FieldByName('AdjFactorResult').Value * (100 - QualCoeff) / 15)));
      AllowedArea := AASampleForTickets * SinglesPerJob
    end
    else
      AllowedArea := qInputs.FieldByName('AASample').AsFloat * SinglesPerJob
  else
    AllowedArea := qInputs.FieldByName('AACosted').AsFloat * SinglesPerJob;

  //Cuttable area in square feet
  if qInputs.FieldByName('Units').AsString = 'I' then
    CuttableArea := qInputs.FieldByName('Area').AsFloat
  else
    CuttableArea := qInputs.FieldByName('Area').AsFloat * SQDC_TO_SQFT;

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

  if (Coefficient > 95) or (qInputs.FieldByName('MaterialType').AsString = 'K') then
    LeatherGrade := 1
  else if Coefficient > 90 then
    LeatherGrade := 2
  else if Coefficient > 85 then
    LeatherGrade := 3
  else if Coefficient > 80 then
    LeatherGrade := 4
  else if Coefficient > 75 then
    LeatherGrade := 5
  else
    LeatherGrade := 6;

  Freq := AllowedArea / 250;
  if Freq > int(Freq) then
    Freq := int(Freq) + 1;
  Freq := Freq;
  Per := SinglesPerJob;
  AddCElement(Name, 'S', 'L_FETCH_LEATHER', Freq, Per, BatchSize, NoInUnit, DoAll);
  AddCElement(Name, 'S', 'L_UNTIE/COUNT', Freq, Per, BatchSize, NoInUnit, DoAll);
  Freq := 1;
  Per := SinglesPerJob;
  AddCElement(Name, 'S', 'L_FETCH/RETURN_KNIVES', Freq, Per, BatchSize, NoInUnit, DoAll);
  AddCElement(Name, 'S', 'L_FETCH_BOXES', Freq, Per, BatchSize, NoInUnit, DoAll);
  AddCElement(Name, 'S', 'L_SORTING_TICKETS_PREP', Freq, Per, BatchSize, NoInUnit, DoAll);
  Freq := Sizes;
  Per := SinglesPerJob;
  AddCElement(Name, 'S', 'L_SORTING_TICKETS', Freq, Per, BatchSize, NoInUnit, DoAll);

  Freq := 1;
  Per := SinglesPerJob;
  if qInputs.FieldByName('CuttingMethodLeather').AsString = 'P' then
    El := 'L_SETUP_PUSH_AND_PULL'
  else if qInputs.FieldByName('CuttingMethodLeather').AsString = 'S' then
    El := 'L_SETUP_SWING_BEAM'
  else if qInputs.FieldByName('CuttingMethodLeather').AsString = 'T' then
    El := 'L_SETUP_TRAVELLING_HEAD';
  AddCElement(Name, 'S', El, Freq, Per, BatchSize, NoInUnit, DoAll);

  //Replenish time
  if CuttableArea <> 0 then
    Freq := AllowedArea / CuttableArea
  else
    Freq := 0;
  Per := SinglesPerJob;
  AddCElement(Name, 'M', 'L_REPLENISH', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Roll skin time
  if CuttableArea > 6 then
    Freq := AllowedArea / CuttableArea
  else
    Freq := 0;
  Per := SinglesPerJob;

  if CuttableArea > 24 then
    El := 'L_ROLL_SKIN_LARGE'
  else if CuttableArea < 12 then
    El := 'L_ROLL_SKIN_SMALL'
  else
    El := 'L_ROLL_SKIN';
  AddCElement(Name, 'M', El, Freq, Per, BatchSize, NoInUnit, DoAll);

  //Place knife inspection time
  Freq := NoCuts;
  case LeatherGrade of
    1: El := 'L_PLACE_KNIFE_INSPECT_1';
    2: El := 'L_PLACE_KNIFE_INSPECT_2';
    3: El := 'L_PLACE_KNIFE_INSPECT_3';
    4: El := 'L_PLACE_KNIFE_INSPECT_4';
    5: El := 'L_PLACE_KNIFE_INSPECT_5';
    6: El := 'L_PLACE_KNIFE_INSPECT_6';
  end;
  AddCElement(Name, 'C', El, Freq, 1, BatchSize, NoInUnit, DoAll);

  if (qInputs.FieldByName('CuttingType').AsString = 'M') or (qInputs.FieldByName('CuttingType').AsString = 'R') then
  begin
    //Assumes the first component Cut is not a Gang Knife. If all the knivees
    //are Gang Knives then this Frequency may become negative.
    Freq := NoCuts - (1 / NoInUnit);
    if Freq < 0 then
      Freq := 0;
    AddCElement(Name, 'C', 'L_PLACE_KNIFE_SELECTION', Freq, 1, BatchSize, NoInUnit, DoAll);
  end;

  //Place knife time
  Freq := NoCuts;
  if qInputs.FieldByName('MaterialType').AsString = 'W' then
    El := 'L_PICK/PLACE_KNIFE_WOOL'
  else
    El := 'L_PICK/PLACE_KNIFE';
  AddCElement(Name, 'C', El, Freq, 1, BatchSize, NoInUnit, DoAll);

  //Position knives that are very difficult to position
  Freq := NoCutsVeryDiffPosn;
  El := 'L_DIFFICULT_KNIFE_POSITION';
  AddCElement(Name, 'C', El, Freq, 1, BatchSize, NoInUnit, DoAll);

  //Activate Press time
  Freq := NoCuts;
  if qInputs.FieldByName('CuttingMethodLeather').AsString = 'P' then
    AddCElement(Name, 'C', 'L_ACTIVATE_PRESS_PUSH_AND_PULL', Freq, 1, BatchSize, NoInUnit, DoAll)
  else if qInputs.FieldByName('CuttingMethodLeather').AsString = 'S' then
    AddCElement(Name, 'C', 'L_ACTIVATE_PRESS_SWING_BEAM', Freq, 1, BatchSize, NoInUnit, DoAll)
  else if qInputs.FieldByName('CuttingMethodLeather').AsString = 'T' then
    AddCElement(Name, 'C', 'L_ACTIVATE_PRESS_TRAVELLING_HEAD', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Double bump time
  Freq := NoCutsWithLargeKnives;
  AddCElement(Name, 'C', 'L_DOUBLE_PRESS_STRIKE', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Press time (Press head cycle) (Element paid pnce for for average Stroke Depth of 0.5 inches)
  Freq := NoCuts + NoCutsWithLargeKnives;
  AddCElement(Name, 'C', 'L_PRESS_HEAD_DOWN_UP', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Change knife time
  MaxCutsPerFetch := 1;
  if CuttableArea >= 10 then
  begin
    case LeatherGrade of
      1: MaxCutsPerFetch := 6;
      2: MaxCutsPerFetch := 5;
      3: MaxCutsPerFetch := 4;
      4: MaxCutsPerFetch := 3;
      5: MaxCutsPerFetch := 2;
    end;
  end
  else if CuttableArea >= 9 then
  begin
    case LeatherGrade of
      1: MaxCutsPerFetch := 5;
      2: MaxCutsPerFetch := 4;
      3: MaxCutsPerFetch := 3;
      4: MaxCutsPerFetch := 2;
    end;
  end
  else if CuttableArea >= 8 then
  begin
    case LeatherGrade of
      1: MaxCutsPerFetch := 4;
      2: MaxCutsPerFetch := 3;
      3: MaxCutsPerFetch := 2;
    end;
  end
  else
  begin
    case LeatherGrade of
      1: MaxCutsPerFetch := 3;
      2: MaxCutsPerFetch := 2;
    end;
  end;

  if LargestNettArea < 0.27 then
    MaxCutsPerFetch := MaxCutsPerFetch * 2
  else if LargestNettArea > 0.55 then
  begin
    case MaxCutsPerFetch of
      6: MaxCutsPerFetch := 3;
      5: MaxCutsPerFetch := 2;
      4: MaxCutsPerFetch := 2;
      3: MaxCutsPerFetch := 1;
      2: MaxCutsPerFetch := 1;
      1: MaxCutsPerFetch := 1;
    end;
  end;

  MinimumNoFetches := NoFetchesPerPair * Sizes;
  CutsPerJob := SinglesPerJob * NoCuts;
  if MinimumNoFetches <> 0 then
    CutsPerFetch := CutsPerJob / MinimumNoFetches
  else
    CutsPerFetch := 999999;

  if CutsPerFetch > MaxCutsPerFetch then
    CutsPerFetch := MaxCutsPerFetch;

  if MinimumNoFetches = 1 then
  begin
    //1 Knife, 1 Size
    Freq := 1;
    Per := SinglesPerJob;
  end
  else
  begin
    Freq := NoCuts / CutsPerFetch;
    Per := 1;
  end;
  AddCElement(Name, 'C', 'L_CHANGE_KNIFE', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Clear knife time
  if NoClears <> 0 then
    Freq := NoCuts * (NoComponents / NoClears)
  else
    Freq := 0;
  AddCElement(Name, 'C', 'L_CLEAR_KNIFE', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Tool cut time
  Freq := NoTools;
  AddCElement(Name, 'C', 'L_THIN_KNIFE_EXTRACT', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Punch cut time
  Freq := NoPeels;
  AddCElement(Name, 'C', 'L_PUNCH_KNIFE_EXTRACT', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Inspect time
  Freq := NoCuts;
  AddCElement(Name, 'C', 'L_INSPECT_CUT_PIECE', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Move skin time
  Freq := (AllowedArea / 2);
  Per := SinglesPerJob;
  AddCElement(Name, 'M', 'L_MOVE_SKIN', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Straighten time
  Freq := (NoComponents * Sizes);
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'L_STRAIGHTEN_COMPONENTS', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Count time
  Freq := NoComponents;
  AddCElement(Name, 'P', 'L_COUNT_COMPONENTS', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Band time
  if NoBands > 0 then
    Freq := 1
  else
    Freq := 0;
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'L_PLACE_TICKET', Freq, Per, BatchSize, NoInUnit, DoAll);

  if qInputs.FieldByName('MaterialType').AsString = 'W' then
    El := 'L_BAND_WOOL'
  else
    El := 'L_BAND';
  Freq := (NoComponentsWithBands * Sizes);
  Per := SinglesPerJob;
  AddCElement(Name, 'P', El, Freq, Per, BatchSize, NoInUnit, DoAll);

  //Mark time
  if NoMarks > 0 then
    Freq := 1
  else
    Freq := 0;
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'L_MARK_GET_CRAYON', Freq, Per, BatchSize, NoInUnit, DoAll);
  Freq := (NoComponentsWithMarks * Sizes);
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'L_MARK_MOVE_CRAYON', Freq, Per, BatchSize, NoInUnit, DoAll);
  Freq := (NoMarks * Sizes);
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'L_MARK_STROKE_CRAYON', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Aside time
  Freq := ((NoComponents * Sizes) / 3);
  if Freq > int(Freq) then
    Freq := int(Freq) + 1;
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'L_ASIDE_TO_BOX', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Return excess leather time
  Freq := 1;
  Per := SinglesPerJob;
  AddCElement(Name, 'S', 'L_RETURN_LEATHER', Freq, Per, BatchSize, NoInUnit, DoAll);
end;

procedure TdmCutUtils_Summs8.Answers2SynElements(Name: String; Sample: Boolean; ActualBatchSize: integer;
                                          qInputs, qKnivesForOperation: TFDQuery; DoAll,
                                          FromTicket: Boolean; NumSizes: integer);

var
   AdjustedAllowance, Pieces, AllowedArea, NettArea, MaterialWidth,
   MaterialLength, MaterialArea, StrokeDepth, TotalRollLength,
   CuttableArea, NoComponents, NoPeels, NoTools, NoBands, NoMarks,
   NoClears, SwatheFreq, SwatheArea, Freq, Per: Real;
   El: String;
   KnifeFreqAndIncludedKnives: integer;
   KnifeFreq: integer;
   NoIncludedKnives: integer;
   NoIncs: integer;
   BatchSize: integer;
   SinglesPerJob, Layers: integer;
   AASampleForTickets: real;
   Sizes: integer;
   FullSynthetic: boolean;
   NoInUnit: SmallInt;
   MaxCutsPerFetch: integer;
   NoCuts, NoCutsWithLargeKnives, NoCutsVeryDiffPosn: real;
   NoComponentsWithBands, NoComponentsWithMarks, NoFetchesPerPair: real;
   MinimumNoFetches, CutsPerJob, CutsPerFetch: real;
   LargestNettArea: real;
   NoLayeredSheets: real;
   MaxTableLength: Real;
   VeryDiffPosn: Boolean;

begin
  Seq := 0;

  NoComponents := 0;
  NoCuts := 0;            NoFetchesPerPair := 0;
  NoPeels := 0;           NoTools := 0;
  NoBands := 0;           NoMarks := 0;
  NoClears := 0;          NoIncs := 0;
  NoCutsWithLargeKnives := 0;
  NoCutsVeryDiffPosn := 0;
  NoComponentsWithBands := 0;
  NoComponentsWithMarks := 0;
  Layers := qInputs.FieldByName('Layers').value;
  LargestNettArea := 0;
  BatchSize := ActualBatchSize;

  if qInputs.FieldByName('MadeInPairs').AsBoolean then
    NoInUnit := 2
  else
    NoInUnit := 1;
  SinglesPerJob := qInputs.FieldByName('UnitsPerJob').value * NoInUnit;

  if qInputs.FindField('SLMAllowance') = nil then
    FullSynthetic := False
  else
    FullSynthetic := not(qInputs.FieldByName('SLMAllowance').Value);

  if FromTicket then
    Sizes := NumSizes
  else
    Sizes := qInputs.FieldByName('Sizes').Value;

  qKnivesForOperation.first;
  while not qKnivesForOperation.Eof do
  begin
    KnifeFreqAndIncludedKnives := qKnivesForOperation.FieldByName('Freq').value;
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

    NoComponents := NoComponents + KnifeFreq;
    NoIncs := NoIncs + NoIncludedKnives;

    Pieces := qKnivesForOperation.FieldByName('Pieces').AsFloat;
    NettArea := qKnivesForOperation.FieldByName('NettArea').AsFloat;
    VeryDiffPosn := qKnivesForOperation.FieldByName('VeryDiffPosn').Value;

    Pieces := qKnivesForOperation.FieldByName('Pieces').AsFloat;
    NoPeels := NoPeels + (KnifeFreq * qKnivesForOperation.FieldByName('Peels').AsFloat);
    NoClears := NoClears + (KnifeFreq * qKnivesForOperation.FieldByName('Clears').AsFloat);
    if qKnivesForOperation.FieldByName('Thin').AsString = 'Y' then
      NoTools := NoTools + KnifeFreq;
    NoBands := NoBands + (KnifeFreq * qKnivesForOperation.FieldByName('Bands').AsFloat);
    NoMarks := NoMarks + (KnifeFreq * qKnivesForOperation.FieldByName('Marks').AsFloat);

    if qKnivesForOperation.FieldByName('Bands').Value > 0 then
      NoComponentsWithBands := NoComponentsWithBands + KnifeFreq;
    if qKnivesForOperation.FieldByName('Marks').Value > 0 then
      NoComponentsWithMarks := NoComponentsWithMarks + KnifeFreq;

    NoCuts := NoCuts + (KnifeFreq * (1 / Pieces));
    if NettArea > 0.55 then
      NoCutsWithLargeKnives := NoCutsWithLargeKnives + (KnifeFreq * (1 / Pieces));
    if VeryDiffPosn then
      NoCutsVeryDiffPosn := NoCutsVeryDiffPosn + (KnifeFreq * (1 / Pieces));

    if qKnivesForOperation.FieldByName('CutsLR').AsString = 'Y' then
      NoFetchesPerPair := NoFetchesPerPair + (KnifeFreq * 1)
    else
      NoFetchesPerPair := NoFetchesPerPair + (KnifeFreq * NoInUnit);

    if NettArea > LargestNettArea then
      LargestNettArea := NettArea;

    qKnivesForOperation.Next;
  end;

  //Following assumptions made for Included Knives from SATRASumm
  NoComponents := NoComponents + NoIncs;
  NoBands := NoBands + NoIncs;
  NoMarks := NoMarks + NoIncs;
  NoCuts := NoCuts + NoIncs;
  if NoBands > 0 then
    NoComponentsWithBands := NoComponentsWithBands + NoIncs;
  if NoMarks > 0 then
    NoComponentsWithMarks := NoComponentsWithMarks + NoIncs;

  //Allowed area in feet
  if Sample then
    if FromTicket then
    begin
      AASampleForTickets := qInputs.FieldByName('BasicAllowance').value / NoInUnit;
      AllowedArea := AASampleForTickets * SinglesPerJob
    end
    else if FullSynthetic then
      AllowedArea := qInputs.FieldByName('AASampleSynth').AsFloat * SinglesPerJob
    else
      AllowedArea := qInputs.FieldByName('AASample').AsFloat * SinglesPerJob
  else if FullSynthetic then
      AllowedArea := qInputs.FieldByName('AACostedSynth').AsFloat * SinglesPerJob
    else
      AllowedArea := qInputs.FieldByName('AACosted').AsFloat * SinglesPerJob;

  //Material Width & Length in feet, Knife depth in inches
  if qInputs.FieldByName('Units').AsString = 'I' then
  begin
    MaterialLength := qInputs.FieldByName('LengthInches').AsFloat * INCHES_TO_FEET;
    MaterialWidth := qInputs.FieldByName('WidthInches').AsFloat * INCHES_TO_FEET;
    StrokeDepth := qInputs.FieldByName('Depth').AsFloat;
  end
  else
  begin
    MaterialLength := qInputs.FieldByName('Length').AsFloat *
                      CMS_TO_INCHES * INCHES_TO_FEET;
    MaterialWidth := qInputs.FieldByName('Width').AsFloat *
                      CMS_TO_INCHES * INCHES_TO_FEET;
    StrokeDepth := qInputs.FieldByName('Depth').AsFloat * CMS_TO_INCHES;
  end;

  //Max table length in feet
  MaxTableLength := qInputs.FieldByName('MaxTablelength').AsFloat *
                    METRES_TO_CMS * CMS_TO_INCHES * INCHES_TO_FEET;

  //Total Roll length REQUIRED in feet
  if MaterialWidth <> 0 then
    TotalRollLength := AllowedArea / MaterialWidth
  else
    TotalRollLength := 0;

  //Area in feet
  if qInputs.FieldByName('MaterialType').AsString = 'R' then
  begin
    MaterialArea := TotalRollLength * MaterialWidth;
    MaterialLength := TotalRollLength;

    if (TotalRollLength / qInputs.FieldByName('Layers').AsFloat) > MaxTableLength then
      MaterialLength := MaxTableLength;
  end
  else if qInputs.FieldByName('MaterialType').AsString = 'S' then
  begin
    MaterialArea := AllowedArea;

    //SheetCutFromRoll
    if qInputs.FieldByName('SheetCutFromRoll').AsBoolean then
    begin
      if (TotalRollLength / qInputs.FieldByName('Layers').AsFloat) <= MaterialLength then
        MaterialLength := TotalRollLength;
    end;
  end;

  //Cuttable area in square feet
  CuttableArea := MaterialLength * MaterialWidth;

  //No of Layered Sheets
  if (Layers * CuttableArea) <> 0 then
    NoLayeredSheets := (MaterialArea / (Layers * CuttableArea))
  else
    NoLayeredSheets := 0;

  if (qInputs.FieldByName('MaterialType').AsString = 'R') and
     (qInputs.FieldByName('FeedSystem').AsString = 'C') then
  begin
    Freq := NoLayeredSheets * Layers;
    Per := SinglesPerJob;
    AddCElement(Name, 'S', 'S_LAYUP_FROM_ROLL', Freq, Per, BatchSize, NoInUnit, DoAll);
  end;

  if (qInputs.FieldByName('MaterialType').AsString = 'S') then
  begin
    Freq := NoLayeredSheets * Layers;
    Per := SinglesPerJob;
    //SheetCutFromRoll
    if qInputs.FieldByName('SheetCutFromRoll').AsBoolean then
      AddCElement(Name, 'S', 'S_LAYUP_FROM_ROLL', Freq, Per, BatchSize, NoInUnit, DoAll)
    else
      AddCElement(Name, 'S', 'S_LAYUP_FROM_SHEETS', Freq, Per, BatchSize, NoInUnit, DoAll);
  end;

  if ((qInputs.FieldByName('MaterialType').AsString = 'R') and
     (qInputs.FieldByName('FeedSystem').AsString = 'C')) or
     (qInputs.FieldByName('MaterialType').AsString = 'S') then
  begin
    Freq := NoLayeredSheets;
    Per := SinglesPerJob;
    if Layers > 1 then
      AddCElement(Name, 'S', 'S_STAPLE_LAYERS', Freq, Per, BatchSize, NoInUnit, DoAll);
    AddCElement(Name, 'S', 'S_LOAD_SHEETS', Freq, Per, BatchSize, NoInUnit, DoAll);
    AddCElement(Name, 'S', 'S_REMOVE_SHEETS', Freq, Per, BatchSize, NoInUnit, DoAll);
  end;

  if (qInputs.FieldByName('MaterialType').AsString = 'R') and
     (qInputs.FieldByName('FeedSystem').AsString = 'G') then
  begin
    Freq := Layers;
    Per := SinglesPerJob;
    AddCElement(Name, 'S', 'S_INSTALL_ROLL_ONTO_GANTRY', Freq, Per, BatchSize, NoInUnit, DoAll);
    AddCElement(Name, 'S', 'S_INSTALL_LOAD_ROLL_GANTRY', Freq, Per, BatchSize, NoInUnit, DoAll);
    AddCElement(Name, 'S', 'S_INSTALL_REMOVE_ROLL_GANTRY', Freq, Per, BatchSize, NoInUnit, DoAll);
  end;

  Freq := 1;
  Per := SinglesPerJob;
  AddCElement(Name, 'S', 'S_FETCH/RETURN_KNIVES', Freq, Per, BatchSize, NoInUnit, DoAll);
  AddCElement(Name, 'S', 'S_FETCH_BOXES', Freq, Per, BatchSize, NoInUnit, DoAll);
  AddCElement(Name, 'S', 'S_SORTING_TICKETS_PREP', Freq, Per, BatchSize, NoInUnit, DoAll);
  Freq := Sizes;
  Per := SinglesPerJob;
  AddCElement(Name, 'S', 'S_SORTING_TICKETS', Freq, Per, BatchSize, NoInUnit, DoAll);

  Freq := 1;
  Per := SinglesPerJob;
  if qInputs.FieldByName('CuttingMethodSynthetic').AsString = 'P' then
    El := 'S_SETUP_PUSH_AND_PULL'
  else if qInputs.FieldByName('CuttingMethodSynthetic').AsString = 'T' then
    El := 'S_SETUP_TRAVELLING_HEAD';
  AddCElement(Name, 'S', El, Freq, Per, BatchSize, NoInUnit, DoAll);

  if Sample then
  begin
    if FromTicket then
      AdjustedAllowance := AASampleForTickets
    else if FullSynthetic then
      AdjustedAllowance := qInputs.FieldByName('AASampleSynth').AsFloat
    else
      AdjustedAllowance := qInputs.FieldByName('AASample').AsFloat;
  end
  else if FullSynthetic then
      AdjustedAllowance := qInputs.FieldByName('AACostedSynth').AsFloat
  else
    AdjustedAllowance := qInputs.FieldByName('AACosted').AsFloat;

  //SwatheArea assumes cutting block 500mm, 1.64 feet deep
  SwatheArea := MaterialWidth * 1.64;
  if (SwatheArea <> 0) and (AdjustedAllowance <> 0) then
  begin
    SwatheFreq := SinglesPerJob / ((SwatheArea * Layers) / AdjustedAllowance);
    if SwatheFreq > int(SwatheFreq) then
      SwatheFreq := int(SwatheFreq) + 1;
  end
  else
    SwatheFreq := 0;

  //Waste and Feed through time
  Freq := SwatheFreq;
  Per := SinglesPerJob;
  if qInputs.FieldByName('CuttingMethodSynthetic').AsString = 'P' then
    AddCElement(Name, 'M', 'S_CHOP_WASTE_AND_ASIDE_PUSH_AND_PULL', Freq, Per, BatchSize, NoInUnit, DoAll)
  else if qInputs.FieldByName('CuttingMethodSynthetic').AsString = 'T' then
    AddCElement(Name, 'M', 'S_CHOP_WASTE_AND_ASIDE_TRAVELLING_HEAD', Freq, Per, BatchSize, NoInUnit, DoAll);
  AddCElement(Name, 'M', 'S_FEED_THROUGH_MATERIAL', Freq, Per, BatchSize, NoInUnit, DoAll);

  if (qInputs.FieldByName('MaterialType').AsString = 'R') and
     (qInputs.FieldByName('FeedSystem').AsString = 'G') then
  begin
    Freq := SwatheFreq / 5;
    if Freq > int(Freq) then
      Freq := int(Freq) + 1;
    Per := SinglesPerJob;
    AddCElement(Name, 'M', 'S_STAPLE_LAYERS_GANTRY', Freq, Per, BatchSize, NoInUnit, DoAll);
  end;

  //Place knife time
  Freq := NoCuts / Layers;
  AddCElement(Name, 'C', 'S_PICK/PLACE_KNIFE', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Position knives that are very difficult to position
  Freq := NoCutsVeryDiffPosn / Layers;
  El := 'S_DIFFICULT_KNIFE_POSITION';
  AddCElement(Name, 'C', El, Freq, 1, BatchSize, NoInUnit, DoAll);

  //Activate Press time
  Freq := NoCuts / Layers;
  if qInputs.FieldByName('CuttingMethodSynthetic').AsString = 'P' then
    AddCElement(Name, 'C', 'S_ACTIVATE_PRESS_PUSH_AND_PULL', Freq, 1, BatchSize, NoInUnit, DoAll)
  else if qInputs.FieldByName('CuttingMethodSynthetic').AsString = 'S' then
    AddCElement(Name, 'C', 'S_ACTIVATE_PRESS_SWING_BEAM', Freq, 1, BatchSize, NoInUnit, DoAll)
  else if qInputs.FieldByName('CuttingMethodSynthetic').AsString = 'T' then
    AddCElement(Name, 'C', 'S_ACTIVATE_PRESS_TRAVELLING_HEAD', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Double bump time
  Freq := NoCutsWithLargeKnives / Layers;
  AddCElement(Name, 'C', 'S_DOUBLE_PRESS_STRIKE', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Press time (Press head cycle) (Element paid per 0.5 inches)
  Freq := ((NoCuts + NoCutsWithLargeKnives) / Layers) * (StrokeDepth / 0.5);
  AddCElement(Name, 'C', 'S_PRESS_HEAD_DOWN_UP', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Change knife time
  if MaterialWidth >= (130 * CMS_TO_INCHES * INCHES_TO_FEET) then
    MaxCutsPerFetch := 6
  else if MaterialWidth >= (100 * CMS_TO_INCHES * INCHES_TO_FEET) then
    MaxCutsPerFetch := 5
  else
    MaxCutsPerFetch := 4;

  if LargestNettArea < 0.27 then
    MaxCutsPerFetch := MaxCutsPerFetch * 2
  else if LargestNettArea > 0.55 then
  begin
    case MaxCutsPerFetch of
      6: MaxCutsPerFetch := 3;
      5: MaxCutsPerFetch := 2;
      4: MaxCutsPerFetch := 2;
    end;
  end;

  MinimumNoFetches := NoFetchesPerPair * Sizes;
  CutsPerJob := SinglesPerJob * NoCuts;
  if MinimumNoFetches <> 0 then
    CutsPerFetch := CutsPerJob / MinimumNoFetches
  else
    CutsPerFetch := 999999;

  if CutsPerFetch > MaxCutsPerFetch then
    CutsPerFetch := MaxCutsPerFetch;

  if MinimumNoFetches = 1 then
  begin
    //1 Knife, 1 Size
    Freq := 1;
    Per := SinglesPerJob;
  end
  else
  begin
    Freq := (NoCuts / Layers) / CutsPerFetch;
    Per := 1;
  end;
  AddCElement(Name, 'C', 'S_CHANGE_KNIFE', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Clear knife time
  if NoClears <> 0 then
    Freq := (NoCuts / Layers) * (NoComponents / NoClears)
  else
    Freq := 0;
  AddCElement(Name, 'C', 'S_CLEAR_KNIFE', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Tool cut time
  Freq := NoTools / Layers;
  AddCElement(Name, 'C', 'S_THIN_KNIFE_EXTRACT', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Punch cut time
  Freq := NoPeels / Layers;
  AddCElement(Name, 'C', 'S_PUNCH_KNIFE_EXTRACT', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Straighten time
  Freq := (NoComponents * Sizes);
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'S_STRAIGHTEN_COMPONENTS', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Count time
  Freq := NoComponents;
  AddCElement(Name, 'P', 'S_COUNT_COMPONENTS', Freq, 1, BatchSize, NoInUnit, DoAll);

  //Band time
  if NoBands > 0 then
    Freq := 1
  else
    Freq := 0;
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'S_PLACE_TICKET', Freq, Per, BatchSize, NoInUnit, DoAll);

  Freq := (NoComponentsWithBands * Sizes);
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'S_BAND', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Mark time
  if NoMarks > 0 then
    Freq := 1
  else
    Freq := 0;
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'S_MARK_GET_CRAYON', Freq, Per, BatchSize, NoInUnit, DoAll);
  Freq := (NoComponentsWithMarks * Sizes);
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'S_MARK_MOVE_CRAYON', Freq, Per, BatchSize, NoInUnit, DoAll);
  Freq := (NoMarks * Sizes);
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'S_MARK_STROKE_CRAYON', Freq, Per, BatchSize, NoInUnit, DoAll);

  //Aside time
  Freq := ((NoComponents * Sizes) / 3);
  if Freq > int(Freq) then
    Freq := int(Freq) + 1;
  Per := SinglesPerJob;
  AddCElement(Name, 'P', 'S_ASIDE_TO_BOX', Freq, Per, BatchSize, NoInUnit, DoAll);
end;

procedure TdmCutUtils_Summs8.Operation_ElementsAndTotals(Name: String; Sample: Boolean;
                                              qInputs, qOutputs, qKnivesForOperation: TFDQuery);
var
  MaterialType: string;
  SQLString: string;
  sItem: string;

begin
  MessageShown := false;

  if (dmCutUtils_Summs8.Owner.name = 'fmMain') then
  begin
    dmCutUtils2_Summs8.qRemoveCuttingElements.paramByName('OpName').AsString := Name;
    dmCutUtils2_Summs8.qRemoveCuttingElements.execSQL;
    Cutting := '';
  end
  else if dmCutUtils_Summs8.Owner.Name = 'fmSumms' then
  begin
    if qInputs.FieldByName('MadeInPairs').AsBoolean then
      sItem := ''' Half Pair(s)'''
    else
      sItem := '''Single(s)''';

    //Start Strings
    SQ1 := 'SELECT CASE Reason';
    SQ2 := ' CASE Reason';
    SQ3 := ' Element,' +
           ' Description,' +
           ' Time as Minutes,';
    SQ4 := ' CASE Reason';
    SQ5 := ' CASE Reason';
    SQ6 := ' CASE Reason';
    SQ7 := ' CASE Reason';
    SQ7S := SQ7;
    SQ7M := SQ7;
    SQ7C := SQ7;
    SQ7P := SQ7;
    SQ8 := ' FROM CuttingElements CE, Elements E, ElementTimes ET ' +
           'WHERE ((E.Code = CE.Element) AND (ET.Code = CE.Element)) AND ((Reason = '''') ';
  end;

  MaterialType := qInputs.FieldByName('MaterialType').AsString;
  if ((MaterialType = 'L') or (MaterialType = 'W') or (MaterialType = 'K')) then
    Answers2LeaElements(Name, Sample, qInputs.FieldByName('StdBatchSize').value, qInputs, qKnivesForOperation, qInputs.FieldByName('QualCoeff').value, TRUE, False, 0)
  else if ((MaterialType = 'R') or (MaterialType = 'S')) then
    Answers2SynElements(Name, Sample, qInputs.FieldByName('StdBatchSize').value, qInputs, qKnivesForOperation, TRUE, False, 0);

  if (dmCutUtils_Summs8.Owner.name = 'fmMain') then
  begin
    dmCutUtils2_Summs8.qAddCuttingElement.SQL.Text := Cutting;
    dmCutUtils2_Summs8.qAddCuttingElement.ExecSQL;
  end
  else if dmCutUtils_Summs8.Owner.Name = 'fmSumms' then
  begin
    //End Strings
    SQ1 := SQ1 + ' END as Seq, ';
    SQ2 := SQ2 + ' END as Category, ';
    SQ4 := SQ4 + ' END as Freq, ';
    SQ5 := SQ5 + ' END as Per, ' + sItem + ' as PerWhat, ';
    SQ6 := SQ6 + ' END as BatchFreq, ';

    SQ7T := SQ7 +  ' END ';
    SQ7S := SQ7S + ' END ';
    SQ7M := SQ7M + ' END ';
    SQ7C := SQ7C + ' END ';
    SQ7P := SQ7P + ' END ';

    SQ7 := SQ7 + ' END as Time ';
    SQ8 := SQ8 + ')';

    //Totals
    //CJY Note wrapping the SUM'D SELECT statements for < 10 UNION compatibility
    SQT := 'SELECT * FROM (' +
           'SELECT 0 as Seq, ''S'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Minutes, 0.0 as Freq, 0.0 as Per, ' +
           '''_'' as PerWhat, 0.0 as BatchFreq, SUM(' +
           SQ7S +
           ') as Time ' +
           SQ8 +
           #13 + ' UNION ' + #13 +

           'SELECT 0 as Seq, ''M'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Minutes, 0.0 as Freq, 0.0 as Per, ' +
           '''_'' as PerWhat, 0.0 as BatchFreq, SUM(' +
           SQ7M +
           ') as Time ' +
           SQ8 +
           #13 + ' UNION ' + #13 +

           'SELECT 0 as Seq, ''C'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Minutes, 0.0 as Freq, 0.0 as Per, ' +
           '''_'' as PerWhat, 0.0 as BatchFreq, SUM(' +
           SQ7C +
           ') as Time ' +
           SQ8 +
           #13 + ' UNION ' + #13 +

           'SELECT 0 as Seq, ''P'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Minutes, 0.0 as Freq, 0.0 as Per, ' +
           '''_'' as PerWhat, 0.0 as BatchFreq, SUM(' +
           SQ7P +
           ') as Time ' +
           SQ8 +
           #13 + ' UNION ' + #13 +

           'SELECT 0 as Seq, ''T'' as Category, ''_'' as Element, ' +
           '''_'' as Description, 0.0 as Minutes, 0.0 as Freq, 0.0 as Per, ' +
           '''_'' as PerWhat, 0.0 as BatchFreq, SUM(' +
           SQ7T +
           ') as Time ' +
           SQ8 + ') A ' +
           #13 + ' UNION ' + #13 +

           SQ1 + SQ2 + SQ3 + SQ4 + SQ5 + SQ6 + SQ7 + SQ8;

    qOutputs.SQL.Text := SQT;
    qOutputs.open;
  end;

  if (dmCutUtils_Summs8.Owner.name = 'fmMain') then
  begin
    //Additional Cutting Elements
    dmCutUtils2_Summs8.qAdditionalCuttingElements.paramByName('OpName').AsString := Name;
    dmCutUtils2_Summs8.qAdditionalCuttingElements.execSQL;

    //ReIndex
    //This should have been 'normal' query but trying to pass General to
    //2nd part of the query gives arise to eroneous 7201 errors.

    SQLString := 'UPDATE Elements4Operations ' +
                 'SET Seq = (' +
                 '           SELECT ((COUNT(E4O.Seq) * 10000) + Elements4Operations.Seq) ' +
                 '           FROM Elements4Operations E4O ' +
                 '           WHERE (E4O.Operation = ''' + QS(Name) + ''') AND ' +
                 '                 ((E4O.Seq - (TRUNCATE(E4O.Seq / 10000, 0) * 10000)) <= Elements4Operations.Seq) AND ' +
                 '                 (Elements4Operations.Operation = E4O.Operation) ' +
                 '           ) ' +
                 'WHERE Operation = ''' + QS(Name) + ''';' + #13 +
                 'UPDATE Elements4Operations ' +
                 'SET Seq = TRUNCATE(Seq / 10000, 0) ' +
                 'WHERE Operation = ''' + QS(Name) + ''';';
    dmCutUtils2_Summs8.qReIndexCuttingElements.SQL.Text := SQLString;

    dmCutUtils2_Summs8.qReIndexCuttingElements.ExecSQL;
  end;
end;

procedure TdmCutUtils_Summs8.Operations_Total_asSms(Name: String;
                                         Sample: Boolean;
                                         ActualBatchSize: integer;
                                         qInputs, qOutputs, qKnivesForOperation: TFDQuery;
                                         MinQual, MaxQual, Rest, Cont: integer;
                                         FromTicket: Boolean;
                                         NumSizes: integer);
var
  MaterialType: string;
  QualCoeff: integer;
  s, SQLString: string;
  sRest, sCont: string;

begin
  MessageShown := false;

  str((100 + Rest) / 100, sRest);
  str((100 + Cont) / 100, sCont);

  SQLString := '';
  for QualCoeff := MinQual to MaxQual do
  begin
    str(QualCoeff, s);

    //Start Strings
    SQ7 := #13 + ' CASE Reason';
    SQ8 :=       ' FROM CuttingElements CE, Elements E, ElementTimes ET ' +
                 'WHERE ((E.Code = CE.Element) AND (ET.Code = CE.Element)) AND ((Reason = '''') ';

    MaterialType := qInputs.FieldByName('MaterialType').AsString;
    if ((MaterialType = 'L') or (MaterialType = 'W') or (MaterialType = 'K')) then
      Answers2LeaElements(Name, Sample, ActualBatchSize, qInputs, qKnivesForOperation, QualCoeff, FALSE, FromTicket, Numsizes)
    else if ((MaterialType = 'R') or (MaterialType = 'S')) then
      Answers2SynElements(Name, Sample, ActualBatchSize, qInputs, qKnivesForOperation, FALSE, FromTicket, NumSizes);

    //End Strings
    SQ7T := SQ7 + ' END ';
    SQ8 := SQ8 + ')';

    //Totals
    SQT := 'SELECT ' + s + ' as Coeff, SUM(' +
           SQ7T +
           ') * ' + sRest + ' * ' + sCont + ' as Time ' + SQ8;

    SQLString := SQLString + SQT + #13;

    if QualCoeff < MaxQual then
      SQLString := SQLString + ' UNION ' + #13;
  end;

  qOutputs.SQL.Text := SQLString;
end;

end.

