unit SuppliersWhereUsed;

interface

uses
  Classes, Controls, Forms, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus, ExtCtrls, Buttons,
  ToolWin, ComCtrls, frxClass, frxDBSet, Vcl.DBGrids, frxReportPlus;

type
  TfmSupplierWhereUsed = class(TForm)
    pnlMaterials: TPanel;
    dbgMaterialsUsing: TDBGridPlus;
    dsMaterialSuppliers: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qMaterialSuppliers: TFDQueryPlus;
    qMaterialSuppliersMaterial: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frdbMaterialSuppliers: TfrxDBDataset;
    frMaterialSuppliersWhereUsed: TfrxReportPlus;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassSupplierName(var Code: string);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgMaterialsUsingDblClick(Sender: TObject);
    procedure dbgMaterialsUsingKeyPress(Sender: TObject; var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frMaterialSuppliersWhereUsedBeforePrint(
      Sender: TfrxReportComponent);
    procedure frMaterialSuppliersWhereUsedGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSupplierWhereUsed: TfmSupplierWhereUsed;

implementation

uses
  Windows, Graphics, Summs, MaterialDetails, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmSupplierWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmSupplierWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmSupplierWhereUsed.PassSupplierName(var Code: string);
begin
  Caption := 'Where Used for Supplier : ' + Code;

  qMaterialSuppliers.ParamByName('Supplier').AsString := Code;
  qMaterialSuppliers.Open;
end;

procedure TfmSupplierWhereUsed.frMaterialSuppliersWhereUsedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frMaterialSuppliersWhereUsed.PreviewOptions.AllowEdit := False;
  frMaterialSuppliersWhereUsed.PreviewOptions.Buttons := frMaterialSuppliersWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frMaterialSuppliersWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frMaterialSuppliersWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frMaterialSuppliersWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSupplierWhereUsed.frMaterialSuppliersWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmSupplierWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  frMaterialSuppliersWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qMaterialSuppliers.GetBookmark;
  qMaterialSuppliers.DisableControls;

  frMaterialSuppliersWhereUsed.PrintOptions.PrintMode := pmScale;
  frMaterialSuppliersWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frMaterialSuppliersWhereUsed.PrepareReport;

  try
    qMaterialSuppliers.GotoBookmark(MyBookmark);
  except
  end;
  qMaterialSuppliers.EnableControls;
  qMaterialSuppliers.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frMaterialSuppliersWhereUsed.ShowPreparedReport
  else
    frMaterialSuppliersWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmSupplierWhereUsed.dbgMaterialsUsingDblClick(Sender: TObject);
var
  Code : string;
  Failed:boolean;
  fmMaterialDetails : TfmMaterialDetails;

begin
  Code := qMaterialSuppliersMaterial.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Material', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmMaterialDetails := TfmMaterialDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmMaterialDetails.PassMaterialName(fmMaterialDetails, Code);
    end;
  end;
end;

procedure TfmSupplierWhereUsed.dbgMaterialsUsingKeyPress(Sender: TObject;
                                                         var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgMaterialsUsingDblClick(Self);
end;

procedure TfmSupplierWhereUsed.btnRefreshClick(Sender: TObject);
begin
  qMaterialSuppliers.close;
  qMaterialSuppliers.open;
end;

procedure TfmSupplierWhereUsed.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
