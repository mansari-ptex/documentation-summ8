unit AllSizeScales;

interface

uses
  Forms, StdCtrls, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBGridPlus, ExtCtrls, Buttons, ComCtrls,
  Controls, ToolWin, Classes, Grids, frxClass, frxDBSet, DBGrids, frxReportPlus;

type
  TfmAllSizeScales = class(TForm)
    dbgSizeScales: TDBGridPlus;
    dsSizeScales: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    qSizeScales: TFDQueryPlus;
    qSizeScalesScale: TStringField;
    qSizeScalesDescription: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frAllSizeScales: TfrxReportPlus;
    frdbAllSizeScales: TfrxDBDataset;
    lblSearch: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgSizeScalesDblClick(Sender: TObject);
    procedure dbgSizeScalesKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSizeScalesTitleClick(Column: TColumn);
    procedure dbgSizeScalesCellClick(Column: TColumn);
    procedure frAllSizeScalesBeforePrint(Sender: TfrxReportComponent);
    procedure frAllSizeScalesGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
    ActiveSearch : String;
  public
    { Public declarations }
  end;

var
  fmAllSizeScales: TfmAllSizeScales;

implementation

uses
  Windows, Graphics, General, SizeScaleDetails, Summs,
  OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmAllSizeScales.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qSizeScales.close;
  action := caFree;
end;

procedure TfmAllSizeScales.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmAllSizeScales.dbgSizeScalesDblClick(Sender: TObject);
var
  fmSizeScaleDetails: TfmSizeScaleDetails;
  Code : string;
  Failed : boolean;

begin
  Code := qSizeScalesScale.value;

  if not(Code = '') then
  begin
    if not ExistingTofront('Size Scale', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmSizeScaleDetails := TfmSizeScaleDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmSizeScaleDetails.PassSizeScaleName(fmSizeScaleDetails, Code);
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmAllSizeScales.dbgSizeScalesKeyPress(Sender: TObject;
                                                 var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgSizeScalesDblClick(Self);
end;

procedure TfmAllSizeScales.edSearchChange(Sender: TObject);

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

procedure TfmAllSizeScales.frAllSizeScalesBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllSizeScales.PreviewOptions.AllowEdit := False;
  frAllSizeScales.PreviewOptions.Buttons := frAllSizeScales.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllSizeScales.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllSizeScales.PreviewOptions.ZoomMode := zmDefault
  else
    frAllSizeScales.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllSizeScales.frAllSizeScalesGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
end;

procedure TfmAllSizeScales.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  frAllSizeScales.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qSizeScales.GetBookmark;
  qSizeScales.DisableControls;
  qSizeScales.Refresh;

  frAllSizeScales.PrintOptions.PrintMode := pmScale;
  frAllSizeScales.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllSizeScales.PrepareReport;

  try
    qSizeScales.GotoBookmark(MyBookmark);
  except
  end;
  qSizeScales.EnableControls;
  qSizeScales.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frAllSizeScales.ShowPreparedReport
  else
    frAllSizeScales.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmAllSizeScales.btnRefreshClick(Sender: TObject);
begin
  qSizeScales.Close;
  if edSearch.Font.Color = clRed then
    qSizeScales.ParamByName('Search').AsString := edSearch.text + '%';
  qSizeScales.Open;

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

procedure TfmAllSizeScales.FormCreate(Sender: TObject);
var
  i: integer;
  
begin
  AutoColor(Self);

  ActiveSearch := '';
  qSizeScales.ParamByName('Search').AsString := '%';
  qSizeScales.Open;

  dbgSizeScales.SortColumn := 0;
  dbgSizeScales.SortOrder := soAscending;
  dbgSizeScales.Refresh;
end;

procedure TfmAllSizeScales.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllSizeScales.dbgSizeScalesTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  dbgSizeScales.OnDblClick := nil;

  if (Column.FieldName = 'Scale') or (Column.Fieldname = 'Description') then
  begin
    dbgSizeScales.SortColumn := Column.Index;

    if dbgSizeScales.SortOrder = soAscending then
    begin
      dbgSizeScales.SortOrder := soDescending;
      SQLString := ' DESC';
    end
    else
    begin
      dbgSizeScales.SortOrder := soAscending;
      SQLString := ' ASC';
    end;

    qSizeScales.Close;
    qSizeScales.SQL.Text := 'SELECT Scale, Description FROM SizeScales WHERE Scale LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Scale ' + SQLString ;
    qSizeScales.Open;
  end;
end;

procedure TfmAllSizeScales.dbgSizeScalesCellClick(Column: TColumn);
begin
  dbgSizeScales.OnDblClick := dbgSizeScalesDblClick;
end;

end.
