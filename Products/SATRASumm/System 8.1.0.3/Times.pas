unit Times;

interface

uses
  Classes, Controls, Forms, Db,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, CmnTypes, General;

type
  TdmTimes = class(TDataModule)
    procedure CalculateTime(Sample: Boolean; qInputs, qOutputs: TFDQueryPlus;
                            var AdjInterlocks: Realarray);
    procedure CalculateAllTimes(Sample: Boolean; ActualBatchSize: integer;
                                qInputs, qOutputs: TFDQueryPlus;
                                NoOrigTickets: integer;
                                var AdjInterlocks: RealArray;
                                var AdjInterlocksPlus: TTicketInts; JustOne: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmTimes: TdmTimes;

implementation

uses
  Summs, Times2, CutUtils;

{$R *.DFM}

procedure TdmTimes.CalculateTime(Sample: Boolean; qInputs, qOutputs: TFDQueryPlus;
                                 var AdjInterlocks: RealArray);
var
  Code: string;
  WidthNo: integer;

begin
  //Wait until previous use complete.
  while dmTimes2.InUse do
    application.processmessages;

  try
    dmTimes2.InUse := true;

    Code := qInputs.FieldByName('Code').value;
    WidthNo := qInputs.FieldByName('No').value;

    dmTimes2.AdjInterlocks := AdjInterlocks;
    dmTimes2.qKnivesForValue.paramByName('Code').value := Code;
    dmTimes2.qKnivesForValue.paramByName('WidthNo').value := WidthNo;
    dmTimes2.qKnivesForValue.open;
    dmCutUtils.Operation_ElementsAndTotals('FROM_SUMMS', Sample, qInputs, qOutputs, dmTimes2.qKnivesForValue);
    dmTimes2.qKnivesForValue.close;
  finally
    dmTimes2.InUse := false;
  end;
end;

procedure TdmTimes.CalculateAllTimes(Sample: Boolean; ActualBatchSize: integer;
                                     qInputs, qOutputs: TFDQueryPlus;
                                     NoOrigTickets: integer;
                                     var AdjInterlocks: RealArray;
                                     var AdjInterlocksPlus: TTicketInts; JustOne: Boolean);
var
  Code: string;
  i, WidthNo: integer;
  MaterialType, CuttingMethod: string;
  FromTicket, Leather, LeatherHand: boolean;
  MinQual, MaxQual, Rest, Cont: integer;
  NumSizes: integer;

begin
  //Although this routine is called AllTimes, JustOne allows for one time
  //to be selected when only the time is required and not the elements.

  NumSizes := 0;

  if NoOrigTickets = 0 then
    FromTicket := False
  else
    FromTicket := True;

  //Wait until previous use complete.
  while dmTimes2.InUse do
    application.processmessages;

  try
    dmTimes2.InUse := true;

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

        dmTimes2.AdjInterlocks := AdjInterlocksPlus[i].AdjInterlocks;
        NumSizes := round(AdjInterlocksPlus[1].Sizes);
      end
      else
        dmTimes2.AdjInterlocks := AdjInterlocks;

      dmTimes2.qKnivesForValue.paramByName('Code').value := Code;
      dmTimes2.qKnivesForValue.paramByName('WidthNo').value := WidthNo;
      dmTimes2.qKnivesForValue.open;
      dmCutUtils.Operations_Total_asSms('FROM_SUMMS', Sample, ActualBatchSize, qInputs, qOutputs, dmTimes2.qKnivesForValue,
                                        MinQual, MaxQual, Rest, Cont, FromTicket, NumSizes);
      dmTimes2.qKnivesForValue.close;
    end
    else
    begin
      dmTimes2.qPatternsForValue.paramByName('Code').value := Code;
      dmTimes2.qPatternsForValue.paramByName('WidthNo').value := WidthNo;
      dmTimes2.qPatternsForValue.open;
      dmCutUtils.Operations_Total_asSms('FROM_SUMMS', Sample, ActualBatchSize, qInputs, qOutputs, dmTimes2.qPatternsForValue,
                                        MinQual, MaxQual, Rest, Cont, FromTicket, NumSizes);
      dmTimes2.qPatternsForValue.close;
    end;
  finally
    dmTimes2.InUse := false;
  end;
end;

end.
