unit SatraConnect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Db,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdmSatraConnect = class(TDataModule)
    AdsConnectionSumms6_L: TFDConnectionPlus;
    AdsConnectionSdata6: TFDConnectionPlus;
    tblLocks: TFDTable;
    tblLocksOption: TStringField;
    AdsConnectionSumms6: TFDConnectionPlus;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmSatraConnect: TdmSatraConnect;

implementation

{$R *.DFM}

procedure TdmSatraConnect.DataModuleCreate(Sender: TObject);
begin
{try
   AdsConnectionSumms6.connect;
except
   messagedlg('NOT connected to SUMMS6', mtError, [MbOk], 0);
end;
try
   AdsConnectionSumms6_L.connect;
except
   messagedlg('NOT connected to SUMMS6_L', mtError, [MbOk], 0);
end;}
try
   AdsConnectionSdata6.connect;
except
   messagedlg('NOT connected to SDATA6', mtError, [MbOk], 0);
end;
end;

end.
