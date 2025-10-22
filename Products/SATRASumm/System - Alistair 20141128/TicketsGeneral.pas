unit TicketsGeneral;

interface

uses
  Classes, Controls, Forms, Db,    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys;

type
  TdmTicketsGeneral = class(TDataModule)
    qCompareGrids: TFDQueryPlus;
    qCompareGridsWidth: TStringField;
    qCompareGridsSize: TStringField;
    LocalConnectionSumms: TFDConnection;
    qFillCompareGrid: TFDQueryPlus;
    StringField1: TStringField;
    StringField2: TStringField;
    qClearCompareGrid: TFDQueryPlus;
    qReadCompareGrid: TFDQueryPlus;
    procedure FillCompareGrid(WeekNo, SequenceNo, Style : string);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ChangeAllConnections(Connection: TFDCustomConnection);
    procedure RevertAllConnections();
  end;

var
  dmTicketsGeneral: TdmTicketsGeneral;

implementation

uses
  Summs, CmnVars, General;

{$R *.DFM}

procedure TdmTicketsGeneral.FillCompareGrid(WeekNo, SequenceNo, Style : string);
var
  SQLString: string;

begin
  qFillCompareGrid.SQL.Text := 'DELETE FROM TicketsCompareGrid ' +
                               'WHERE Identifier = ''' + Identifier + ''' AND WeekNo = ' + WeekNo + ' AND SequenceNo = ' +
                                SequenceNo + ';' + #13 +
                               'INSERT INTO TicketsCompareGrid ' +
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

procedure TdmTicketsGeneral.ChangeAllConnections(Connection: TFDCustomConnection);
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

procedure TdmTicketsGeneral.RevertAllConnections();
begin
  ChangeAllConnections(LocalConnectionSumms);
end;

procedure TdmTicketsGeneral.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

end.
