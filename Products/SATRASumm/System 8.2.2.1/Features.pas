unit Features;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, General, Vcl.StdCtrls, SummsVars,
  Vcl.ExtCtrls;

type
  TfmFeatures = class(TForm)
    pnlMain: TPanel;
    lblOption4: TLabel;
    lblOption1: TLabel;
    lblOption2: TLabel;
    lblOption3: TLabel;
    lblOption5: TLabel;
    lblOption6: TLabel;
    lblOption7: TLabel;
    lblOption8: TLabel;
    lblOption9: TLabel;
    lblOption1OnOff: TLabel;
    lblOption2OnOff: TLabel;
    lblOption3OnOff: TLabel;
    lblOption4OnOff: TLabel;
    lblOption5OnOff: TLabel;
    lblOption6OnOff: TLabel;
    lblOption7OnOff: TLabel;
    lblOption8OnOff: TLabel;
    lblOption9OnOff: TLabel;
    lblOption10OnOff: TLabel;
    lblOption11: TLabel;
    lblOption10: TLabel;
    lblOption11OnOff: TLabel;
    function OnOff(Option: Boolean): string;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmFeatures: TfmFeatures;

implementation

{$R *.dfm}

procedure TfmFeatures.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	action := caFree;
end;

procedure TfmFeatures.FormCreate(Sender: TObject);
begin
	AutoColor(Self);
end;

procedure TfmFeatures.FormShow(Sender: TObject);
begin
  lblOption1OnOff.caption := OnOff(Option_Leather);
  lblOption2OnOff.caption := OnOff(Option_FullSynthetics);
  lblOption3OnOff.caption := OnOff(Option_LegacySynthetics);
  lblOption4OnOff.caption := OnOff(Option_ProductionSystem);
  lblOption5OnOff.caption := OnOff(Option_CuttingTimes);
  lblOption6OnOff.caption := OnOff(Option_CadFiles);
  lblOption7OnOff.caption := OnOff(Option_TicketsIn);
  lblOption8OnOff.caption := OnOff(Option_TicketsOut);
  lblOption9OnOff.caption := OnOff(Option_TicketAudit);
  lblOption10OnOff.caption := OnOff(Option_TicketUpdating);
  lblOption11OnOff.caption := OnOff(Option_SinglesAllowed);
end;

function TfmFeatures.OnOff(Option: Boolean): string;
var
  s: string;
begin
  if Option then
    s:= 'ON'
  else
    s := 'OFF';

  Result := s;
end;

end.




