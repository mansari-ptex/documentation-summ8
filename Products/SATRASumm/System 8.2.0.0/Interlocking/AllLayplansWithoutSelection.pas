unit AllLayplansWithoutSelection;

interface

uses
  Classes, Controls, Forms, Types, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, ExtCtrls,
  Menus, Buttons, ComCtrls,   ToolWin, Grids, DBGridPlus,
  XStringGrid, XStringGridPlus, jpeg,
  General_Interlocking, Mask, DBCtrls, Vcl.DBGrids;

type
  TfmAllLayplansWithoutSelection = class(TForm)
    dsLayplans: TDataSource;
    qLayplans: TFDQueryPlus;
    qLayplansMaterialLength: TIntegerField;
    qLayplansMaterialWidth: TIntegerField;
    qLayplansMaterialCutGap: TIntegerField;
    qLayplansMaterialLengthInUnits: TFloatField;
    qLayplansMaterialWidthInUnits: TFloatField;
    qLayplansMaterialCodeRestrictive: TStringField;
    qLayplansKnifeCode: TStringField;
    qLayplansKnifeSizeScale: TStringField;
    qLayplansKnifeSize: TStringField;
    qLayplansSelectedNo: TIntegerField;
    qLayplansMaterialEdge: TIntegerField;
    qLayplansKnifeAngle: TFloatField;
    dbgLayplans: TDBGridPlus;
    procedure FormActivate(Sender: TObject);
    procedure dbgLayplansDblClick(Sender: TObject);
    procedure dbgLayplansKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure qLayplansCalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitMultiplier: Real;
  end;

var
  fmAllLayplansWithoutSelection: TfmAllLayplansWithoutSelection;

implementation

uses
  SysUtils, Windows, Graphics, Dialogs, LayMain, SummsVars, General;

{$R *.DFM}

procedure TfmAllLayplansWithoutSelection.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmAllLayplansWithoutSelection.dbgLayplansDblClick(Sender: TObject);
begin
  //CJY: qLayPlans.FetchOptions.RecordCountMode set to cmTotal
  if (qLayPlans.RecordCount >= 1) then
    ModalResult := mrOK
  else
    ModalResult := mrCancel;
end;

procedure TfmAllLayplansWithoutSelection.dbgLayplansKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgLayplansDblClick(Self);
end;

procedure TfmAllLayplansWithoutSelection.FormShow(Sender: TObject);
begin
  if qLayplans.active then
    qLayPlans.Close;

  qLayplans.open;
end;

procedure TfmAllLayplansWithoutSelection.qLayplansCalcFields(DataSet: TDataSet);
begin
  qLayplansMaterialLengthInUnits.Value := qLayplansMaterialLength.Value * UnitMultiplier;
  qLayplansMaterialWidthInUnits.Value := qLayplansMaterialWidth.Value * UnitMultiplier;
end;

procedure TfmAllLayplansWithoutSelection.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.

