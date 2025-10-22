unit AllWidthRanges;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus,
  ExtCtrls, Buttons, ToolWin, ComCtrls, frxClass, frxDBSet, DBGrids,
  frxReportPlus;

type
  TfmAllWidthRanges = class(TForm)
    dbgWidthRanges: TDBGridPlus;
    dsWidthRanges: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    qWidthRanges: TFDQueryPlus;
    qWidthRangesCode: TStringField;
    qWidthRangesDescription: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frdbAllWidthRanges: TfrxDBDataset;
    frAllWidthRanges: TfrxReportPlus;
    lblSearch: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgWidthRangesDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure dbgWidthRangesKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgWidthRangesTitleClick(Column: TColumn);
    procedure dbgWidthRangesCellClick(Column: TColumn);
    procedure frAllWidthRangesBeforePrint(Sender: TfrxReportComponent);
    procedure frAllWidthRangesGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmAllWidthRanges: TfmAllWidthRanges;

implementation

uses
  Windows, Graphics, General, WidthDetails, Summs, OutOfMemory,
  SummsVars;

{$R *.DFM}

procedure TfmAllWidthRanges.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qWidthRanges.close;
  action := caFree;
end;

procedure TfmAllWidthRanges.FormActivate(Sender: TObject);
begin
Screen.cursor := crDefault;
end;

procedure TfmAllWidthRanges.dbgWidthRangesDblClick(Sender: TObject);

var code:string;
    Failed:boolean;

begin
  Code := qWidthRangesCode.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Width Range', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmWidthDetails := TfmWidthDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then fmWidthDetails.PassWidthRangeName(Code);
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmAllWidthRanges.Button1Click(Sender: TObject);
var SINew:TScrollInfo;
begin
  GetScrollInfo(dbgWidthRanges.Handle,SB_VERT,SINew);
  SINew.Fmask:=SIF_DISABLENOSCROLL;
  SetScrollInfo(dbgWidthRanges.Handle,SB_VERT,SINew,True)
end;

procedure TfmAllWidthRanges.dbgWidthRangesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgWidthRangesDblClick(Self);
end;

procedure TfmAllWidthRanges.edSearchChange(Sender: TObject);

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

procedure TfmAllWidthRanges.frAllWidthRangesBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllWidthRanges.PreviewOptions.AllowEdit := False;
  frAllWidthRanges.PreviewOptions.Buttons := frAllWidthRanges.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllWidthRanges.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllWidthRanges.PreviewOptions.ZoomMode := zmDefault
  else
    frAllWidthRanges.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllWidthRanges.frAllWidthRangesGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
end;

procedure TfmAllWidthRanges.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  frAllWidthRanges.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qWidthRanges.GetBookmark;
  qWidthRanges.DisableControls;

  frAllWidthRanges.PrintOptions.PrintMode := pmScale;
  frAllWidthRanges.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllWidthRanges.PrepareReport;

  qWidthRanges.GotoBookmark(MyBookmark);
  qWidthRanges.EnableControls;
  qWidthRanges.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frAllWidthRanges.ShowPreparedReport
  else
    frAllWidthRanges.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmAllWidthRanges.btnRefreshClick(Sender: TObject);
begin
  qWidthRanges.Close;
  if edSearch.Font.Color = clRed then
    qWidthRanges.ParamByName('Search').AsString := edSearch.text + '%';
  qWidthRanges.Open;

  edSearch.Font.Color := OurColor(clWindowText);
  btnPrintPreview.Enabled := True;
  btnPrint.Enabled := True;
  ActiveSearch := edSearch.Text;  
end;

procedure TfmAllWidthRanges.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  ActiveSearch := '';
  qWidthRanges.ParamByName('Search').AsString := '%';
  qWidthRanges.Open;

  dbgWidthRanges.SortColumn := 0;
  dbgWidthRanges.SortOrder := soAscending;
  dbgWidthRanges.Refresh;
end;

procedure TfmAllWidthRanges.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllWidthRanges.dbgWidthRangesTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  dbgWidthRanges.OnDblClick := nil;

  if (Column.FieldName = 'Code') or (Column.Fieldname = 'Description') then
  begin
    dbgWidthRanges.SortColumn := Column.Index;

    if dbgWidthRanges.SortOrder = soAscending then
    begin
      dbgWidthRanges.SortOrder := soDescending;
      SQLString := ' DESC';
    end
    else
    begin
      dbgWidthRanges.SortOrder := soAscending;
      SQLString := ' ASC';
    end;

    qWidthRanges.Close;
    qWidthRanges.SQL.Text := 'SELECT Code, Description FROM WRngs WHERE Code LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
    qWidthRanges.Open;
  end;
end;

procedure TfmAllWidthRanges.dbgWidthRangesCellClick(Column: TColumn);
begin
  dbgWidthRanges.OnDblClick := dbgWidthRangesDblClick;
end;

end.
