unit AllSizeRanges;

interface

uses
  Forms, StdCtrls, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBGridPlus, ExtCtrls, Buttons, ComCtrls,
  Controls, ToolWin, Classes, Grids, frxClass, frxDBSet, DBGrids, frxReportPlus,
  Vcl.Dialogs;

type
  TfmAllSizeRanges = class(TForm)
    dbgSizeRanges: TDBGridPlus;
    dsSizeRanges: TDataSource;
    qSizeRanges: TFDQueryPlus;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qSizeRangesRange: TStringField;
    qSizeRangesScale: TStringField;
    qSizeRangesDescription: TStringField;
    pnlSearch: TPanel;
    edSearch: TEdit;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frdbAllSizeRanges: TfrxDBDataset;
    frAllSizeRanges: TfrxReportPlus;
    lblSearch: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgSizeRangesDblClick(Sender: TObject);
    procedure dbgSizeRangesKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSizeRangesTitleClick(Column: TColumn);
    procedure dbgSizeRangesCellClick(Column: TColumn);
    procedure frAllSizeRangesGetValue(const VarName: string;
      var Value: Variant);
    procedure frAllSizeRangesBeforePrint(Sender: TfrxReportComponent);
  private
    { Private declarations }
    BusyPrinting: boolean;
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmAllSizeRanges: TfmAllSizeRanges;

implementation

uses
  Windows, Graphics, General, SizeRangeDetails, Summs, OutOfMemory,
  SummsVars;

{$R *.DFM}

procedure TfmAllSizeRanges.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    qSizeRanges.close;
    action := caFree;
  end;
end;

procedure TfmAllSizeRanges.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmAllSizeRanges.dbgSizeRangesDblClick(Sender: TObject);
var
  fmSizeRangeDetails: TfmSizeRangeDetails;
  Code: string;
  Failed: boolean;

begin
  Code := qSizeRangesRange.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Size Range', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmSizeRangeDetails := TfmSizeRangeDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmSizeRangeDetails.PassSizeRangeName(fmSizeRangeDetails, Code);
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmAllSizeRanges.dbgSizeRangesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgSizeRangesDblClick(Self);
end;

procedure TfmAllSizeRanges.edSearchChange(Sender: TObject);

begin
  if edSearch.Text = ActiveSearch then
  begin
    edSearch.Font.Color := OurColor(clWindowText);
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
  end
  else
  begin
    edSearch.Font.Color := clRed;
    btnPrintPreview.Enabled := False;
    btnPrint.Enabled := False;
  end;
end;

procedure TfmAllSizeRanges.frAllSizeRangesBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllSizeRanges.PreviewOptions.AllowEdit := False;
  frAllSizeRanges.PreviewOptions.Buttons := frAllSizeRanges.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllSizeRanges.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllSizeRanges.PreviewOptions.ZoomMode := zmDefault
  else
    frAllSizeRanges.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllSizeRanges.frAllSizeRangesGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
end;

procedure TfmAllSizeRanges.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frAllSizeRanges.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qSizeRanges.GetBookmark;
  qSizeRanges.DisableControls;
  qSizeRanges.Refresh;

  frAllSizeRanges.PrintOptions.PrintMode := pmScale;
  frAllSizeRanges.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllSizeRanges.PrepareReport;

  try
    qSizeRanges.GotoBookmark(MyBookmark);
  except
  end;
  qSizeRanges.EnableControls;
  qSizeRanges.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frAllSizeRanges do
    begin
      ShowPreparedReport;
      if (((PreviewForm.Left + (PreviewForm.Width div 2)) > Application.MainForm.Width) or 
          (((PreviewForm.Left + (PreviewForm.Width div 2)) < 0))) then
        PreviewForm.Left := ((Application.MainForm.Width - PreviewForm.Width) div 2);
      if (((PreviewForm.Top + (PreviewForm.Height div 2)) > Application.MainForm.Height) or 
          (((PreviewForm.Top + (PreviewForm.Height div 2)) < 0))) then
        PreviewForm.Top := ((Application.MainForm.Height - PreviewForm.Height) div 2);
    end;
  end
  else
    frAllSizeRanges.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllSizeRanges.btnRefreshClick(Sender: TObject);
begin
  qSizeRanges.Close;
  if edSearch.Font.Color = clRed then
    qSizeRanges.ParamByName('Search').AsString := edSearch.text + '%';
  qSizeRanges.Open;

  edSearch.Font.Color := OurColor(clWindowText);
  btnPrintPreview.Enabled := True;
  btnPrint.Enabled := True;
  ActiveSearch := edSearch.Text;

  //Fixes Missing Scrollbar on Windows 8
  //if Refresh with nothing selected then
  //refresh again with enough selected that
  //it SHOULD show Scrollbar. Was working
  //as it should on Windows 7 but needs
  //this 'twitch' to work with Windows 8.
  //Included in all 'All' forms.
  Width := Width + 1;
  Width := Width - 1;
end;

procedure TfmAllSizeRanges.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;

  ActiveSearch := '';
  qSizeRanges.ParamByName('Search').AsString := '%';
  qSizeRanges.Open;

  dbgSizeRanges.SortColumn := 0;
  dbgSizeRanges.SortOrder := soAscending;
  dbgSizeRanges.Refresh;
end;

procedure TfmAllSizeRanges.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllSizeRanges.dbgSizeRangesTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  if fmSumms.ActiveMDIChild = Self then
  begin
    dbgSizeRanges.OnDblClick := nil;

    if (Column.FieldName = 'Range') or (Column.Fieldname = 'Description') then
    begin
      SortOrder(dbgSizeRanges, Column, SQLString);

      qSizeRanges.Close;
      qSizeRanges.SQL.Text := 'SELECT Range, Scale, Description FROM SizeRanges WHERE Range LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Range ' + SQLString ;
      qSizeRanges.Open;
    end;
  end;
end;

procedure TfmAllSizeRanges.dbgSizeRangesCellClick(Column: TColumn);
begin
  dbgSizeRanges.OnDblClick := dbgSizeRangesDblClick;
end;

end.
