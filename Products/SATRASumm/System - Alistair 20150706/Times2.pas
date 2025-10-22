unit Times2;

interface

uses
  Classes, Controls, Forms, Db,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, CmnTypes;

type
  TdmTimes2 = class(TDataModule)
    qKnivesForValue: TFDQueryPlus;
    qPatternsForValue: TFDQueryPlus;
    qKnivesForValueValue: TStringField;
    qKnivesForValueKnife: TStringField;
    qKnivesForValueFreq: TIntegerField;
    qKnivesForValuePieces: TSmallintField;
    qKnivesForValuePeels: TSmallintField;
    qKnivesForValueCutsLR: TStringField;
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
  dmTimes2: TdmTimes2;

implementation

{$R *.DFM}

procedure TdmTimes2.qKnivesForValueCalcFields(DataSet: TDataSet);
begin
  //The times calculation will add 10%, so remove 10% here so it can be added back later
//CJY  if qKnivesForValue.recNo < Length(AdjInterlocks) then
//  qKnivesForValueNettArea.value := AdjInterlocks[qKnivesForValue.recNo] / 1.1;

//NettArea no longer a calculated field
end;

procedure TdmTimes2.DataModuleCreate(Sender: TObject);
begin
  InUse := false;
end;

end.
