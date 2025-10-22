unit CutUtils2_Summs8;

interface

uses
  Forms, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Classes, Db;

type
  TdmCutUtils2_Summs8 = class(TDataModule)
    qAddCuttingElement: TFDQuery;
    qRemoveCuttingElements: TFDQuery;
    qAdditionalCuttingElements: TFDQuery;
    qReIndexCuttingElements: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmCutUtils2_Summs8: TdmCutUtils2_Summs8;

implementation

{$R *.DFM}

end.
