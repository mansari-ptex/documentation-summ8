unit Times2_Summs7;

interface

uses
  Classes, Controls, Forms, Db, FireDAC.Comp.Client, CmnTypes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdmTimes2_Summs7 = class(TDataModule)
    qKnivesForValue: TFDQuery;
    qPatternsForValue: TFDQuery;
    qKnivesForValueValue: TStringField;
    qKnivesForValueKnife: TStringField;
    qKnivesForValueFreq: TIntegerField;
    qKnivesForValuePieces: TSmallintField;
    qKnivesForValuePunches: TSmallintField;
    qKnivesForValuePair: TStringField;
    qKnivesForValueBands: TFloatField;
    qKnivesForValueMarks: TFloatField;
    qKnivesForValueClears: TSmallintField;
    qKnivesForValueNettArea: TFloatField;
    qKnivesForValueThin: TStringField;
    procedure qKnivesForValueCalcFields(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AdjInterlocks: RealArray;
    InUse: boolean;
  end;

var
  dmTimes2_Summs7: TdmTimes2_Summs7;

implementation

{$R *.DFM}

procedure TdmTimes2_Summs7.qKnivesForValueCalcFields(DataSet: TDataSet);
begin
  //The times calculation will add 10%, so remove 10% here so it can be added back later
  qKnivesForValueNettArea.value := AdjInterlocks[qKnivesForValue.recNo] / 1.1;
end;

procedure TdmTimes2_Summs7.DataModuleCreate(Sender: TObject);
begin
  InUse := false;
end;

end.
