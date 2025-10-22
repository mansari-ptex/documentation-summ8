unit KnivesWhereUsed;

interface

uses
  Classes, Controls, Forms, Grids, DBGridPlus, DB, ExtCtrls, Buttons, ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus,
  FDTablePlus, ToolWin, StdCtrls, SysUtils, DBCtrls, frxClass, frxDBSet, Types,
  Vcl.DBGrids, frxReportPlus, Vcl.Dialogs;

type
  TfmKnivesWhereUsed = class(TForm)
    dsPartWidhtKnife: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qPartWidthKnife: TFDQueryPlus;
    qPartWidthKnifePart: TStringField;
    qPartWidthKnifeWidthNo: TSmallintField;
    qPartWidthKnifeKnife: TStringField;
    qPartWidthKnifeSizeRelationship: TStringField;
    qPartWidthKnifeSizeAdjustment: TSmallintField;
    qPartWidthKnifeWidth: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    qLayplans: TFDQueryPlus;
    dsLayplans: TDataSource;
    frKnifeSetsWhereUsed: TfrxReportPlus;
    frdbPartWidthKnife: TfrxDBDataset;
    frdbLayplans: TfrxDBDataset;
    qLayplansKnifeSize: TStringField;
    qLayplansMaterialLength: TIntegerField;
    qLayplansMaterialWidth: TIntegerField;
    qLayplansMaterialCutGap: TIntegerField;
    qLayplansMaterialCodeRestrictive: TStringField;
    pnlMain: TPanel;
    pnlTitlesMain: TPanel;
    pnlTitles1: TPanel;
    pnlTitles3: TPanel;
    pnlTitles4: TPanel;
    pnlTitles2: TPanel;
    pnlTitles5: TPanel;
    dbgParts: TDBGridPlus;
    dbgLayplans: TDBGridPlus;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassKnifeName(var Code: string);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgPartsDblClick(Sender: TObject);
    procedure dbgPartsKeyPress(Sender: TObject; var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frKnifeSetsWhereUsedBeforePrint(Sender: TfrxReportComponent);
    procedure frKnifeSetsWhereUsedGetValue(const VarName: string;
      var Value: Variant);
    procedure pcMainDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
  private
    { Private declarations }
    BusyPrinting: boolean;
  public
    { Public declarations }
  end;

var
  fmKnivesWhereUsed: TfmKnivesWhereUsed;

implementation

uses
  Windows, Graphics, General, Summs, PartDetails, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmKnivesWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    action := caFree
  end;
end;

procedure TfmKnivesWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmKnivesWhereUsed.PassKnifeName(var Code: string);
begin
  Caption := 'Where Used for Knife : ' + Code;

  qPartWidthKnife.ParamByName('Knife').AsString := Code;
  qPartWidthKnife.Open;

  qLayplans.ParamByName('Knife').AsString := Code;
  qLayplans.Open;
end;

procedure TfmKnivesWhereUsed.pcMainDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TfmKnivesWhereUsed.frKnifeSetsWhereUsedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frKnifeSetsWhereUsed.PreviewOptions.AllowEdit := False;
  frKnifeSetsWhereUsed.PreviewOptions.Buttons := frKnifeSetsWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frKnifeSetsWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frKnifeSetsWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frKnifeSetsWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmKnivesWhereUsed.frKnifeSetsWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmKnivesWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frKnifeSetsWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qPartWidthKnife.GetBookmark;
  qPartWidthKnife.DisableControls;

  frKnifeSetsWhereUsed.PrintOptions.PrintMode := pmScale;
  frKnifeSetsWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frKnifeSetsWhereUsed.PrepareReport;

  try
    qPartWidthKnife.GotoBookmark(MyBookmark);
  except
  end;
  qPartWidthKnife.EnableControls;
  qPartWidthKnife.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frKnifeSetsWhereUsed do
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
    frKnifeSetsWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmKnivesWhereUsed.dbgPartsDblClick(Sender: TObject);
var
  fmPartDetails : TfmPartDetails;
  Code : string;
  Failed : boolean;

begin
  Code := qPartWidthKnifePart.value;

  if not(Code = '') then
  begin
    if not ExistingToFront('Part', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmPartDetails := TfmPartDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmPartDetails.PassPartName(fmPartDetails, Code);
    end;
  end;
end;

procedure TfmKnivesWhereUsed.dbgPartsKeyPress(Sender: TObject;
                                                      var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgPartsDblClick(Self);
end;

procedure TfmKnivesWhereUsed.btnRefreshClick(Sender: TObject);
begin
  qPartWidthKnife.close;
  qPartWidthKnife.open;

  qLayplans.close;
  qLayplans.open;
end;

procedure TfmKnivesWhereUsed.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;
end;

end.

