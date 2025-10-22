unit MaterialsWhereUsed;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBGridPlus, Buttons,
  ComCtrls, ToolWin, Grids, frxClass, frxDBSet, Vcl.StdCtrls, Dialogs,
  SysUtils, Vcl.DBGrids, frxReportPlus;

type
  TfmMaterialWhereUsed = class(TForm)
    pnlMain: TPanel;
    dbgPartsUsing: TDBGridPlus;
    dsConstructionParts: TDataSource;
    dsParts: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qConstructionParts: TFDQueryPlus;
    qParts: TFDQueryPlus;
    qConstructionPartsConstruction: TStringField;
    qConstructionPartsPart: TStringField;
    qPartsCode: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frMaterialsWhereUsed: TfrxReportPlus;
    frdbConstructionParts: TfrxDBDataset;
    frdbParts: TfrxDBDataset;
    dbgPartsOnConstructionsUsing: TDBGridPlus;
    btnSize: TButton;
    pnlTitlesMain: TPanel;
    pnlTitles1: TPanel;
    pnlTitles3: TPanel;
    pnlTitles4: TPanel;
    pnlTitles2: TPanel;
    pnlTitles5: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassMaterialName(var Code: string);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgPartsOnConstructionsUsingDblClick(Sender: TObject);
    procedure dbgPartsOnConstructionsUsingKeyPress(Sender: TObject;
      var Key: Char);
    procedure dbgPartsUsingDblClick(Sender: TObject);
    procedure dbgPartsUsingKeyPress(Sender: TObject; var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frMaterialsWhereUsedBeforePrint(Sender: TfrxReportComponent);
    procedure frMaterialsWhereUsedGetValue(const VarName: string;
      var Value: Variant);
    procedure btnSizeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMaterialWhereUsed: TfmMaterialWhereUsed;

implementation

uses
  Windows, Graphics, General, Summs, ConstructionDetails, PartDetails, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmMaterialWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree
end;

procedure TfmMaterialWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmMaterialWhereUsed.PassMaterialName(var Code: string);
begin
  Caption := 'Where Used for Material : ' + Code;

  qParts.ParamByName('Material').AsString := Code;
  qParts.Open;

  qConstructionParts.ParamByName('Material').AsString := Code;
  qConstructionParts.Open;
end;

procedure TfmMaterialWhereUsed.frMaterialsWhereUsedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frMaterialsWhereUsed.PreviewOptions.AllowEdit := False;
  frMaterialsWhereUsed.PreviewOptions.Buttons := frMaterialsWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frMaterialsWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frMaterialsWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frMaterialsWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmMaterialWhereUsed.frMaterialsWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmMaterialWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark, MyBookmark2: TBookmark;

begin
  frMaterialsWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qParts.GetBookmark;
  MyBookmark2 := qConstructionParts.GetBookmark;
  qParts.DisableControls;
  qConstructionParts.DisableControls;

  frMaterialsWhereUsed.PrintOptions.PrintMode := pmScale;
  frMaterialsWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frMaterialsWhereUsed.PrepareReport;

  qParts.GotoBookmark(MyBookmark);
  qParts.EnableControls;
  qParts.FreeBookmark(MyBookmark);

  qConstructionParts.GotoBookmark(MyBookmark2);
  qConstructionParts.EnableControls;
  qConstructionParts.FreeBookmark(MyBookmark2);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frMaterialsWhereUsed.ShowPreparedReport
  else
    frMaterialsWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmMaterialWhereUsed.dbgPartsOnConstructionsUsingDblClick(Sender: TObject);
var
  fmConstructionDetails: TfmConstructionDetails;
  Code : string;
  Failed : boolean;

begin
  Code := qConstructionPartsConstruction.value;

  if not(Code = '') then
  begin
    if not ExistingToFront('Construction', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmConstructionDetails := TfmConstructionDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmConstructionDetails.PassConstructionName(fmConstructionDetails, Code);
    end;
  end;
end;

procedure TfmMaterialWhereUsed.dbgPartsOnConstructionsUsingKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgPartsonConstructionsUsingDblClick(Self);
end;

procedure TfmMaterialWhereUsed.dbgPartsUsingDblClick(Sender: TObject);
var
  fmPartDetails : TfmPartDetails;
  Code : string;
  Failed:boolean;

begin
  Code := qPartsCode.value;

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

procedure TfmMaterialWhereUsed.dbgPartsUsingKeyPress(Sender: TObject;
                                                     var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgPartsUsingDblClick(Self);
end;

procedure TfmMaterialWhereUsed.btnRefreshClick(Sender: TObject);
begin
  qParts.close;
  qParts.open;
  qConstructionParts.close;
  qConstructionParts.open;
end;

procedure TfmMaterialWhereUsed.btnSizeClick(Sender: TObject);
begin
  showmessage(inttostr(fmMaterialWhereUsed.height) + ' - ' + inttostr(fmMaterialWhereUsed.Width));
end;

procedure TfmMaterialWhereUsed.FormCreate(Sender: TObject);
var
  AddToHeight, AddToWidth: integer;

begin
  AutoColor(Self);
end;

end.
