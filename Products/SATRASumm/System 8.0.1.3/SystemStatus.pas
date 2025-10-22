unit SystemStatus;

interface

uses
  Classes, Controls, Forms, Db, StdCtrls, ExtCtrls, DBCtrls, Buttons, ToolWin,
  ComCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus,  General;

type
  TfmSystemStatus = class(TForm)
    pnlWhole: TPanel;
    lblConstructions: TLabel;
    lblCutters: TLabel;
    lblCutterLocations: TLabel;
    lblKnives: TLabel;
    lblMaterials: TLabel;
    lblParts: TLabel;
    lblSizeRanges: TLabel;
    lblSizeRelationships: TLabel;
    lblSizeScales: TLabel;
    lblStyles: TLabel;
    lblSuppliers: TLabel;
    lblTickets: TLabel;
    lblWidths: TLabel;
    lblWidthRanges: TLabel;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qSum: TFDQueryPlus;
    qSumIdx: TIntegerField;
    qSumTotal: TIntegerField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ReadTotals;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSystemStatus: TfmSystemStatus;

implementation

uses
  SummsVars;

{$R *.DFM}

procedure TfmSystemStatus.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmSystemStatus.btnRefreshClick(Sender: TObject);
begin
  ReadTotals;
end;

procedure TfmSystemStatus.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  ReadTotals;
  tbMain.enabled := True;
end;

procedure TfmSystemStatus.ReadTotals;
var
  s: string;

begin
  Screen.cursor := crHourGlass;

  qSum.open;
  str(qSumTotal.value : 5, s);
  Label1.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label2.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label3.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label4.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label5.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label6.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label7.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label8.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label9.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label10.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label11.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label12.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label13.caption := s;
  qSum.next;
  str(qSumTotal.value : 5, s);
  Label14.caption := s;
  qSum.close;

  Screen.cursor := crDefault;
end;

end.
