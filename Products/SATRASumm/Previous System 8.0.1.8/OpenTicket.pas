unit OpenTicket;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ToolWin, PBNumEdit, PBSuperSpin;

type
  TfmOpenTicket = class(TForm)
    lblSlash: TLabel;
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    seWeekNo: TPBSuperSpin;
    seSequenceNo: TPBSuperSpin;
    lblNumber: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seAnyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenTicket: TfmOpenTicket;

implementation

uses
  Windows, SysUtils, Summs, OutOfMemory, TicketsBreakdown, General, SummsVars, dialogs;

{$R *.DFM}

procedure TfmOpenTicket.btnCancelClick(Sender: TObject);
begin
  Close
end;

procedure TfmOpenTicket.FormActivate(Sender: TObject);
begin
  seWeekNo.value := 1;
  seSequenceNo.value := 1;

  seWeekNo.SetFocus;
end;

procedure TfmOpenTicket.btnOpenClick(Sender: TObject);
var
  TicketCaption : string;
  SequenceNo, WeekNo : integer;
  sSequenceNo, sWeekNo: string;
  Failed : boolean;
  fmTicketsBreakdown : TfmTicketsBreakdown;

begin
  WeekNo := round(seWeekNo.Value);
  SequenceNo := round(seSequenceNo.Value);

  if (WeekNo > 0) and (WeekNo < 54) then
  begin
    sWeekNo := intToStr(WeekNo);
    sSequenceNo := intToStr(SequenceNo);
    TicketCaption := 'Ticket(s) : ' + sWeekNo + '/' + sSequenceNo + '/xx    ';
    if not ExistingToFront(TicketCaption, '') then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmTicketsBreakdown := TfmTicketsBreakDown.Create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmTicketsBreakdown.PassTicketSequenceReference(fmTicketsBreakdown, WeekNo, SequenceNo);

    end;
  end
  else
    MessageDlgPos('Week Number is too big', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

  Close;
end;

procedure TfmOpenTicket.seAnyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenTicket.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

procedure TfmOpenTicket.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
