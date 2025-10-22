unit CutUtils2_Summs7;

interface

uses
  Forms, FireDAC.Comp.Client, Classes, Db, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TdmCutUtils2_Summs7 = class(TDataModule)
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
  dmCutUtils2_Summs7: TdmCutUtils2_Summs7;

implementation

{$R *.DFM}

end.
