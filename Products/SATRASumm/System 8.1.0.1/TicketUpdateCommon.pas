unit TicketUpdateCommon;

interface

uses
  Classes, Controls, Forms, Db,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus;

type
  TdmTicketUpdateCommon = class(TDataModule)
    qUpdateTickets: TFDQueryPlus;
    qClearBothTables: TFDQueryPlus;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ChangeAllConnections(Connection: TFDCustomConnection);
    procedure RevertAllConnections();
  end;

var
  dmTicketUpdateCommon: TdmTicketUpdateCommon;

implementation

uses
  Summs, General, CmnVars, SummsVars;

{$R *.DFM}

procedure TdmTicketUpdateCommon.DataModuleCreate(Sender: TObject);
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

procedure TdmTicketUpdateCommon.ChangeAllConnections(Connection: TFDCustomConnection);
var
  i: integer;

begin
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
end;

procedure TdmTicketUpdateCommon.RevertAllConnections();
begin
  ChangeAllConnections(fmSumms.ConnectionSumms);
end;

end.

