unit Audit;

interface

uses
  Classes, Controls, Forms, StdCtrls, Types, Db, DBGridPlus,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  ComCtrls, ExtCtrls, Spin, Buttons, Grids, ToolWin, PBNumEdit, PBSuperSpin,
  Vcl.DBGrids;

type
  TfmAudit = class(TForm)
    dsAudit: TDataSource;
    qAudit: TFDQueryPlus;
    qAuditType: TStringField;
    qAuditUserName: TStringField;
    qAuditWeekNo: TSmallintField;
    qAuditSequenceNo: TSmallintField;
    qAuditTicketNo: TSmallintField;
    qAuditTransactionDate: TDateField;
    qAuditPrinted: TBooleanField;
    qAuditMaterialCode: TStringField;
    qAuditAllowance: TFloatField;
    qAuditConstruction: TStringField;
    qAuditPart: TStringField;
    qAuditTotalPairs: TSmallintField;
    qAuditUsage: TFloatField;
    qAuditAmended: TBooleanField;
    qAuditCustNo: TStringField;
    qAuditPrintedYN: TStringField;
    qAuditAmendedYN: TStringField;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlBottom: TPanel;
    lblOlder: TLabel;
    lblDays: TLabel;
    pnlMain: TPanel;
    pcAudit: TPageControl;
    tsAuditCleared: TTabSheet;
    tsAuditDeleted: TTabSheet;
    tsAuditPrinted: TTabSheet;
    tsAuditUpdated: TTabSheet;
    qAuditTicketNumber: TStringField;
    dbgAudit: TDBGridPlus;
    qAudit2: TFDQueryPlus;
    pnlSpin: TPanel;
    seDays: TPBSuperSpin;
    btnSaveAndClearAll: TSpeedButton;
    pnlButtons: TPanel;
    btnClear: TSpeedButton;
    btnSaveASC: TSpeedButton;
    qAuditTagNo: TStringField;
    btnSize: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qAuditCalcFields(DataSet: TDataSet);
    procedure pcAuditChange(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    function SaveTextFiles: Boolean;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure SearchType;
    procedure seDaysInvalidEntry(Sender: TObject);
    procedure btnSaveAndClearAllClick(Sender: TObject);
    procedure pcAuditDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure btnSizeClick(Sender: TObject);
    procedure btnSaveASCClick(Sender: TObject);
  private
    { Private declarations }
    DaysInvalid: boolean;
  public
    { Public declarations }
  end;

var
  fmAudit: TfmAudit;

implementation

uses
  Windows, SysUtils, Dialogs, FileCtrl, General, Summs, SummsVars;

{$R *.DFM}

procedure TfmAudit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree
end;

procedure TfmAudit.qAuditCalcFields(DataSet: TDataSet);
var
  TicketNo, s : string;

begin
  str(qAuditWeekNo.value, s);
  TicketNo := s;
  str(qAuditSequenceNo.value, s);
  TicketNo := TicketNo + '/' + s;
  str(qAuditTicketNo.value, s);
  TicketNo := TicketNo + '/' + s;
  qAuditTicketNumber.value := TicketNo;

  if (qAuditPrinted.value) then
    qAuditPrintedYN.value := 'Yes'
  else
    qAuditPrintedYN.value := 'No';

  if (qAuditAmended.value) then
    qAuditAmendedYN.value := 'Yes'
  else
    qAuditAmendedYN.value := 'No';
end;

procedure TfmAudit.pcAuditChange(Sender: TObject);
begin
  SearchType;
end;

procedure TfmAudit.btnClearClick(Sender: TObject);
var
   Days : integer;
   s : string;
   SaveSDF : string;

begin
  DaysInvalid := False;

  tbMain.SetFocus;

  if not DaysInvalid then
  begin
    if MessageDlgPos('Clear audit history?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
    begin
      Days := round(seDays.value);
      qAudit2.SQL.Text := 'DELETE FROM Audit WHERE TransactionDate <= CurDate() - ' + IntToStr(Days);

      qAudit2.execSQL;

      //Refresh
      SearchType;
    end;
  end;
end;

function TfmAudit.SaveTextFiles: Boolean;
var
  Allowance, Amended, CustNo, Material, Part, PathName, Printed, Construction, TagNo, TotalPairs, Usage: string;
  WeekNumber, SequenceNumber, TicketNumber: string;
  FullTicketNumber: string;
  TagNoLength: integer;
  Saved: Boolean;
  TextC: TStringlist;
  TextD: TStringlist;
  TextP: TStringlist;
  TextU: TStringlist;
  s: string;

begin
  Saved := False;

  PathName := AuditPathName;
  //Check no trailing \
  if PathName[length(PathName)] = '\' then
    delete(PathName, length(PathName), 1);

  if DirectoryExists(PathName) then
  begin
    screen.cursor := crHourGlass;

    if ShortTagNo then
      TagNoLength := 25
    else
      TagNoLength := 55;

    TextC:= TStringlist.create;
    TextD:= TStringlist.create;
    TextP:= TStringlist.create;
    TextU:= TStringlist.create;

    try
      qAudit2.SQL.Text := 'SELECT * FROM Audit';
      qAudit2.open;
      qAudit2.First;
      while not qAudit2.eof do
      begin
        str(qAudit2.FieldByName('WeekNo').value : 2 : 0, WeekNumber);
        str(qAudit2.FieldByName('SequenceNo').value : 5 : 0, SequenceNumber);
        str(qAudit2.FieldByName('TicketNo').value : 4 : 0, TicketNumber);
        FullTicketNumber := WeekNumber + '/' + SequenceNumber + '/' + TicketNumber;

        if qAudit2.FieldByName('Printed').isNull then
          Printed := ' '
        else if qAudit2.FieldByName('Printed').value then
          Printed := 'Y'
        else
          Printed := 'N';

        if qAudit2.FieldByName('MaterialCode').isNull then
          Material := StringOfChar(' ', 20)
        else
          Material := copy(qAudit2.FieldByName('MaterialCode').value + StringOfChar(' ', 20), 1, 20);

        if qAudit2.FieldByName('Allowance').isNull then
          Allowance := StringOfChar(' ', 5)
        else
          Str(qAudit2.FieldByName('Allowance').value : 8 : 2, Allowance);

        if qAudit2.FieldByName('Construction').isNull then
          Construction := StringOfChar(' ', 20)
        else
          Construction := copy(qAudit2.FieldByName('Construction').value + StringOfChar(' ', 20), 1, 20);

        if qAudit2.FieldByName('Part').isNull then
          Part := StringOfChar(' ', 20)
        else
          Part := copy(qAudit2.FieldByName('Part').value + StringOfChar(' ', 20), 1, 20);

        if qAudit2.FieldByName('TotalPairs').isNull then
          TotalPairs := StringOfChar(' ', 5)
        else
          str(qAudit2.FieldByName('TotalPairs').value : 5 : 0, TotalPairs);

        if qAudit2.FieldByName('Usage').isNull then
          Usage := StringOfChar(' ', 5)
        else
          Str(qAudit2.FieldByName('Usage').value : 8 : 2, Usage);

        if qAudit2.FieldByName('Amended').isNull then
          Amended := ' '
        else if qAudit2.FieldByName('Amended').value then
          Amended := 'Y'
        else
          Amended := 'N';

        if qAudit2.FieldByName('TagNo').isNull then
          TagNo := StringOfChar(' ', TagNoLength)
        else
        begin
          TagNo := Copy(qAudit2.FieldByName('TagNo').value, 1, TagNoLength);
          TagNo := TagNo + StringOfChar(' ', TagNoLength - length(TagNo));
        end;

        if qAudit2.FieldByName('CustNo').isNull then
          CustNo := StringOfChar(' ', 20)
        else
          CustNo := copy(qAudit2.FieldByName('CustNo').value + StringOfChar(' ', 20), 1, 20);

        if qAudit2.FieldByName('Type').value = 'C' then
        begin
          //Cleared
          s := FullTicketNumber + ' ' + FormatDateTime('dd/mm/yy', qAudit2.FieldByName('TransactionDate').value) + ' ' + Printed +  ' ' + Amended;
          if not OldAudit then
            s := s + ' ' + TagNo + ' ' + CustNo;

          TextC.Add(s);
        end
        else if qAudit2.FieldByName('Type').value = 'D' then
        begin
          //Deleted
          s := FullTicketNumber + ' ' + FormatDateTime('dd/mm/yy', qAudit2.FieldByName('TransactionDate').value) + ' ' + Printed;
          if not OldAudit then
            s := s + ' ' + TagNo + ' ' + CustNo;

          TextD.Add(s);
        end
        else if qAudit2.FieldByName('Type').value = 'P' then
        begin
          //Printed
          s := FullTicketNumber + ' ' + FormatDateTime('dd/mm/yy', qAudit2.FieldByName('TransactionDate').value) + ' ' + Material + ' ' + Allowance + ' ' + Construction + ' ' + Part + ' ' +  TotalPairs;
          if not OldAudit then
            s := s + ' ' + TagNo + ' ' + CustNo;

          TextP.Add(s);
        end
        else if qAudit2.FieldByName('Type').value = 'U' then
        begin
          //Updated
          s := FullTicketNumber + ' ' + FormatDateTime('dd/mm/yy', qAudit2.FieldByName('TransactionDate').value) + ' ' + Material + ' ' + Allowance + ' ' + Construction + ' ' + Part + ' ' +  TotalPairs + ' ' + Usage + ' ' + Amended;
          if not OldAudit then
            s := s + ' ' + TagNo + ' ' + CustNo;

          TextU.Add(s);
        end;

        qAudit2.next;
      end;

      qAudit2.close;

      TextC.SaveToFile(PathName + '\Cleared.asc');
      TextD.SaveToFile(PathName + '\Deleted.asc');
      TextP.SaveToFile(PathName + '\Printed.asc');
      TextU.SaveToFile(PathName + '\Updated.asc');

      Saved := True;
    finally
      TextC.Free;
      TextD.Free;
      TextP.Free;
      TextU.Free;
    end;

    screen.cursor := crDefault;

    if Saved then
      MessageDlgPos('Output files saved in directory ' + #13 +
        PathName + '\', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
      MessageDlgPos('Error saving output files', mtinformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end
  else
    MessageDlgPos('Parameters | Audit Path directory does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

  Result := Saved;
end;

procedure TfmAudit.btnSizeClick(Sender: TObject);
begin
  showmessage(inttostr(fmAudit.height) + ' - ' + inttostr(fmAudit.Width));
end;

procedure TfmAudit.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  if ClearAuditAfterSave then
    Height := Height - pnlBottom.height - (pnlBottom.Margins.Top + pnlBottom.Margins.Bottom);

  if ClearAuditAfterSave then
  begin
    pnlButtons.Visible := False;
    btnSaveAndClearAll.Visible := True;
    pnlBottom.Visible := False;
  end
  else
  begin
    pnlButtons.Visible := True;
    btnSaveAndClearAll.Visible := False;
    pnlBottom.Visible := True;
  end;

  dbgAudit.columns[9].Title.Caption := PairsWord;

  SearchType;
end;

procedure TfmAudit.btnRefreshClick(Sender: TObject);
begin
  qAudit.Close;
  qAudit.Open;  
end;

procedure TfmAudit.SearchType;
var
  Which : string;

begin
  if pcAudit.ActivePage = tsAuditCleared then
    Which := 'C'
  else if pcAudit.ActivePage = tsAuditDeleted then
    Which := 'D'
  else if pcAudit.ActivePage = tsAuditPrinted then
    Which := 'P'
  else if pcAudit.ActivePage = tsAuditUpdated then
    Which := 'U';

  dbgAudit.columns[3].visible := (Which = 'C') or (Which = 'D');
  dbgAudit.columns[4].visible := (Which = 'C') or (Which = 'U');
  dbgAudit.columns[5].visible := (Which = 'P') or (Which = 'U');
  dbgAudit.columns[6].visible := (Which = 'P') or (Which = 'U');
  dbgAudit.columns[7].visible := (Which = 'P') or (Which = 'U');
  dbgAudit.columns[8].visible := (Which = 'P') or (Which = 'U');
  dbgAudit.columns[9].visible := (Which = 'P') or (Which = 'U');
  dbgAudit.columns[10].visible := (Which = 'P') and (not OldAudit);
  dbgAudit.columns[11].visible := (Which = 'P') and (not OldAudit);
  dbgAudit.columns[12].visible := (Which = 'U');

  dbgAudit.parent := pcAudit.ActivePage;

  qAudit.close;
  qAudit.SQL.Text := 'SELECT * FROM Audit WHERE Type = ''' + QS(Which) + '''' +
                     ' Order By TransactionDate, TransactionDate, WeekNo, SequenceNo, TicketNo, UserName';
  qAudit.open;
end;

procedure TfmAudit.seDaysInvalidEntry(Sender: TObject);
begin
  DaysInvalid := True;
  seDays.Value := 0;
  seDays.SetFocus;
end;

procedure TfmAudit.btnSaveAndClearAllClick(Sender: TObject);
var
  Saved: Boolean;

begin
  Saved := SaveTextFiles;
  tbMain.SetFocus;

  if Saved then
  begin
    qAudit2.SQL.Text := 'DELETE FROM Audit WHERE TransactionDate <= CurDate()';
    qAudit2.execSQL;
  end;

  //Refresh
  SearchType;
end;

procedure TfmAudit.btnSaveASCClick(Sender: TObject);
begin
  SaveTextFiles;
end;

procedure TfmAudit.pcAuditDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

end.
