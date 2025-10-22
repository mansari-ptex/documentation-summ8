unit TicketsSplit;

interface

uses
  Classes, Controls, Forms, Db,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus;

type
  PSplitRec = ^SplitRec;
  SplitRec = record
               Size, Width: string;
               Pairs, WidthNo: integer;
               SizeSeq: real;
             end;

  TWidthsRec = record
                 Code: string;
                 No: integer;
               end;

  TSizesRec = record
                Code: string;
                Seq: real;
              end;

  TCombinationsRec = record
                       Size, Width: string;
                       Pairs, WidthNo: integer;
                       SizeSeq: real;
                     end;

  TCombs = array of TCombinationsRec;

  TdmTicketsSplit = class(TDataModule)
    qGetSizePairs: TFDQueryPlus;
    qGetSizePairsWeekNo: TSmallintField;
    qGetSizePairsSequenceNo: TSmallintField;
    qGetSizePairsTicketNo: TSmallintField;
    qGetSizePairsWidth: TStringField;
    qGetSizePairsSize: TStringField;
    qGetSizePairsKnifeSize: TStringField;
    qGetSizePairsPairs: TIntegerField;
    qGetSizePairsWidthNo: TSmallintField;
    qGetSizePairsSizeSeq: TFloatField;
    qGovernor: TFDQueryPlus;
    qGovernorKnifeSize: TStringField;
    qGovernorSeq: TFloatField;
    qTicketsSplitInput: TFDQueryPlus;
    procedure SplitGoverned(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
                            var TicketNo: integer;
                            var HaveMaster: boolean);
    procedure SplitNormal(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
                          var TicketNo: integer);
    procedure SplitTickets(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
                           var TicketNo, NumSizesOnTicket, Remainder, Total: integer;
                           var Splits: TList);
{    procedure QueryStrings(WeekNo, SequenceNo, NegTicketNo, WidthNo: integer;
                           var NumSizesOnTicket, TicketNo: integer;
                           Splits: TList);}
    procedure QueryStrings(WeekNo, SequenceNo, NegTicketNo, WidthNo: integer;
                           var NoCombinations, TicketNo: integer;
                           Combinations: TCombs);
    procedure AddZeroes(var NoCombinations: integer;
                        var Combinations: TCombs;
                        var NumSizesOnTicket: integer;
                        Splits: TList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmTicketsSplit: TdmTicketsSplit;

implementation

uses
  Windows, SysUtils, TicketsCreate, General;

{$R *.DFM}

procedure TdmTicketsSplit.SplitGoverned(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
                                        var TicketNo: integer;
                                        var HaveMaster: boolean);
var
//  i: integer;
  Remainder, NumSizesOnTicket, Total: integer;
  Failed: boolean;
  Splits: TList;

begin
  Failed := FALSE;
  try
    Splits := TList.Create;
  except
    Failed := TRUE;
    Raise;
  end;

  if not Failed then
  begin
    NumSizesOnTicket := 0;

    qGovernor.Open;

    //CJY: qGovernor.FetchOptions.RecordCountMode set to cmTotal
    if qGovernor.RecordCount > 0 then
    begin
      HaveMaster := True;

      qGetSizePairs.Open;
      qGetSizePairs.RecNo := 1;
      qGetSizePairs.Prior;

      //CJY: qGovernor.FetchOptions.RecordCountMode set to cmTotal
//    for i := 1 to qGovernor.RecordCount do
      While not qGovernor.Eof do
      begin
        Remainder := 0;
        Total := 0;

        qGetSizePairs.Filter := 'KnifeSize = ''' + qGovernorKnifeSize.Value + '''';
        qGetSizePairs.Filtered := TRUE;

        SplitTickets(NegTicketNo, WeekNo, SequenceNo, SplitLimit, TicketNo, NumSizesOnTicket, Remainder,
                     Total, Splits);

        qGovernor.Next;
      end;

      qGetSizePairs.Filtered := FALSE;
      qGovernor.Close;

      qGetSizePairs.Close;
    end
    else
      HaveMaster := False;
  end;
end;

procedure TdmTicketsSplit.SplitNormal(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
                                      var TicketNo: integer);
var
  Remainder, NumSizesOnTicket, Total: integer;
  Failed: boolean;
  Splits: TList;

begin
  Failed := FALSE;
  try
    Splits := TList.Create;
  except
    Failed := TRUE;
    Raise;
  end;

  if not Failed then
  begin
    NumSizesOnTicket := 0;

    qGetSizePairs.Open;

    while not qGetSizePairs.eof do
    begin
      Remainder := 0;
      Total := 0;

      SplitTickets(NegTicketNo, WeekNo, SequenceNo, SplitLimit, TicketNo, NumSizesOnTicket,
                   Remainder, Total, Splits);
    end;

    qGetSizePairs.Close;
  end;
end;

procedure TdmTicketsSplit.SplitTickets(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
                                       var TicketNo, NumSizesOnTicket, Remainder, Total: integer;
                                       var Splits: TList);
var
  j, NoCombinations, Pairage, PartPairage, WidthNo: integer;
  Size, Width: string;
  SizeSeq: real;
  SplitRecord: PSplitRec;
  Combinations: TCombs;

begin
  j := 0;

  //CJY: qGetSizePairs.FetchOptions.RecordCountMode set to cmTotal
  while not(j >= qGetSizePairs.RecordCount) or (Remainder > 0) do
  begin
    if Remainder = 0 then
    begin
      inc(j);

      Pairage := qGetSizePairsPairs.Value;
      Width := qGetSizePairsWidth.Value;
      SizeSeq := qGetSizePairsSizeSeq.Value;
      WidthNo := qGetSizePairsWidthNo.Value;
      Size := qGetSizePairsSize.Value;
      qGetSizePairs.Next;
    end
    else
    begin
      Pairage := Remainder;
      Remainder := 0;
    end;

    PartPairage := SplitLimit - Total;
    Total := Total + Pairage;
    if Total > SplitLimit then
    begin
      Remainder := Total - SplitLimit;
      Total := SplitLimit;

      New(SplitRecord);
      SplitRecord^.Size := Size;
      SplitRecord^.Pairs := PartPairage;
      SplitRecord^.SizeSeq := SizeSeq;
      SplitRecord^.Width := Width;
      SplitRecord^.WidthNo := WidthNo;
      Splits.Add(SplitRecord);

      inc(NumSizesOnTicket);

      AddZeroes(NoCombinations, Combinations, NumSizesOnTicket, Splits);

      QueryStrings(WeekNo, SequenceNo, NegTicketNo, WidthNo, NoCombinations, TicketNo, Combinations);
//      QueryStrings(WeekNo, SequenceNo, NegTicketNo, WidthNo, NumSizesOnTicket, TicketNo, Splits);

      Total := 0;
    end
    else
    begin
      New(SplitRecord);
      SplitRecord^.Size := Size;
      SplitRecord^.Pairs := Pairage;
      SplitRecord^.SizeSeq := SizeSeq;
      SplitRecord^.Width := Width;
      SplitRecord^.WidthNo := WidthNo;
      Splits.Add(SplitRecord);

      inc(NumSizesOnTicket);
    end;
  end;  //while

  if Total > 0 then
  begin
    AddZeroes(NoCombinations, Combinations, NumSizesOnTicket, Splits);
//    QueryStrings(WeekNo, SequenceNo, NegTicketNo, WidthNo, NumSizesOnTicket, TicketNo, Splits);
    QueryStrings(WeekNo, SequenceNo, NegTicketNo, WidthNo, NoCombinations, TicketNo, Combinations);
  end;
end;

procedure TdmTicketsSplit.AddZeroes(var NoCombinations: integer;
                                    var Combinations: TCombs;
                                    var NumSizesOnTicket: integer;
                                    Splits: TList);
var
  i, j, k, m, NoSizes, NoWidths: integer;
  Sizes: array of TSizesRec;
  Widths: array of TWidthsRec;
  SplitRecord: PSplitRec;
  PairsSet, Unique: boolean;

begin
  SetLength(Sizes, NumSizesOnTicket + 1);
  SetLength(Widths, NumSizesOnTicket + 1);


  NoSizes := 0;
  NoWidths := 0;
  for i := 0 to NumSizesOnTicket - 1 do
  begin
    SplitRecord := Splits.Items[i];

    Unique := True;
    for j := 0 to NoSizes do
    begin
      if Sizes[j].Code = SplitRecord^.Size then
        Unique := False;
    end;

    if Unique then
    begin
      inc(NoSizes);
      Sizes[NoSizes].Code := SplitRecord^.Size;
      Sizes[NoSizes].Seq := SplitRecord^.SizeSeq;
    end;

    Unique := True;
    for j := 0 to NoWidths do
    begin
      if Widths[j].Code = SplitRecord^.Width then
        Unique := False;
    end;

    if Unique then
    begin
      inc(NoWidths);
      Widths[NoWidths].Code := SplitRecord^.Width;
      Widths[NoWidths].No := SplitRecord^.WidthNo;
    end;
  end;

  SetLength(Combinations, (NoSizes * NoWidths) + 1);
  k := 0;
  for i := 1 to NoSizes do
  begin
//    SplitRecord := Splits.Items[i - 1];
    for j := 1 to NoWidths do
    begin
      inc(k);
      Combinations[k].Size := Sizes[i].Code;
      Combinations[k].SizeSeq := Sizes[i].Seq;
      Combinations[k].Width := Widths[j].Code;
      Combinations[k].WidthNo := Widths[j].No;

      m := 0;
      PairsSet := False;
      while (m < Splits.Count) and not PairsSet do
      begin
        SplitRecord := Splits.Items[m];
        if (SplitRecord^.Size = Combinations[k].Size) and (SplitRecord^.WidthNo = Combinations[k].WidthNo) then
        begin
          Combinations[k].Pairs := SplitRecord^.Pairs;
          PairsSet := True;
        end
        else
          Combinations[k].Pairs := 0;

        inc(m);
      end;
    end;
  end;
  NoCombinations := k;
  
  NumSizesOnTicket := 0;
  Splits.Clear;
end;

procedure TdmTicketsSplit.QueryStrings(WeekNo, SequenceNo, NegTicketNo, WidthNo: integer;
                                       var NoCombinations, TicketNo: integer;
                                       Combinations: TCombs);
var
  SQLString: string;
  i, TotalPairs: integer;

begin
  inc(TicketNo);
  SQLString := 'INSERT INTO TicketTickets ' +
               'SELECT WeekNo, SequenceNo, ' + IntToStr(TicketNo) + ', PartCode, PartDescription, ID, MaterialCode, ' +
                      'MaterialDescription, MaterialType, MaterialCutType, MaterialLength, MaterialWidth, MaterialSkinSize, ' +
                      'MaterialSkinTrimmed, MaterialUnits, MaterialLayers, AdjFactorResult, CutWeek, Cutter, CutterLocation, ' +
                      'Quality, Area, IssuedAllowance, CostedAllowance, ActualUsage, SMVs, Bulked, CostedResult, ' +
                      'TotalPairs, MatSupplier, StandardMatPrice, MatPrice, SpecialInstructions, MaterialQualCoeff, ' +
                      'MaterialAreaCoeff, MaterialUnitDescription, MaterialUnitAbbreviation, MaterialSubUnitDesc, ' +
                      'MaterialSubUnitAbbreviation, MaterialSubUnitsPerUnit, MaterialUnitsToFeet, BasicAllowance, ' +
                      'AdjustedAllowance, Print, Printed, SLMAllowance, MaterialCutGap, SizeScale, ' +
                      'MaterialLinearPrice, MaterialLinearAllowance, 1 ' +
               'FROM TicketTickets ' +
               'WHERE WeekNo = ' + IntToStr(WeekNo) + ' AND SequenceNo = ' + IntToStr(SequenceNo) + ' AND TicketNo = ' +
                      IntToStr(NegTicketNo) + ';' + #13 +
               'INSERT INTO TicketTicketsWidths ' +
               'SELECT WeekNo, SequenceNo, ' + IntToStr(TicketNo) + ', Part, Width ' +
               'FROM TicketTicketsWidths ' +
               'WHERE WeekNo = ' + IntToStr(WeekNo) + ' AND SequenceNo = ' + IntToStr(SequenceNo) + ' AND TicketNo = ' +
                      IntToStr(NegTicketNo) + ';';

  TotalPairs := 0;
  for i := 1 to NoCombinations do
  begin
    SQLString := SQLString + #13 + 'INSERT INTO TicketsSplitInput ' +
                 'VALUES (' + IntToStr(WeekNo) + ', ' + IntToStr(SequenceNo) + ', ' + IntToStr(TicketNo) + ', ''' + QS(Combinations[i].Width) +
                 ''', ''' + QS(Combinations[i].Size) + ''', ' + IntToStr(Combinations[i].Pairs) + ', ' + IntToStr(Combinations[i].WidthNo) + ', ' +
                 FloatToStrF(Combinations[i].SizeSeq, ffGeneral, 15, 0) + ');';

    TotalPairs := TotalPairs + Combinations[i].Pairs;
  end;

  SQLString := SQLString + #13 + 'UPDATE TicketTickets ' +
               'SET TotalPairs = ' + IntToStr(TotalPairs) +
               ' WHERE WeekNo = ' + IntToStr(WeekNo) + ' AND SequenceNo = ' + IntToStr(SequenceNo) + ' AND TicketNo = ' +
               IntToStr(TicketNo) + ';';
  //Intentional left as an SQL.Add to to complexity of query construction.
  dmTicketsCreate.qNewTickets.SQL.Add(SQLString);
end;

end.
