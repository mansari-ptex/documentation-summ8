unit AllSizeRelationships;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, ExtCtrls, Buttons,
  ComCtrls, ToolWin, Grids, DBGridPlus, DBGrids, frxClass, frxDBSet,
  frxReportPlus;

type
  TfmAllSizeRelationships = class(TForm)
    dsSizeRelationships: TDataSource;
    dbgSizeRelationships: TDBGridPlus;
    qSizeRelationships: TFDQueryPlus;
    qSizeRelationshipsRelationship: TStringField;
    qSizeRelationshipsRange: TStringField;
    qSizeRelationshipsDescription: TStringField;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frAllSizeRelationships: TfrxReportPlus;
    frdbAllSizeRelationships: TfrxDBDataset;
    lblSearch: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edSearchChange(Sender: TObject);
    procedure dbgSizeRelationshipsDblClick(Sender: TObject);
    procedure dbgSizeRelationshipsKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSizeRelationshipsTitleClick(Column: TColumn);
    procedure dbgSizeRelationshipsCellClick(Column: TColumn);
    procedure frAllSizeRelationshipsBeforePrint(Sender: TfrxReportComponent);
    procedure frAllSizeRelationshipsGetValue(const VarName: string;
      var Value: Variant);
    procedure dbgSizeRelationshipsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmAllSizeRelationships: TfmAllSizeRelationships;

implementation

uses
  Windows, Graphics, Menus, General, CmnVars,
  SizeRelationshipDetails, Summs, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmAllSizeRelationships.FormClose(Sender: TObject;
                                            var Action: TCloseAction);
begin
  qSizeRelationships.close;
  action := caFree;
end;

procedure TfmAllSizeRelationships.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmAllSizeRelationships.edSearchChange(Sender: TObject);
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

procedure TfmAllSizeRelationships.dbgSizeRelationshipsDblClick(Sender: TObject);
var
  fmSizeRelationshipDetails: TfmSizeRelationshipDetails;
  Code : string;
  Failed:boolean;

begin
  Code := qSizeRelationshipsRelationship.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Size Relationship', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmSizeRelationshipDetails := TfmSizeRelationshipDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmSizeRelationshipDetails.PassSizeRelationshipName(fmSizeRelationshipDetails, Code);
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmAllSizeRelationships.dbgSizeRelationshipsKeyPress(Sender: TObject;
                                                               var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgSizeRelationshipsDblClick(Self);
end;

procedure TfmAllSizeRelationships.dbgSizeRelationshipsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if y > TStringGrid(Sender).RowHeights[0] then
  begin
    if (ssLeft in Shift) then
    begin
      DragType := dragSizeRelationship;
      DragSort := dragEdit;
      DragCode := qSizeRelationshipsRelationship.value;

      TDBGridPlus(Sender).BeginDrag(False, MouseMovePixels);
    end;
  end;
end;

procedure TfmAllSizeRelationships.frAllSizeRelationshipsBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllSizeRelationships.PreviewOptions.AllowEdit := False;
  frAllSizeRelationships.PreviewOptions.Buttons := frAllSizeRelationships.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllSizeRelationships.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllSizeRelationships.PreviewOptions.ZoomMode := zmDefault
  else
    frAllSizeRelationships.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllSizeRelationships.frAllSizeRelationshipsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
end;

procedure TfmAllSizeRelationships.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  frAllSizeRelationships.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qSizeRelationships.GetBookmark;
  qSizeRelationships.DisableControls;

  frAllSizeRelationships.PrintOptions.PrintMode := pmScale;
  frAllSizeRelationships.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllSizeRelationships.PrepareReport;
  
  qSizeRelationships.GotoBookmark(MyBookmark);
  qSizeRelationships.EnableControls;
  qSizeRelationships.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frAllSizeRelationships.ShowPreparedReport
  else
    frAllSizeRelationships.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmAllSizeRelationships.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  ActiveSearch := '';
  qSizeRelationships.ParamByName('Search').AsString := '%';
  qSizeRelationships.Open;

  dbgSizeRelationships.SortColumn := 0;
  dbgSizeRelationships.SortOrder := soAscending;
  dbgSizeRelationships.Refresh;
end;

procedure TfmAllSizeRelationships.btnRefreshClick(Sender: TObject);
begin
  qSizeRelationships.Close;
  if edSearch.Font.Color = clRed then
    qSizeRelationships.ParamByName('Search').AsString := edSearch.text + '%';
  qSizeRelationships.Open;

  edSearch.Font.Color := OurColor(clWindowText);
  btnPrintPreview.Enabled := True;
  btnPrint.Enabled := True;
  ActiveSearch := edSearch.Text;
end;

procedure TfmAllSizeRelationships.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllSizeRelationships.dbgSizeRelationshipsTitleClick(
  Column: TColumn);
var
  SQLString: string;

begin
  dbgSizeRelationships.OnDblClick := nil;

  if (Column.FieldName = 'Relationship') or (Column.Fieldname = 'Description') then
  begin
    dbgSizeRelationships.SortColumn := Column.Index;

    if dbgSizeRelationships.SortOrder = soAscending then
    begin
      dbgSizeRelationships.SortOrder := soDescending;
      SQLString := ' DESC';
    end
    else
    begin
      dbgSizeRelationships.SortOrder := soAscending;
      SQLString := ' ASC';
    end;

    qSizeRelationships.Close;
    qSizeRelationships.SQL.Text := 'SELECT Relationship, Range, Description FROM SizeRelationships WHERE Relationship LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Relationship ' + SQLString ;
    qSizeRelationships.Open;
  end;
end;

procedure TfmAllSizeRelationships.dbgSizeRelationshipsCellClick(
  Column: TColumn);
begin
  dbgSizeRelationships.OnDblClick := dbgSizeRelationshipsDblClick;
end;

end.
