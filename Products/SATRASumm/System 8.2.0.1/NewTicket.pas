unit NewTicket;

interface

uses
  Classes, Controls, Forms, StdCtrls,  Db,  
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Spin, Buttons, ExtCtrls, ToolWin, ComCtrls, PBNumEdit,
  PBSuperSpin, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FDConnectionPlus;

type
  TfmNewTicket = class(TForm)
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    eStyle: TEdit;
    btnBrowse: TSpeedButton;
    eWeekNo: TPBSuperSpin;
    LocalConnectionSumms: TFDConnectionPlus;
    qAreThereSizes: TFDQueryPlus;
    qAreThereSizesNumberOfSizes: TIntegerField;
    qNewTicketSequence: TFDQueryPlus;
    qNewTicketSequenceSequenceNo: TIntegerField;
    lblWeekNo: TLabel;
    lblStyle: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eStyleEnter(Sender: TObject);
    procedure eStyleExit(Sender: TObject);
    procedure eAnyCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure eWeekNoInvalidEntry(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    InvalidWeekNo: boolean;
  public
    { Public declarations }
  end;

var
  fmNewTicket: TfmNewTicket;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs, BrowseStyles, TicketsBreakdown,
  OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmNewTicket.btnSaveClick(Sender: TObject);

var
  WeekNo, SequenceNo : integer;
  sWeekNo, sSequenceNo, Style, StyleIncomplete : string;
  Failed, StyleFocus, TicketCreated : boolean;
  fmTicketsBreakdown : TfmTicketsBreakdown;

begin
  InvalidWeekNo := False;

  tbMain.SetFocus;

  if not InvalidWeekNo then
  begin
    StyleFocus := True;

    WeekNo := round(eWeekNo.Value);

    if WeekNo > 53 then
      MessageDlgPos('Week Number is too big', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else if WeekNo < 1 then
      MessageDlgPos('Week Number is too small', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      sWeekNo := IntToStr(round(eWeekNo.Value));

      Style := eStyle.Text;
      if (sWeekNo = '') OR (Style = '') then
        abort;

      qNewTicketSequence.SQL.Text := 'SELECT MAX(SequenceNo + 1) AS SequenceNo ' +
                                     'FROM TicketSequences WHERE WeekNo = ' + sWeekNo + ' OR WeekNo = 0';
      qNewTicketSequence.Open;
      SequenceNo := qNewTicketSequenceSequenceNo.Value;
      sSequenceNo := IntToStr(qNewTicketSequenceSequenceNo.Value);
      qNewTicketSequence.Close;

      qNewTicketSequence.SQL.Clear;
      qNewTicketSequence.SQL.Text := 'INSERT INTO TicketSequences (WeekNo, SequenceNo, Style, StyleDescription, Construction, Picture) ' +
                                     'SELECT ' + sWeekNo + ', ' + sSequenceNo + ', ''' + QS(Style) +
                                     ''', Description, CurrentCon, Picture FROM Styles WHERE Style = ''' + QS(Style) + ''' ;' + #13 +
                                     'INSERT INTO TicketsInput (Width, Weekno, SequenceNo, Size, Pairs, WidthNo, SizeSeq) ' +
                                     'SELECT DISTINCT(Width), ' + sWeekNo + ', ' + sSequenceNo + ', ''AddWidth'', 1, No, 0 ' +
                                     'FROM TicketSequences TS, Widths W, WRngWs WRW, Parts P, ConParts CP, Styles S, SizeRangeSizes SRS, Construc C ' +
                                       'WHERE W.No = WRW.WidthNo AND WRW.Range = P.WidthRange AND ' +
                                       'P.Code = CP.Part AND CP.Construction = S.CurrentCon AND ' +
                                       'SRS.Range = C.SizeRange AND C.Construction = S.CurrentCon AND ' +
                                       'S.Style = ''' + QS(Style) + ''' AND TS.WeekNo = ' + sWeekNo + ' AND ' +
                                       'TS.SequenceNo = ' + sSequenceNo + ' AND ' +
                                       'W.Width IN (SELECT W.Width ' +
                                                   'FROM PtWidKnf PWK, Widths W, Parts P, WRngWs WRW ' +
                                                   'WHERE PWK.Seq = 1 AND ' +
                                                         'PWK.Part IN (SELECT Part ' +
                                                                      'FROM ConParts ' +
                                                                      'WHERE Construction IN (SELECT CurrentCon ' +
                                                                                             'FROM Styles ' +
                                                                                             'WHERE Style = ''' + QS(Style) + ''')) AND ' +
                                                         'P.Code = PWK.Part AND ' +
                                                         'WRW.Range = P.WidthRange AND ' +
                                                         'WRW.WidthNo = PWK.WidthNo AND '+
                                                         'PWK.WidthNo = W.No ' +
                                                  'GROUP BY W.Width ' +
                                                  'HAVING COUNT(*) = (SELECT COUNT(*) FROM ConParts ' +
                                                                     'WHERE Construction IN (SELECT CurrentCon ' +
                                                                                            'FROM Styles ' +
                                                                                            'WHERE Style = ''' + QS(Style) + '''))) ' +
                                        'GROUP BY WeekNo, SequenceNo, W.Width, W.No, SRS.Seq;' + #13 +
                                        'INSERT INTO TicketsInput (Size, Weekno, SequenceNo, Width, WidthNo, SizeSeq, Pairs) ' +
                                        'SELECT DISTINCT(SRS.Size), ' + sWeekNo + ', ' + sSequenceNo + ', W.Width, W.No, SRS.Seq, 0 ' +
                                        'FROM TicketSequences TS, Widths W, WRngWs WRW, Parts P, ConParts CP, Styles S, SizeRangeSizes SRS, Construc C ' +
                                        'WHERE W.No = WRW.WidthNo AND WRW.Range = P.WidthRange AND ' +
                                          'P.Code = CP.Part AND CP.Construction = S.CurrentCon AND ' +
                                          'SRS.Range = C.SizeRange AND C.Construction = S.CurrentCon AND ' +
                                          'S.Style = ''' + QS(Style) + ''' AND TS.WeekNo = ' + sWeekNo + ' AND ' +
                                          'TS.SequenceNo = ' + sSequenceNo + ' AND ' +
                                          'W.Width IN (SELECT W.Width ' +
                                                      'FROM PtWidKnf PWK, Widths W, Parts P, WRngWs WRW ' +
                                                      'WHERE PWK.Seq = 1 AND ' +
                                                            'PWK.Part IN (SELECT Part ' +
                                                                         'FROM ConParts ' +
                                                                         'WHERE Construction IN (SELECT CurrentCon ' +
                                                                                                'FROM Styles ' +
                                                                                                'WHERE Style = ''' + QS(Style) + ''')) AND ' +
                                                            'P.Code = PWK.Part AND ' +
                                                            'WRW.Range = P.WidthRange AND ' +
                                                            'WRW.WidthNo = PWK.WidthNo AND '+
                                                            'PWK.WidthNo = W.No ' +
                                                     'GROUP BY W.Width ' +
                                                     'HAVING COUNT(*) = (SELECT COUNT(*) FROM ConParts ' +
                                                                        'WHERE Construction IN (SELECT CurrentCon ' +
                                                                                               'FROM Styles ' +
                                                                                               'WHERE Style = ''' + QS(Style) + '''))) ' +
                                          'GROUP BY W.Width, W.No, P.Code, SRS.Seq, SRS.Size;';

      TicketCreated := True;

      if not LocalConnectionSumms.Connected then
        LocalConnectionSumms.Connected := True;

      LocalConnectionSumms.StartTransaction;
      try
        qNewTicketSequence.ExecSQL;
      except
        TicketCreated := False;
      end;

      qAreThereSizes.ParamByName('WeekNo').Value := eWeekNo.Value;
      qAreThereSizes.ParamByName('SequenceNo').Value := SequenceNo;

      qAreThereSizes.Open;

      if qAreThereSizesNumberOfSizes.Value = 0 then
      begin
        TicketCreated := False;
        StyleIncomplete := 'Style does not exist OR' + #13 +
                           'Style is incomplete OR' + #13  +
                           'Style is being edited OR' + #13 +
                           'Construction has duplicate Parts OR' + #13 +
                           'Parts have no common width(s)' + #13 + #13;
      end
      else
        StyleIncomplete := '';

      qAreThereSizes.Close;

      if TicketCreated then
        LocalConnectionSumms.commit
      else
        LocalConnectionSumms.rollBack;

      if TicketCreated then
      begin
        Failed := false;
        try
          fmTicketsBreakdown := TfmTicketsBreakDown.Create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
        begin
          fmTicketsBreakdown.Style := Style;
          fmTicketsBreakdown.FromNew := TRUE;
          fmTicketsBreakdown.PassTicketSequenceReference(fmTicketsBreakdown, WeekNo, SequenceNo);
        end;

        Close;
      end
      else
      begin
        MessageDlgPos(StyleIncomplete + 'Ticket could not be created.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
        if StyleFocus then
        begin
          eStyle.SetFocus;
          eStyle.SelectAll;
        end
        else
        begin
          eWeekNo.SetFocus;
          eWeekNo.SelectAll;
        end;
      end;
    end;
  end;
end;

procedure TfmNewTicket.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewTicket.btnBrowseClick(Sender: TObject);
begin
  if fmBrowseStyles.ShowModal = mrOK then
    eStyle.text := fmBrowseStyles.lblStyle.caption;
end;

procedure TfmNewTicket.FormActivate(Sender: TObject);
begin
  eStyle.Text := '';
  eWeekNo.SetFocus;
end;

procedure TfmNewTicket.eStyleEnter(Sender: TObject);
begin
  btnBrowse.enabled := True;
end;

procedure TfmNewTicket.eStyleExit(Sender: TObject);
begin
  btnBrowse.enabled := False;
end;

procedure TfmNewTicket.eAnyCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewTicket.FormShow(Sender: TObject);
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

procedure TfmNewTicket.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmNewTicket.eWeekNoInvalidEntry(Sender: TObject);
begin
  InvalidWeekNo := True;
  eWeekNo.Value := 1;
  eWeekNo.SetFocus;
end;

procedure TfmNewTicket.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
