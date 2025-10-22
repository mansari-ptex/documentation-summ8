unit AllSizeRelationships;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, ExtCtrls, Buttons,
  ComCtrls, ToolWin, Grids, DBGridPlus, DBGrids, frxClass, frxDBSet,
  frxReportPlus, Vcl.Dialogs;

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
    BusyPrinting: boolean;
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
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    qSizeRelationships.close;
    action := caFree;
  end;
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
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frAllSizeRelationships.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qSizeRelationships.GetBookmark;
  qSizeRelationships.DisableControls;
  qSizeRelationships.Refresh;

  frAllSizeRelationships.PrintOptions.PrintMode := pmScale;
  frAllSizeRelationships.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllSizeRelationships.PrepareReport;
  
  try
    qSizeRelationships.GotoBookmark(MyBookmark);
  except
  end;
  qSizeRelationships.EnableControls;
  qSizeRelationships.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frAllSizeRelationships do
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
    frAllSizeRelationships.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllSizeRelationships.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;

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
  if fmSumms.ActiveMDIChild = Self then
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
end;

procedure TfmAllSizeRelationships.dbgSizeRelationshipsCellClick(
  Column: TColumn);
begin
  dbgSizeRelationships.OnDblClick := dbgSizeRelationshipsDblClick;
end;

end.
