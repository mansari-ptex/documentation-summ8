unit TicketsAllDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, Controls, Forms, BasicAlw, CmnTypes, cmnVars,
  FDTablePlus, FDConnectionPlus, CutUtils;

const
  SPLITTINGCONSECUTIVESIZES = 0;
  SPLITTINGCONSECUTIVESIZESGOVERNED = 1;

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

  TdmTicketsAll = class(TDataModule)
    LocalConnectionSumms: TFDConnectionPlus;
    qWidthKnives: TFDQueryPlus;
    qWidthKnivesPart: TStringField;
    qWidthKnivesAltMaterial: TStringField;
    qWidthKnivesWidthNo: TSmallintField;
    qWidthKnivesWidth: TStringField;
    qWidthKnivesKnife: TStringField;
    qWidthKnivesPairs: TIntegerField;
    qWidthKnivesMaxPairs: TSmallintField;
    qWidthKnivesSeqNo: TFloatField;
    qWidthKnivesInterlockAreaPrimeSynthetic: TFloatField;
    qWidthKnivesInterlockAreaNonPrime: TFloatField;
    qWidthKnivesPSN: TStringField;
    qWidthKnivesKnifeCutGap: TSmallintField;
    qWidthKnivesMaterialType: TStringField;
    qWidthKnivesSLMAllowance: TBooleanField;
    qTimesGridFullBatch: TFDQueryPlus;
    qNewTickets: TFDQueryPlus;
    qTicketTimes: TFDQueryPlus;
    qTimesGridSmallBatch: TFDQueryPlus;
    qGetData: TFDQueryPlus;
    qGetAverageSizes: TFDQueryPlus;
    qGetAverageSizesPartCode: TStringField;
    qGetAverageSizesMaterialCode: TStringField;
    qGetAverageSizesMaterialType: TStringField;
    qGetAverageSizesMaterialAreaCoeff: TIntegerField;
    qGetAverageSizesMaterialQualCoeff: TIntegerField;
    qGetAverageSizesWeekNo: TSmallintField;
    qGetAverageSizesSequenceNo: TSmallintField;
    qGetAverageSizesTicketNo: TSmallintField;
    qGetAverageSizesKnifeIndex: TFloatField;
    qGetAverageSizesAverage: TFloatField;
    qGetAverageSizesWidthNo: TSmallintField;
    qGetAverageSizesSLMAllowance: TBooleanField;
    qWhatTickets: TFDQueryPlus;
    qWhatTicketsTicketNo: TSmallintField;
    qWhatTicketsSLMAllowance: TBooleanField;
    qInvalidTickets: TFDQueryPlus;
    qBAForTickets: TFDQueryPlus;
    qBAForTicketsKnife: TStringField;
    qBAForTicketsSeq: TFloatField;
    qBAForTicketsFrequency: TSmallintField;
    qBAForTicketsNumberOfKnives: TIntegerField;
    qBAForTicketsMatType: TStringField;
    qBAForTicketsAreaCoeff: TIntegerField;
    qBAForTicketsQualCoeff: TIntegerField;
    qBAForTicketsShoeSize: TStringField;
    qBAForTicketsKnifeType: TStringField;
    qBAForTicketsKnifeCutGap: TIntegerField;
    qBAForTicketsInterlockAreaPrimeSynthetic: TFloatField;
    qBAForTicketsInterlockAreaNonPrime: TFloatField;
    qBAForTicketsPieces: TSmallintField;
    qBAForTicketsGrossArea: TFloatField;
    qBAForTicketsNettArea: TFloatField;
    qBAForTicketsToFeet: TFloatField;
    qBAForTicketsSubUnitsPerUnit: TSmallintField;
    qBAForTicketsSkinSize: TFloatField;
    qBAForTicketsMatLength: TFloatField;
    qBAForTicketsMatWidth: TFloatField;
    qBAForTicketsCutType: TStringField;
    qBAForTicketsTrimmed: TBooleanField;
    qBAForTicketsSampleSizeMm: TSmallintField;
    qBAForTicketsTableLength: TFloatField;
    qBAForTicketsBAQuadraticA: TFloatField;
    qBAForTicketsBAQuadraticB: TFloatField;
    qBAForTicketsBAQuadraticC: TFloatField;
    qBAForTicketsNumWidths: TIntegerField;
    qBAForTicketsSqFtPerPiece: TFloatField;
    qBAForTicketsSLMAllowance: TBooleanField;
    qBAForTicketsMadeInParts: TBooleanField;
    qBAForTicketsLinearAllowance: TBooleanField;
    qCheckFullSynthetics: TFDQueryPlus;
    qCheckFullSyntheticsPartCode: TStringField;
    qCheckFullSyntheticsKnifeCode: TStringField;
    qCheckFullSyntheticsSize: TStringField;
    qNoSampleKnife: TFDQueryPlus;
    qNoSampleKnifePart: TStringField;
    qNoSampleKnifeKnife: TStringField;
    qNoSampleKnifeWidth: TStringField;
    qCompareGrids: TFDQueryPlus;
    qCompareGridsWidth: TStringField;
    qCompareGridsSize: TStringField;
    qFillCompareGrid: TFDQueryPlus;
    StringField1: TStringField;
    StringField2: TStringField;
    qClearCompareGrid: TFDQueryPlus;
    qReadCompareGrid: TFDQueryPlus;
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
    qUpdateTickets: TFDQueryPlus;
    qClearBothTables: TFDQueryPlus;
    function MakeTickets(WeekNo, SequenceNo: string; FromGroup: boolean): boolean;
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    function AllowanceTicket: AllowanceResult;
    procedure FillCompareGrid(WeekNo, SequenceNo, Style : string);
    procedure SplitGoverned(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
                            var TicketNo: integer;
                            var HaveMaster: boolean);
    procedure SplitNormal(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
                          var TicketNo: integer);
    procedure SplitTicketsProcedure(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
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
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    ComponentNest: Array of TComponentConnection;

    InUse: Boolean;
    Ints4Ticket: TTicketInts;

    FullBatchError, SmallBatchError: boolean;
  public
    { Public declarations }
    procedure TicketUpdateCommonCreate();
    function ChangeAllConnections(Connection: TFDCustomConnection): Boolean;
    procedure RevertAllConnections();
  end;

var
  dmTicketsAll: TdmTicketsAll;

implementation

//Did not try to change SQL.Add in this module due to complexity of query building.

{$R *.DFM}

uses
  Windows, Summs, Times, TicketsSplit, AdjFact, SummsVars,
  General, Dialogs, TicketsBreakdown, Const_Interlocking;

function TdmTicketsAll.MakeTickets(WeekNo, SequenceNo: string; FromGroup: boolean): boolean;
type Ticket = record
                Part, AltMaterial, Width, Knives: string;
                MaxPairs, WidthNo: short;
                AddWidth, Used: boolean;
                AdjFact: integer;
              end;

var
  Part, LastPart, AltMaterial, LastAltMaterial, Width, LastWidth, Knife, AllKnives: string;
  LastMaxPairs, LastWidthNo, MaxPairs, WidthNo: short;
  Lines, AdjFact, LastAdjFact: integer;
  Tickets: array of Ticket;
  MaxTicketIndex, TicketNo: integer;
  i, j: integer;
  AddWidth, LastAddWidth: boolean;
  GovString, SQLString, sRollLength: string;
  STicketNo: string;
  sBasicAllowance: string;
  LoopCount: integer;
  Dummy: RealArray;
  CreateComplete, SyntheticFailed, HaveMaster, UnAssessed, LeatherWithCutGap, MissingSampleKnife: Boolean;
  FullBatches, SmallBatch: integer;
  IntArea, TotalTime: Real;
  Allowance: AllowanceResult;
  MyMessage, s: string;
  MaterialType: char;
  ChangedConnection: Boolean;
  inTransaction: Boolean;

  procedure ListTicket;
  begin
    inc(MaxTicketIndex);
    Tickets[MaxTicketIndex].Part := LastPart;
    Tickets[MaxTicketIndex].AltMaterial := LastAltMaterial;
    Tickets[MaxTicketIndex].Width := LastWidth;
    Tickets[MaxTicketIndex].Knives := AllKnives;
    Tickets[MaxTicketIndex].MaxPairs := LastMaxPairs;
    Tickets[MaxTicketIndex].WidthNo := LastWidthNo;
    Tickets[MaxTicketIndex].AddWidth := LastAddWidth;
    Tickets[MaxTicketIndex].AdjFact := LastAdjFact;
    Tickets[MaxTicketIndex].Used := FALSE;
  end;

  procedure CreateTicketWidth (No: integer; NewTicket: boolean);
  var
    SQLString: string;
    sTicketNo: string;
    AdjStr, MatCode: string;

  begin
    if SplitTickets and (Tickets[No].MaxPairs > 0) then
    begin
      TicketNo := -TicketNo;  //if Splitting - Write to negative ticket numbers
      str(TicketNo, sTicketNo);
      TicketNo := abs(TicketNo);
    end
    else
      str(TicketNo, sTicketNo);

    if NewTicket then
    begin
      if Tickets[No].AltMaterial = '' then
        MatCode := 'P.Material'
      else
        MatCode := '''' + QS(Tickets[No].AltMaterial) + '''';

      if Tickets[No].AdjFact = 0 then
        AdjStr := '0, '
      else
        AdjStr := 'IIF((M.Type = ''R'' OR M.Type = ''S''), 0, ' + IntToStr(Tickets[No].AdjFact) + '), ';

      SQLString := 'INSERT INTO TicketTickets ' +
                   '(WeekNo, SequenceNo, TicketNo, PartCode, PartDescription, SizeScale, SpecialInstructions, ' +
                   'MaterialCode, MaterialDescription, MaterialType, MaterialLinearPrice, ' +
                   'MaterialCutType, MaterialLength, MaterialWidth, ' +
                   'MaterialSkinSize, MaterialSkinTrimmed, MaterialSheetCutFromRoll, MaterialUnits, ' +
                   'MaterialLayers, AdjFactorResult, Quality, Area, StandardMatPrice, MatPrice, ' +
                   'TotalPairs, MaterialQualCoeff, MaterialAreaCoeff, ' +
                   'MaterialUnitDescription, MaterialUnitAbbreviation, MaterialSubUnitDesc, ' +
                   'MaterialSubUnitAbbreviation, MaterialSubUnitsPerUnit, MaterialUnitsToFeet, ' +
                   'BasicAllowance, CostedAllowance, SLMAllowance, MaterialCutGap) ' +
                   'SELECT ' + WeekNo + ', ' + SequenceNo + ', ' + sTicketNo + ', ' + '''' + QS(Tickets[No].Part) + ''', ' +
                   'P.Description, P.SizeScale, P.Notes, ' + MatCode + ', M.Description, M.Type, M.LinearMatPrice, ' +
                   'M.CutType, M.Length, M.Width, M.SkinSize, M.Trimmed, M.SheetCutFromRoll, M.Units, M.Layers, ' + AdjStr +
                   'IIF((M.Type = ''R'' OR M.Type = ''S''), 100, M.QualCoeff), ' +
                   'IIF((M.Type = ''R'' OR M.Type = ''S''), 100, M.AreaCoeff), M.StandardPrice, M.StandardPrice, 0, ' +
                   'IIF((M.Type = ''R'' OR M.Type = ''S''), 100, M.QualCoeff), ' +
                   'IIF((M.Type = ''R'' OR M.Type = ''S''), 100, M.AreaCoeff), MU.UnitDescription, MU.UnitAbbreviation, ' +
                   'MU.SubUnitDesc, MU.SubUnitAbbreviation, MU.SubUnitsPerUnit, MU.ToFeet, ' +
                   '0, P.CostedAllowance, P.SLMAllowance, M.CutGap ' +
                   'FROM Parts P, Material M, MatUnits MU ' +
                   'WHERE (P.Code = ' + '''' + QS(Tickets[No].Part) + ''') AND (M.Code = ' + MatCode + ') AND (MU.Code = M.Units);';

      qNewTickets.SQL.Add(SQLString);
    end;

    SQLString := 'INSERT INTO TicketTicketsWidths VALUES(' + WeekNo + ', ' +
                 SequenceNo + ', ' + sTicketNo + ',  ''' + QS(Tickets[No].Part) +
                 ''',  ''' + QS(Tickets[No].Width) + ''');';
    qNewTickets.SQL.Add(SQLString);

    SQLString := 'UPDATE TicketTickets ' +
                 'SET TotalPairs = (SELECT TT.TotalPairs + SUM(TI.Pairs) FROM TicketsInput TI ' +
                 'WHERE TT.WeekNo = TI.WeekNo AND TT.SequenceNo = TI.SequenceNo AND ' +
                 'TI.Width = ''' + QS(Tickets[No].Width) + ''' AND NOT(TI.Size = ''AddWidth'')) ' +
                 'FROM TicketTickets TT ' +
                 'WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ' AND TicketNo = ' + sTicketNo + ';';

    qNewTickets.SQL.Add(SQLString);

    Tickets[No].Used := TRUE;
  end;

begin
  HaveMaster := True;

  str(ROLLLENGTH_FT : 6 : 2, sRollLength);

  //Wait until previous use complete.
  while InUse do
    application.processmessages;

  if not qNewTickets.Connection.Connected then
    qNewTickets.Connection.Connected := True;

  inTransaction := qNewTickets.Connection.InTransaction;
  qNewTickets.Connection.StartTransaction;
  CreateComplete := False;
  SyntheticFailed := False;

  try
    InUse := true;

    ChangedConnection := dmBasAll.ChangeAllConnections(qBAForTickets.Connection);

    qNewTickets.SQL.clear;
    qInvalidTickets.SQL.clear;

    //----------------------------------------------------------------------------
    //Query the Knives on the selected parts
    //to form Array 'Tickets' of details.

    //CJY: qWidthKnives.FetchOptions.RecordCountMode set to cmTotal
    Lines := qWidthKnives.recordCount;

    SetLength(Tickets, Lines);

    LastPart := '';
    LastAltMaterial := '';
    LastWidth := '';
    LastWidthNo := 0;
    LastMaxPairs := 0;
    LastAddWidth := false;
    LastAdjFact := -999;
    MaxTicketIndex := -1;
    AllKnives := '';
    UnAssessed := False;
    LeatherWithCutGap := False;

    qWidthKnives.RecNo := 1; //CJY changed from qWidthKnives.First
    qWidthKnives.Prior; //CJY changed from qWidthKnives.First
    while not(qWidthKnives.eof or UnAssessed or LeatherWithCutGap) do
    begin
      Part := qWidthKnivesPart.value;
      AltMaterial := qWidthKnivesAltMaterial.value;
      Width := qWidthKnivesWidth.value;
      Knife := qWidthKnivesKnife.value;
      if qWidthKnivesPSN.Value = 'N' then
        IntArea := qWidthKnivesInterlockAreaNonPrime.value
      else
        IntArea := qWidthKnivesInterlockAreaPrimeSynthetic.value;

      if (qWidthKnivesSLMAllowance.value) and (IntArea < 0.0001) then
        UnAssessed := True;

      MaterialType := qWidthKnivesMaterialType.AsString[1];
      if (MaterialType in ['L', 'W', 'K']) and (qWidthKnivesKnifeCutGap.Value <> 0) then
        LeatherWithCutGap := True;

      if (not UnAssessed) and (not LeatherWithCutGap) then
      begin
        MaxPairs := qWidthKnivesMaxPairs.value;
        WidthNo := qWidthKnivesWidthNo.value;
        AddWidth := (qWidthKnivesPairs.value = 1);
        AdjFact := dmAdjFact.PartAdjFactor(Part, WidthNo);

        if not((Part = LastPart) and (Width = LastWidth)) then
        begin
          if LastPart <> '' then
            ListTicket;

          AllKnives := '';
        end;

        AllKnives := AllKnives + Knife + '|@|';

        LastPart := Part;
        LastAltMaterial := AltMaterial;
        LastWidth := Width;
        LastMaxPairs := MaxPairs;
        LastWidthNo := WidthNo;
        LastAddWidth := AddWidth;
        LastAdjFact := AdjFact;

        qWidthKnives.next;
      end;
    end;

    //Last Ticket
    //CJY: qWidthKnives.FetchOptions.RecordCountMode set to cmTotal
    if (qWidthKnives.RecordCount <> 0) and (not UnAssessed) and (not LeatherWithCutGap) then
      ListTicket;

    qWidthKnives.close;

    if (MaxTicketIndex > -1) and (not UnAssessed) and (not LeatherWithCutGap) then
    //MaxTicketIndex = -1 when there are zero records returned by qWidthKnives, which happens when the Construction on
    //the Ticket has been deleted before the ticket is created.  It would be more correct to establish this Construction
    //problem with another query, but for speed reasons we're using the fact qWidthKnives returns nothing.
    begin
      //----------------------------------------------------------------------------
      //Insert Tickets into TICKETTICKETS and
      //Width Details into TICKETTICKETWIDTHS
      //checking whether widths can/should be
      //added together.

      //Add Entries to Widths Table to new query
      TicketNo := 0;
      i := 0;
      repeat
        //Add Header record into Ticket Tickets
        if not Tickets[i].Used then
        begin
          inc(TicketNo);

          if SplitTickets and (Tickets[i].MaxPairs > 0) then
          begin
            qGetSizePairs.SQL.Clear;
            qGovernor.SQL.Clear;

            if SplittingScheme = SPLITTINGCONSECUTIVESIZES then
            begin
              SQLString := 'SELECT WeekNo, SequenceNo, ' + IntToStr(TicketNo - 1) + ' AS TicketNo, ' +
                                  'Width, Size, Size AS KnifeSize, Pairs, WidthNo, SizeSeq ' +
                           'FROM TicketsInput ' +
                           'WHERE WeekNo = ' + WeekNo + ' AND ' +
                                 'SequenceNo = ' + SequenceNo + ' AND ' +
                                 'Size <> ''AddWidth'' AND Pairs > 0 AND ' +
                                 '(Width = ''' + QS(Tickets[i].Width) + '''';
            end
            else
            begin
              SQLString := 'SELECT TI.WeekNo, TI.SequenceNo, ' + IntToStr(TicketNo - 1) + ' AS TicketNo, ' +
                           'TI.Width, TI.Size, SRS.KnifeSize, TI.Pairs, TI.WidthNo, TI.SizeSeq ' +
                           'FROM TicketsInput TI, PtWidKnf PWK, SizeRelationshipSizes SRS, Widths W ' +
                           'WHERE TI.WeekNo = ' + WeekNo + ' AND ' +
                           'TI.SequenceNo = ' + SequenceNo + ' AND ' +
                           'TI.Size <> ''AddWidth'' AND TI.Pairs > 0 AND ' +
                           'PWK.Part = ''' + QS(Tickets[i].Part) + ''' AND ' +
                           'SRS.Scale = PWK.SizeScale AND SRS.Range = PWK.SizeRange AND ' +
                           'SRS.Relationship = PWK.SizeRelationship AND Governor = TRUE AND ' +
                           'SRS.ShoeSize = TI.Size AND W.Width = TI.Width AND PWK.WidthNo = W.No AND ' +
                           '(TI.Width = ''' + QS(Tickets[i].Width) + '''';

              GovString := 'SELECT DISTINCT(SRS.KnifeSize), SSS.Seq ' +
                           'FROM PtWidKnf PWK, SizeRelationshipSizes SRS, SizeScaleSizes SSS, Widths W ' +
                           'WHERE PWK.Part = ''' + QS(Tickets[i].Part) + ''' AND SRS.Scale = PWK.SizeScale AND ' +
                           'SRS.Range = PWK.SizeRange AND SRS.Relationship = PWK.SizeRelationship AND ' +
                           'Governor = TRUE AND SSS.Scale = PWK.SizeScale AND SSS.Size = SRS.KnifeSize AND ' +
                           'PWK.WidthNo = W.No AND ' +
                           '(W.Width = ''' + QS(Tickets[i].Width) + '''';
            end;
          end;

          //First ticket of block...
          CreateTicketWidth(i, TRUE);

          for j := i + 1 to MaxTicketIndex do
          begin
            if (Tickets[i].AddWidth) and
               (Tickets[j].AddWidth) and
               (not Tickets[j].Used) and
               (Tickets[j].Part = Tickets[i].Part) and
               (Tickets[j].Knives = Tickets[i].Knives) and
               (Tickets[j].AdjFact = Tickets[i].AdjFact) then
            begin
              //...& subsequent 'Added Width' tickets
              CreateTicketWidth(j, FALSE);

              if SplitTickets and (Tickets[j].MaxPairs > 0) then
              begin
                if SplittingScheme = SPLITTINGCONSECUTIVESIZES then
                  SQLString := SQLString +
                             ' OR Width = ''' + QS(Tickets[j].Width) + ''''
                else
                begin
                  SQLString := SQLString +
                             ' OR TI.Width = ''' + QS(Tickets[j].Width) + '''';

                  GovString := GovString +
                             ' OR W.Width = ''' + QS(Tickets[j].Width) + '''';
                end;
              end;
            end;
          end;

          if SplitTickets and (Tickets[i].MaxPairs > 0) then
          begin
            if SplittingScheme = SPLITTINGCONSECUTIVESIZES then
              SQLString := SQLString + ') ' +
                          'Order By SizeSeq, SizeSeq, Width'
            else
            begin
              SQLString := SQLString + ') ' +
                          'Order By TI.SizeSeq, TI.SizeSeq, TI.Width';

              GovString := GovString + ') ' +
                          'Order By SSS.Seq, SSS.Seq, SRS.KnifeSize';
              qGovernor.SQL.Add(GovString);
            end;

            qGetSizePairs.SQL.Add(SQLString);

            dec(TicketNo);

            if SplittingScheme = SPLITTINGCONSECUTIVESIZES then
              SplitNormal(-TicketNo - 1, StrToInt(WeekNo), StrToInt(SequenceNo), Tickets[i].MaxPairs, TicketNo)
            else
              SplitGoverned(-TicketNo - 1, StrToInt(WeekNo), StrToInt(SequenceNo), Tickets[i].MaxPairs, TicketNo, HaveMaster);
          end;
        end;
        inc(i);
      until (i > MaxTicketIndex) or not(HaveMaster);

      //----------------------------------------------------------------------------
      //Insert Pairage into TICKETPAIRAGE
      //taking into account Size Relationships,
      //Size Adjustments

  //1. Commented out queries apply Size Relationship and then SizeAdjustment.
  //2. Working queries apply SizeAdjustment and then Size Relationship, to match old system.
  //Example of when the two approaches give different results.
  // Size Reln
  // ShoeSize     KnifeSize
  //    6             6
  //   6.5            7
  //    7             7
  //  SizeAdjustment = 1
  //Example of 1.  ShoeSize 6 gives KnifeSize 6.  Adjusted by +1 gives 6.5.
  //Example of 2.  Adjustment gives 6.5 ShoeSize, leads to KnifeSize of 7.
  //Consult consultants.

  {    SQLString := 'INSERT INTO TicketPairage ' +
                   'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SSC2.Seq, PWK.Knife, SSC2.Size, SUM(TI.Pairs * PWK.Frequency) ' +
                   'FROM TicketTicketsWidths TTW, TicketsInput TI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS, SizeScaleSizes SSC1, SizeScaleSizes SSC2 ' +
                   'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                   'AND TI.WeekNo = ' + WeekNo + ' AND TI.SequenceNo = ' + SequenceNo + ' ' +
                   'AND PWK.Part = TTW.Part ' +
                   'AND PWK.WidthNo = W.No ' +
                   'AND SRLS.Relationship = PWK.SizeRelationship ' +
                   'AND SRLS.ShoeSize = TI.Size ' +
                   'AND SSC1.Scale = SRLS.Scale ' +
                   'AND SSC1.Size = SRLS.KnifeSize ' +
                   'AND SSC2.Scale = SSC1.Scale ' +
                   'AND SSC2.Seq = SSC1.Seq + PWK.SizeAdjustment ' +
                   'AND W.Width = TTW.Width ' +
                   'AND TI.SizeSeq <> 0 ' +
                   'AND TTW.Width = TI.Width ' +
                   'AND TI.Pairs > 0 ' +
                   'AND TTW.TicketNo NOT IN ' +
                   '  (SELECT TicketNo ' +
                   '   FROM TicketsSplitInput ' +
                   '   WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ') ' +
                   'GROUP BY TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SSC2.Seq, PWK.Knife, SSC2.Size;';     }

      if HaveMaster then
      begin
        SQLString := 'INSERT INTO TicketPairage ' +
                     'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SSC.Seq, PWK.Knife, SSC.Size, SUM(TI.Pairs * PWK.Frequency) ' +
                     'FROM TicketTicketsWidths TTW, TicketsInput TI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS, SizeRelationshipSizes SRLS2, SizeScaleSizes SSC ' +
                     'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                     'AND TI.WeekNo = ' + WeekNo + ' AND TI.SequenceNo = ' + SequenceNo + ' ' +
                     'AND PWK.Part = TTW.Part ' +
                     'AND PWK.WidthNo = W.No ' +
                     'AND SRLS.Relationship = PWK.SizeRelationship ' +
                     'AND SRLS.ShoeSize = TI.Size ' +
                     'AND SRLS2.Relationship = PWK.SizeRelationship ' +
                     'AND SRLS2.Seq = SRLS.Seq + PWK.SizeAdjustment ' +
                     'AND SSC.Scale = SRLS.Scale ' +
                     'AND SSC.Size = SRLS2.KnifeSize ' +
                     'AND W.Width = TTW.Width ' +
                     'AND TI.SizeSeq <> 0 ' +
                     'AND TTW.Width = TI.Width ' +
                     'AND TI.Pairs > 0';

        if SplitTickets then
          SQLString := SQLString +
                       ' AND TTW.TicketNo NOT IN ' +
                       '  (SELECT TicketNo ' +
                       '   FROM TicketsSplitInput ' +
                       '   WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ') ';

        SQLString := SQLString +
                     'GROUP BY TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SSC.Seq, PWK.Knife, SSC.Size;';

        qNewTickets.SQL.Add(SQLString);

        //Adds Pairage to '?' category where Size Adjustment takes us off the Size Scale (Either +/-)
        //For Pairage in TICKETSINPUT
    {    SQLString := 'INSERT INTO TicketPairage ' +
                     'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, -1 * (1000 + (SSC1.Seq + PWK.SizeAdjustment)), PWK.Knife, CONCAT(''? '', CONCAT(RTRIM(SSC1.Size), CONCAT('' + '', CONVERT(PWK.SizeAdjustment, SQL_CHAR)))), TI.Pairs ' +
                     'FROM TicketTicketsWidths TTW, TicketsInput TI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS, SizeScaleSizes SSC1 ' +
                     'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                     'AND TI.WeekNo = TTW.WeekNo AND TI.SequenceNo = TTW.SequenceNo ' +
                     'AND PWK.Part = TTW.Part ' +
                     'AND PWK.WidthNo = W.No ' +
                     'AND SRLS.Relationship = PWK.SizeRelationship ' +
                     'AND SRLS.ShoeSize = TI.Size ' +
                     'AND SSC1.Scale = SRLS.Scale ' +
                     'AND SSC1.Size = SRLS.KnifeSize ' +
                     'AND SSC1.Seq + PWK.SizeAdjustment NOT IN ' +
                     ' (SELECT Seq ' +
                     '  FROM SizeScaleSizes ' +
                     '  WHERE Scale = SSC1.Scale) ' +
                     'AND W.Width = TTW.Width ' +
                     'AND TI.SizeSeq <> 0 ' +
                     'AND TTW.Width = TI.Width ' +
                     'AND TI.Pairs > 0 ' +
                     'AND TTW.TicketNo NOT IN ' +
                     '  (SELECT TicketNo ' +
                     '   FROM TicketsSplitInput ' +
                     '   WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ');';  }

{
        SQLString := 'INSERT INTO TicketPairage ' +
                     'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, -1 * (1000 + (SRLS.Seq + PWK.SizeAdjustment)), PWK.Knife, CONCAT('' ? '', CONCAT(RTRIM(SRLS.ShoeSize), CONCAT('' + '', CONVERT(PWK.SizeAdjustment, SQL_CHAR)))), SUM(TI.Pairs) ' +
                     'FROM TicketTicketsWidths TTW, TicketsInput TI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS ' +
                     'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                     'AND TI.WeekNo = TTW.WeekNo AND TI.SequenceNo = TTW.SequenceNo ' +
                     'AND PWK.Part = TTW.Part ' +
                     'AND PWK.WidthNo = W.No ' +
                     'AND SRLS.Relationship = PWK.SizeRelationship ' +
                     'AND SRLS.ShoeSize = TI.Size ' +
                     'AND PWK.SizeAdjustment <> 0 ' +
                     'AND SRLS.Seq + PWK.SizeAdjustment NOT IN' +
                     ' (SELECT Seq ' +
                     '  FROM SizeRelationshipSizes ' +
                     '  WHERE Relationship = PWK.SizeRelationship) ' +
                     'AND W.Width = TTW.Width ' +
                     'AND TI.SizeSeq <> 0 ' +
                     'AND TTW.Width = TI.Width ' +
                     'AND TI.Pairs > 0';
}

        SQLString := 'INSERT INTO TicketPairage ' +
                     'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, (SSC.Seq + PWK.SizeAdjustment), PWK.Knife, CONCAT(''?'', CONCAT(RTRIM(SRLS.ShoeSize), ' +
                     'IIF(PWK.SizeAdjustment < 0, CONVERT(PWK.SizeAdjustment, SQL_CHAR), CONCAT(''+'', CONVERT(PWK.SizeAdjustment, SQL_CHAR))))), SUM(TI.Pairs) ' +
                     'FROM TicketTicketsWidths TTW, TicketsInput TI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS, SizeScaleSizes SSC ' +
                     'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                     'AND TI.WeekNo = TTW.WeekNo AND TI.SequenceNo = TTW.SequenceNo ' +
                     'AND PWK.Part = TTW.Part ' +
                     'AND PWK.WidthNo = W.No ' +
                     'AND SRLS.Relationship = PWK.SizeRelationship ' +
                     'AND SRLS.ShoeSize = TI.Size ' +
                     'AND SSC.Scale = SRLS.Scale ' +
                     'AND SSC.Size = SRLS.KnifeSize ' +
                     'AND PWK.SizeAdjustment <> 0 ' +
                     'AND SRLS.Seq + PWK.SizeAdjustment NOT IN' +
                     ' (SELECT Seq ' +
                     '  FROM SizeRelationshipSizes ' +
                     '  WHERE Relationship = PWK.SizeRelationship) ' +
                     'AND W.Width = TTW.Width ' +
                     'AND TI.SizeSeq <> 0 ' +
                     'AND TTW.Width = TI.Width ' +
                     'AND TI.Pairs > 0';

        if SplitTickets then
          SQLString := SQLString +
                      ' AND TTW.TicketNo NOT IN ' +
                      '  (SELECT TicketNo ' +
                      '   FROM TicketsSplitInput' +
                      '   WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ')';

{
        SQLString := SQLString + ' GROUP BY TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SRLS.Seq, ' +
                                 'PWK.SizeAdjustment, PWK.Knife, SRLS.ShoeSize';
}
        SQLString := SQLString + ' GROUP BY TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, (SSC.Seq + PWK.SizeAdjustment), SRLS.Seq, ' +
                                 'PWK.SizeAdjustment, PWK.Knife, SRLS.ShoeSize';

        SQLString := SQLString + ';';

        qNewTickets.SQL.Add(SQLString);

        SQLString := 'SELECT DISTINCT PWK.Part, PWK.Knife, W.Width, SRLS.ShoeSize, PWK.SizeAdjustment, TI.Pairs ' +
                     'FROM TicketTicketsWidths TTW, TicketsInput TI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS ' +
                     'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                     'AND TI.WeekNo = TTW.WeekNo AND TI.SequenceNo = TTW.SequenceNo ' +
                     'AND PWK.Part = TTW.Part ' +
                     'AND PWK.WidthNo = W.No ' +
                     'AND SRLS.Relationship = PWK.SizeRelationship ' +
                     'AND SRLS.ShoeSize = TI.Size ' +
                     'AND PWK.SizeAdjustment <> 0 ' +
                     'AND SRLS.Seq + PWK.SizeAdjustment NOT IN' +
                     ' (SELECT Seq ' +
                     '  FROM SizeRelationshipSizes ' +
                     '  WHERE Relationship = PWK.SizeRelationship) ' +
                     'AND W.Width = TTW.Width ' +
                     'AND TI.SizeSeq <> 0 ' +
                     'AND TTW.Width = TI.Width ' +
                     'AND TI.Pairs > 0';

        if SplitTickets then
          SQLString := SQLString +
                       ' AND TTW.TicketNo NOT IN ' +
                       '  (SELECT TicketNo ' +
                       '   FROM TicketsSplitInput' +
                       '   WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ')';
//        else
//          SQLString := SQLString + ';';

        qInvalidTickets.SQL.Add(SQLString);

    {    SQLString := 'INSERT INTO TicketPairage ' +
                     'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SSC2.Seq, PWK.Knife, SSC2.Size, SUM(TSI.Pairs * PWK.Frequency) ' +
                     'FROM TicketTicketsWidths TTW, TicketsSplitInput TSI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS, SizeScaleSizes SSC1, SizeScaleSizes SSC2 ' +
                     'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                     'AND TSI.WeekNo = TTW.WeekNo AND TSI.SequenceNo = TTW.SequenceNo AND TSI.TicketNo = TTW.TicketNo ' +
                     'AND PWK.Part = TTW.Part ' +
                     'AND PWK.WidthNo = W.No ' +
                     'AND SRLS.Relationship = PWK.SizeRelationship ' +
                     'AND SRLS.ShoeSize = TSI.Size ' +
                     'AND SSC1.Scale = SRLS.Scale ' +
                     'AND SSC1.Size = SRLS.KnifeSize ' +
                     'AND SSC2.Scale = SSC1.Scale ' +
                     'AND SSC2.Seq = SSC1.Seq + PWK.SizeAdjustment ' +
                     'AND W.Width = TTW.Width ' +
                     'AND TSI.SizeSeq <> 0 ' +
                     'AND TTW.Width = TSI.Width ' +
                     'AND TSI.Pairs > 0 ' +
                     'GROUP BY TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SSC2.Seq, PWK.Knife, SSC2.Size;';
    }
        if SplitTickets then
        begin
          SQLString := 'INSERT INTO TicketPairage ' +
                       'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SSC.Seq, PWK.Knife, SSC.Size, SUM(TSI.Pairs * PWK.Frequency) ' +
                       'FROM TicketTicketsWidths TTW, TicketsSplitInput TSI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS, SizeRelationshipSizes SRLS2, SizeScaleSizes SSC ' +
                       'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                       'AND TSI.WeekNo = TTW.WeekNo AND TSI.SequenceNo = TTW.SequenceNo AND TSI.TicketNo = TTW.TicketNo ' +
                       'AND PWK.Part = TTW.Part ' +
                       'AND PWK.WidthNo = W.No ' +
                       'AND SRLS.Relationship = PWK.SizeRelationship ' +
                       'AND SRLS.ShoeSize = TSI.Size ' +
                       'AND SRLS2.Relationship = PWK.SizeRelationship ' +
                       'AND SRLS2.Seq = SRLS.Seq + PWK.SizeAdjustment ' +
                       'AND SSC.Scale = SRLS.Scale ' +
                       'AND SSC.Size = SRLS2.KnifeSize ' +
                       'AND W.Width = TTW.Width ' +
                       'AND TSI.SizeSeq <> 0 ' +
                       'AND TTW.Width = TSI.Width ' +
                       'AND TSI.Pairs > 0 ' +
                       'GROUP BY TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SSC.Seq, PWK.Knife, SSC.Size;';

          qNewTickets.SQL.Add(SQLString);

          //Adds Pairage to '?' category where Size Adjustment takes us off the Size Scale (Either +/-)
          //For Pairage in TICKETSSPLITINPUT
      {    SQLString := 'INSERT INTO TicketPairage ' +
                       'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, -1 * (1000 + (SSC1.Seq + PWK.SizeAdjustment)), PWK.Knife, CONCAT(''? '', CONCAT(RTRIM(SSC1.Size), CONCAT('' + '', CONVERT(PWK.SizeAdjustment, SQL_CHAR)))), TSI.Pairs ' +
                       'FROM TicketTicketsWidths TTW, TicketsSplitInput TSI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS, SizeScaleSizes SSC1 ' +
                       'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                       'AND TSI.WeekNo = TTW.WeekNo AND TSI.SequenceNo = TTW.SequenceNo AND TSI.TicketNo = TTW.TicketNo ' +
                       'AND PWK.Part = TTW.Part ' +
                       'AND PWK.WidthNo = W.No ' +
                       'AND SRLS.Relationship = PWK.SizeRelationship ' +
                       'AND SRLS.ShoeSize = TSI.Size ' +
                       'AND SSC1.Scale = SRLS.Scale ' +
                       'AND SSC1.Size = SRLS.KnifeSize ' +
                       'AND SSC1.Seq + PWK.SizeAdjustment NOT IN ' +
                       ' (SELECT Seq ' +
                       '  FROM SizeScaleSizes ' +
                       '  WHERE Scale = SSC1.Scale) ' +
                       'AND W.Width = TTW.Width ' +
                       'AND TSI.SizeSeq <> 0 ' +
                       'AND TTW.Width = TSI.Width ' +
                       'AND TSI.Pairs > 0;';         }

{
          SQLString := 'INSERT INTO TicketPairage ' +
                       'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, -1 * (1000 + (SRLS.Seq + PWK.SizeAdjustment)), PWK.Knife, CONCAT(''? '', CONCAT(RTRIM(SRLS.ShoeSize), CONCAT('' + '', CONVERT(PWK.SizeAdjustment, SQL_CHAR)))), SUM(TSI.Pairs) ' +
                       'FROM TicketTicketsWidths TTW, TicketsSplitInput TSI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS ' +
                       'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                       'AND TSI.WeekNo = TTW.WeekNo AND TSI.SequenceNo = TTW.SequenceNo AND TSI.TicketNo = TTW.TicketNo ' +
                       'AND PWK.Part = TTW.Part ' +
                       'AND PWK.WidthNo = W.No ' +
                       'AND SRLS.Relationship = PWK.SizeRelationship ' +
                       'AND SRLS.ShoeSize = TSI.Size ' +
                       'AND PWK.SizeAdjustment <> 0 ' +
                       'AND SRLS.Seq + PWK.SizeAdjustment NOT IN' +
                       ' (SELECT Seq ' +
                       '  FROM SizeRelationshipSizes ' +
                       '  WHERE Relationship = PWK.SizeRelationship) ' +
                       'AND W.Width = TTW.Width ' +
                       'AND TSI.SizeSeq <> 0 ' +
                       'AND TTW.Width = TSI.Width ' +
                       'AND TSI.Pairs > 0 ' +
                       'GROUP BY TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, SRLS.Seq, ' +
                                'PWK.SizeAdjustment, PWK.Knife, SRLS.ShoeSize;';
}

          SQLString := 'INSERT INTO TicketPairage ' +
                       'SELECT TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, (SSC.Seq + PWK.SizeAdjustment), PWK.Knife, ' +
                       'IIF(PWK.SizeAdjustment < 0, CONVERT(PWK.SizeAdjustment, SQL_CHAR), CONCAT(''+'', CONVERT(PWK.SizeAdjustment, SQL_CHAR))))), SUM(TSI.Pairs) ' +
                       'FROM TicketTicketsWidths TTW, TicketsSplitInput TSI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS, SizeScaleSizes SSC ' +
                       'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                       'AND TSI.WeekNo = TTW.WeekNo AND TSI.SequenceNo = TTW.SequenceNo AND TSI.TicketNo = TTW.TicketNo ' +
                       'AND PWK.Part = TTW.Part ' +
                       'AND PWK.WidthNo = W.No ' +
                       'AND SRLS.Relationship = PWK.SizeRelationship ' +
                       'AND SRLS.ShoeSize = TSI.Size ' +
                       'AND SSC.Scale = SRLS.Scale ' +
                       'AND SSC.Size = SRLS.KnifeSize ' +
                       'AND PWK.SizeAdjustment <> 0 ' +
                       'AND SRLS.Seq + PWK.SizeAdjustment NOT IN' +
                       ' (SELECT Seq ' +
                       '  FROM SizeRelationshipSizes ' +
                       '  WHERE Relationship = PWK.SizeRelationship) ' +
                       'AND W.Width = TTW.Width ' +
                       'AND TSI.SizeSeq <> 0 ' +
                       'AND TTW.Width = TSI.Width ' +
                       'AND TSI.Pairs > 0 ' +
                       'GROUP BY TTW.WeekNo, TTW.SequenceNo, TTW.TicketNo, PWK.Seq, (SSC.Seq + PWK.SizeAdjustment), SRLS.Seq, ' +
                                'PWK.SizeAdjustment, PWK.Knife, SRLS.ShoeSize;';


          qNewTickets.SQL.Add(SQLString);

          SQLString := ' UNION SELECT DISTINCT PWK.Part, PWK.Knife, W.Width, SRLS.ShoeSize, PWK.SizeAdjustment, TSI.Pairs ' +
                       'FROM TicketTicketsWidths TTW, TicketsSplitInput TSI, PtWidKnf PWK, Widths W, SizeRelationshipSizes SRLS ' +
                       'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo + ' ' +
                       'AND TSI.WeekNo = TTW.WeekNo AND TSI.SequenceNo = TTW.SequenceNo AND TSI.TicketNo = TTW.TicketNo ' +
                       'AND PWK.Part = TTW.Part ' +
                       'AND PWK.WidthNo = W.No ' +
                       'AND SRLS.Relationship = PWK.SizeRelationship ' +
                       'AND SRLS.ShoeSize = TSI.Size ' +
                       'AND PWK.SizeAdjustment <> 0 ' +
                       'AND SRLS.Seq + PWK.SizeAdjustment NOT IN' +
                       ' (SELECT Seq ' +
                       '  FROM SizeRelationshipSizes ' +
                       '  WHERE Relationship = PWK.SizeRelationship) ' +
                       'AND W.Width = TTW.Width ' +
                       'AND TSI.SizeSeq <> 0 ' +
                       'AND TTW.Width = TSI.Width ' +
                       'AND TSI.Pairs > 0';

          qInvalidTickets.SQL.Add(SQLString);
        end;

        //Delete the -ve tickets that we make when we split.
        //Would expect to only have to delete from TicketTickets due to cascading
        //deletes but due to complex query within a transaction, if we don't delete
        //from TicketPairage and TicketTicketsWidths first then there are locking
        //problems when trying to delete from TicketTickets.
        SQLString := 'DELETE FROM TicketPairage ' +
                     'WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ' AND TicketNo < 0;';
        qNewTickets.SQL.Add(SQLString);
        SQLString := 'DELETE FROM TicketTicketsWidths ' +
                     'WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ' AND TicketNo < 0;';
        qNewTickets.SQL.Add(SQLString);
        SQLString := 'DELETE FROM TicketTickets ' +
                     'WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ' AND TicketNo < 0;';
        qNewTickets.SQL.Add(SQLString);

        qNewTickets.ExecSQL;

        qCheckFullSynthetics.SQL.Text := 'SELECT DISTINCT P.Code as PartCode, P.SizeScale, TP.KnifeCode, TP.Size ' +
                                         'FROM Styles S, ConParts CP, Parts P, PtWidKnf PWK, Knives K, TicketSequences TS, ' +
                                              'TicketPairage TP, TicketTickets TT ' +
                                         'WHERE TS.WeekNo = ' + WeekNo + ' AND TS.SequenceNo = ' + SequenceNo +
                                         '  AND TT.WeekNo = TS.WeekNo AND TT.SequenceNo = TS.SequenceNo AND ' +
                                         '      S.Style = TS.Style AND CP.Construction = S.CurrentCon AND ' +
                                         'P.Code = CP.Part AND PWK.Part = P.Code AND P.SLMAllowance = FALSE AND ' +
                                         'K.Code = PWK.Knife AND TP.WeekNo = TS.WeekNo AND TP.SequenceNo = TS.SequenceNo ' +
                                         'AND TP.TicketNo = TT.TicketNo ' +
                                         'AND (TT.MaterialType = ''R'' OR TT.MaterialType = ''S'') ' +
                                         'AND TP.KnifeCode = K.Code AND TP.Pairs > 0 AND ' +
                                         'TT.PartCode = P.Code AND ' +
                                         'NOT EXISTS (' +
                                         '	  SELECT LPP.KnifeSize ' +
                                         '		FROM LayplanPlans LPP, LayPlanSets LPS ' +
                                         '		WHERE LPP.KnifeSize = TP.Size AND TT.PartCode = P.Code AND LPP.KnifeCode = LPS.KnifeCode AND ' +
                                         '          LPP.KnifeSizeScale = LPS.KnifeSizeScale AND ' +
                                         '          LPP.KnifeSize = LPS.KnifeSize AND ' +
                                         '		  	  LPP.MaterialLength = LPS.MaterialLength AND ' +
                                         '			    LPP.MaterialWidth = LPS.MaterialWidth AND ' +
                                         '			    LPP.MaterialCutGap = LPS.MaterialCutGap AND ' +
                                         '  			  ((LPP.MaterialCodeRestrictive = LPS.MaterialCodeRestrictive) OR ' +
                                         '			     (LPP.MaterialCodeRestrictive IS NULL AND LPS.MaterialCodeRestrictive IS NULL)) AND ' +
                                         '          LPP.Seq = LPS.SelectedNo AND ' +
                                         '          LPS.KnifeCode = TP.KnifeCode AND ' +
                                         '		      LPS.KnifeSizeScale = P.SizeScale AND ' +
                                         '          LPS.MaterialLength = ROUND(IIF(TT.MaterialType = ''R'', ' + sRollLength + ', ' +
                                         '(TT.MaterialLength * (TT.MaterialUnitsToFeet / ' +
                                         'TT.MaterialSubUnitsPerUnit))) / (CONVERT(10, SQL_DOUBLE) / ' +
                                         'CONVERT(12000, SQL_DOUBLE)), 0) AND ' +
                                         '          LPS.MaterialWidth = ROUND(TT.MaterialWidth * (TT.MaterialUnitsToFeet / ' +
                                         'TT.MaterialSubUnitsPerUnit) / (CONVERT(10, SQL_DOUBLE) / ' +
                                         'CONVERT(12000, SQL_DOUBLE)), 0) AND ' +
                                         '          LPS.MaterialCutGap = TT.MaterialCutGap AND ' +
                                         '          ((TT.MaterialCutType <> ''R'' AND LPS.MaterialCodeRestrictive IS NULL) OR ' +
                                         '           (TT.MaterialCutType = ''R'' AND LPS.MaterialCodeRestrictive = TT.MaterialCode)) AND ' +
                                         '          LPP.SqFtPerPiece > 0 ' +
                                         ')';

        qInvalidTickets.Open;

        qNoSampleKnife.ParamByName('WeekNo').Value := StrToInt(WeekNo);
        qNoSampleKnife.ParamByName('SequenceNo').Value := StrToInt(SequenceNo);
        qNoSampleKnife.Open;

        MyMessage := '';

        //CJY: qInvalidTickets.FetchOptions.RecordCountMode set to cmTotal
        if qInvalidTickets.RecordCount > 0 then
        begin
          CreateComplete := False;
          qInvalidTickets.RecNo := 1; //CJY changed from qInvalidTickets.First
          qInvalidTickets.Prior; //CJY changed from qInvalidTickets.First
          //CJY: Would require qInvalidTickets.FetchOptions.RecordCountMode set to cmTotal
//        for i := 1 to qInvalidTickets.RecordCount do
          while not qInvalidTickets.Eof do
          begin
            MyMessage := MyMessage + 'Part: ' + qInvalidTickets.FieldByName('Part').Value +
                         '   Knife: ' + qInvalidTickets.FieldByName('Knife').Value +
                         '   Width: ' + qInvalidTickets.FieldByName('Width').Value +
                         '   Size: ' + qInvalidTickets.FieldByName('ShoeSize').Value +
                         '   Adjustment: ' + IntToStr(qInvalidTickets.FieldByName('SizeAdjustment').AsInteger) + #13;
            qInvalidTickets.Next;
          end;
        end
        //CJY: qNoSampleKnife.FetchOptions.RecordCountMode set to cmTotal
        else if qNoSampleKnife.RecordCount > 0 then
        begin
          MissingSampleKnife := True;
          CreateComplete := False;
          s := 'No Knife of Sample Size on ' + #13;
          qNoSampleKnife.RecNo := 1; //CJY changed from qNoSampleKnife.First
          qNoSampleKnife.Prior; //CJY changed from qNoSampleKnife.First
          //CJY: qNoSampleKnife.FetchOptions.RecordCountMode set to cmTotal
//        for i := 1 to qNoSampleKnife.RecordCount do
          while not qNoSampleKnife.Eof do
          begin
            s := s + '   Part: ' + qNoSampleKnife.FieldByName('Part').Value +
                     '   Width: ' + qNoSampleKnife.FieldByName('Width').Value +
                     '   Knife: ' + qNoSampleKnife.FieldByName('Knife').Value + #13;
            qNoSampleKnife.Next;
          end;
          s := s + #13 + 'Ticket creation aborted.';
          MessageDlgPos(s, mtError, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
        end
        else
        begin
          qCheckFullSynthetics.Open;
          //CJY: qCheckFullSynthetics.FetchOptions.RecordCountMode set to cmTotal
          if (not FromGroup) and (qCheckFullSynthetics.RecordCount > 0) then
          begin
            CreateComplete := False;
            SyntheticFailed := True;
            s := 'To create this Ticket layplans for the following ' + #13 + 'Knife/Size combinations are required: ' + #13;
            qCheckFullSynthetics.RecNo := 1; //CJY changed from qCheckFullSynthetics.First
            qCheckFullSynthetics.Prior; //CJY changed from qCheckFullSynthetics.First
            while not qCheckFullSynthetics.Eof do
            begin
              s := s + #13 + 'Part: ' + qCheckFullSyntheticsPartCode.Value + '  Knife: ' +
                qCheckFullSyntheticsKnifeCode.Value + '  Size: ' + qCheckFullSyntheticsSize.Value;
              qCheckFullSynthetics.Next;
            end;

            MessageDlgPos(s, mtError, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
          end
          else
          begin
            CreateComplete := True;
            SyntheticFailed := False;
          end;
        end;

        qInvalidTickets.Close;
        qNoSampleKnife.Close;

        if (not SyntheticFailed) and (not CreateComplete) and (not MissingSampleKnife)  then
          CreateComplete := (MessageDlgPos('Ticket(s) Invalid.' + #13#13 + MyMessage + #13 +
                                        'Abort creation?', mtWarning, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrNo);

        if CreateComplete then
        begin
          CreateComplete := False;

          //----------------------------------------------------------------------------
          //Calculate allowances based on Average Size for Ticket weighted by pairage

          qNewTickets.SQL.Clear;

          qWhatTickets.ParamByName('WeekNo').AsInteger := StrToInt(WeekNo);
          qWhatTickets.ParamByName('SequenceNo').AsInteger := StrToInt(SequenceNo);

          qWhatTickets.Open;

          //CJY: qWhatTickets.FetchOptions.RecordCountMode set to cmTotal
          SetLength(Ints4Ticket, qWhatTickets.RecordCount + 2);  //+2 because TicketNo starts at 1 and can exceed qWhatTickets.RecordCount by 1.

          qWhatTickets.RecNo := 1; //CJY changed from qWhatTickets.First
          qWhatTickets.Prior; //CJY changed from qWhatTickets.First
          //CJY: qWhatTickets.FetchOptions.RecordCountMode set to cmTotal
//        for i := 1 to qWhatTickets.RecordCount do
          while not qWhatTickets.Eof do
          begin
            sTicketNo := IntToStr(qWhatTicketsTicketNo.Value);

            if qWhatTicketsSLMAllowance.Value then
            begin
              qGetAverageSizes.ParamByName('WeekNo').AsInteger := StrToInt(WeekNo);
              qGetAverageSizes.ParamByName('SequenceNo').AsInteger := StrToInt(SequenceNo);
              qGetAverageSizes.ParamByName('TicketNo').AsInteger := qWhatTicketsTicketNo.Value;
              qGetAverageSizes.Open;

              Allowance := AllowanceTicket;
              sBasicAllowance := FloatToStr(Allowance.BasicAllowance);

              Ints4Ticket[qWhatTicketsTicketNo.Value].AdjInterlocks := Allowance.AdjInterlocks;
              Ints4Ticket[qWhatTicketsTicketNo.Value].Part := qGetAverageSizesPartCode.value;
              Ints4Ticket[qWhatTicketsTicketNo.Value].WidthNo := qGetAverageSizesWidthNo.value;

              //Set the BasicAllowance
              SQLString := 'UPDATE TicketTickets SET BasicAllowance = ' + sBasicAllowance +
                           ' WHERE SLMAllowance = TRUE AND WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo +
                           ' AND TicketNo = ' + sTicketNo + ';';

              qNewTickets.SQL.Add(SQLString);

              //Set the Adjusted Allowance to be the Allowance for the Quality/Area for the Material on the Ticket
              SQLString := 'UPDATE TicketTickets SET AdjustedAllowance = ' +
                           ' (BasicAllowance * ' +
                           ' (100.0 / CONVERT(MaterialAreaCoeff, SQL_DOUBLE)) * ' +
                           ' (100.0 / (MaterialQualCoeff + (CONVERT(AdjFactorResult * (100.0 - MaterialQualCoeff), SQL_DOUBLE) / 15.0)))) ' +
                           'WHERE SLMAllowance = TRUE AND WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo +
                           ' AND TicketNo = ' + sTicketNo + ';';

              qNewTickets.SQL.Add(SQLString);

              SQLString := 'UPDATE TicketTickets SET CostedResult = ' +
                           '((CostedAllowance * TotalPairs) / (MaterialUnitsToFeet * MaterialUnitsToFeet))' +
                           'WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ' AND TicketNo = ' + sTicketNo + ';';

              qNewTickets.SQL.Add(SQLString);

              SQLString := 'UPDATE TicketTickets SET IssuedAllowance = ' +
//                           '(AdjustedAllowance * TotalPairs) / (MaterialUnitsToFeet * MaterialUnitsToFeet) ' +
                           '(TotalPairs * AdjustedAllowance / (MaterialUnitsToFeet * MaterialUnitsToFeet)) ' +
                           'WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ' AND TicketNo = ' + sTicketNo +
                           ' AND SLMAllowance = TRUE;';

              qNewTickets.SQL.Add(SQLString);
              qGetAverageSizes.Close;
            end
            else
            begin
              if Option_CuttingTimes then
              begin
                qGetAverageSizes.ParamByName('WeekNo').AsInteger := StrToInt(WeekNo);
                qGetAverageSizes.ParamByName('SequenceNo').AsInteger := StrToInt(SequenceNo);
                qGetAverageSizes.ParamByName('TicketNo').AsInteger := qWhatTicketsTicketNo.Value;
                qGetAverageSizes.Open;
              //Note - this is only called here to get the proper result for AdjInterlocks.  It is ONLY used for Times.
                Allowance := AllowanceTicket;

                Ints4Ticket[qWhatTicketsTicketNo.Value].AdjInterlocks := Allowance.AdjInterlocks;
                Ints4Ticket[qWhatTicketsTicketNo.Value].Part := qGetAverageSizesPartCode.value;
                Ints4Ticket[qWhatTicketsTicketNo.Value].WidthNo := qGetAverageSizesWidthNo.value;
                qGetAverageSizes.Close;
              end;

              //Set the BasicAllowance
              SQLString := 'UPDATE TicketTickets SET BasicAllowance = 0, AdjustedAllowance = 0' +
                           ' WHERE SLMAllowance = FALSE AND WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo +
                           ' AND TicketNo = ' + sTicketNo + ';';

              qNewTickets.SQL.Add(SQLString);

              SQLString := 'UPDATE TicketTickets SET CostedResult = ' +
                           '(CostedAllowance * TotalPairs) / (MaterialUnitsToFeet * MaterialUnitsToFeet) ' +
                           'WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ' AND TicketNo = ' + sTicketNo + ';';

              qNewTickets.SQL.Add(SQLString);

              SQLString := 'UPDATE TicketTickets SET IssuedAllowance = ' +
//                           '(SELECT SUM(TP.Pairs * PWK.Frequency * ((L.SqFtPerPiece / KS.Pieces)/ (TT.MaterialUnitsToFeet * TT.MaterialUnitsToFeet)) * 2) ' +
                           '(SELECT SUM(TP.Pairs * ((LPP.SqFtPerPiece / KS.Pieces) / (TT.MaterialUnitsToFeet ' +
                           '* TT.MaterialUnitsToFeet)) * IIF(P.MadeInPairs = True, 2, 1)) ' +
                           'FROM TicketTickets TT, TicketPairage TP, PtWidKnf PWK, Parts P, LayplanPlans LPP, LayPlanSets LPS, KnifeSets KS ' +
                           'WHERE TT.WeekNo = ' + WeekNo + ' AND TT.SequenceNo = ' + SequenceNo + ' AND TT.TicketNo = ' + sTicketNo +
                           '      AND TP.WeekNo = TT.WeekNo AND TP.SequenceNo = TT.SequenceNo AND TP.TicketNo = TT.TicketNo AND ' +
                           '      PWK.Part = TT.PartCode AND ' +
                           '      PWK.WidthNo = (SELECT MIN(W.No) ' +
                           '                     FROM TicketTicketsWidths TTW, Widths W ' +
                           '                     WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo +
                           '                           AND TTW.TicketNo = ' + sTicketNo + ' AND W.Width = TTW.Width) AND ' +
                           '      PWK.Knife = TP.KnifeCode AND P.Code = PWK.Part AND ' +
                           '      KS.Code = PWK.Knife AND ' +
                           '      LPP.KnifeCode = LPS.KnifeCode AND ' +
                           '      LPP.KnifeSizeScale = LPS.KnifeSizeScale AND ' +
                           '      LPP.KnifeSize = LPS.KnifeSize AND ' +
                           '   	  LPP.MaterialLength = LPS.MaterialLength AND ' +
                           '		  LPP.MaterialWidth = LPS.MaterialWidth AND ' +
                           '		  LPP.MaterialCutGap = LPS.MaterialCutGap AND ' +
                           '  		((LPP.MaterialCodeRestrictive = LPS.MaterialCodeRestrictive) OR ' +
                           '		   (LPP.MaterialCodeRestrictive IS NULL AND LPS.MaterialCodeRestrictive IS NULL)) AND ' +
                           '      LPP.Seq = LPS.SelectedNo AND ' +
                           '      LPS.KnifeCode = PWK.Knife AND ' +
                           '      LPS.KnifeSizeScale = TT.SizeScale AND ' +
                           '      LPS.KnifeSize = TP.Size AND ' +
                           '      LPS.MaterialLength = ROUND(IIF(TT.MaterialType = ''R'', ' + sRollLength + ', ' +
                           '(TT.MaterialLength * (TT.MaterialUnitsToFeet / TT.MaterialSubUnitsPerUnit))) / ' +
                           '(CONVERT(10, SQL_DOUBLE) / CONVERT(12000, SQL_DOUBLE)), 0) AND ' +
                           '      LPS.MaterialWidth = ROUND(TT.MaterialWidth * (TT.MaterialUnitsToFeet / ' +
                           'TT.MaterialSubUnitsPerUnit) / (CONVERT(10, SQL_DOUBLE) ' +
                           '/ CONVERT(12000, SQL_DOUBLE)), 0) AND LPS.MaterialCutGap = TT.MaterialCutGap AND ' +
                           '      ((TT.MaterialCutType <> ''R'' AND LPS.MaterialCodeRestrictive IS NULL) OR ' +
                           '       (TT.MaterialCutType = ''R'' AND LPS.MaterialCodeRestrictive = TT.MaterialCode))) ' +
                           'WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ' AND TicketNo = ' + sTicketNo +
                           '      AND SLMAllowance = FALSE; ' +

//We have calculate the exact allowance (IssuedAllowance).  Now we make The equivalent of the old average size
//BasicAllowance by dividing IssuedAllowance by TotalPairs.  This is the figure (multiplied by TotalPairs) which
//is displayed on the Ticket.  BasicAllowance is also used in the Times calculations.
//Note BasicAllowance & AdjustedAllowance must remain in sq units for times.

                           'UPDATE TicketTickets SET BasicAllowance = IssuedAllowance * (MaterialUnitsToFeet * MaterialUnitsToFeet) / TotalPairs, ' +
                           'AdjustedAllowance = IssuedAllowance * (MaterialUnitsToFeet * MaterialUnitsToFeet) / TotalPairs ' +
                           'WHERE WeekNo = ' + WeekNo + ' AND SequenceNo = ' + SequenceNo + ' AND TicketNo = ' + sTicketNo +
                           '      AND SLMAllowance = FALSE; ';

              qNewTickets.SQL.Add(SQLString);
            end;
            qWhatTickets.Next;
          end;

          qWhatTickets.Close;
          qNewTickets.ExecSQL;

          //----------------------------------------------------------------------------
          //Read TicketTickets to find Tickets Created and Calculate Times

          if Option_CuttingTimes then
          begin
            qTicketTimes.SQL.Clear;

            qGetData.ParamByName('WeekNo').AsInteger := StrToInt(WeekNo);
            qGetData.ParamByName('SequenceNo').AsInteger := StrToInt(SequenceNo);

            qGetData.open;
            qGetData.RecNo := 1; //CJY changed from qGetData.First
            qGetData.Prior; //CJY changed from qGetData.First

            //CJY: qGetData.FetchOptions.RecordCountMode set to cmTotal
            LoopCount := qGetData.RecordCount;

            for i := 1 to LoopCount do
            begin
              qGetData.Filter := 'TicketNo = ' + IntToStr(i);
              qGetData.Filtered := TRUE;

              Ints4Ticket[1].Sizes := qGetData.FieldByName('Sizes').value;

              //Calculate Full Batches and any remainder for possible smaller batch
              FullBatches := qGetData.FieldByName('UnitsPerJob').value div qGetData.FieldByName('StdBatchSize').value;
              SmallBatch := qGetData.FieldByName('UnitsPerJob').value mod qGetData.FieldByName('StdBatchSize').value;

              //CJY: If CalculateAllTimes finds a min/max error note Error
              dmTimes.CalculateAllTimes(TRUE, qGetData.FieldByName('StdBatchSize').value, qGetData, qTimesGridFullBatch, LoopCount, Dummy, Ints4Ticket, FALSE);
              FullBatchError := dmCutUtils.MessageShown;

              qTimesGridFullBatch.open;

              //...time for Smaller batch
              if SmallBatch > 0 then
              begin
              //CJY: If CalculateAllTimes finds a min/max error note Error
                dmTimes.CalculateAllTimes(TRUE, SmallBatch, qGetData, qTimesGridSmallBatch, LoopCount, Dummy, Ints4Ticket, FALSE);
                SmallBatchError := dmCutUtils.MessageShown;

                qTimesGridSmallBatch.open;
                qTimesGridSmallBatch.RecNo := 1; //CJY changed from qTimesGridSmallBatch.First
                qTimesGridSmallBatch.Prior; //CJY changed from qTimesGridSmallBatch.First
              end;

              qTimesGridFullBatch.RecNo := 1; //CJY changed from qTimesGridFullBatch.First
              qTimesGridFullBatch.Prior; //CJY changed from qTimesGridFullBatch.First

              //CJY: qTimesGridFullBatch.FetchOptions.RecordCountMode set to cmTotal
              for j := 1 to qTimesGridFullBatch.RecordCount do
              begin
                //CJY: If CalculateAllTimes finds a min/max error set TotalTime = 0;
                if not FullBatchError then
                  TotalTime := qTimesGridFullBatch.FieldByName('Time').AsFloat * FullBatches//;
                else
                  TotalTime := 0;

                if SmallBatch > 0 then
                begin
                  //CJY: If CalculateAllTimes finds a min/max error set TotalTime = 0;
                  if not SmallBatchError then
                    TotalTime := TotalTime + qTimesGridSmallBatch.FieldByName('Time').AsFloat//;
                  else
                    TotalTime := 0;
                end;

                SQLString := 'INSERT INTO TicketTicketsTimes ' +
                             'VALUES (' + WeekNo + ', ' + SequenceNo + ', ' + IntToStr(qGetData.FieldByName('TicketNo').AsInteger) + ', ' + IntToStr(qTimesGridFullBatch.FieldByName('Coeff').AsInteger) + ', ' + FloatToStr(TotalTime) + ');';
                qTicketTimes.SQL.Add(SQLString);

                if SmallBatch > 0 then
                  qTimesGridSmallBatch.Next;

                qTimesGridFullBatch.Next;
              end;

              qTimesGridFullBatch.close;
              qTimesGridSmallBatch.close;

              SQLString := 'UPDATE TicketTickets SET SMVs = ' +
                           'TTT.Time ' +
                           'FROM TicketTickets TT INNER JOIN TicketTicketsTimes TTT ON ' +
                           'TTT.WeekNo = TT.WeekNo AND TTT.SequenceNo = TT.SequenceNo AND ' +
                           'TTT.TicketNo = TT.TicketNo AND TTT.Quality = TT.MaterialQualCoeff ' +
                           'WHERE TT.WeekNo = ' + WeekNo + ' AND TT.SequenceNo = ' + SequenceNo + ' AND TT.TicketNo = ' + IntToStr(qGetData.FieldByName('TicketNo').AsInteger) + ';';

              qTicketTimes.SQL.Add(SQLString);

              qGetData.Filtered := FALSE;
            end;

            qGetData.close;

            qTicketTimes.ExecSQL;
          end;
          //----------------------------------------------------------------------------
          CreateComplete := True;
          Result := True;
        end;
      end
      else
        MessageDlgPos('Part: ' + Tickets[i - 1].Part + ' has no Master' + #13#13 + 'Ticket creation aborted', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    end
    else if UnAssessed then
      MessageDlgPos('Zero Interlock Area on Knife ' + #13 + Knife + #13#13 + 'Ticket creation aborted', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else if LeatherWithCutGap then
      MessageDlgPos('Ticket is for Leather but Cut Gap on Knife ' + #13 + Knife + #13#13 + 'Ticket creation aborted', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
      MessageDlgPos('No Knives found.' + #13 + 'Check Construction.', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

  finally
    if CreateComplete then
    begin
      qNewTickets.Connection.Commit;
      Result := True;
    end
    else
    begin
//      qNewTickets.Connection.Rollback;  //FireDAC Advantage Rollback transaction within a Commit transaction issue
      if inTransaction then
      begin
        qNewTickets.Connection.RollbackRetaining;
        qNewTickets.Connection.Commit
      end
      else
        qNewTickets.Connection.Rollback;


      Result := False;
    end;

    InUse := false;
    if ChangedConnection then
      dmBasAll.RevertAllConnections();
  end;
end;

function TdmTicketsAll.AllowanceTicket: AllowanceResult;
var
  AreaCoeff, MatCode, MatType, NumKnives, PartCode, QualCoeff, sPatternRes, SQLString, WidthNoStr, WeekNo, SequenceNo,
  TicketNo: string;
  TempAlwRes: AllowanceResult;

  q: TFDQueryPlus;
  i: integer;

begin
  dmBasAll.PassAllowanceTicketQuery(qGetAverageSizes);

  //CJY: qGetAverageSizes.FetchOptions.RecordCountMode set to cmTotal
  NumKnives := IntToStr(qGetAverageSizes.RecordCount);
  MatType := qGetAverageSizes.FieldByName('MaterialType').AsString[1];
  AreaCoeff := IntToStr(qGetAverageSizes.FieldByName('MaterialAreaCoeff').Value);
  QualCoeff := IntToStr(qGetAverageSizes.FieldByName('MaterialQualCoeff').Value);

  PartCode := '''' + QS(qGetAverageSizes.FieldByName('PartCode').Value) + '''';
  MatCode := '''' + QS(qGetAverageSizes.FieldByName('MaterialCode').Value) + '''';

  WidthNoStr := IntToStr(qGetAverageSizes.FieldByName('WidthNo').Value);

  WeekNo := IntToStr(qGetAverageSizes.FieldByName('WeekNo').Value);
  SequenceNo := IntToStr(qGetAverageSizes.FieldByName('SequenceNo').Value);
  TicketNo := IntToStr(qGetAverageSizes.FieldByName('TicketNo').Value);

  sPatternRes := 'CONVERT(' + IntToStr(PATTERNRES) +', SQL_DOUBLE)';

  if ((MatType = 'S') or (MatType = 'R')) and not qGetAverageSizes.FieldByName('SLMAllowance').Value then
  begin
    SQLString := 'SELECT PWK.Seq, PWK.Knife, SUM(PWK.Frequency) as Frequency, COUNT(PWK.WidthNo) as NumWidths, ' +
                  NumKnives + ' AS NumberOfKnives, ''' + MatType + ''' AS MatType, ' +
                  AreaCoeff + ' AS AreaCoeff, ' + QualCoeff + ' AS QualCoeff, False as SLMAllowance, (' +
                 '   SELECT LPP.SqFtPerPiece ' +
                 ' 	 FROM LayplanPlans LPP, LayPlanSets LPS ' +
                 '	 WHERE LPP.KnifeCode = LPS.KnifeCode AND ' +
                 '         LPP.KnifeSizeScale = LPS.KnifeSizeScale AND ' +
                 '         LPP.KnifeSize = LPS.KnifeSize AND ' +
                 '	  		 LPP.MaterialLength = LPS.MaterialLength AND ' +
                 '		 	   LPP.MaterialWidth = LPS.MaterialWidth AND ' +
                 '			   LPP.MaterialCutGap = LPS.MaterialCutGap AND ' +
                 '  			 ((LPP.MaterialCodeRestrictive = LPS.MaterialCodeRestrictive) OR ' +
                 '			    (LPP.MaterialCodeRestrictive IS NULL AND LPS.MaterialCodeRestrictive IS NULL)) AND ' +
                 '         LPP.Seq = LPS.SelectedNo AND ' +
                 '         LPS.KnifeCode = PWK.Knife AND ' +
                 '         LPS.KnifeSizeScale = SSS.Scale AND ' +
                 '         LPS.KnifeSize = SSS.Size AND ' +
                 '         LPS.MaterialLength = ROUND(IIF(M.Type = ''R'', ' + FloatToStr(ROLLLENGTH_FT) +
                 ', (M.Length * (MU.ToFeet / MU.SubUnitsPerUnit))) / (' + sPatternRes +
                 ' / CONVERT(12000, SQL_DOUBLE)), 0) AND ' +
                 '         LPS.MaterialWidth = ROUND(M.Width * (MU.ToFeet / MU.SubUnitsPerUnit) / (' + sPatternRes +
                 ' / CONVERT(12000, SQL_DOUBLE)), 0) AND ' +
                 '         LPS.MaterialCutGap = M.CutGap AND ' +
                 '         ((M.CutType <> ''R'' AND LPS.MaterialCodeRestrictive IS NULL) OR ' +
               	 '          (M.CutType = ''R'' AND LPS.MaterialCodeRestrictive = M.Code)) AND ' +
                 '         M.Code = ' + MatCode + ' AND ' +
                 '         MU.Code = M.Units) as SqFtPerPiece, ' +
                 'P.SampleSize AS ShoeSize, P.MadeInPairs, KS.Type AS KnifeType, KS.CutGap as KnifeCutGap, K.InterlockAreaPrimeSynthetic, ' +
                 'K.InterlockAreaNonPrime, KS.Pieces, K.GrossArea, K.NettArea, MU.ToFeet, MU.SubUnitsPerUnit, M.SkinSize, ' +
	                'M.Length AS MatLength, M.Width AS MatWidth, M.CutType, M.Trimmed, M.SheetCutFromRoll, M.LinearAllowance, SSS.Length AS SampleSizeMm, ' +
                 'PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BAQuadraticC ' +
           'FROM PtWidKnf PWK, Parts P, Knives K, KnifeSets KS, MatUnits MU, Material M, SizeScaleSizes SSS, Params PM ' +
           'WHERE P.Code = ' + PartCode + ' AND M.Code = ' + MatCode + ' AND PWK.Part = P.Code AND ' +
                 'K.Code = PWK.Knife AND K.SizeScale = KS.SizeScale AND KS.Code = PWK.Knife AND MU.Code = M.Units AND ' +
                 'SSS.Scale = P.SizeScale AND SSS.Size = P.SampleSize AND PWK.WidthNo IN ' +
                   '(SELECT W.No ' +
                   'FROM TicketTicketsWidths TTW, Widths W ' +
                    'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo +
                   ' AND TTW.TicketNo = ' + TicketNo + ' AND W.Width = TTW.Width) ' +
           'GROUP BY PWK.Seq, PWK.Knife, P.SampleSize, P.MadeInPairs, KS.Type, KS.CutGap, K.InterlockAreaPrimeSynthetic, ' +
                 'K.InterlockAreaNonPrime, KS.Pieces, K.GrossArea, K.NettArea, MU.ToFeet, MU.SubUnitsPerUnit, ' +
 	               'M.SkinSize, M.Length, M.Width, M.CutType, M.Trimmed, M.SheetCutFromRoll, M.LinearAllowance, SSS.Length, ' +
                 'PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BAQuadraticC, SqFtPerPiece ' +
           'Order By PWK.Seq, PWK.Seq';

    qBAForTickets.SQL.Clear;
    qBAForTickets.SQL.Add(SQLString);
    qBAForTickets.Open;
    qBAForTickets.RecNo := 1; //CJY changed from qBAForTickets.First
    qBAForTickets.Prior; //CJY changed from qBAForTickets.First

    TempAlwRes := dmBasAll.Allowances(PartCode, MatCode, StrToInt(WidthNoStr), False, False, True, qBAForTickets);

//    TempAlwRes.BasicAllowance := TempAlwRes.BasicAllowance / qBAForTicketsNumWidths.Value;
//    TempAlwRes.AdjustedAllowance := TempAlwRes.AdjustedAllowance / qBAForTicketsNumWidths.Value;
//    TempAlwRes.SampleSyntheticBasicAllowance := TempAlwRes.SampleSyntheticBasicAllowance / qBAForTicketsNumWidths.Value;

    Result := TempAlwRes;

    qBAForTickets.Close;
  end
  else
  begin
    SQLString := 'SELECT PWK.Seq, PWK.Knife, SUM(PWK.Frequency) as Frequency, COUNT(PWK.WidthNo) as NumWidths, ' + NumKnives + ' AS NumberOfKnives, ''' + MatType + ''' AS MatType, ' +
                  AreaCoeff + ' AS AreaCoeff, ' + QualCoeff + ' AS QualCoeff, True as SLMAllowance, ' +
                 'CONVERT(0, SQL_DOUBLE) as SqFtPerPiece, P.SampleSize AS ShoeSize, P.MadeInPairs, KS.Type AS KnifeType, KS.CutGap as KnifeCutGap, K.InterlockAreaPrimeSynthetic, ' +
                 'K.InterlockAreaNonPrime, KS.Pieces, K.GrossArea, K.NettArea, MU.ToFeet, MU.SubUnitsPerUnit, M.SkinSize, ' +
 	               'M.Length AS MatLength, M.Width AS MatWidth, M.CutType, M.Trimmed, M.SheetCutFromRoll, M.LinearAllowance, SSS.Length AS SampleSizeMm, ' +
                 'PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BAQuadraticC ' +
           'FROM PtWidKnf PWK, Parts P, Knives K, KnifeSets KS, MatUnits MU, Material M, SizeScaleSizes SSS, Params PM ' +
           'WHERE P.Code = ' + PartCode + ' AND M.Code = ' + MatCode + ' AND PWK.Part = P.Code AND ' +
                 'K.Code = PWK.Knife AND K.MeasuredSize = P.SampleSize AND KS.Code = PWK.Knife AND MU.Code = M.Units AND ' +
                 'SSS.Scale = P.SizeScale AND SSS.Size = P.SampleSize AND PWK.WidthNo IN ' +
                   '(SELECT W.No ' +
                   'FROM TicketTicketsWidths TTW, Widths W ' +
                   'WHERE TTW.WeekNo = ' + WeekNo + ' AND TTW.SequenceNo = ' + SequenceNo +
                   ' AND TTW.TicketNo = ' + TicketNo + ' AND W.Width = TTW.Width)' +
           'GROUP BY PWK.Seq, PWK.Knife, P.SampleSize, P.MadeInPairs, KS.Type, KS.CutGap, K.InterlockAreaPrimeSynthetic, ' +
                 'K.InterlockAreaNonPrime, KS.Pieces, K.GrossArea, K.NettArea, MU.ToFeet, MU.SubUnitsPerUnit, ' +
	               'M.SkinSize, M.Length, M.Width, M.CutType, M.Trimmed, M.SheetCutFromRoll, M.LinearAllowance, SSS.Length, ' +
                 'PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BAQuadraticC ' +
           'Order By PWK.Seq, PWK.Seq';

    qBAForTickets.SQL.Clear;
    qBAForTickets.SQL.Add(SQLString);
    qBAForTickets.Open;
    qBAForTickets.RecNo := 1; //CJY changed from qBAForTickets.First
    qBAForTickets.Prior; //CJY changed from qBAForTickets.First

    TempAlwRes := dmBasAll.Allowances(PartCode, MatCode, StrToInt(WidthNoStr), False, False, True, qBAForTickets);

    if qBAForTickets.RecordCount = 0 then ShowMessage(PartCode);

    TempAlwRes.BasicAllowance := TempAlwRes.BasicAllowance / qBAForTicketsNumWidths.Value;
    TempAlwRes.AdjustedAllowance := TempAlwRes.AdjustedAllowance / qBAForTicketsNumWidths.Value;
    TempAlwRes.SampleSyntheticBasicAllowance := TempAlwRes.SampleSyntheticBasicAllowance / qBAForTicketsNumWidths.Value;

    Result := TempAlwRes;

    qBAForTickets.Close;
  end;
end;


procedure TdmTicketsAll.FillCompareGrid(WeekNo, SequenceNo, Style : string);
var
  SQLString: string;

begin
  qFillCompareGrid.SQL.Text := 'DELETE FROM TicketsCompareGrid ' +
                               'WHERE Identifier = ''' + Identifier + ''' AND WeekNo = ' + WeekNo + ' AND SequenceNo = ' +
                                SequenceNo + ';';
  qFillCompareGrid.ExecSQL;

  qFillCompareGrid.SQL.Text := 'INSERT INTO TicketsCompareGrid ' +
                               'SELECT DISTINCT ''' + Identifier + ''' AS Identifier , ' + WeekNo + ' AS WeekNo, ' + SequenceNo +
                               ' AS SequenceNo, W.Width AS Width, SRS.Size AS Size, 0 AS Pairs, W.No AS WidthNo, SRS.Seq AS SizeSeq ' +
                               'FROM Widths W, WRngWs WRW, Parts P, ConParts CP, Styles S, SizeRangeSizes SRS, Construc C ' +
                               'WHERE W.No = WRW.WidthNo AND WRW.Range = P.WidthRange AND ' +
                                     'P.Code = CP.Part AND CP.Construction = S.CurrentCon AND ' +
                                     'SRS.Range = C.SizeRange AND C.Construction = S.CurrentCon AND ' +
                               'S.Style = ''' + QS(Style) + ''' AND ' +
                               'W.Width IN (SELECT W.Width ' +
                                           'FROM PtWidKnf PWK, Widths W, Parts P, WRngWs WRW ' +
                                           'WHERE PWK.Seq = 1 AND ' +
                                                 'PWK.Part IN (SELECT Part ' +
                                                              'FROM ConParts ' +
                                                              'WHERE Construction = (SELECT CurrentCon ' +
                                                                                    'FROM Styles ' +
                                                                                    'WHERE Style = ''' + QS(Style) + ''')) AND ' +
                                                 'P.Code = PWK.Part AND ' +
                                                 'WRW.Range = P.WidthRange AND ' +
                                                 'WRW.WidthNo = PWK.WidthNo AND '+
                                                 'PWK.WidthNo = W.No ' +
                                          'GROUP BY W.Width ' +
                                          'HAVING COUNT(*) = (SELECT COUNT(*) FROM ConParts ' +
                                                             'WHERE Construction = (SELECT CurrentCon ' +
                                                                                   'FROM Styles ' +
                                                                                   'WHERE Style = ''' + QS(Style) + '''))) ' +
                              'UNION ' +
                              'SELECT DISTINCT ''' + Identifier + ''' AS Identifier, ' + WeekNo + ' AS WeekNo, ' + SequenceNo +
                              ' AS SequenceNo, W.Width AS Width, ''AddWidth'' AS Size, 0 AS Pairs, W.No AS WidthNo, 0 AS SizeSeq ' +
                                 'FROM Widths W, WRngWs WRW, Parts P, ConParts CP, Styles S, SizeRangeSizes SRS, Construc C ' +
                                 'WHERE W.No = WRW.WidthNo AND WRW.Range = P.WidthRange AND ' +
                                 'P.Code = CP.Part AND CP.Construction = S.CurrentCon AND ' +
                                 'SRS.Range = C.SizeRange AND C.Construction = S.CurrentCon AND ' +
                                 'S.Style = ''' + QS(Style) + ''' AND ' +
                                 'W.Width IN (SELECT W.Width ' +
                                             'FROM PtWidKnf PWK, Widths W, Parts P, WRngWs WRW ' +
                                             'WHERE PWK.Seq = 1 AND ' +
                                                   'PWK.Part IN (SELECT Part ' +
                                                                'FROM ConParts ' +
                                                                'WHERE Construction = (SELECT CurrentCon ' +
                                                                                      'FROM Styles ' +
                                                                                      'WHERE Style = ''' + QS(Style) + ''')) AND ' +
                                                   'P.Code = PWK.Part AND ' +
                                                   'WRW.Range = P.WidthRange AND ' +
                                                   'WRW.WidthNo = PWK.WidthNo AND '+
                                                   'PWK.WidthNo = W.No ' +
                                            'GROUP BY W.Width ' +
                                            'HAVING COUNT(*) = (SELECT COUNT(*) FROM ConParts ' +
                                                               'WHERE Construction = (SELECT CurrentCon ' +
                                                                                     'FROM Styles ' +
                                                                                     'WHERE Style = ''' + QS(Style) + ''')));';

  qFillCompareGrid.ExecSQL;
end;

procedure TdmTicketsAll.SplitGoverned(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
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

        SplitTicketsProcedure(NegTicketNo, WeekNo, SequenceNo, SplitLimit, TicketNo, NumSizesOnTicket, Remainder,
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

procedure TdmTicketsAll.SplitNormal(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
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

      SplitTicketsProcedure(NegTicketNo, WeekNo, SequenceNo, SplitLimit, TicketNo, NumSizesOnTicket,
                   Remainder, Total, Splits);
    end;

    qGetSizePairs.Close;
  end;
end;

procedure TdmTicketsAll.SplitTicketsProcedure(NegTicketNo, WeekNo, SequenceNo, SplitLimit: integer;
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

procedure TdmTicketsAll.TicketUpdateCommonCreate;
var
  s: string;

begin
  //-------------------------
  // FORMULATE qUpdateTickets
  //-------------------------
  s :=
  'DELETE FROM TicketUpdateAudit ' +
  'WHERE Identifier = ''' + Identifier + ''';' + #13 +

  //Set Previous Actual Usage
  'UPDATE TU ' +
  'SET PreviousActualUsage = TT.ActualUsage ' +
  'FROM TicketUpdate TU, TicketTickets TT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo; ' + #13 +

  //Set Automatic Cutter Locations to equal actual... '
  'UPDATE TicketUpdate ' +
  'SET AutoCutterLocation = CutterLocation ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE;' + #13 +

  //...Fill in others with look ups. '
  'UPDATE TU ' +
  'SET AutoCutterLocation = C.Location ' +
  'FROM TicketUpdate TU, Cutters C ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TU.AutoCutterLocation IS NULL AND ' +
  '      C.Code = TU.Cutter; ' + #13 +

  //Set Automatic Material Price to equal actual... '
  'UPDATE TicketUpdate ' +
  'SET AutoMatPrice = MatPrice ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE; ' + #13 +

  //...Fill in others with look ups. '
  'UPDATE TU ' +
  'SET AutoMatPrice = MS.Price ' +
  'FROM TicketUpdate TU, TicketTickets TT, MatSupl MS ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TU.AutoMatPrice IS NULL AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      MS.Material = TT.MaterialCode AND ' +
  '      MS.Supplier = TU.MatSupplier; ' + #13 +

  //Set Automatic Issued Allowance to equal actual... '
  'UPDATE TicketUpdate ' +
  'SET AutoIssuedAllowance = IssuedAllowance ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE; ' + #13 +

  //...Fill in others with look ups. '
  'UPDATE TU ' +
  'SET AutoIssuedAllowance = (TT.BasicAllowance * ' +
  '                          (100 / CONVERT(TU.Area, SQL_DOUBLE)) * ' +                                                         //Area Adjustment
  '                          (100 / (TU.Quality + (TT.AdjFactorResult * (100 - TU.Quality) / CONVERT(15, SQL_DOUBLE)))) * ' +  //Quality Adjustment
  '                           TT.TotalPairs) / (TT.MaterialUnitsToFeet * TT.MaterialUnitsToFeet) ' +
  'FROM TicketUpdate TU, TicketTickets TT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TU.AutoIssuedAllowance IS NULL AND ' +
  '      TU.Quality IS NOT NULL AND ' +
  '      TU.Area IS NOT NULL AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo; ' + #13 +

  //Set Automatic SMVs to equal actual... '
  'UPDATE TicketUpdate ' +
  'SET AutoSMVs = SMVs ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE; ' + #13 +

  //...Fill in others with look ups. '
  'UPDATE TU ' +
  'SET AutoSMVs = TTT.Time ' +
  'FROM TicketUpdate TU, TicketTicketsTimes TTT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TU.AutoSMVs IS NULL AND ' +
  '      TTT.WeekNo = TU.WeekNo AND ' +
  '      TTT.SequenceNo = TU.SequenceNo AND ' +
  '      TTT.TicketNo = TU.TicketNo AND ' +
  '      TTT.Quality = TU.Quality; ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT Identifier, WeekNo, SequenceNo, TicketNo, 1, 1, ''Ticket does not exist'' ' +
  'FROM TicketUpdate ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE AND ' +
  '      ((WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) NOT IN ' +
  '        (SELECT ((WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) ' +
  '         FROM TicketTickets); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT Identifier, WeekNo, SequenceNo, TicketNo, 2, 1, ''Cutter '' + RTRIM(Cutter) + '' does not exist'' ' +
  'FROM TicketUpdate ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE AND ' +
  '      Cutter NOT IN ' +
  '      (SELECT Code ' +
  '       FROM Cutters); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT Identifier, WeekNo, SequenceNo, TicketNo, 3, 1, ''Cutter Location '' + RTRIM(CutterLocation) + '' does not exist'' ' +
  'FROM TicketUpdate ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE AND ' +
  '      CutterLocation NOT IN ' +
  '      (SELECT Code ' +
  '       FROM CutLocs); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT TU.Identifier, TU.WeekNo, TU.SequenceNo, TU.TicketNo, 4, 1, ''Ticket not yet printed'' ' +
  'FROM TicketUpdate TU, TicketTickets TT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      TT.Printed = FALSE; ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT TU.Identifier, TU.WeekNo, TU.SequenceNo, TU.TicketNo, 5, 1, ''Supplier '' + RTRIM(TU.MatSupplier) + '' does not exist for material '' + RTRIM(TT.MaterialCode) ' +
  'FROM TicketUpdate TU, TicketTickets TT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      (TT.MaterialCode + TU.MatSupplier) NOT IN ' +
  '        (SELECT (Material + Supplier) ' +
  '         FROM MatSupl, TicketTickets TT2 ' +
  '         WHERE TT2.WeekNo = TT.WeekNo AND ' +
  '               TT2.SequenceNo = TT.SequenceNo AND ' +
  '               TT2.TicketNo = TT.TicketNo AND ' +
  '               Material = TT2.MaterialCode); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT Identifier, WeekNo, SequenceNo, TicketNo, 6, 1, ''Requires both Quality/Area or neither'' ' +
  'FROM TicketUpdate ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE AND ' +
  '      ((Quality IS NULL) AND NOT (Area IS NULL)) OR ' +
  '      (NOT (Quality IS NULL) AND (Area IS NULL)); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT Identifier, WeekNo, SequenceNo, TicketNo, 7, 1, ''Does not require Issued Allowance and Quality/Area'' ' +
  'FROM TicketUpdate ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE AND ' +
  '      (NOT (Quality IS NULL) AND NOT (Area IS NULL)) AND ' +
  '      (NOT (IssuedAllowance IS NULL)); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT Identifier, WeekNo, SequenceNo, TicketNo, 8, 1, ''Does not require Sms and Quality/Area'' ' +
  'FROM TicketUpdate ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE AND ' +
  '      (NOT (Quality IS NULL) AND NOT (Area IS NULL)) AND ' +
  '      (NOT (SMVs IS NULL)); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT TU.Identifier, TU.WeekNo, TU.SequenceNo, TU.TicketNo, 9, 2, ''Cutter '' + RTRIM(TT.Cutter) + '' overwritten'' ' +
  'FROM TicketUpdate TU, TicketTickets TT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      (NOT TU.Cutter IS NULL) AND (NOT TT.Cutter IS NULL) AND ' +
  '      ((1 * 1000000000) + (TU.WeekNo * 1000000) + (TU.SequenceNo * 1000) + TU.TicketNo) NOT IN ' +
  '        (SELECT ((ErrorLevel * 1000000000) + (WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) ' +
  '         FROM TicketUpdateAudit ' +
  '         WHERE Identifier = ''' + Identifier + '''); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT TU.Identifier, TU.WeekNo, TU.SequenceNo, TU.TicketNo, 10, 2, ''Cutter Location '' + RTRIM(TT.CutterLocation) + '' overwritten'' ' +
  'FROM TicketUpdate TU, TicketTickets TT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      (NOT TU.AutoCutterLocation IS NULL) AND (NOT TT.CutterLocation IS NULL) AND ' +
  '      ((1 * 1000000000) + (TU.WeekNo * 1000000) + (TU.SequenceNo * 1000) + TU.TicketNo) NOT IN ' +
  '        (SELECT ((ErrorLevel * 1000000000) + (WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) ' +
  '         FROM TicketUpdateAudit ' +
  '         WHERE Identifier = ''' + Identifier + '''); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT TU.Identifier, TU.WeekNo, TU.SequenceNo, TU.TicketNo, 11, 2, ''Material Supplier '' + RTRIM(TT.MatSupplier) + '' overwritten'' ' +
  'FROM TicketUpdate TU, TicketTickets TT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      (NOT TU.MatSupplier IS NULL) AND (NOT TT.MatSupplier IS NULL) AND ' +
  '      ((1 * 1000000000) + (TU.WeekNo * 1000000) + (TU.SequenceNo * 1000) + TU.TicketNo) NOT IN ' +
  '        (SELECT ((ErrorLevel * 1000000000) + (WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) ' +
  '         FROM TicketUpdateAudit ' +
  '         WHERE Identifier = ''' + Identifier + '''); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT TU.Identifier, TU.WeekNo, TU.SequenceNo, TU.TicketNo, 12, 2, ''Actual Usage '' + RTRIM(CONVERT(TT.ActualUsage, SQL_CHAR)) + '' overwritten'' ' +
  'FROM TicketUpdate TU, TicketTickets TT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      (NOT TU.ActualUsage IS NULL) AND (NOT TT.ActualUsage IS NULL) AND ' +
  '      ((1 * 1000000000) + (TU.WeekNo * 1000000) + (TU.SequenceNo * 1000) + TU.TicketNo) NOT IN ' +
  '        (SELECT ((ErrorLevel * 1000000000) + (WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) ' +
  '         FROM TicketUpdateAudit ' +
  '         WHERE Identifier = ''' + Identifier + '''); ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT TU.Identifier, TU.WeekNo, TU.SequenceNo, TU.TicketNo, 13, 2, ''Difference too great ( > '' + RTRIM(CONVERT(P.AlwUseErrorCheck, SQL_CHAR)) + ''% )'' ' +
  'FROM TicketUpdate TU, TicketTickets TT, Params P ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      TU.ActualUsage IS NOT NULL AND ' +
  '      TU.AutoIssuedAllowance IS NOT NULL AND ' +
  '      ABS(IIF(TU.AutoIssuedAllowance = 0, 0, (TU.ActualUsage - TU.AutoIssuedAllowance) / TU.AutoIssuedAllowance * 100)) > P.AlwUseErrorCheck; ' + #13 +

  'INSERT INTO TicketUpdateAudit ' +
  'SELECT TU.Identifier, TU.WeekNo, TU.SequenceNo, TU.TicketNo, 14, 2, ''Nothing to update''' +
  'FROM TicketUpdate TU, TicketTickets TT, Params P ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      TU.CutWeek IS NULL AND ' +
  '      TU.Cutter IS NULL AND ' +
  '      TU.CutterLocation IS NULL AND ' +
  '      TU.MatSupplier IS NULL AND ' +
  '      TU.MatPrice IS NULL AND ' +
  '      TU.Quality IS NULL AND ' +
  '      TU.Area IS NULL AND ' +
  '      TU.ActualUsage IS NULL AND ' +
  '      TU.IssuedAllowance IS NULL AND ' +
  '      TU.SMVs IS NULL; ' + #13 +

  'UPDATE TT ' +
  'SET CutWeek = IIF(TU.CutWeek IS NULL, TT.CutWeek, TU.CutWeek), ' +
  '    Cutter = IIF(TU.Cutter IS NULL, TT.Cutter, TU.Cutter), ' +
  '    CutterLocation = IIF(TU.AutoCutterLocation IS NULL, TT.CutterLocation, TU.AutoCutterLocation), ' +
  '    MatSupplier = IIF(TU.MatSupplier IS NULL, TT.MatSupplier, TU.MatSupplier), ' +
  '    MatPrice = IIF(TU.AutoMatPrice IS NULL, TT.MatPrice, TU.AutoMatPrice), ' +
  '    Quality = IIF(TU.Quality IS NULL, TT.Quality, TU.Quality), ' +
  '    Area = IIF(TU.Area IS NULL, TT.Area, TU.Area), ' +
  '    ActualUsage = IIF(TU.ActualUsage IS NULL, TT.ActualUsage, TU.ActualUsage), ' +
  '    IssuedAllowance = IIF(TU.AutoIssuedAllowance IS NULL, TT.IssuedAllowance, TU.AutoIssuedAllowance), ' +
  '    SMVs = IIF(TU.AutoSMVs IS NULL, TT.SMVs, TU.AutoSMVs) ' +
  'FROM TicketTickets TT, TicketUpdate TU ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TU.WeekNo = TT.WeekNo AND ' +
  '      TU.SequenceNo = TT.SequenceNo AND ' +
  '      TU.TicketNo = TT.TicketNo AND ' +
  '      ((TT.WeekNo * 1000000) + (TT.SequenceNo * 1000) + TT.TicketNo) NOT IN ' +
  '        (SELECT ((WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) ' +
  '         FROM TicketUpdateAudit ' +
  '         WHERE Identifier = ''' + Identifier + ''' AND ' +
  '               ErrorLevel = 1); ';

  if Option_TicketAudit then
  begin
    s := s + #13 +
    'INSERT INTO Audit (Type, UserName, WeekNo, SequenceNo, TicketNo, TransactionDate, ' +
    '                   MaterialCode, Allowance, Construction, Part, TotalPairs, ' +
    '                   Usage, Amended) ' +
    'SELECT ''U'', ''' + QS(SystemUserName) + ''', TT.WeekNo, TT.SequenceNo, TT.TicketNo, CURRENT_DATE(), ' +
    '       TT.MaterialCode, TT.IssuedAllowance, TS.Construction, TT.PartCode, ' +
    '       TT.TotalPairs, TT.ActualUsage, IIF(TU.PreviousActualUsage <> 0, TRUE, FALSE) ' +
    'FROM TicketUpdate TU, TicketTickets TT, TicketSequences TS ' +
    'WHERE TT.WeekNo = TU.WeekNo AND ' +
    '      TT.SequenceNo = TU.SequenceNo AND ' +
    '      TT.TicketNo = TU.TicketNo AND ' +
    '      TS.WeekNo = TU.WeekNo AND ' +
    '      TS.SequenceNo = TU.SequenceNo AND ' +
    '      TU.Identifier = ''' + Identifier + ''' AND ' +
    '      TU.BulkUpdate = FALSE AND ' +
    '   	  (TU.ActualUsage IS NOT NULL) AND ((TU.ActualUsage <> TU.PreviousActualUsage) OR (TU.PreviousActualUsage IS NULL)) AND ' +
    '      ((1 * 1000000000) + (TU.WeekNo * 1000000) + (TU.SequenceNo * 1000) + TU.TicketNo) NOT IN ' +
    '        (SELECT ((ErrorLevel * 1000000000) + (WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) ' +
    '         FROM TicketUpdateAudit ' +
    '         WHERE Identifier = ''' + Identifier + '''); ';
  end;

  s := s + #13 +
  'DELETE FROM TicketUpdate ' +
  'WHERE Identifier = ''' + Identifier + ''' AND ' +
  '      BulkUpdate = FALSE AND ' +
  '      ((WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) NOT IN ' +
  '        (SELECT ((WeekNo * 1000000) + (SequenceNo * 1000) + TicketNo) ' +
  '         FROM TicketUpdateAudit ' +
  '         WHERE Identifier = ''' + Identifier + ''' AND ' +
  '               ErrorLevel = 1); ';

  qUpdateTickets.SQL.Text := s;

  //---------------------------
  // FORMULATE qClearBothTables
  //---------------------------
  s :=
  'DELETE FROM TicketUpdate ' +
  'WHERE Identifier = ''' + Identifier + ''';' + #13 +

  'DELETE FROM TicketUpdateAudit ' +
  'WHERE Identifier = ''' + Identifier + ''';';

  qClearBothTables.SQL.Text := s;
end;

procedure TdmTicketsAll.AddZeroes(var NoCombinations: integer;
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

procedure TdmTicketsAll.QueryStrings(WeekNo, SequenceNo, NegTicketNo, WidthNo: integer;
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
                      'MaterialSkinTrimmed, MaterialSheetCutFromRoll, MaterialUnits, MaterialLayers, AdjFactorResult, CutWeek, Cutter, CutterLocation, ' +
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
  qNewTickets.SQL.Add(SQLString);
end;

procedure TdmTicketsAll.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

function TdmTicketsAll.ChangeAllConnections(Connection: TFDCustomConnection): boolean;

  procedure AddConnection(cName: string; cConnection: TFDCustomConnection);
  var
    i, iMax: integer;
    NotFound: boolean;

  begin
    NotFound := true;

    i := 0;
    iMax := Length(ComponentNest);

    while (NotFound) and (i < iMax) do
    begin
      NotFound := not (ComponentNest[i].Name = cName);
      if NotFound then
        Inc(i);
    end;

    if NotFound then
    begin
      SetLength(ComponentNest, iMax + 1);
      i := iMax;
      ComponentNest[i].Name := cName;
    end;

    iMax := Length(ComponentNest[i].Connections);
    SetLength(ComponentNest[i].Connections, iMax + 1);
    ComponentNest[i].Connections[iMax] := cConnection;
  end;

var
  i: integer;

begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TFDQuery) or
       (Components[i] is TFDQueryPlus) then
    begin
      AddConnection(TFDQueryPlus(Components[i]).Name, TFDQueryPlus(Components[i]).Connection);
      TFDQuery(Components[i]).Connection := Connection;
    end
    else
    if (Components[i] is TFDTable) or
       (Components[i] is TFDTablePlus) then
    begin
      AddConnection(TFDTablePlus(Components[i]).Name, TFDTablePlus(Components[i]).Connection);
      TFDTable(Components[i]).Connection := Connection;
    end;
  end;

  Result := true;
end;

procedure TdmTicketsAll.RevertAllConnections();

  function GetConnection(cName: string): TFDCustomConnection;
  var
    i, iMax: integer;
    NotFound: boolean;
    cConnection: TFDCustomConnection;

  begin
    cConnection := nil;
    NotFound := true;

    i := 0;
    iMax := Length(ComponentNest);

    while (NotFound) and (i < iMax) do
    begin
      NotFound := not (ComponentNest[i].Name = cName);
      if NotFound then
        Inc(i);
    end;

    iMax := Length(ComponentNest[i].Connections);

    if not NotFound and (iMax > 0) then
    begin
      iMax := iMax - 1;
      cConnection := ComponentNest[i].Connections[iMax];
      ComponentNest[i].Connections[iMax] := nil;
      SetLength(ComponentNest[i].Connections, iMax);
    end;

    Result := cConnection;
  end;

var
  i, iConn: integer;
  Connection: TFDCustomConnection;

begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TFDQuery) or
       (Components[i] is TFDQueryPlus) then
      TFDQuery(Components[i]).Connection := GetConnection(TFDQueryPlus(Components[i]).Name)
    else
    if (Components[i] is TFDTable) or
       (Components[i] is TFDTablePlus) then
      TFDTable(Components[i]).Connection := GetConnection(TFDQueryPlus(Components[i]).Name);
  end;
end;

procedure TdmTicketsAll.DataModuleCreate(Sender: TObject);
begin
  InUse := false;
end;

procedure TdmTicketsAll.DataModuleDestroy(Sender: TObject);
var
  i, j: integer;

begin
  for i := 0 to Length(ComponentNest) - 1 do
  begin
    for j := 0 to Length(ComponentNest[i].Connections) - 1 do
      ComponentNest[i].Connections[j] := nil;

    SetLength(ComponentNest[i].Connections, 0);
  end;

  SetLength(ComponentNest, 0);
end;

end.
