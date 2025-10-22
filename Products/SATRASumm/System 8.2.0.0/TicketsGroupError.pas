unit TicketsGroupError;

interface

uses
  Classes, Controls, Forms, XStringGrid, XStringGridPlus, Grids, General;

type
  TfmTicketsGroupError = class(TForm)
    sgOtherErrors: TXStringGridPlus;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmTicketsGroupError: TfmTicketsGroupError;

implementation

uses
  SummsVars;

{$R *.DFM}

procedure TfmTicketsGroupError.FormShow(Sender: TObject);
begin
  fmTicketsGroupError.height := 303;
  fmTicketsGroupError.width := 487;

  fmTicketsGroupError.left := (Screen.Width div 2) - (fmTicketsGroupError.Width div 2);
  fmTicketsGroupError.top := (Screen.Height div 2) - (fmTicketsGroupError.Height div 2);
end;

procedure TfmTicketsGroupError.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.

