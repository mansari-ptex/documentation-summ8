unit TktBlkUpErrors;

interface

uses
  Classes, Controls, Forms, Grids, DBGridPlus, General;

type
  TfmTicketBulkUpdateErrors = class(TForm)
    dbgTicketUpdateAudit: TDBGridPlus;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmTicketBulkUpdateErrors: TfmTicketBulkUpdateErrors;

implementation

uses
  SummsVars;

{$R *.DFM}

procedure TfmTicketBulkUpdateErrors.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
