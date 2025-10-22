unit MaterialDetails;

{A big note about the Clarks work:
This version of SATRASumm contains code to make special Clarks linear allowances. There is a
Word document about the number we believe Clarks requested during a JLP visit in Dec 2010.
Clarks were sent this document and never responded to confirm that it matched their request.
JLP believes that other companies would benefit from being able to enter the material price in linear
terms e.g. price per foot of 54" wide material, so this is in this release. However, JLP and TAH agree
that - with no confirmation from Clarks and no requests for the 'linear' type of allowance figure from
any other customer - there is little point in including this figure.
The code has been left in and the dbcbAllowance checkbox needed to trigger it has been made invisible on
this form.
IMPORTANT - the code is not finished. It works (untested) up to the Part/Style allowance level but allowances
appear in their linear form on the Tickets Breakdown/update grid and in sq units on the printed ticket.
The Ticket level ramifications would need careful thought and a rewrite if the linear allowance feature
was ever released.

Sept 2012 update - Linear Allowance work in Tickets removed. Only affects up to Style Allowance level.
Thought to be given to taking it further in future versions.
}

interface

uses
  Classes, Controls, Forms, StdCtrls, DBCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, ExtCtrls, DBGridPlus,
  Buttons, ComCtrls,  XStringGrid, XStringGridPlus, Grids, ToolWin, Mask,
  frxClass, frxDBSet, Types, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, Vcl.DBGrids, frxReportPlus, FDConnectionPlus;

type
  TfmMaterialDetails = class(TForm)
    tblMatSupl: TFDTablePlus;
    dsMatSupl: TDataSource;
    tblMatSuplMaterial: TStringField;
    tblMatSuplSupplier: TStringField;
    tblMatSuplPrice: TFloatField;
    tblMaterials: TFDTablePlus;
    dsMaterials: TDataSource;
    pnlTop: TPanel;
    lblCutType: TLabel;
    lblMatUnits: TLabel;
    tblMaterialsCode: TStringField;
    tblMaterialsDescription: TStringField;
    tblMaterialsType: TStringField;
    tblMaterialsCutType: TStringField;
    tblMaterialsStandardPrice: TCurrencyField;
    tblMaterialsDegDiff: TSmallintField;
    tblMaterialsQualCoeff: TSmallintField;
    tblMaterialsAreaCoeff: TSmallintField;
    tblMaterialsLength: TFloatField;
    tblMaterialsWidth: TFloatField;
    tblMaterialsSkinSize: TFloatField;
    tblMaterialsTrimmed: TBooleanField;
    tblMaterialsUnits: TStringField;
    tblMaterialsLayers: TSmallintField;
    tblMaterialsStrokeDepth: TFloatField;
    tblMaterialsNotes: TMemoField;
    dbeDescription: TDBEdit;
    lblDescription: TLabel;
    lblStandardPrice: TLabel;
    dbeStandardPrice: TDBEdit;
    lblMatTypes: TLabel;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    btnRefresh: TSpeedButton;
    cbCutType: TDBComboBox;
    LocalConnectionSumms: TFDConnectionPlus;
    cbUnits: TDBComboBox;
    pnlView1: TPanel;
    pnlView2: TPanel;
    pnlView3: TPanel;
    lblCuttingType: TLabel;
    lblUnitsType: TLabel;
    dbtDescription: TDBText;
    dbtStandardPrice: TDBText;
    tblMaterialsTrimmedYesNo: TStringField;
    pnlKeepPreview: TPanel;
    btnWhereUsed: TSpeedButton;
    btnCopy: TSpeedButton;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    lblMaterialType: TLabel;
    tblMaterialsCutGap: TSmallintField;
    qCheckForLayplans: TFDQueryPlus;
    qCheckForLayplansNoLayplans: TIntegerField;
    tblMaterialsLinearMatPrice: TBooleanField;
    tblMaterialsLinearAllowance: TBooleanField;
    tblMaterialsLinearMatPriceYesNo: TStringField;
    tblMaterialsLinearAllowanceYesNo: TStringField;
    pnlUseLinear: TPanel;
    dbcbMatPrice: TDBCheckBox;
    dbcbAllowance: TDBCheckBox;
    pnlLinearMatPrice: TPanel;
    dbtLinearPrice: TDBText;
    pnlLinearAllowance: TPanel;
    dbtLinearAllowance: TDBText;
    frMaterialDetails: TfrxReportPlus;
    frMaterials: TfrxDBDataset;
    frMatSupl: TfrxDBDataset;
    pcMaterial: TPageControl;
    tsDetails: TTabSheet;
    tsNotes: TTabSheet;
    Suppliers: TTabSheet;
    dbMemoNotes: TDBMemo;
    pnlView7: TPanel;
    dbmNotes: TDBMemo;
    pnlLeathers: TPanel;
    lblQualCoeff: TLabel;
    lblAreaCoeff: TLabel;
    lblSkinSize: TLabel;
    lblDegDiff: TLabel;
    dbeQualCoeff: TDBEdit;
    dbeAreaCoeff: TDBEdit;
    dbeSkinSize: TDBEdit;
    dbcbTrimmed: TDBCheckBox;
    pnlView5: TPanel;
    dbtQualCoeff: TDBText;
    dbtAreaCoeff: TDBText;
    dbtSkinSize: TDBText;
    dbtDegDiff: TDBText;
    dbtTrimmed: TDBText;
    pnlSynthetics: TPanel;
    lblLength: TLabel;
    lblWidth: TLabel;
    lblLayers: TLabel;
    lblStrokeDepth: TLabel;
    lblCutGap: TLabel;
    dbeLength: TDBEdit;
    dbeWidth: TDBEdit;
    dbeLayers: TDBEdit;
    dbeStrokeDepth: TDBEdit;
    dbeCutGap: TDBEdit;
    pnlView4: TPanel;
    dbtLayers: TDBText;
    dbtStrokeDepth: TDBText;
    dbtWidth: TDBText;
    dbtLength: TDBText;
    dbtCutGap: TDBText;
    pnlSuppliers: TPanel;
    dbgSuppliers: TDBGridPlus;
    pnlView6: TPanel;
    sgSuppliers: TXStringGridPlus;
    lblWidthWarning: TLabel;
    dbtType: TDBText;
    cbDegDiff: TDBComboBox;
    dbcbCutFromRoll: TDBCheckBox;
    tblMaterialsSheetCutFromRoll: TBooleanField;
    tblMaterialsSheetCutFromRollYesNo: TStringField;
    dbtCutFromRoll: TDBText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure PassMaterialName(MaterialForm : TfmMaterialDetails; var Code: string);
    procedure btnWhereUsedClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure MaterialType;
    procedure tblMaterialsWidthValidate(Sender: TField);
    procedure tblMaterialsAfterOpen(DataSet: TDataSet);
    procedure LoadCutTypesDropDown;
    procedure LoadUnitsDropDown;
    procedure UnitsType;
    procedure cbUnitsChange(Sender: TObject);
    procedure cbCutTypeChange(Sender: TObject);
    procedure CuttingType;
    procedure CheckWidth;
    procedure btnEditClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UpdateSuppliersCopy;
    procedure tblMatSuplAfterOpen(DataSet: TDataSet);
    procedure tblMaterialsCalcFields(DataSet: TDataSet);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure sgSuppliersDblClick(Sender: TObject);
    procedure sgSuppliersKeyPress(Sender: TObject; var Key: Char);
    procedure FinishSecondProcess(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sgSuppliersSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SetTabStops(Editing: Boolean);
    procedure dbgSuppliersDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dbgSuppliersDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure dbgSuppliersKeyPress(Sender: TObject; var Key: Char);
    procedure dbmNotesEnter(Sender: TObject);
    procedure frMaterialDetailsGetValue(const VarName: string;
      var Value: Variant);
    procedure frMaterialDetailsBeforePrint(Sender: TfrxReportComponent);
    procedure pcMaterialDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
  private
    { Private declarations }
    BusyPrinting: boolean;
    fmMaterialDetails: TfmMaterialDetails;
    ToFeet, SubUnitsPerUnit : real;
  public
    { Public declarations }
    MaterialCode : string;
    SecondProcessInUse: Boolean;
  end;

var
  GroupPrinting, PrintingCancelled: boolean;

implementation

uses
  SysUtils, Windows, Graphics, Dialogs, General, MaterialsWhereUsed, Summs, CopyMaterial,
  SupplierDetails, OutOfMemory, SummsThreads, SummsVars, CmnVars, AdvErrorHandler, Dongle_Green;

{$R *.DFM}

procedure TfmMaterialDetails.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    if tblMaterials.state in [dsEdit, dsInsert] then
    begin
      if MessageDlgPos('Save Changes to Material ' + MaterialCode + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    action := caFree;
  end;
end;

procedure TfmMaterialDetails.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmMaterialDetails.PassMaterialName(MaterialForm : TfmMaterialDetails; var Code: string);
begin
  try
    fmMaterialDetails := MaterialForm;
    MaterialCode := Code;

//    Caption := 'Material : ' + MaterialCode;
    Caption := 'Material Loading...';

    screen.cursor := crHourGlass;
    tblMaterials.open;
    tblMaterials.setRange([MaterialCode], [MaterialCode]);
    screen.cursor := crDefault;

    if tblMaterials.recordcount = 0 then
    begin
      MessageDlgPos('Material ' + MaterialCode + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      Caption := 'Material : Not Found';
      close;
    end
    else
    begin
      MaterialType;
      CuttingType;
      UnitsType;
      CheckWidth;
      LoadCutTypesDropDown;
      LoadUnitsDropDown;
    end;

    Caption := 'Material : ' + MaterialCode;
  except
    Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure TfmMaterialDetails.pcMaterialDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TfmMaterialDetails.btnWhereUsedClick(Sender: TObject);
var
  Code : string;
  Failed : boolean;

begin
  if ItemGone(tblMaterials, MaterialCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    Code := tblMaterialsCode.value;

    if not ExistingToFront('Where Used for Material', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmMaterialWhereUsed := TfmMaterialWhereUsed.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;
      if not Failed then
        fmMaterialWhereUsed.PassMaterialName(Code);
    end;
  end;
end;

procedure TfmMaterialDetails.btnDeleteClick(Sender: TObject);
var
  LockSuccess : boolean;
  CanDelete : boolean;
  NoLayplans: integer;
  s: string;

begin
  if ItemGone(tblMaterials, MaterialCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    CanDelete := False;

    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oMaterial, fmSumms.tblLocks, tblMaterials, MaterialCode, True);

    if LockSuccess then
    begin
      //Check for any associated Layplans
      qCheckForLayplans.ParamByName('MaterialCode').Value := MaterialCode;
      qCheckForLayplans.open;
      NoLayplans := qCheckForLayplansNoLayplans.Value;
      qCheckForLayplans.close;

      if NoLayplans >= 1 then
        s := 'Delete Material and its associated ' + intToStr(NoLayplans) + ' layplan(s)?'
      else
        s := 'Delete Material?';

      CanDelete := (MessageDlgPos(s , mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes);
      if CanDelete then
      begin
        try
          tblMaterials.delete;
        except
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Material in use', E.Message, '');
            CanDelete := false;
          end;
        end;
      end;
    end;

    //Unlock
    if CanDelete then
      LocalConnectionSumms.Commit
    else
      LocalConnectionSumms.RollBack;

    //Ensure table not in Edit mode and Close if deleted
    tblMatSupl.Cancel;
    tblMaterials.Cancel;
    if CanDelete then
      Close;
  end;
end;

procedure TfmMaterialDetails.btnPrintClick(Sender: TObject);
var
  mObj: TfrxMemoView;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  if ItemGone(tblMaterials, MaterialCode) then
    Close
  else
  begin
    frMaterialDetails.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    btnPrint.Enabled := False;
    btnPrintPreview.Enabled := False;

    mObj := frMaterialDetails.FindObject('mLinMatPrcTitle') as TfrxMemoView;
    mObj.Visible := pnlUseLinear.Visible;
    mObj := frMaterialDetails.FindObject('mLinMatPrc') as TfrxMemoView;
    mObj.Visible := pnlUseLinear.Visible;
    mObj := frMaterialDetails.FindObject('mLinAlwTitle') as TfrxMemoView;
    mObj.Visible := pnlUseLinear.Visible;
    mObj := frMaterialDetails.FindObject('mLinAlw') as TfrxMemoView;
    mObj.Visible := pnlUseLinear.Visible;

    if not(pnlLeathers.visible and DifficultLeatherFacility) then
    begin
      mObj := frMaterialDetails.FindObject('mDegDifTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mDegDif') as TfrxMemoView;
      mObj.Visible := False;
    end;

    if not pnlLeathers.visible then
    begin
      mObj := frMaterialDetails.FindObject('mQualCoeffTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mQualCoeff') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mAreaCoeffTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mAreaCoeff') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mSkinSizeTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mSkinSize') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mTrimmedTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mTrimmed') as TfrxMemoView;
      mObj.Visible := False;

      mObj := frMaterialDetails.FindObject('mLayersTitle') as TfrxMemoView;
      mObj.left := 1;
      mObj := frMaterialDetails.FindObject('mLayers') as TfrxMemoView;
      mObj.left := 120;
      mObj := frMaterialDetails.FindObject('mCutGapTitle') as TfrxMemoView;
      mObj.left := 1;
      mObj := frMaterialDetails.FindObject('mCutGap') as TfrxMemoView;
      mObj.left := 120;
      mObj := frMaterialDetails.FindObject('mStrokeDepthTitle') as TfrxMemoView;
      mObj.left := 1;
      mObj.Visible := lblStrokeDepth.enabled;
      mObj := frMaterialDetails.FindObject('mStrokeDepth') as TfrxMemoView;
      mObj.left := 120;
      mObj.Visible := dbtStrokeDepth.enabled;
      mObj := frMaterialDetails.FindObject('mWidthTitle') as TfrxMemoView;
      mObj.left := 1;
      mObj := frMaterialDetails.FindObject('mWidth') as TfrxMemoView;
      mObj.left := 120;
      mObj := frMaterialDetails.FindObject('mLengthTitle') as TfrxMemoView;
      mObj.left := 1;
      mObj.Visible := lblLength.visible;
      mObj := frMaterialDetails.FindObject('mLength') as TfrxMemoView;
      mObj.left := 120;
      mObj.Visible := dbtLength.visible;
      mObj := frMaterialDetails.FindObject('mCutFromRollTitle') as TfrxMemoView;
      mObj.left := 1;
      mObj.Visible := dbcbCutFromRoll.visible;
      mObj := frMaterialDetails.FindObject('mCutFromRoll') as TfrxMemoView;
      mObj.left := 120;
      mObj.Visible := dbtCutFromRoll.visible;
    end
    else
    begin
      mObj := frMaterialDetails.FindObject('mLayersTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mLayers') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mCutGapTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mCutGap') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mStrokeDepthTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mStrokeDepth') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mWidthTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mWidth') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mLengthTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mLength') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mCutFromRollTitle') as TfrxMemoView;
      mObj.Visible := False;
      mObj := frMaterialDetails.FindObject('mCutFromRoll') as TfrxMemoView;
      mObj.Visible := False;

    end;

    frMaterialDetails.PrintOptions.PrintMode := pmScale;
    frMaterialDetails.PrintOptions.PrintOnSheet := GetPaperSize;
    frMaterialDetails.PrepareReport;

    frMaterialDetails.PrintOptions.ShowDialog := not GroupPrinting;
    if ((Sender as TSpeedButton) = btnPrintPreview) then
    begin
      with frMaterialDetails do
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
      PrintingCancelled := not frMaterialDetails.Print;

    btnPrint.Enabled := True;
    btnPrintPreview.Enabled := True;
  end;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmMaterialDetails.btnCopyClick(Sender: TObject);
begin
  if ItemGone(tblMaterials, MaterialCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    fmCopyMaterial.BaseCode := tblMaterialsCode.Value;
    fmCopyMaterial.ShowModal
  end;
end;

procedure TfmMaterialDetails.MaterialType;
var
   MaterialType : string;

begin
  MaterialType := dbtType.Field.value;

  if MaterialType = 'L' then
    lblMaterialType.caption := 'Leather'
  else if MaterialType = 'W' then
    lblMaterialType.caption := 'Wool'
  else if MaterialType = 'K' then
    lblMaterialType.caption := 'Kip'
  else if MaterialType = 'R' then
    lblMaterialType.caption := 'Roll'
  else if MaterialType = 'S' then
    lblMaterialType.caption := 'Sheet';

  pnlLeathers.visible := (MaterialType[1] in ['K','L','W']);
  pnlSynthetics.visible := not pnlLeathers.visible;
  pnlUseLinear.Visible := not pnlLeathers.Visible;

  if (MaterialType[1] in ['K','L','W']) then
  begin
    lblDegDiff.enabled := DifficultLeatherFacility;
    dbtDegDiff.enabled := DifficultLeatherFacility;
    cbDegDiff.enabled := DifficultLeatherFacility;
    if not DifficultLeatherFacility then
    begin
      cbDegDiff.Font.Style := [];
      cbDegDiff.Font.Color := clInactiveCaptionText;
    end
    else
    begin
      cbDegDiff.Font.Style := [];
      cbDegDiff.Font.Color := clWindowText;
    end;
  end
  else
  begin
    lblLength.visible := not (MaterialType = 'R');
    dbeLength.visible := not (MaterialType = 'R');
    dbtLength.visible := not (MaterialType = 'R');

    dbcbCutFromRoll.visible := (MaterialType = 'S');
    dbtCutFromRoll.visible := (MaterialType = 'S');
  end;
end;

procedure TfmMaterialDetails.tblMaterialsWidthValidate(Sender: TField);
begin
  CheckWidth;
end;

procedure TfmMaterialDetails.tblMaterialsAfterOpen(DataSet: TDataSet);
var
  SecondProcess : MaterialTablesOpenThread;

begin
  if not SecondProcessInUse then
  begin
    SecondProcessInUse := True;
    SecondProcess := MaterialTablesOpenThread.Create(true);
    SecondProcess.FreeOnTerminate := True;
    SecondProcess.OnTerminate := FinishSecondProcess;
    SecondProcess.PassDetails(fmMaterialDetails);
    SecondProcess.resume;
  end;

  LoadUnitsDropDown;
end;

procedure TfmMaterialDetails.LoadUnitsDropDown;
begin
  cbUnits.DataField := '';
  cbUnits.Items.Clear;
  fmSumms.qMaterialUnits.RecNo := 1; //CJY changed from qMaterialUnits.First
  fmSumms.qMaterialUnits.Prior; //CJY changed from qMaterialUnits.First
  while not fmSumms.qMaterialUnits.eof do
  begin
    cbUnits.Items.Add(fmSumms.qMaterialUnitsCode.value);

    fmSumms.qMaterialUnits.next;
  end;
  cbUnits.DataField := 'Units';
end;

procedure TfmMaterialDetails.LoadCutTypesDropDown;
begin
  cbCutType.DataField := '';
  cbCutType.Items.Clear;

  if not pnlLeathers.visible then
    cbCutType.Items.Add('E');
  if pnlLeathers.visible then
    cbCutType.Items.Add('M');
  cbCutType.Items.Add('R');
  if pnlLeathers.visible then
    cbCutType.Items.Add('S');

  cbCutType.DataField := 'CutType';
end;

procedure TfmMaterialDetails.UnitsType;
begin
  fmSumms.qMaterialUnits.findkey([cbUnits.text]);
  ToFeet := fmSumms.qMaterialUnitsToFeet.value;
  SubUnitsPerUnit := fmSumms.qMaterialUnitsSubUnitsPerUnit.value;

  lblSkinSize.caption := 'Skin Size (Sq ' + fmSumms.qMaterialUnitsUnitAbbreviation.value + ')';
  lblStrokeDepth.caption := 'Stroke Depth (' + fmSumms.qMaterialUnitsSubUnitAbbreviation.value + ')';
  lblWidth.caption := 'Width (' + fmSumms.qMaterialUnitsSubUnitAbbreviation.value + ')';
  lblLength.caption := 'Length (' + fmSumms.qMaterialUnitsSubUnitAbbreviation.value + ')';

  lblUnitsType.caption := fmSumms.qMaterialUnitsUnitDescription.value;
end;

procedure TfmMaterialDetails.cbUnitsChange(Sender: TObject);
begin
  UnitsType;
end;

procedure TfmMaterialDetails.CuttingType;
var
   CuttingType : string;

begin
  CuttingType := cbCutType.text;

  if CuttingType = 'E' then
    lblCuttingType.caption := 'Exhaustive'
  else if CuttingType = 'M' then
    lblCuttingType.caption := 'Match Marked'
  else if CuttingType = 'R' then
    lblCuttingType.caption := 'Restrictive'
  else if CuttingType = 'S' then
    lblCuttingType.caption := 'Selective';
end;

procedure TfmMaterialDetails.cbCutTypeChange(Sender: TObject);
begin
  CuttingType;
end;

procedure TfmMaterialDetails.CheckWidth;
begin
  //Only for Synthetics.
  lblWidthWarning.Visible := Option_LegacySynthetics and
    (((tblMaterialsType.Value = 'S') or (tblMaterialsType.Value = 'R')) and
     ((tblMaterialsWidth.value / SubUnitsPerUnit * ToFeet) < 0.98424)); {30cm}
end;

procedure TfmMaterialDetails.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  if ItemGone(tblMaterials, MaterialCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oMaterial, fmSumms.tblLocks, tblMaterials, MaterialCode, True);

    if LockSuccess then
      UpdateScreen(True)
    else
      LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmMaterialDetails.UpdateScreen(Editing : boolean);
begin
  if editing then
    tbMain.color := clEditing
  else
    tbMain.color := clBack;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnDelete.enabled := not Editing;
  btnRefresh.enabled := not Editing;

  btnPrint.enabled := not Editing;
  btnPrintPreview.enabled := not Editing;
  btnCopy.enabled := not Editing;
  btnWhereUsed.enabled := not Editing;

  pnlView1.visible := not Editing;
  pnlView2.visible := not Editing;
  pnlView3.visible := not Editing;
  pnlView4.visible := not Editing;
  pnlView5.visible := not Editing;
  pnlView6.visible := not Editing;
  pnlView7.visible := not Editing;

  pnlLinearMatPrice.visible := not Editing;
  pnlLinearAllowance.visible := not Editing;

  dbcbTrimmed.ReadOnly := not Editing;
  dbcbMatPrice.ReadOnly := not Editing;
  dbcbAllowance.ReadOnly := not Editing;
  dbcbCutFromRoll.ReadOnly := not Editing;

  SetTabStops(Editing);

  MaterialType;
  CuttingType;
  UnitsType;

  SetColumnWidthsDetails1(fmMaterialDetails, sgSuppliers, dbgSuppliers, 1, Editing);

  if Editing then
    dbeDescription.setfocus
  else
    tbMain.setfocus;
end;

procedure TfmMaterialDetails.btnSaveClick(Sender: TObject);
begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
//    dbgSuppliers.PostEdit;
    if tblMatSupl.state in [dsEdit, dsInsert] then
      tblMatSupl.post;
    tblMaterials.post;
    LocalConnectionSumms.commit;
    UpdateScreen(False);
    UpdateSuppliersCopy;
  end;
end;

procedure TfmMaterialDetails.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblMatSupl.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblMaterials.cancel;

  //Refresh Grids
  tblMatSupl.refresh;
  dbgSuppliers.refresh;

  UpdateScreen(False);
end;

procedure TfmMaterialDetails.btnRefreshClick(Sender: TObject);
begin
  if ItemGone(tblMaterials, MaterialCode) then
    Close
  else
  begin
    MaterialType;
    UpdateSuppliersCopy;
  end;
end;

procedure TfmMaterialDetails.UpdateSuppliersCopy;
var
  i : integer;
  s : string;

begin
  if tblMatSupl.active then
  begin
    sgSuppliers.RowCount := 2;
    sgSuppliers.Cells[0, 1] := '';
    sgSuppliers.Cells[1, 1] := '';

    i := 0;
    tblMatSupl.refresh;
    tblMatSupl.first;
    while not tblMatSupl.eof do
    begin
      inc(i);
      if i > 1 then
         sgSuppliers.RowCount := sgSuppliers.RowCount + 1;
      sgSuppliers.Cells[0, i] := tblMatSuplSupplier.value;
      str(tblMatSuplPrice.value : 8 : 2, s);
      sgSuppliers.Cells[1, i] := s;
      tblMatSupl.next;
    end;
  end;
end;

procedure TfmMaterialDetails.tblMatSuplAfterOpen(DataSet: TDataSet);
begin
  //Do not allow editing until MatSupl is open
  //because triggers a 'post' as opens.
  tbMain.enabled := true;
  //Below relies on table being open
  pnlSuppliers.enabled := true;
end;

procedure TfmMaterialDetails.tblMaterialsCalcFields(DataSet: TDataSet);
begin
  if tblMaterialsTrimmed.value then
    tblMaterialsTrimmedYesNo.value := 'Yes'
  else
    tblMaterialsTrimmedYesNo.value := 'No';
  if tblMaterialsLinearMatPrice.value then
    tblMaterialsLinearMatPriceYesNo.value := 'Yes'
  else
    tblMaterialsLinearMatPriceYesNo.value := 'No';
  if tblMaterialsLinearAllowance.value then
    tblMaterialsLinearAllowanceYesNo.value := 'Yes'
  else
    tblMaterialsLinearAllowanceYesNo.value := 'No';
  if tblMaterialsSheetCutFromRoll.value then
    tblMaterialsSheetCutFromRollYesNo.value := 'Yes'
  else
    tblMaterialsSheetCutFromRollYesNo.value := 'No';
end;

procedure TfmMaterialDetails.sgSuppliersDblClick(Sender: TObject);
var
  RowNo, ColNo: integer;
  Failed: boolean;
  Code: string;
  fmSupplierDetails : TfmSupplierDetails;

begin
  RowNo := sgSuppliers.Row;
  ColNo := sgSuppliers.Col;

  if (RowNo >= 1) and (RowNo <= sgSuppliers.RowCount) then
  begin
    Code := sgSuppliers.Cells[0, sgSuppliers.Row];

    Failed := false;
    if not (Code = '') then
    begin
      if not ExistingToFront('Supplier', Code) then
      begin
        Screen.cursor := crHourGlass;
        Failed := false;
        try
          fmSupplierDetails := TfmSupplierDetails.create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;
        if not Failed then
          fmSupplierDetails.PassSupplierName(Code);
      end;
    end;
  end;
end;

procedure TfmMaterialDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmMaterialDetails.sgSuppliersKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    sgSuppliersDblClick(Self);
end;

procedure TfmMaterialDetails.FinishSecondProcess(Sender: TObject);
begin
  SecondProcessInUse := False;
end;

procedure TfmMaterialDetails.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;

  SecondProcessInUse := False;

  if not Option_CuttingTimes then
  begin
    lblStrokeDepth.Enabled := false;
    dbtStrokeDepth.Enabled := false;
    dbeStrokeDepth.Enabled := false;
  end;

  if GroupPrinting then
  begin
    Enabled := False;
    Position := poMainFormCenter;
  end;

  SetTabStops(False);
end;

procedure TfmMaterialDetails.frMaterialDetailsBeforePrint(
  Sender: TfrxReportComponent);
begin
  frMaterialDetails.PreviewOptions.AllowEdit := False;
  frMaterialDetails.PreviewOptions.Buttons := frMaterialDetails.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frMaterialDetails.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frMaterialDetails.PreviewOptions.ZoomMode := zmDefault
  else
    frMaterialDetails.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmMaterialDetails.frMaterialDetailsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := 'Material : ' + MaterialCode
  else if (VarName = 'Type') then
    Value := lblMaterialType.Caption
  else if (VarName = 'CutType') then
    Value := lblCuttingType.Caption
  else if (VarName = 'Units') then
    Value := lblUnitsType.Caption
  else if (VarName = 'SkinSize') then
    Value := lblSkinSize.Caption
  else if (VarName = 'StrokeDepth') then
    Value := lblStrokeDepth.Caption
  else if (VarName = 'Width') then
    Value := lblWidth.Caption
  else if (VarName = 'Length') then
    Value := lblLength.Caption;
end;

procedure TfmMaterialDetails.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not SecondProcessInUse;

  if SecondProcessInUse then
    MessageDlgPos('Cannot close whilst loading', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

procedure TfmMaterialDetails.sgSuppliersSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    CanSelect := False;
end;

procedure TfmMaterialDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
  cbCutType.TabStop := Editing;
  dbeStandardPrice.TabStop := Editing;
  cbUnits.TabStop := Editing;
  cbDegDiff.TabStop := Editing;
  dbeQualCoeff.TabStop := Editing;
  dbeAreaCoeff.TabStop := Editing;
  dbeSkinSize.TabStop := Editing;
  dbcbTrimmed.TabStop := Editing;
  dbcbMatPrice.TabStop := Editing;
  dbcbAllowance.TabStop := Editing;
  dbeLayers.TabStop := Editing;
  dbeCutGap.TabStop := Editing;
  dbeStrokeDepth.TabStop := Editing;
  dbeWidth.TabStop := Editing;
  dbeLength.TabStop := Editing;
  sgSuppliers.TabStop := not Editing;
  dbgSuppliers.TabStop := Editing;
  dbmNotes.TabStop := Editing;
end;

procedure TfmMaterialDetails.dbgSuppliersDragDrop(Sender, Source: TObject;
  X, Y: Integer);
begin
  BringToFront;

  if DragType = dragSupplier then
  begin
    if DragSort = dragInsert then
      tblMatSupl.insert
    else if DragSort = dragAppend then
    begin
      tblMatSupl.Last;
      tblMatSupl.append;
    end;

    tblMatSuplSupplier.value := DragCode;
    tblMatSupl.post;
  end;
  dbeDescription.SetFocus;
  dbgSuppliers.SetFocus;
end;

procedure TfmMaterialDetails.dbgSuppliersDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := false;
  if (DragType = dragSupplier) and (tblMatSupl.state in [dsBrowse]) and (tblMatSuplSupplier.readonly = false) then
    Accept := true;
end;

procedure TfmMaterialDetails.dbgSuppliersKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (dbgSuppliers.SelectedField.Fieldname = 'Supplier') then
    Key := upcase(Key);
end;

procedure TfmMaterialDetails.dbmNotesEnter(Sender: TObject);
begin
  tbMain.SetFocus;
end;

end.

