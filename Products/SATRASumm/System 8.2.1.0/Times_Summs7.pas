unit Times_Summs7;

interface

uses
  Classes, Controls, Forms, Db, FireDAC.Comp.Client, CmnTypes, General;

type
  TdmTimes_Summs7 = class(TDataModule)
    procedure CalculateTime(Sample: Boolean; qInputs, qOutputs: TFDQuery;
                            var AdjInterlocks: Realarray);
    procedure CalculateAllTimes(Sample: Boolean; ActualBatchSize: integer;
                                qInputs, qOutputs: TFDQuery;
                                NoOrigTickets: integer;
                                var AdjInterlocks: RealArray;
                                var AdjInterlocksPlus: TTicketInts; JustOne: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmTimes_Summs7: TdmTimes_Summs7;

implementation

uses
  Summs, Times2_Summs7, CutUtils_Summs7;

{$R *.DFM}

procedure TdmTimes_Summs7.CalculateTime(Sample: Boolean; qInputs, qOutputs: TFDQuery;
                                 var AdjInterlocks: RealArray);
var
  Code: string;
  WidthNo: integer;

begin
  //Wait until previous use complete.
  while dmTimes2_Summs7.InUse do
    application.processmessages;

  try
    dmTimes2_Summs7.InUse := true;

    Code := qInputs.FieldByName('Code').value;
    WidthNo := qInputs.FieldByName('No').value;

    dmTimes2_Summs7.AdjInterlocks := AdjInterlocks;
    dmTimes2_Summs7.qKnivesForValue.paramByName('Code').value := Code;
    dmTimes2_Summs7.qKnivesForValue.paramByName('WidthNo').value := WidthNo;
    dmTimes2_Summs7.qKnivesForValue.open;
    dmCutUtils_Summs7.Value_ElementsAndTotals('FROM_SUMMS', Sample, qInputs, qOutputs, dmTimes2_Summs7.qKnivesForValue, LegacyCuttingTimesBase);
    dmTimes2_Summs7.qKnivesForValue.close;
  finally
    dmTimes2_Summs7.InUse := false;
  end;
end;

procedure TdmTimes_Summs7.CalculateAllTimes(Sample: Boolean; ActualBatchSize: integer;
                                     qInputs, qOutputs: TFDQuery;
                                     NoOrigTickets: integer;
                                     var AdjInterlocks: RealArray;
                                     var AdjInterlocksPlus: TTicketInts; JustOne: Boolean);
var
  Code: string;
  i, WidthNo: integer;
  MaterialType, CuttingMethod: string;
  FromTicket, Leather, LeatherHand: boolean;
  MinQual, MaxQual, Rest, Cont: integer;
  NumSizes: real;

begin
  //Although this routine is called AllTimes, JustOne allows for one time
  //to be selected when only the time is required and not the elements.

  NumSizes := 0;

  if NoOrigTickets = 0 then
    FromTicket := False
  else
    FromTicket := True;

  //Wait until previous use complete.
  while dmTimes2_Summs7.InUse do
    application.processmessages;

  try
    dmTimes2_Summs7.InUse := true;

    Code := qInputs.FieldByName('Code').value;
    WidthNo := qInputs.FieldByName('No').value;
    MaterialType := qInputs.FieldByName('MaterialType').value;
    CuttingMethod := qInputs.FieldByName('CuttingMethodLeather').value;
    Leather := (MaterialType = 'L') or (MaterialType = 'W') or (MaterialType = 'K');
    LeatherHand := Leather and (CuttingMethod = 'H');

    if not Leather then
    begin
      MaxQual := 100;
      MinQual := 100;
    end
    else if JustOne then
    begin
      MaxQual := qInputs.FieldByName('QualCoeff').value;
      MinQual := MaxQual;
    end
    else
    begin
      MaxQual := qInputs.FieldByName('QualCoeff').value + (LinesInLeatherGrid div 2);
      MinQual := MaxQual - LinesInLeatherGrid + 1;

      if MaxQual > 100 then
      begin
        MinQual := MinQual - (MaxQual - 100);
        MaxQual := 100;
      end;
    end;

    Rest := qInputs.FieldByName('Rest').value;
    Cont := qInputs.FieldByName('Contingency').value;

    if not LeatherHand then
    begin
      if FromTicket then
      begin
        i := 1;
        while (not((AdjInterlocksPlus[i].Part = Code) and (AdjInterlocksPlus[i].WidthNo = WidthNo))) and (i < NoOrigTickets) do
          inc(i);

        dmTimes2_Summs7.AdjInterlocks := AdjInterlocksPlus[i].AdjInterlocks;
        NumSizes := AdjInterlocksPlus[1].Sizes;
      end
      else
        dmTimes2_Summs7.AdjInterlocks := AdjInterlocks;

      dmTimes2_Summs7.qKnivesForValue.paramByName('Code').value := Code;
      dmTimes2_Summs7.qKnivesForValue.paramByName('WidthNo').value := WidthNo;
      dmTimes2_Summs7.qKnivesForValue.open;
      dmCutUtils_Summs7.Values_Total_asSms('FROM_SUMMS', Sample, ActualBatchSize, qInputs, qOutputs, dmTimes2_Summs7.qKnivesForValue,
                                    LegacyCuttingTimesBase, MinQual, MaxQual, Rest, Cont, FromTicket, NumSizes);
      dmTimes2_Summs7.qKnivesForValue.close;
    end
    else
    begin
      dmTimes2_Summs7.qPatternsForValue.paramByName('Code').value := Code;
      dmTimes2_Summs7.qPatternsForValue.paramByName('WidthNo').value := WidthNo;
      dmTimes2_Summs7.qPatternsForValue.open;
      dmCutUtils_Summs7.Values_Total_asSms('FROM_SUMMS', Sample, ActualBatchSize, qInputs, qOutputs, dmTimes2_Summs7.qPatternsForValue,
                                    LegacyCuttingTimesBase, MinQual, MaxQual, Rest, Cont, FromTicket, NumSizes);
      dmTimes2_Summs7.qPatternsForValue.close;
    end;
  finally
    dmTimes2_Summs7.InUse := false;
  end;
end;

end.
