unit CopyTicket;

interface

uses
  Classes, Controls, Forms, StdCtrls, Spin, Buttons, ExtCtrls, ComCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, TicketsBreakdown,  Db, ToolWin,
  PBNumEdit, PBSuperSpin, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FDConnectionPlus;

type
  TfmCopyTicket = class(TForm)
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qCopyTickets: TFDQueryPlus;
    qGetSequenceForCopy: TFDQueryPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    eWeekNo: TPBSuperSpin;
    lblWeekNo: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure eWeekNooldKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eWeekNoInvalidEntry(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    InvalidWeekNo: boolean;
  public
    { Public declarations }
    fmTicketsBreakdown: TfmTicketsBreakdown;
  end;

var
  fmCopyTicket: TfmCopyTicket;

implementation

uses
  Windows, SysUtils, Dialogs, Summs, OutOfMemory, AdvErrorHandler, SummsVars, General;

{$R *.DFM}

procedure TfmCopyTicket.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCopyTicket.btnSaveClick(Sender: TObject);
var
  fmTicketsBreakdownCopy: TfmTicketsBreakdown;
  Failed: Boolean;
  SequenceNo: SmallInt;
  sWeekNo, ErrorMessage: string;

begin
  InvalidWeekNo := False;
  tbMain.SetFocus;

  if not InvalidWeekNo then
  begin
    Failed := FALSE;

    Screen.cursor := crHourGlass;

    if not LocalConnectionSumms.Connected then
      LocalConnectionSumms.Connected := True;

    LocalConnectionSumms.StartTransaction;

    str(eWeekNo.Value:2:0,sWeekNo);

    qGetSequenceForCopy.SQL.Text := 'SELECT MAX(SequenceNo + 1) AS SequenceNo ' +
                                    'FROM TicketSequences WHERE WeekNo = ' + sWeekNo + ' OR WeekNo = 0';

    try
      qGetSequenceForCopy.Open;
    except
      on E: Exception do
      begin
        ErrorMessage := E.Message;
        Failed := TRUE;
      end;
    end;

    if not Failed then
    begin
      SequenceNo := qGetSequenceForCopy.FieldByName('SequenceNo').AsInteger;

      qCopyTickets.SQL.Text := 'INSERT INTO TicketSequences(WeekNo, SequenceNo, Style, Construction, Picture) ' +
                               'SELECT ' + sWeekNo + ' AS WeekNo, ' + IntToStr(SequenceNo) + ' AS SequenceNo, ' +
                                          'Style, Construction, Picture ' +
                               'FROM TicketSequences ' +
                               'WHERE WeekNo = ' + fmTicketsBreakdown.sWeekNo + ' AND SequenceNo = ' +
                                      fmTicketsBreakdown.sSequenceNo + ';' + #13 +
                               'INSERT INTO TicketsInput(WeekNo, SequenceNo, Width, Size, Pairs, WidthNo, SizeSeq) ' +
                               'SELECT ' + sWeekNo + ' AS WeekNo, ' + IntToStr(SequenceNo) + 'AS SequenceNo, ' +
                                          'Width, Size, Pairs, WidthNo, SizeSeq ' +
                               'FROM TicketsInput ' +
                               'WHERE WeekNo = ' + fmTicketsBreakdown.sWeekNo + ' AND SequenceNo = ' +
                                      fmTicketsBreakdown.sSequenceNo + ';';
      try
        qCopyTickets.ExecSQL;
        LocalConnectionSumms.Commit;
        try
          fmTicketsBreakdownCopy := TfmTicketsBreakDown.Create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
          fmTicketsBreakdownCopy.PassTicketSequenceReference(fmTicketsBreakdownCopy, StrToInt(sWeekNo), SequenceNo);

        Close;
      except
        on E: Exception do
        begin
          LocalConnectionSumms.RollBack;
          fmErrorHandler.DebugMessageDlg('Copy Failed', E.Message, qCopyTickets.Text);
        end;
      end;
    end
    else
      fmErrorHandler.DebugMessageDlg('Copy Failed', ErrorMessage, qGetSequenceForCopy.Text);

    Screen.cursor := crDefault;
  end;
end;

procedure TfmCopyTicket.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);

  eWeekNo.Value := 1;
end;

procedure TfmCopyTicket.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCopyTicket.eWeekNooldKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmCopyTicket.eWeekNoInvalidEntry(Sender: TObject);
begin
  InvalidWeekNo := True;
  eWeekNo.Value := 1;
  eWeekNo.SetFocus;  
end;

procedure TfmCopyTicket.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
