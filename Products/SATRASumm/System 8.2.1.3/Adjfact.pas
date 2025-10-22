unit AdjFact;

interface

uses
  Forms, Db, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Classes;

type
  IFTRec = record
             Interlock : real;
             Frequency : integer;
             KnifeType : ansichar
           end;

  IntlckFreqTypeArray = array of IFTRec;

  TdmAdjFact = class(TDataModule)
    qAFVars: TFDQueryPlus;
    qAFVarsAdjFactor: TSmallintField;
    qAFVarsType: TStringField;
    qAFVarsInterlockAreaPrimeSynthetic: TFloatField;
    qAFVarsInterlockAreaNonPrime: TFloatField;
    qAFVarsFrequency: TSmallintField;
    qAFVarsMaterialType: TStringField;
    qAFVarsManualAdjFactor: TBooleanField;
    procedure SortInterlocks(var SortIt:IntlckFreqTypeArray;
                             LoIndex,HiIndex:integer);
    function PartAdjFactor(Part : string; WidthNo : integer) : Integer;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    InUse : boolean;
  public
    { Public declarations }
  end;

var
  dmAdjFact: TdmAdjFact;

implementation

uses
  CmnTypes, Summs; //Summs added for XE5 conversion

{$R *.DFM}

function TdmAdjFact.PartAdjFactor(Part : string; WidthNo : integer) : Integer;
//Function returns correct part adjustment factor,
//taking into account whether or not a manual one
//has been selected. When data was invalid it used to return -999.
var
  TotalNonPrimeArea, TotalPrimeArea, TotalInterlockArea, PrimeAreaRatio,
  NonPrimeAreaRatio, AdjFactorReal, InterlockArea, Factor, X, Y : real;
  i,AdjFactorInteger : integer;
  IntlckFreqType : IntlckFreqTypeArray;

begin
  //Wait until previous use complete.
  while InUse do
    application.processmessages;

  try
    InUse := true;

    qAFVars.ParamByName('PartCode').AsString := Part;
    qAFVars.ParamByName('WidthNo').AsInteger := WidthNo;
    qAFVars.Open;

    if qAFVarsManualAdjFactor.Value then
      Result := qAFVarsAdjFactor.value
    else
    begin
      //CJY qAFVars.FetchOptions.RecordCountMode set to cmTotal
      if (qAFVars.RecordCount = 0) then
        Result := 0
      else
      begin
        if (qAFVarsMaterialType.value[1] in Leathers) then
        begin
          //Leather or derivative
          TotalPrimeArea := 0;
          TotalNonPrimeArea := 0;
          PrimeAreaRatio := 0;
          NonPrimeAreaRatio := 0;

          //CJY:Begin removing dependence on RecordCount
          i := 1;
          qAFVars.RecNo := 1; //CJY changed from qAFVars.First
          qAFVars.Prior; //CJY changed from qAFVars.First
          while not qAFVars.eof do
          begin
            if (qAFVarsType.value = 'N') then
              TotalNonPrimeArea := TotalNonPrimeArea + (qAFVarsInterlockAreaNonPrime.value * qAFVarsFrequency.Value)
            else
              TotalPrimeArea := TotalPrimeArea + (qAFVarsInterlockAreaPrimeSynthetic.value * qAFVarsFrequency.Value);
            Inc(i);
            qAFVars.next;
          end;
{
          //CJY: Would require qAFVars.FetchOptions.RecordCountMode set to cmTotal
          for i := 1 to qAFVars.RecordCount do
          begin
            if (qAFVarsType.value = 'N') then
              TotalNonPrimeArea := TotalNonPrimeArea + (qAFVarsInterlockAreaNonPrime.value * qAFVarsFrequency.Value)
            else
              TotalPrimeArea := TotalPrimeArea + (qAFVarsInterlockAreaPrimeSynthetic.value * qAFVarsFrequency.Value);
            qAFVars.next;
          end;
}
         //CJY:End

          TotalInterlockArea := TotalPrimeArea + TotalNonPrimeArea;
          if TotalInterlockArea > 0 then
          begin
            PrimeAreaRatio := TotalPrimeArea / TotalInterlockArea;
            NonPrimeAreaRatio := TotalNonPrimeArea / TotalInterlockArea;
          end;

          AdjFactorReal := 0;

          //CJY: i been incremented through all records + 1 (to get to eof)
          SetLength(IntlckFreqType, i);

          //CJY:Begin removing dependence on RecordCount
          i := 1;
          qAFVars.RecNo := 1; //CJY changed from qAFVars.First
          qAFVars.Prior; //CJY changed from qAFVars.First
          while not qAFVars.eof do
          begin
            if (qAFVarsType.value = 'N') then
              IntlckFreqType[i].Interlock := qAFVarsInterlockAreaNonPrime.value
            else
              IntlckFreqType[i].Interlock := qAFVarsInterlockAreaPrimeSynthetic.value;
            IntlckFreqType[i].Frequency := qAFVarsFrequency.value;
            IntlckFreqType[i].KnifeType := qAFVarsType.value[1];
            Inc(i);
            qAFVars.next;
          end;
{
          //CJY: Would require qAFVars.FetchOptions.RecordCountMode set to cmTotal
          qAFVars.RecNo := 1; //CJY changed from qAFVars.First
          qAFVars.Prior; //CJY changed from qAFVars.First
          for i := 1 to qAFVars.RecordCount do
          begin
            if (qAFVarsType.value = 'N') then
              IntlckFreqType[i].Interlock := qAFVarsInterlockAreaNonPrime.value
            else
              IntlckFreqType[i].Interlock := qAFVarsInterlockAreaPrimeSynthetic.value;
            IntlckFreqType[i].Frequency := qAFVarsFrequency.value;
            IntlckFreqType[i].KnifeType := qAFVarsType.value[1];
            qAFVars.next;
          end;
 }
         //CJY:End

          SortInterlocks(IntlckFreqType,1,(Length(IntlckFreqType) - 1));

          //CJY:Begin removing dependence on RecordCount
          //CJY: Would require qAFVars.FetchOptions.RecordCountMode set to cmTotal
//        for i := 1 to qAFVars.RecordCount do
          for i := 1 to (Length(IntlckFreqType) - 1) do
          begin
            InterlockArea := IntlckFreqType[i].Interlock;

            if ((PrimeAreaRatio > 0.6) and ((IntlckFreqType[i].KnifeType = 'P') or
                (IntlckFreqType[i].KnifeType = 'S'))) then
            //Prime
            begin
              if InterlockArea < 0.05 then
              begin
                X := 5;
                Y := 100;
              end
              else if ((InterlockArea >= 0.05) and (InterlockArea < 0.125)) then
              begin
                X := 1.2;
                Y := 22.7;
              end
              else if ((InterlockArea >= 0.125) and (InterlockArea < 0.4)) then
              begin
                X := 0;
                Y := 13.7;
              end
              else
              begin
                X := 3.2;
                Y := 22;
              end;

              AdjFactorReal := AdjFactorReal + (((X - (InterlockArea * Y)) *
                              (PrimeAreaRatio - 0.6) * 2.5 * InterlockArea / TotalPrimeArea) * IntlckFreqType[i].Frequency);
            end;
            if ((NonPrimeAreaRatio > 0) and (IntlckFreqType[i].KnifeType = 'N')) then
            //Non Prime
            begin
              if InterlockArea < 0.05 then
              begin
                X := 6;
                Y := 80;
              end
              else if ((InterlockArea >= 0.05) and (InterlockArea < 0.125)) then
              begin
                X := 3;
                Y := 21;
              end
              else if ((InterlockArea >= 0.125) and (InterlockArea < 0.4)) then
              begin
                X := 1;
                Y := 5;
              end
              else
              begin
                X := 6.8;
                Y := 20;
              end;

              Factor := X - InterlockArea * Y;
              if ((Factor > 4) and (AdjFactorReal > 3)) then
                AdjFactorReal := AdjFactorReal + (Factor * NonPrimeAreaRatio * IntlckFreqType[i].Frequency)
              else
                AdjFactorReal := AdjFactorReal + (Factor * IntlckFreqType[i].Frequency);
            end;
          end;

          AdjFactorInteger := round(AdjFactorReal);
          if AdjFactorInteger > 13 then
            AdjFactorInteger := 13
          else if AdjFactorInteger <- 13 then
            AdjFactorInteger := -13;
        end
        else
          //Synthetic
          AdjFactorInteger := 0;

        Result := AdjFactorInteger;
      end;
    end;
    qAFVars.Close;
  finally
    InUse := false;
  end;
end;

procedure TdmAdjFact.SortInterlocks(var SortIt : IntlckFreqTypeArray;
                                    LoIndex , HiIndex : integer);
var
  Lo, Hi : integer;
  Temp : IFTRec;
  mid : real;

begin
  Lo := LoIndex;
  Hi := HiIndex;

  Mid := SortIt[(Lo + Hi) div 2].interlock;

  repeat
    while SortIt[Lo].interlock < Mid do Inc(Lo);       //to reverse final order of array
    while SortIt[Hi].interlock > Mid do Dec(Hi);       //simply swap these > and < signs.
    if Lo <= Hi then
    begin
      Temp := SortIt[Lo];
      SortIt[Lo] := SortIt[Hi];
      SortIt[Hi] := Temp;

      Inc(Lo);
      Dec(Hi);
    end;
   until Lo > Hi;

  if (Hi > LoIndex) then
    SortInterlocks(SortIt, LoIndex, Hi);
  if (Lo < HiIndex) then
    SortInterlocks(SortIt, Lo, HiIndex);
end;

procedure TdmAdjFact.DataModuleCreate(Sender: TObject);
begin
  InUse := false;
end;

end.
