unit AllLayplans;

interface

uses
  Classes, Controls, Forms, Types, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, ExtCtrls,
  Menus, Buttons, ComCtrls,   ToolWin, Grids, DBGridPlus,
  XStringGrid, XStringGridPlus, jpeg, General_Interlocking, Mask, DBCtrls, Vcl.DBGrids;

type
  TfmAllLayplans = class(TForm)
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
    qLayplansSelectedYesNo: TStringField;
    dbgLayPlans: TDBGridPlus;
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
  fmAllLayplans: TfmAllLayplans;

implementation

uses
  SysUtils, Windows, Graphics, Dialogs, LayMain, SummsVars, General;

{$R *.DFM}

procedure TfmAllLayplans.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmAllLayplans.dbgLayplansDblClick(Sender: TObject);
begin
  //CJY qLayPlans.FetchOptions.RecordCountMode set to cmTotal
  if (qLayPlans.RecordCount >= 1) then
    ModalResult := mrOK
  else
    ModalResult := mrCancel;
end;

procedure TfmAllLayplans.dbgLayplansKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgLayplansDblClick(Self);
end;

procedure TfmAllLayplans.FormShow(Sender: TObject);
begin
  if qLayplans.active then
    qLayPlans.Close;
  qlayplans.ParamByName('KnifeCode').Value := fmLayplan.KnifeCode;
  qlayplans.ParamByName('KnifeScale').Value := fmLayplan.KnifeScale;
  qlayplans.ParamByName('KnifeSize').Value := fmLayplan.KnifeSize;
  qLayplans.Open;
end;

procedure TfmAllLayplans.qLayplansCalcFields(DataSet: TDataSet);
begin
  qLayplansMaterialLengthInUnits.Value := qLayplansMaterialLength.Value * UnitMultiplier;
  qLayplansMaterialWidthInUnits.Value := qLayplansMaterialWidth.Value * UnitMultiplier;
  if qLayplansSelectedNo.Value = -1 then
    qLayplansSelectedYesNo.Value := 'No'
  else
    qLayplansSelectedYesNo.Value := 'Yes';
end;

procedure TfmAllLayplans.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.

