unit PartDetails;

interface

uses
  Classes, Controls, Forms, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, DBCtrls, Grids, DBGridPlus,
  DBGrids, ExtCtrls, Buttons, ComCtrls, XStringGrid, XStringGridPlus, Mask,
  ToolWin, Types, frxClass, frxDBSet, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, frxReportPlus, FDConnectionPlus;

type
  TfmPartDetails = class(TForm)
    tblParts: TFDTablePlus;
    dsParts: TDataSource;
    dsPartWidthKnife: TDataSource;
    tblPartsSizeRange: TStringField;
    tblPartsCode: TStringField;
    tblPartsWidthRange: TStringField;
    tblPartsMaterial: TStringField;
    tblPartsCostedSize: TStringField;
    tblPartsSampleSize: TStringField;
    tblPartsMaxPairs: TSmallintField;
    tblPartsStdBatchSize: TSmallintField;
    tblPartsNotes: TMemoField;
    tblPartsManualAdjFactor: TBooleanField;
    tblPtWidAF: TFDTablePlus;
    dsPtWidAF: TDataSource;
    tblPtWidAFPart: TStringField;
    tblPtWidAFWidthNo: TSmallintField;
    tblPtWidAFAdjFactor: TSmallintField;
    tblPartsCostedAllowance: TFloatField;
    tblPartsRest: TFloatField;
    tblPartsContingency: TFloatField;
    tblPartsDescription: TStringField;
    tblPartsFeedSystem: TStringField;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    btnRefresh: TSpeedButton;
    LocalConnectionSumms: TFDConnectionPlus;
    qSizeRangeSizes: TFDQueryPlus;
    qSizeRangeSizesRange: TStringField;
    qSizeRangeSizesSize: TStringField;
    qPartInUse: TFDQueryPlus;
    qPartInUseEXPR: TIntegerField;
    btnAllowance: TSpeedButton;
    qSizeRangeSizesSeq: TFloatField;
    qWidthRanges: TFDQueryPlus;
    qWidthRangesCode: TStringField;
    qWidthsForRange: TFDQueryPlus;
    qWidthsForRangeWidth: TStringField;
    qWidthsForRangeNo: TSmallintField;
    btnBrowse: TSpeedButton;
    tblPartsManualAdjFactorYesNo: TStringField;
    qMaterials: TFDQueryPlus;
    qMaterialsDescription: TStringField;
    qPtWidAF: TFDQueryPlus;
    qPtWidAFPart: TStringField;
    qPtWidAFWidthNo: TSmallintField;
    qPtWidAFAdjFactor: TSmallintField;
    qPtWidAFWidth: TStringField;
    qPtWidAFRealAdjFactor: TIntegerField;
    tblPartsSizeScale: TStringField;
    tblPartsPressTypeLeatherDesc: TStringField;
    tblPartsFeedSystemDesc: TStringField;
    qRedoIndex: TFDQueryPlus;
    pnlKeepPreview: TPanel;
    btnWhereUsed: TSpeedButton;
    btnCopy: TSpeedButton;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    qDefaultRelationship: TFDQueryPlus;
    qDefaultRelationshipRelationship: TStringField;
    btnPrintincAllowPreview: TSpeedButton;
    btnPrintincAllow: TSpeedButton;
    tblKnives: TFDTablePlus;
    tblPartWidthKnife: TFDTablePlus;
    tblPartWidthKnifePart: TStringField;
    tblPartWidthKnifeWidthNo: TSmallintField;
    tblPartWidthKnifeKnife: TStringField;
    tblPartWidthKnifeSeq: TFloatField;
    tblPartWidthKnifeFrequency: TSmallintField;
    tblPartWidthKnifeSizeScale: TStringField;
    tblPartWidthKnifeSizeRange: TStringField;
    tblPartWidthKnifeSizeRelationship: TStringField;
    tblPartWidthKnifeSizeAdjustment: TSmallintField;
    tblPartWidthKnifeNoIncludedKnives: TSmallintField;
    tblPartWidthKnifeMaster: TStringField;
    tblPartWidthKnifeGovernor: TBooleanField;
    tblPartWidthKnifeRelationshipRange: TStringField;
    tblPartWidthKnifeKnifeNettArea: TFloatField;
    tblPartWidthKnifeKnifeType: TStringField;
    tblPartWidthKnifeKnifeInterlockAreaPrimeSyn: TFloatField;
    tblPartWidthKnifeKnifeInterlockAreaNonPrime: TFloatField;
    tblPartWidthKnifeKnifeInterlockEfficiency: TFloatField;
    qMaterialsType: TStringField;
    qMaterialsLength: TFloatField;
    qMaterialsWidth: TFloatField;
    qMaterialsUnits: TStringField;
    qMaterialsToFeet: TFloatField;
    qMaterialsSubUnitsPerUnit: TSmallintField;
    tblLayplans: TFDTablePlus;
    pnlForm: TPanel;
    pnlMain: TPanel;
    lblDescription: TLabel;
    lblSizeRange: TLabel;
    dbtSizeRange: TDBText;
    lblWidthRange: TLabel;
    lblSampleSize: TLabel;
    lblCostedSize: TLabel;
    lblCostedAllowance: TLabel;
    lblMaxPairs: TLabel;
    lblMaterial: TLabel;
    lblMaterialDescription: TLabel;
    lblMaterialType: TLabel;
    lblMatTypeTitle: TLabel;
    dbeDescription: TDBEdit;
    dbcbManualAdjFactor: TDBCheckBox;
    cbSampleSize: TDBComboBox;
    cbCostedSize: TDBComboBox;
    dbeCostedAllowance: TDBEdit;
    dbeMaxPairs: TDBEdit;
    dbeMaterial: TDBEdit;
    pnlView1: TPanel;
    dbtDescription: TDBText;
    pnlView2: TPanel;
    dbtMaterial: TDBText;
    dbtWidthRange: TDBText;
    pnlView4: TPanel;
    dbtCostedAllowance: TDBText;
    dbtMaxpairs: TDBText;
    dbtManualAdjFactor: TDBText;
    pnlView3: TPanel;
    dbtSampleSize: TDBText;
    dbtCostedSize: TDBText;
    splMiddle: TSplitter;
    pnlTabSheet: TPanel;
    pcPart: TPageControl;
    tsWidthDetails: TTabSheet;
    pnlWidthDetailsHeader: TPanel;
    lblAdjFactor: TLabel;
    dbtAdjFactor: TDBText;
    lblCalcAdjFact: TLabel;
    btnCopyWidths: TSpeedButton;
    cbWidthsForRange: TComboBox;
    dbeAdjFactor: TDBEdit;
    dbgPartWidthKnife: TDBGridPlus;
    pnlView9: TPanel;
    sgKnives: TXStringGridPlus;
    tsSpecialInstructions: TTabSheet;
    dbMemoNotes: TDBMemo;
    pnlView7: TPanel;
    dbmNotes: TDBMemo;
    qMaterialsConversion: TFloatField;
    qMaterialsUnitDescription: TStringField;
    pnlAdjFactCover: TPanel;
    qMaterialsSubUnitDesc: TStringField;
    qMaterialsSubUnitAbbreviation: TStringField;
    tblKnifeSets: TFDTablePlus;                                                                        
    tblKnifeSetsCode: TStringField;
    tblKnifeSetsDescription: TStringField;
    tblKnifeSetsSizeScale: TStringField;
    tblKnifeSetsType: TStringField;
    tblKnifeSetsManualEntry: TBooleanField;
    qMaterialsCutGap: TSmallintField;
    lblBatchSize: TLabel;
    dbeBatchSize: TDBEdit;
    dbtStdBatchSize: TDBText;
    tblPartsSLMAllowance: TBooleanField;
    tblPartsSLMAllowanceYesNo: TStringField;
    pnlSLMAllowance: TPanel;
    dbcbSLMAllowance: TDBCheckBox;
    pnlView10: TPanel;
    dbtSLMAllowance: TDBText;
    tblLayplansKnifeCode: TStringField;
    tblLayplansKnifeSizeScale: TStringField;
    tblLayplansKnifeSize: TStringField;
    tblLayplansMaterialLength: TIntegerField;
    tblLayplansMaterialWidth: TIntegerField;
    tblLayplansMaterialCutGap: TIntegerField;
    tblLayplansSqFtPerPiece: TFloatField;
    tblLayplansDetails1: TStringField;
    tblLayplansDetails2: TStringField;
    tblLayplansDetails3: TStringField;
    tblLayplansDetails4: TStringField;
    tblLayplansDetails5: TStringField;
    tblLayplansDetails6: TStringField;
    btnLayplanCosted: TSpeedButton;
    btnLayplanSample: TSpeedButton;
    qAdjustedKnifeSizes: TFDQueryPlus;
    qMaterialsRestrictiveMaterialCode: TStringField;
    qPtWidAFSampleSize: TStringField;
    qPtWidAFCostedSize: TStringField;
    tblKnifeSetsCutGap: TSmallintField;
    tblKnivesCode: TStringField;
    tblKnivesSizeScale: TStringField;
    tblKnivesMeasuredSize: TStringField;
    tblKnivesGrossArea: TFloatField;
    tblKnivesNettArea: TFloatField;
    tblKnivesInterlockAreaPrimeSynthetic: TFloatField;
    tblKnivesInterlockAreaNonPrime: TFloatField;
    tblKnivesToBeAssessed: TBooleanField;
    tblKnivesImportFilename: TStringField;
    tblKnivesPiecename: TStringField;
    tblKnivesAssessedVersion: TSmallintField;
    tblKnivesSeq: TFloatField;
    qPtWidAFSLMAllowance: TBooleanField;
    btnLayplan: TSpeedButton;
    dbtWidth: TDBText;
    tblPartsCostedWidth: TSmallintField;
    tblWidths: TFDTablePlus;
    dsWidths: TDataSource;
    tblWidthsNo: TSmallintField;
    tblWidthsWidth: TStringField;
    qUpdateSLMAlwFlag: TFDQueryPlus;
    dbcbMadeInPairs: TDBCheckBox;
    dbtPairs: TDBText;
    tblPartsMadeInPairs: TBooleanField;
    tblPartsMadeInPairsYesNo: TStringField;
    qDefaultWidth: TFDQueryPlus;
    StringField1: TStringField;
    qDefaultWidthWidthNo: TSmallintField;
    qDefaultWidthWidth: TStringField;
    frPartDetails: TfrxReportPlus;
    frdbPartWidthKnife: TfrxDBDataset;
    frdbPtWidAF: TfrxDBDataset;
    dsqPWAF: TDataSource;
    frudsPtAlw: TfrxUserDataSet;
    pnlCutting: TPanel;
    lblPressTypeLeather: TLabel;
    lblRest: TLabel;
    lblContingency: TLabel;
    lblFeedSystem: TLabel;
    dbrgPressTypeLeather: TDBRadioGroup;
    dbrgFeedSystem: TDBRadioGroup;
    pnlView6: TPanel;
    dbtFeedSystem: TDBText;
    dbtCuttingTypeLeather: TDBText;
    dbeRest: TDBEdit;
    dbeContingency: TDBEdit;
    pnlView5: TPanel;
    dbtRest: TDBText;
    dbtContingency: TDBText;
    tblPartsPressTypeLeather: TStringField;
    tblPartsPressTypeSynthetic: TStringField;
    lblPressTypeSynthetic: TLabel;
    dbrgPressTypeSynthetic: TDBRadioGroup;
    dbtCuttingTypeSynthetic: TDBText;
    tblPartsPressTypeSyntheticDesc: TStringField;
    dbeWidthRange: TDBEdit;
    procedure PassPartName(PartForm : TfmPartDetails; var Code: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBrowseClick(Sender: TObject);
    procedure tbPartWidthKnifeBeforePost(DataSet: TDataSet);
    procedure DisplayAdjFactor(Editing: boolean);
    procedure dbcbManualAdjFactorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure dbgPartWidthKnifeCellClick(Column: TColumn);
    procedure dbgPartWidthKnifeDblClick(Sender: TObject);
    procedure dbgPartWidthKnifeKeyPress(Sender: TObject; var Key: Char);
    procedure tblPartWidthKnifeAfterInsert(DataSet: TDataSet);
    procedure tblPartWidthKnifeBeforeInsert(DataSet: TDataSet);
    procedure PartWidthKnifeRedoIndex;
    procedure MaterialCodeDblClick(Sender: TObject);
    procedure dbgPartWidthKnifeDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure dbgPartWidthKnifeDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure tblPartWidthKnifeGovernorChange(Sender: TField);
    procedure tblPartWidthKnifeCalcFields(DataSet: TDataSet);
    procedure btnEditClick(Sender: TObject);
    procedure UpdateScreen(AllowFocus, Editing: boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnWhereUsedClick(Sender: TObject);
    procedure UpdateKnivesCopy;
    procedure LoadSizeDropDowns;
    procedure SizeDropDowns;
    procedure cbSampleSizeDropDown(Sender: TObject);
    procedure cbCostedSizeDropDown(Sender: TObject);
    function PartInUse: boolean;
    procedure cbSampleSizeChange(Sender: TObject);
    procedure cbCostedSizeChange(Sender: TObject);
    procedure cbWidthsForRangeChange(Sender: TObject);
    function WidthNoForWidth(Width: string): integer;
    procedure LoadWidthsDropDown;
    procedure WidthSelected(No: integer);
    procedure dbeMaterialEnter(Sender: TObject);
    procedure dbeMaterialExit(Sender: TObject);
    procedure tblPartsCalcFields(DataSet: TDataSet);
    procedure UpdateMaterialDescription;
    procedure tblPartWidthKnifeAfterOpen(DataSet: TDataSet);
    procedure tblPtWidAFAfterOpen(DataSet: TDataSet);
    procedure UpdateAdjFactor;
    procedure btnAllowanceClick(Sender: TObject);
    procedure btnCopyWidthsClick(Sender: TObject);
    procedure qPtWidAFCalcFields(DataSet: TDataSet);
    procedure tblPartsAfterPost(DataSet: TDataSet);
    procedure sgKnivesDblClick(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure sgKnivesKeyPress(Sender: TObject; var Key: Char);
    procedure dbtWidthRangeDblClick(Sender: TObject);
    procedure dbtSizeRangeDblClick(Sender: TObject);
    procedure FinishSecondProcess(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sgKnivesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SetTabStops(Editing: Boolean);
    procedure tblPartsBeforePost(DataSet: TDataSet);
    procedure dbmNotesEnter(Sender: TObject);
    procedure ReferToSyntheticResults(Scale, Size: string;
                                      Sample: boolean);
    procedure btnLayplanSampleClick(Sender: TObject);
    procedure btnLayplanCostedClick(Sender: TObject);
    procedure tblPartWidthKnifeSqFtPerPieceSetText(Sender: TField;
      const Text: String);
    procedure pcPartDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure PartMaterialDescription;
    procedure btnLayplanClick(Sender: TObject);
    procedure tblWidthsWidthGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure dbcbMadeInPairsClick(Sender: TObject);
    procedure SetDefaultWidth;
    procedure frPartDetailsBeforePrint(Sender: TfrxReportComponent);
    procedure frPartDetailsGetValue(const VarName: string; var Value: Variant);
    procedure frudsPtAlwGetValue(const VarName: string;
      var Value: Variant);
    procedure dbeWidthRangeEnter(Sender: TObject);
    procedure dbeWidthRangeExit(Sender: TObject);
    procedure WidthChanged;
  private
    { Private declarations }
    BusyPrinting: boolean;
    fmPartDetails: TfmPartDetails;
    FormClosing: Boolean;
    PartSizeRange: string;
    NewIndex: real;
    NoWidths: integer;
    WidthNo: array of integer;
    WidthName: array of String;
    AnyWidthSelected: boolean;
    ActualWidthSelected: integer;
    DefaultSR: string;
    KnifeSize: string;
    MatLengthFt, MatWidthFt: real;
    Cutgap: integer;
    IsSample: boolean;
  public
    { Public declarations }
    PartCode: string;
    SecondProcessInUse: Boolean;
    MaterialUnitConversion: double;
    AllowanceRows: integer;
    AllowanceResults: array[1..100, 0..2, 0..9] of string;
  end;

var
  WhichCode, WhichField: string;
  GroupPrinting, PrintingCancelled: boolean;    

implementation

uses
  Windows, Messages, SysUtils, Graphics, Menus, Dialogs, General, SummsVars,
  CmnVars, SizeRangeDetails, AdjFact, PartsWhereUsed, Summs, BrowseMaterials,
  BrowseWidthRanges, CopyPart, PartAllowance, KnifeSetDetails,
  SizeRelationshipDetails, MaterialDetails, OutOfMemory, WidthDetails,
  SummsThreads, CopyPartWidthKnives, AllKnifeSets, Const_Interlocking,
  AdvErrorHandler, AllPatterns, LayMain, NewSizeReln, Dongle_Green;

{$R *.DFM}

var
  fmPartAllowanceArray: array of TfmPartAllowance;
  PACount,PARead: integer;

procedure TfmPartDetails.PartMaterialDescription;
var
  s: string;

begin
//Called from SummsThreads
  lblMaterialDescription.caption := 'Searching...';
  qMaterials.paramByname('Material').value := tblPartsMaterial.value;
  qMaterials.open;
  if (qMaterialsType.value = 'R') or (qMaterialsType.value = 'S') then
    s := 'SYNTHETIC'
  else
    s := 'LEATHER';

  lblMaterialDescription.caption := qMaterialsDescription.value;
  lblMaterialType.caption := s;
  MaterialUnitConversion := qMaterialsConversion.value;

  //Overrides to normal UpdateScreen because of threads
  if Option_FullSynthetics and (s = 'SYNTHETIC') then
  begin
    pnlAdjFactCover.Visible := True;
    dbcbManualAdjFactor.Enabled := False;
    dbtManualAdjFactor.Enabled := False;
  end
  else
  begin
    pnlAdjFactCover.Visible := False;
    dbcbManualAdjFactor.Enabled := True;
    dbtManualAdjFactor.Enabled := True;
  end;
  btnLayplanSample.enabled := (lblMaterialType.Caption = 'SYNTHETIC') and Option_FullSynthetics and AnyWidthSelected;
  btnLayplanCosted.enabled := (lblMaterialType.Caption = 'SYNTHETIC') and Option_FullSynthetics and AnyWidthSelected;
  btnLayplan.enabled := (lblMaterialType.Caption = 'SYNTHETIC') and Option_FullSynthetics and AnyWidthSelected;

  pnlSLMAllowance.Visible := (Option_LegacySynthetics and Option_FullSynthetics and (s = 'SYNTHETIC'));
  qMaterials.close;
end;

procedure TfmPartDetails.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    FormClosing := True;

    if tblParts.state in [dsEdit, dsInsert] then
    begin
      if MessageDlgPos('Save Changes to Part ' + PartCode + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    action := caFree;
  end;
end;

procedure TfmPartDetails.SetDefaultWidth;
var
  i: integer;

begin
  qDefaultWidth.ParamByName('WidthRange').Value := tblPartsWidthRange.value;
  qDefaultWidth.Open;
  if qDefaultWidthWidthNo.IsNull then
    WidthSelected(0)
  else
  begin
    WidthSelected(qDefaultWidthWidthNo.Value);
    for i := 0 to cbWidthsForRange.Items.Count - 1 do
      if cbWidthsForRange.Items.Strings[i] = qDefaultWidthWidth.Value then
        cbWidthsForRange.ItemIndex := i;
    AnyWidthSelected := True;
    cbWidthsForRangeChange(cbWidthsForRange);
  end;
  qDefaultWidth.Close;
end;

procedure TfmPartDetails.PassPartName(PartForm: TfmPartDetails; var Code: string);
var
  i: integer;

begin
  try
    fmPartDetails := PartForm;
    PartCode := Code;

//    Caption := 'Part : ' + PartCode;
    Caption := 'Part Loading...';

    screen.cursor := crHourGlass;
    tblParts.open;
    tblParts.setRange([PartCode], [PartCode]);
    tblPtWidAF.open;
    tblKnives.open;
    tblPartWidthKnife.open;
    tblWidths.Open;
    screen.cursor := crDefault;

    if tblParts.recordcount = 0 then
    begin
      MessageDlgPos('Part ' + PartCode + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      Caption := 'Part : Not Found';
      close;
    end
    else
    begin
      PartSizeRange := tblPartsSizeRange.value;

      cbSampleSize.DataField := '';
      cbSampleSize.Items.Add(tblPartsSampleSize.value);
      cbSampleSize.DataField := 'SampleSize';

      cbCostedSize.DataField := '';
      cbCostedSize.Items.Add(tblPartsCostedSize.value);
      cbCostedSize.DataField := 'CostedSize';

      qWidthsForRange.paramByname('WidthRange').value := tblPartsWidthRange.value;
      qWidthsForRange.open;
      LoadWidthsDropDown;

      UpdateMaterialDescription;
      DisplayAdjFactor(False);

      WidthSelected(0);

      if not(SplitTickets) then
      begin
        lblMaxPairs.Visible := false;
        dbeMaxPairs.Color := clBack;
        dbeMaxPairs.DataField := '';
        dbtMaxPairs.DataField := '';

        dbeMaxPairs.Visible := False;
      end;

      if not Option_ProductionSystem then
      begin
        qDefaultRelationship.ParamByName('PartCode').Value := PartCode;
        //Use default Size Relationship with same name as Size Range
        qDefaultRelationship.Open;
        //CJY: qDefaultRelationship.FetchOptions.RecordCountMode set to cmTotal
        if qDefaultRelationship.RecordCount = 1 then
          DefaultSR := qDefaultRelationshipRelationship.value
        else
          DefaultSR := '';
        qDefaultRelationship.Close;

        if DefaultSR = '' then
        begin
          MessageDlgPos('Matching Size Relationship ' + tblPartsSizeRange.value + ' missing.' + #13 + 'This Size Relationship will be auto created for Costing system use.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
          fmNewSizeRelationship.AutoCreate := True;
          fmNewSizeRelationship.eNewSizeRelationshipCode.Text := tblPartsSizeRange.value;
          fmNewSizeRelationship.eSizeRange.Text := tblPartsSizeRange.value;
          fmNewSizeRelationship.btnSave.Click;
          DefaultSR := tblPartsSizeRange.value;
          //close;
        end;
      end;

      SetDefaultWidth;
    end;

    Caption := 'Part : ' + PartCode;
  except
    Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure TfmPartDetails.btnBrowseClick(Sender: TObject);
begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if btnBrowse.Tag = 0 then
    begin
      if fmBrowseMaterials.ShowModal = mrOK then
        tblPartsMaterial.value := fmBrowseMaterials.lblMaterial.caption;
    end
    else
    begin
      if fmBrowseWidthRanges.ShowModal = mrOK then
        tblPartsWidthRange.value := fmBrowseWidthRanges.lblWidthRange.caption;
    end;
  end;
end;

procedure TfmPartDetails.tbPartWidthKnifeBeforePost(DataSet: TDataSet);
var
  sMessage: string;

begin
  //CJY Uppercasing a Null returns a blank string which can upset RI
  if not tblPartWidthKnifeKnife.IsNull then
    tblPartWidthKnifeKnife.value := UpperCase(tblPartWidthKnifeKnife.value);
  tblPartWidthKnifeSizeScale.value := tblPartsSizeScale.value;
  tblPartWidthKnifeSizeRange.value := tblPartsSizeRange.value;
  //CJY Uppercasing a Null returns a blank string which can upset RI
  if not tblPartWidthKnifeSizeRelationship.IsNull then
    tblPartWidthKnifeSizeRelationship.value := UpperCase(tblPartWidthKnifeSizeRelationship.value);

  sMessage := '';
  if tblPartWidthKnifeKnife.IsNull then
    sMessage := 'Knife Empty';

  if tblPartWidthKnifeSizeRelationship.isNull then
  begin
    if sMessage <> '' then
      sMessage := sMessage + ' and' + sLineBreak;
    sMessage := sMessage + 'Size Relationship empty';
  end
  else if not fmSumms.tblSizeRelationships.Locate('Relationship', tblPartWidthKnife.FieldByName('SizeRelationship').Value, []) then
  begin
    if sMessage <> '' then
      sMessage := sMessage + ' and' + sLineBreak;
    sMessage := sMessage + 'Size Relationship not found';
  end
  else if tblPartWidthKnifeRelationshipRange.value <> PartSizeRange then
  begin
    if sMessage <> '' then
      sMessage := sMessage + ' and' + sLineBreak;
    sMessage := sMessage + 'Size Relationship does not match Size Range';
  end;

  if sMessage <> '' then
  begin
    MessageDlgPos(sMessage, mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    abort;
  end;


  if tblPartWidthKnifeKnife.isNull then
    abort;
end;

procedure TfmPartDetails.DisplayAdjFactor(Editing: boolean);
begin
  if Editing then
  begin
    dbeAdjFactor.visible := dbcbManualAdjFactor.Checked;
    dbtAdjFactor.visible := false;
    lblCalcAdjFact.visible := not dbcbManualAdjFactor.Checked;
  end
  else
  begin
    dbeAdjFactor.visible := false;
    dbtAdjFactor.visible := dbcbManualAdjFactor.Checked;
    lblCalcAdjFact.visible := not dbcbManualAdjFactor.Checked;
  end;
end;

procedure TfmPartDetails.dbcbManualAdjFactorClick(Sender: TObject);
begin
  DisplayAdjFactor(True);
end;

procedure TfmPartDetails.dbeWidthRangeEnter(Sender: TObject);
begin
  btnBrowse.Tag := 1;
  btnBrowse.enabled := True;
end;

procedure TfmPartDetails.dbeWidthRangeExit(Sender: TObject);
begin
  WidthChanged;
  btnBrowse.enabled := False;
end;

procedure TfmPartDetails.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;

  PartCode := '';

  FormClosing := False;
  AnyWidthSelected := false;
  ActualWidthSelected := 0;

  if not Option_CuttingTimes then
  begin
    pnlCutting.visible := False;
    Height := Height - pnlCutting.Height - pnlCutting.Margins.Top - pnlCutting.Margins.Bottom;

    sgKnives.Columns[1].Width := sgKnives.Columns[1].Width + 46;
    sgKnives.Columns[5].Width := -1;

    dbgPartWidthKnife.Columns[1].Width := dbgPartWidthKnife.Columns[1].Width + 46;
    dbgPartWidthKnife.Columns[5].Visible := False;
  end;

  if (not Option_SinglesAllowed) then
  begin
    dbcbMadeInPairs.visible := False;
    dbtPairs.visible := False;
  end;

  if not(SplitTickets) or not(SplittingScheme = 1) then
  begin
    dbgPartWidthKnife.Columns[6].Visible := False;
    sgKnives.ColCount := 6;
  end;

  if GroupPrinting then
  begin
    Enabled := False;
    Position := poMainFormCenter;
  end;

  if not Option_ProductionSystem then
  begin
    dbgPartWidthKnife.Columns[2].visible := False;
    dbgPartWidthKnife.Columns[4].visible := False;
    SetColumnWidthsDetails1(fmPartDetails, sgKnives, dbgPartWidthKnife, sgKnives.ColCount - 1, False);
  end;

  SetTabStops(False);
end;

procedure TfmPartDetails.frPartDetailsBeforePrint(Sender: TfrxReportComponent);
begin
  frPartDetails.PreviewOptions.AllowEdit := False;
  frPartDetails.PreviewOptions.Buttons := frPartDetails.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frPartDetails.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frPartDetails.PreviewOptions.ZoomMode := zmDefault
  else
    frPartDetails.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmPartDetails.frPartDetailsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := 'Part : ' + PartCode
  else if (VarName = 'Description') then
    Value := dbtDescription.Caption
  else if (VarName = 'Material') then
    Value := dbtMaterial.Caption
  else if (VarName = 'MaterialDescription') then
    Value := lblMaterialDescription.caption
  else if (VarName = 'WidthRange') then
    Value := dbtWidthRange.Caption
  else if (VarName = 'MaterialType') then
    Value := lblMaterialType.Caption
  else if (VarName = 'SizeRange') then
    Value := dbtSizeRange.Caption
  else if (VarName = 'SampleSize') then
    Value := dbtSampleSize.Caption
  else if (VarName = 'CostedSize') then
    Value := dbtCostedSize.Caption
  else if (VarName = 'BatchSize') then
    Value := dbtStdBatchSize.Caption
  else if (VarName = 'MadeInPairs') then
    Value := dbtPairs.Caption
  else if (VarName = 'ManualAF') then
    Value := dbtManualAdjFactor.Caption
  else if (VarName = 'CostedAllowanceTitle') then
    Value := lblCostedAllowance.Caption + ' ' + dbtWidth.Caption
  else if (VarName = 'CostedAllowance') then
    Value := dbtCostedAllowance.Caption
  else if (VarName = 'SpecialInstructions') then
    Value := tblPartsNotes.Value
  else if (VarName = 'Setup') then
  begin
    inc(PARead);
    if fmPartAllowanceArray[PARead] = nil then
      frudsPtAlw.RangeEndCount := 0
    else
      frudsPtAlw.RangeEndCount := fmPartAllowanceArray[PARead].sgAllowances.RowCount;
    Value := '';
  end
  else if (VarName = 'Sample') then
    Value := fmPartAllowanceArray[PARead].sgAllowances.Cells[1,0]
  else if (VarName = 'Costed') then
    Value := fmPartAllowanceArray[PARead].sgAllowances.Cells[2,0]
  else if (VarName = 'Rest') then
    Value := dbtRest.Caption
  else if (VarName = 'Contingency') then
    Value := dbtContingency.Caption
  else if (VarName = 'CuttingTypeLeather') then
    Value := dbtCuttingTypeLeather.Caption
  else if (VarName = 'CuttingTypeSynthetic') then
    Value := dbtCuttingTypeSynthetic.Caption
  else if (VarName = 'FeedSystem') then
    Value := dbtFeedSystem.Caption;
end;

procedure TfmPartDetails.frudsPtAlwGetValue(const VarName: string;
  var Value: Variant);
begin
  if (frudsPtAlw.RecNo = 0) then
    frudsPtAlw.Next;
  if VarName = 'RowTitle' then
    Value := fmPartAllowanceArray[PARead].sgAllowances.Cells[0, frudsPtAlw.RecNo]
  else if VarName = 'Sample' then
    Value := fmPartAllowanceArray[PARead].sgAllowances.Cells[1, frudsPtAlw.RecNo]
  else if VarName = 'Costed' then
    Value := fmPartAllowanceArray[PARead].sgAllowances.Cells[2, frudsPtAlw.RecNo];
end;

procedure TfmPartDetails.btnPrintClick(Sender: TObject);
var
  mObj: TfrxMemoView;
  mObjC: TfrxChild;
  Master: TfrxMasterData;
  Failed: boolean;
  Code: string;
  No, i: integer;
  Success, TotalSuccess: Boolean;
  frddPartAllowances: TfrxDetailData;
  ShowIntEff: Boolean;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  if ItemGone(tblParts, PartCode) then
    Close
  else
  begin
    frPartDetails.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    if not GroupPrinting then
      btnRefresh.Click;  //ensure everything is properly refreshed before printing -
                         //important because of possible Knife Swap
    TotalSuccess := True;
    PACount := -1;
    PARead := -999;

    btnPrint.Enabled := False;
    btnPrintPreview.Enabled := False;
    btnPrintincAllow.Enabled := False;
    btnPrintincAllowPreview.Enabled := False;

    frddPartAllowances := frPartDetails.FindObject('frddPartAllowances') as TfrxDetailData;
    frddPartAllowances.DataSet := nil;

    Master := frPartDetails.FindObject('frmdPartWidthKnife') as TfrxMasterData;
    Master.StartNewPage := not((Sender as TSpeedButton) = btnPrintPreview);

    dsPtWidAF.DataSet := qPtWidAF;
    qPtWidAF.paramByName('PartCode').value := PartCode;
    qPtWidAF.paramByname('WidthRange').value := tblPartsWidthRange.value;
    qPtWidAF.open;

    mObjC := frPartDetails.FindObject('frcCuttingTimes') as TfrxChild;
    mObjC.Visible := Option_CuttingTimes;

    mObj := frPartDetails.FindObject('mSizeRelnTitle') as TfrxMemoView;
    mObj.Visible := Option_ProductionSystem;
    mObj := frPartDetails.FindObject('mSizeReln') as TfrxMemoView;
    mObj.Visible := Option_ProductionSystem;
    mObj := frPartDetails.FindObject('mSizeAdjTitle') as TfrxMemoView;
    mObj.Visible := Option_ProductionSystem;
    mObj := frPartDetails.FindObject('mSizeAdj') as TfrxMemoView;
    mObj.Visible := Option_ProductionSystem;
    mObj := frPartDetails.FindObject('mIncKnivesTitle') as TfrxMemoView;
    mObj.Visible := Option_CuttingTimes;
    mObj := frPartDetails.FindObject('mIncKnives') as TfrxMemoView;
    mObj.Visible := Option_CuttingTimes;
    mObj := frPartDetails.FindObject('mMadeInPairsTitle') as TfrxMemoView;
    mObj.Visible := Option_SinglesAllowed;
    mObj := frPartDetails.FindObject('mMadeInPairs') as TfrxMemoView;
    mObj.Visible := Option_SinglesAllowed;
    mObj := frPartDetails.FindObject('mAdjFactTitle') as TfrxMemoView;
    mObj.Visible := not pnlAdjfactCover.Visible;
    mObj := frPartDetails.FindObject('mAdjFact') as TfrxMemoView;
    mObj.Visible := not pnlAdjfactCover.Visible;

    mObj := frPartDetails.FindObject('mSetup') as TfrxMemoView;
    mObj.Visible := False;  //Setup is only there to hang code off later

    if ((Sender as TSpeedButton) = btnPrintIncAllowPreview) or ((Sender as TSpeedButton) = btnPrintIncAllow) then
    begin
      //Decide whether to show Interlock Efficiency
      ShowIntEff := False;
      if lblMaterialType.caption = 'LEATHER' then
        ShowIntEff := True
      else
      begin
        //Synthetics
        if Option_LegacySynthetics then
          ShowIntEff := (tblPartsSLMAllowance.Value)
        else
          ShowIntEff := False;
      end;

      frddPartAllowances.DataSet := frudsPtAlw;
      mObj.Visible := True;  //Making Setup visible (it's a null string) so the GetValue is called.
      mObj := frPartDetails.FindObject('mIntEffTitle') as TfrxMemoView;
      mObj.Visible := ShowIntEff;
      mObj := frPartDetails.FindObject('mIntEff') as TfrxMemoView;
      mObj.Visible := ShowIntEff;

      //Open Part Allowances Forms. One for each Width
      PARead := -1;
      qPtWidAF.RecNo := 1; //CJY changed from qPtWidAF.First
      qPtWidAF.Prior; //CJY changed from qPtWidAF.First
      while not qPtWidAF.eof do
      begin
        inc(PACount);
        Screen.cursor := crHourGlass;
        Failed := false;
        try
          SetLength(fmPartAllowanceArray, PACount + 1);
          fmPartAllowanceArray[PACount] := TfmPartAllowance.create(fmPartDetails);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        Code := qPtWidAFPart.value;
        No := qPtWidAFWidthNo.value;

        Success := False;
        if not Failed then
        try
          Success := fmPartAllowanceArray[PACount].PassPartNameWidth(fmPartAllowanceArray[PACount], self, Code, No, qPtWidAFSampleSize.value, qPtWidAFCostedSize.value, qPtWidAFSLMAllowance.Value, True);
          fmPartAllowanceArray[PACount].LoadingAllowance := false;
        except
          Success := False;
          Failed := True;
        end;

        if (not Failed) and Success then
        begin
          //Wait until Form Open
          while fmPartAllowanceArray[PACount].SecondProcessInUse do
            application.processmessages;

          frudsPtAlw.RangeEnd := reCount;
        end
        else
        begin
          fmPartAllowanceArray[PACount] := nil;
          TotalSuccess := False;
        end;

        qPtWidAF.next;
      end;
    end;

    if TotalSuccess then
    begin
      frPartDetails.PrintOptions.PrintMode := pmScale;
      frPartDetails.PrintOptions.PrintOnSheet := GetPaperSize;
      frPartDetails.PrepareReport;
      frPartDetails.PrintOptions.ShowDialog := not GroupPrinting;
      if ((Sender as TSpeedButton) = btnPrintPreview) or ((Sender as TSpeedButton) = btnPrintincAllowPreview) then
      begin
        with frPartDetails do
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
        PrintingCancelled := not frPartDetails.Print;
    end
    else
      MessageDlgPos('Cannot produce report.' + #13 + 'Allowance details unavailable for at least one width.' + #13 +
        'Open Parts/Part Allowance for further information', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

    qPtWidAF.Close;
    dsPtWidAF.DataSet := tblPtWidAF;

    if (PACount > -1) then
      for i := 0 to PACount - 1 do
      begin
        if not(fmPartAllowanceArray[PACount] = nil) then
          fmPartAllowanceArray[PACount].Close;
        FreeAndNil(fmPartAllowanceArray[PACount]);
      end;

    btnPrint.Enabled := True;
    btnPrintPreview.Enabled := True;
    btnPrintincAllow.Enabled := True;
    btnPrintincAllowPreview.Enabled := True;
  end;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmPartDetails.btnCopyClick(Sender: TObject);
begin
  if ItemGone(tblParts, PartCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    fmCopyPart.BaseCode := tblPartsCode.Value;
    fmCopyPart.ShowModal;
  end;
end;

procedure TfmPartDetails.dbgPartWidthKnifeCellClick(Column: TColumn);
begin
  WhichField := Column.FieldName;
end;

procedure TfmPartDetails.dbgPartWidthKnifeDblClick(Sender: TObject);
begin
  if WhichField = 'Master' then
  begin
    //CJY: NewValue and Value replaced by Value and OldValue respectively
//    if (tblPartWidthKnifeKnife.NewValue = tblPartWidthKnifeKnife.Value) and
//      (tblPartWidthKnifeSizeRelationship.NewValue = tblPartWidthKnifeSizeRelationship.Value) then
    if (tblPartWidthKnifeKnife.OldValue = tblPartWidthKnifeKnife.Value) and
      (tblPartWidthKnifeSizeRelationship.OldValue = tblPartWidthKnifeSizeRelationship.Value) then
    begin
      if not(tblPartWidthKnife.state in [dsEdit, dsInsert]) then
        tblPartWidthKnife.edit;
      if (tblPartWidthKnifeGovernor.value) then
        tblPartWidthKnifeGovernor.value := false
      else
        tblPartWidthKnifeGovernor.value := true
    end
    else
      MessageDlgPos('Please enter Knife and Size relationship before setting Master', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;
end;

procedure TfmPartDetails.dbgPartWidthKnifeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (ord(Key) = VK_RETURN) then
    dbgPartWidthKnifeDblClick(Self);

  if (ord(Key) = 32) and (WhichField = 'Master') then
    dbgPartWidthKnifeDblClick(Self);

  if (dbgPartWidthKnife.SelectedField.Fieldname = 'Knife') or (dbgPartWidthKnife.SelectedField.Fieldname = 'SizeRelationship') then
    Key := upcase(Key);
end;

procedure TfmPartDetails.tblPartWidthKnifeAfterInsert(DataSet: TDataSet);
begin
  tblPartWidthKnifePart.Value := PartCode;
  tblPartWidthKnifeWidthNo.Value := WidthNoForWidth(cbWidthsForRange.text);
  if not (DefaultSR = '') then
    tblPartWidthKnifeSizeRelationship.value := DefaultSR;

  tblPartWidthKnifeSeq.value := NewIndex;
end;

procedure TfmPartDetails.tblPartWidthKnifeBeforeInsert(DataSet: TDataSet);
var
  BookMark : TBookMark;
  PriorIndex, NextIndex : real;

begin
  {Set current position in table}
  BookMark := tblPartWidthKnife.GetBookMark;

  if tblPartWidthKnife.RecordCount = 0 then
    NewIndex := 1
  else if tblPartWidthKnife.EOF then
    NewIndex := tblPartWidthKnifeSeq.value + 1
  else
  begin
    tblPartWidthKnife.Prior;
    if tblPartWidthKnife.BOF then
    begin
      PriorIndex := 0;
      NewIndex := tblPartWidthKnifeSeq.value / 2
    end
    else
    begin
      PriorIndex := tblPartWidthKnifeSeq.value;
      tblPartWidthKnife.Next;
      NextIndex := tblPartWidthKnifeSeq.value;
      NewIndex := (PriorIndex + NextIndex) / 2;
    end;

    {Allow 17 inserts before index gets too small}
    if (NewIndex - PriorIndex) < 0.00001 then
    begin
      MessageDlgPos('Unable to insert Sizes, Close Size Range and try again', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      sysutils.abort;
    end;
  end;

  {Return to/Release position in table}
  try
    tblPartWidthKnife.GotoBookMark(BookMark);
  except
  end;
  tblPartWidthKnife.FreeBookMark(BookMark);
end;

procedure TfmPartDetails.PartWidthKnifeRedoIndex;
var
  SQLString, sNo: string;
  i, No: integer;

begin
  qRedoIndex.SQL.Clear;

  i := -1;
  while i < (NoWidths - 1) do
  begin
    inc(i);
    No := WidthNo[i];
    str(No, sNo);

    SQLString := 'UPDATE PtWidKnf ' +
                 'SET Seq = (' +
                 '           SELECT ((COUNT(PWK.Seq) * CONVERT(10000, SQL_DOUBLE)) + PtWidKnf.Seq) ' +
                 '           FROM PtWidKnf PWK ' +
                 '           WHERE (PWK.Part = ''' + QS(PartCode) + ''') AND ' +
                 '                 (PWK.WidthNo = ' + sNo + ') AND ' +
                 '                 ((PWK.Seq - (TRUNCATE(PWK.Seq / CONVERT(10000, SQL_DOUBLE), 0) * CONVERT(10000, SQL_DOUBLE))) <= PtWidKnf.Seq) AND ' +
                 '                 (PtWidKnf.Part = PWK.Part) ' +
                 '           ) ' +
                 'WHERE (Part = ''' + QS(PartCode) + ''') AND (WidthNo = ' + sNo + ');' + #13 +
                 'UPDATE PtWidKnf ' +
                 'SET Seq = TRUNCATE(Seq / CONVERT(10000, SQL_DOUBLE), 0) ' +
                 'WHERE (Part = ''' + QS(PartCode) + ''') AND (WidthNo = ' + sNo + ');';

    qRedoIndex.SQL.Text := qRedoIndex.SQL.Text + SQLString;
  end;

  qRedoIndex.ExecSQL;
end;

procedure TfmPartDetails.MaterialCodeDblClick(Sender: TObject);
var
  Code: string;
  Failed: boolean;
  fmMaterialDetails: TfmMaterialDetails;

begin
  Code := tblPartsMaterial.value;

  if (not (Code = '')) then
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

procedure TfmPartDetails.dbgPartWidthKnifeDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := false;
  if (DragType = dragKnife) and (tblPartWidthKnife.state in [dsBrowse]) then
    Accept := true;
  if (DragType = dragSizeRelationship) and (tblPartWidthKnife.state in [dsInsert]) and (not tblPartWidthKnifeKnife.isNull) then
    Accept := true;
end;

procedure TfmPartDetails.dbgPartWidthKnifeDragDrop(Sender, Source: TObject;
  X, Y: Integer);
var
  Index: double;
  k, s: string;
  i: integer;

begin
  //Must Cancel because Clicking back on form does automatic (non trappable) post
  if DragSort = dragEdit then
  begin
    Index := tblPartWidthKnifeSeq.value;
    k := tblPartWidthKnifeKnife.value;
    s := tblPartWidthKnifeSizeRelationship.value;
  end
  else
  begin
    Index := 0;
    k := '';
    s := '';
  end;
  tblPartWidthKnife.Cancel;

  BringToFront;

  if DragType = dragKnife then
  begin
    if not Option_ProductionSystem then
    begin
      tblPartWidthKnife.cancel;
      if fmAllKnifeSets.dbgKnifeSets.SelectedRows.Count > 0 then
        with fmAllKnifeSets.dbgKnifeSets.DataSource.DataSet do
          for i := 0 to fmAllKnifeSets.dbgKnifeSets.SelectedRows.Count - 1 do
          begin
            try
              GotoBookmark(pointer(fmAllKnifeSets.dbgKnifeSets.SelectedRows.Items[i]));
            except
            end;

            if DragSort = dragInsert then
              tblPartWidthKnife.insert
            else if DragSort = dragAppend then
            begin
              tblPartWidthKnife.Last;
              tblPartWidthKnife.append;
            end;
            tblPartWidthKnifeKnife.value := fmAllKnifeSets.dbgKnifeSets.DataSource.DataSet.FieldByname('Code').value;
            tblPartWidthKnife.post;

            //Put in Position Ready for next insert
            if DragSort = dragInsert then
              tblPartWidthKnife.next;
          end;
    end
    else
    begin
      if DragSort = dragInsert then
        tblPartWidthKnife.insert
      else if DragSort = dragAppend then
      begin
        tblPartWidthKnife.Last;
        tblPartWidthKnife.append;
      end;

      tblPartWidthKnifeKnife.value := DragCode;
      if not (s = '') then
        tblPartWidthKnifeSizeRelationship.value := s;
    end;
  end
  else if DragType = dragSizeRelationship then
  begin
    //Will always have be inserting into a record
    //because will have canceled above. Index will
    //ensure correct place - above or below last record.
    tblPartWidthKnife.insert;
    tblPartWidthKnifeSeq.value := Index;
    tblPartWidthKnifeKnife.value := k;
    if not (DragCode = '') then
      tblPartWidthKnifeSizeRelationship.value := DragCode;
    tblPartWidthKnife.post;
  end;
end;

procedure TfmPartDetails.tblPartWidthKnifeGovernorChange(Sender: TField);
var
  SkipRec: real;
  KeepPos: TBookmark;

begin
  if (tblPartWidthKnifeGovernor.value) then
  begin
    SkipRec := tblPartWidthKnifeSeq.value;
    KeepPos := tblPartWidthKnife.GetBookmark;
    tblPartWidthKnife.DisableControls;
    tblPartWidthKnife.First;
    while not tblPartWidthKnife.EOF do
    begin
      if (tblPartWidthKnifeGovernor.value) and (tblPartWidthKnifeSeq.value <> SkipRec) then
      begin
        if not(tblPartWidthKnife.state in [dsEdit, dsInsert]) then
          tblPartWidthKnife.Edit;
        tblPartWidthKnifeGovernor.value := false;
      end;
      tblPartWidthKnife.Next;
    end;
    try
      tblPartWidthKnife.GotoBookmark(KeepPos);
    except
    end;
    tblPartWidthKnife.FreeBookmark(KeepPos);
    tblPartWidthKnife.EnableControls;
  end;
end;

procedure TfmPartDetails.tblPartWidthKnifeCalcFields(DataSet: TDataSet);
var
  InterlockArea, IE: real;

begin
  if (tblPartWidthKnifeGovernor.value) then
    tblPartWidthKnifeMaster.value := 'Yes'
  else
    tblPartWidthKnifeMaster.value := 'No';

  //Interlock Efficiency
  if (tblPartWidthKnifeKnifeType.value = 'P') or (tblPartWidthKnifeKnifeType.value = 'S') then
    InterlockArea := tblPartWidthKnifeKnifeInterlockAreaPrimeSyn.value
  else
    InterlockArea := tblPartWidthKnifeKnifeInterlockAreaNonPrime.value;

  if tblPartWidthKnifeKnifeNettArea.value > 0 then
    IE := ((InterlockArea - tblPartWidthKnifeKnifeNettArea.value) / tblPartWidthKnifeKnifeNettArea.value) * 100
  else
    IE := 0;

  //Check for minor rounding errors
  if IE < 0 then
    IE := 0;

  tblPartWidthKnifeKnifeInterlockEfficiency.value := IE;
end;

procedure TfmPartDetails.btnEditClick(Sender: TObject);
var
  LockSuccess: boolean;

begin
  if ItemGone(tblParts, PartCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oPart, fmSumms.tblLocks, tblParts, PartCode, True);

    if LockSuccess then
      UpdateScreen(True, True)
    else
      LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmPartDetails.UpdateScreen(AllowFocus, Editing: boolean);
begin
  if Editing then
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
  btnPrintincAllow.Enabled := not Editing;
  btnPrintincAllowPreview.Enabled := not Editing;

  btnCopy.enabled := not Editing;
  btnWhereUsed.enabled := not Editing;
  //Note : Uses btnWhereUsed to Check status elsewhere.
  btnLayplanSample.enabled := (lblMaterialType.Caption = 'SYNTHETIC') and Option_FullSynthetics and (not Editing) and AnyWidthSelected;
  btnLayplanCosted.enabled := (lblMaterialType.Caption = 'SYNTHETIC') and Option_FullSynthetics and (not Editing) and AnyWidthSelected;
  btnLayplan.enabled := (lblMaterialType.Caption = 'SYNTHETIC') and Option_FullSynthetics and (not Editing) and AnyWidthSelected;
  btnAllowance.enabled := (not Editing) and AnyWidthSelected;

  btnCopyWidths.enabled := (not Editing) and (NoWidths > 1) and AnyWidthSelected;

  pnlView1.visible := not Editing;
  pnlView2.visible := not Editing;
  pnlView3.visible := not Editing;
  pnlView4.visible := not Editing;
  pnlView5.visible := not Editing;
  pnlView6.visible := not Editing;
  pnlView7.visible := not Editing;
  pnlView9.visible := not Editing;
  pnlView10.visible := not Editing;

  dbcbSLMAllowance.ReadOnly := not Editing;
  dbcbMadeInPairs.ReadOnly := not Editing;
  dbcbManualAdjFactor.ReadOnly := not Editing;

  SetTabStops(Editing);

  DisplayAdjFactor(Editing);
  if Editing then
    lblCalcAdjFact.font.color := clRed
  else
    lblCalcAdjFact.font.color := clData;

  SetColumnWidthsDetails1(fmPartDetails, sgKnives, dbgPartWidthKnife, sgKnives.ColCount - 1, Editing);

  if Editing then
  begin
    //Move the 'implied' focus back
    //to the 1st column in the grid
    if dbgPartWidthKnife.enabled then
    begin
      dbgPartWidthKnife.DataSource.DataSet.Refresh;
      TStringGrid(dbgPartWidthKnife).Col := 1;
    end;

    if AllowFocus then
      dbeDescription.setfocus;
    dbcbMadeInPairs.OnClick := dbcbMadeInPairsClick;
  end
  else
  begin
    pcPart.ActivePageIndex := 0;
    if Allowfocus then    
      cbWidthsForRange.setfocus;
    dbcbMadeInPairs.OnClick := nil;
  end;
end;

procedure TfmPartDetails.btnSaveClick(Sender: TObject);
begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if tblPartWidthKnife.state in [dsEdit, dsInsert] then
      tblPartWidthKnife.post;
    if tblPtWidAF.state in [dsEdit, dsInsert] then
      tblPtWidAF.post;

    tblParts.post;
    if AnyWidthSelected then
      PartWidthKnifeRedoIndex;

    qUpdateSLMAlwFlag.ParamByName('Part').Value := PartCode;
    qUpdateSLMAlwFlag.ParamByName('Legacy').value := Option_LegacySynthetics;
    qUpdateSLMAlwFlag.ExecSQL;

    LocalConnectionSumms.commit;

//    UpdateMaterialDescription;
//    UpdateKnivesCopy;
//    UpdateAdjFactor;
//    UpdateScreen(True, False);
    //CJY Refresh button does all of the above and more
    btnRefresh.Click;
  end;
end;

procedure TfmPartDetails.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblPartWidthKnife.cancel;
  tblPtWidAF.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblWidths.Cancel;
  tblParts.cancel;

  //Refresh Grids
{  tblPartWidthKnife.refresh;
  dbgPartWidthKnife.refresh;}
  btnRefresh.Click;  //in case of knife swap  

  UpdateScreen(True, False);
end;

procedure TfmPartDetails.btnDeleteClick(Sender: TObject);
var
  LockSuccess : boolean;
  CanDelete : boolean;

begin
  if ItemGone(tblParts, PartCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    CanDelete := False;

    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oPart, fmSumms.tblLocks, tblParts, PartCode, True);

    if LockSuccess then
    begin
      CanDelete := (MessageDlgPos('Delete Part?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes);
      if CanDelete then
      begin
        try
          tblParts.delete;
        except
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Part in use', E.Message, '');
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
    tblWidths.Cancel;
    tblParts.Cancel;
    if CanDelete then
      Close;
  end;
end;

procedure TfmPartDetails.btnRefreshClick(Sender: TObject);
begin
  if ItemGone(tblParts, PartCode) then
    Close
  else
  begin
    WidthChanged;
    UpdateMaterialDescription;
    UpdateKnivesCopy;
    UpdateAdjFactor;
  end;

  UpdateScreen(True, False);
end;

procedure TfmPartDetails.btnWhereUsedClick(Sender: TObject);
var
  Failed : boolean;

begin
  if ItemGone(tblParts, PartCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Where Used for Part', PartCode) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmPartsWhereUsed := TfmPartsWhereUsed.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmPartsWhereUsed.PassPartName(PartCode);
    end;
  end;
end;

procedure TfmPartDetails.UpdateKnivesCopy;
var
   i : integer;
   s : string;

begin
  if tblPartWidthKnife.active then
  begin
    sgKnives.RowCount := 2;
    sgKnives.Cells[0, 1] := '';
    sgKnives.Cells[1, 1] := '';
    sgKnives.Cells[2, 1] := '';
    sgKnives.Cells[3, 1] := '';
    sgKnives.Cells[4, 1] := '';
    sgKnives.Cells[5, 1] := '';
    sgKnives.Cells[6, 1] := '';

    i := 0;
    tblPartWidthKnife.refresh;
    tblPartWidthKnife.first;
    while not tblPartWidthKnife.eof do
    begin
      inc(i);
      if i > 1 then
         sgKnives.RowCount := sgKnives.RowCount + 1;
      sgKnives.Cells[0, i] := tblPartWidthKnifeKnifeType.value;
      sgKnives.Cells[1, i] := tblPartWidthKnifeKnife.value;
      sgKnives.Cells[2, i] := tblPartWidthKnifeSizeRelationship.value;
      str(tblPartWidthKnifeFrequency.value : 0, s);
      sgKnives.Cells[3, i] := s;
      str(tblPartWidthKnifeSizeAdjustment.value : 0, s);
      sgKnives.Cells[4, i] := s;
      str(tblPartWidthKnifeNoIncludedKnives.value : 0, s);
      sgKnives.Cells[5, i] := s;
      sgKnives.Cells[6, i] := tblPartWidthKnifeMaster.value;
      tblPartWidthKnife.next;
    end;

    tblPartWidthKnife.First;
    dbgPartWidthKnife.SelectedIndex := 0;
  end;
end;

procedure TfmPartDetails.LoadSizeDropDowns;
begin
  cbSampleSize.DataField := '';
  cbSampleSize.Items.Clear;
  cbCostedSize.DataField := '';
  cbCostedSize.Items.Clear;
  qSizeRangeSizes.RecNo := 1; //CJY changed from qSizeRangeSizes.First
  qSizeRangeSizes.Prior; //CJY changed from qSizeRangeSizes.First
  while not qSizeRangeSizes.eof do
  begin
    cbSampleSize.Items.Add(qSizeRangeSizesSize.value);
    cbCostedSize.Items.Add(qSizeRangeSizesSize.value);

    qSizeRangeSizes.next;
  end;
  cbSampleSize.DataField := 'SampleSize';
  cbCostedSize.DataField := 'CostedSize';
end;

procedure TfmPartDetails.SizeDropDowns;
begin
  screen.cursor := crHourGlass;

  if not qSizeRangeSizes.active then
  begin
    qSizeRangeSizes.ParamByName('SizeRange').value := tblPartsSizeRange.value;
    qSizeRangeSizes.open;

    //Load list box
    LoadSizeDropDowns;
  end;

  screen.cursor := crDefault;
end;

procedure TfmPartDetails.cbSampleSizeDropDown(Sender: TObject);
begin
  SizeDropDowns;
end;

procedure TfmPartDetails.cbCostedSizeDropDown(Sender: TObject);
begin
  SizeDropDowns;
end;

function TfmPartDetails.PartInUse: boolean;
var
  InUse : boolean;

begin
  qPartInUse.ParamByName('PartCode').value := PartCode;
  qPartInUse.open;
  InUse := (qPartInUseEXPR.value > 0);
  qPartInUse.close;

  result := InUse;
end;

procedure TfmPartDetails.cbSampleSizeChange(Sender: TObject);
begin
  if PartInUse then
  begin
    tblPartsSampleSize.Value := tblPartsSampleSize.OldValue;
    MessageDlgPos('Cannot change Sample Size ' + #13 +
               'for a Part which is in use', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;
end;

procedure TfmPartDetails.cbCostedSizeChange(Sender: TObject);
begin
  if PartInUse then
  begin
    tblPartsCostedSize.Value := tblPartsCostedSize.OldValue;
    MessageDlgPos('Cannot change Costed Size ' + #13 +
               'for a Part which is in use', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;
end;

procedure TfmPartDetails.dbcbMadeInPairsClick(Sender: TObject);
begin
  if PartInUse then
  begin
    MessageDlgPos('Cannot change Made in Pairs ' + #13 +
               'for a Part which is in use', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    dbcbMadeInPairs.OnClick := nil;
    tblPartsMadeInPairs.Value := tblPartsMadeInPairs.OldValue;
    dbcbMadeInPairs.OnClick := dbcbMadeInPairsClick;
  end;
end;

procedure TfmPartDetails.cbWidthsForRangeChange(Sender: TObject);
var
  No : integer;
  IsEditing: Boolean;

begin
  AnyWidthSelected := true;
  IsEditing := btnSave.enabled;
  UpdateScreen(False, IsEditing);
{
    //Allowance button Status is same is Where Used button Status once on.
  btnAllowance.enabled := (btnWhereUsed.enabled) and AnyWidthSelected;
 }
  No := WidthNoForWidth(cbWidthsForRange.text);
  WidthSelected(No);
  UpdateKnivesCopy;
  UpdateAdjFactor;

  if (No <> 0) and (tblPtWidAF.recordCount = 0) then
  begin
    //First time this Width Used - Initialise
    //CJY Transactions required for posting when AutoStart/Stop/Commit is Disabled.
    try
      LocalConnectionSumms.StartTransaction;
      tblPtWidAF.insert;
      tblPtWidAFPart.value := tblPartsCode.value;
      tblPtWidAFWidthNo.value := No;
      tblPtWidAFAdjFactor.value := 0;
      tblPtWidAF.post;
      LocalConnectionSumms.Commit;
    except
      LocalConnectionSumms.Rollback;
      Beep;
    end;
  end;

  sgKnives.enabled := True;
  dbgPartWidthKnife.enabled := True;
  dbeAdjFactor.Enabled := AnyWidthSelected;
end;

procedure TfmPartDetails.WidthChanged;
var
  i, OldWidthNo: integer;
  OldWidthName: String;

begin
  screen.cursor := crHourGlass;

  OldWidthNo := ActualWidthSelected;
  OldWidthName := cbWidthsForRange.text;

  WidthSelected(0);

  if qWidthsForRange.active then
    qWidthsForRange.close;
  qWidthsForRange.paramByname('WidthRange').value := dbeWidthRange.Text;
  qWidthsForRange.open;

  //Load list box
  LoadWidthsDropDown;

  //If Original Width is in new Range then refresh... if not, see if the default
  //width for this range is available and set it.
  //CJY Refresh not required as only updating filter value
  qWidthsForRange.Filtered := False;
  qWidthsForRange.Filter := 'No = ' + intToStr(OldWidthNo);
  qWidthsForRange.Filtered := True;
  //CJY: qWidthsForRange.FetchOptions.RecordCountMode set to cmTotal
  if qWidthsForRange.recordcount = 1 then
  begin
    for i := 0 to cbWidthsForRange.Items.Count - 1 do
      if cbWidthsForRange.Items.Strings[i] = OldWidthName then
      begin
        cbWidthsForRange.ItemIndex := i;
        WidthSelected(OldWidthNo);
      end;
  end
  else
  begin
    qDefaultWidth.ParamByName('WidthRange').Value := dbeWidthRange.Text;
    qDefaultWidth.Open;
    if not qDefaultWidthWidthNo.IsNull then
    begin
      //CJY Refresh not required as only updating filter value
      qWidthsForRange.Filtered := False;
      qWidthsForRange.Filter := 'No = ' + intToStr(qDefaultWidthWidthNo.Value);
      qWidthsForRange.Filtered := True;
      //CJY: qWidthsForRange.FetchOptions.RecordCountMode set to cmTotal
      if qWidthsForRange.recordcount = 1 then
      begin
        for i := 0 to cbWidthsForRange.Items.Count - 1 do
          if cbWidthsForRange.Items.Strings[i] = qDefaultWidthWidth.Value then
          begin
            cbWidthsForRange.ItemIndex := i;
            WidthSelected(qDefaultWidthWidthNo.Value);
          end;
      end;
    end;
    qDefaultWidth.Close;
  end;
  qWidthsForRange.Filtered := False;
  qWidthsForRange.Filter := '';

  with cbWidthsForRange do
    if (ItemIndex = -1) and (Items.Count > 0) then
      ItemIndex := 0;

  if tblPtWidAF.active then
    cbWidthsForRangeChange(Self);

  screen.cursor := crDefault;
end;

function TfmPartDetails.WidthNoForWidth(Width : string) : integer;
var
   i, No : integer;
   Found : boolean;

begin
  No := 0;
  i := -1;
  Found := false;
  while (not Found) and (i < (NoWidths - 1)) do
  begin
    inc(i);
    if Width = WidthName[i] then
    begin
      No := WidthNo[i];
      Found := true;
    end;
  end;

  WidthNoForWidth := No;
end;

procedure TfmPartDetails.LoadWidthsDropDown;
var
  i : integer;

begin
  i := -1;
  cbWidthsForRange.Items.Clear;

  //CJY: qWidthsForRange.FetchOptions.RecordCountMode set to cmTotal
  NoWidths := qWidthsForRange.recordcount;
  setLength(WidthNo, NoWidths);
  setLength(WidthName, NoWidths);

  qWidthsForRange.RecNo := 1; //CJY changed from qWidthsForRange.First
  qWidthsForRange.Prior; //CJY changed from qWidthsForRange.First
  while not qWidthsForRange.eof do
  begin
    inc(i);
    WidthNo[i] := qWidthsForRangeNo.value;
    WidthName[i] := qWidthsForRangeWidth.value;

    cbWidthsForRange.Items.Add(qWidthsForRangeWidth.value);

    qWidthsForRange.next;
  end;


end;

procedure TfmPartDetails.WidthSelected(No: integer);
begin
  if (tblPtWidAF.active) then
    tblPtWidAF.SetRange([tblPartsCode.value, No], [tblPartsCode.value, No]);

  dbgPartWidthKnife.enabled := (No > 0);
  ActualWidthSelected := No;
end;

procedure TfmPartDetails.dbeMaterialEnter(Sender: TObject);
begin
  btnBrowse.Tag := 0;
  btnBrowse.enabled := True;
end;

procedure TfmPartDetails.dbeMaterialExit(Sender: TObject);
begin
  btnBrowse.enabled := False;
end;

procedure TfmPartDetails.tblPartsCalcFields(DataSet: TDataSet);
begin
  if tblPartsManualAdjFactor.value then
    tblPartsManualAdjFactorYesNo.value := 'Yes'
  else
    tblPartsManualAdjFactorYesNo.value := 'No';

  if tblPartsSLMAllowance.value then
    tblPartsSLMAllowanceYesNo.value := 'Yes'
  else
    tblPartsSLMAllowanceYesNo.value := 'No';

  if tblPartsMadeInPairs.value then
    tblPartsMadeInPairsYesNo.value := 'Yes'
  else
    tblPartsMadeInPairsYesNo.value := 'No';

  if tblPartsPressTypeLeather.value = 'S' then
    tblPartsPressTypeLeatherDesc.value := dbrgPressTypeLeather.Items[0]
  else if tblPartsPressTypeLeather.value = 'P' then
    tblPartsPressTypeLeatherDesc.value := dbrgPressTypeLeather.Items[1]
  else if tblPartsPressTypeLeather.value = 'T' then
    tblPartsPressTypeLeatherDesc.value := dbrgPressTypeLeather.Items[2];

  if tblPartsPressTypeSynthetic.value = 'P' then
    tblPartsPressTypeSyntheticDesc.value := dbrgPressTypeSynthetic.Items[0]
  else if tblPartsPressTypeSynthetic.value = 'T' then
    tblPartsPressTypeSyntheticDesc.value := dbrgPressTypeSynthetic.Items[1];

  if tblPartsFeedSystem.value = 'C' then
    tblPartsFeedSystemDesc.value := 'Clips'
  else if tblPartsFeedSystem.value = 'G' then
    tblPartsFeedSystemDesc.value := 'Gantry';
end;

procedure TfmPartDetails.UpdateMaterialDescription;
var
  SecondProcess: PartMaterialDescriptionThread;

begin
  if not SecondProcessInUse then
  begin
    SecondProcessInUse := True;
    SecondProcess := PartMaterialDescriptionThread.Create(true);
    SecondProcess.FreeOnTerminate := True;
    SecondProcess.OnTerminate := FinishSecondProcess;
    SecondProcess.PassDetails(fmPartDetails);
    SecondProcess.resume;
  end;
end;

procedure TfmPartDetails.tblPartWidthKnifeAfterOpen(DataSet: TDataSet);
begin
  //Do not allow editing until PartWidthAF &
  //PartWidthKnife tables are open because
  //these trigger a 'post' as they open.
  tbMain.enabled := true;
  //Below relies on these tables being open
  pcPart.enabled := true;
end;

procedure TfmPartDetails.tblPtWidAFAfterOpen(DataSet: TDataSet);
begin
  //Dont display a width until one chosen
  tblPtWidAF.SetRange([tblPartsCode.value, 0], [tblPartsCode.value, 0]);
end;

procedure TfmPartDetails.tblWidthsWidthGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not(tblWidthsWidth.IsNull) then
    Text := '(' + tblWidthsWidth.AsString + ')';
end;

procedure TfmPartDetails.UpdateAdjFactor;
var
  Adjfactor : real;
  s : string;
  No : integer;

begin
  s := '';
  lblCalcAdjFact.Visible := AnyWidthSelected;

  No := 0;
  if cbWidthsForRange.text <> '' then
    No := WidthNoForWidth(cbWidthsForRange.text);
  if No > 0 then
  begin
    AdjFactor := dmAdjFact.PartAdjFactor(tblPartsCode.value, No);
    str(AdjFactor : 1 : 0, s);
  end;

  lblCalcAdjFact.caption := s;
end;

procedure TfmPartDetails.btnAllowanceClick(Sender: TObject);
var
  fmPartAllowance: TfmPartAllowance;
  Code: string;
  Failed: boolean;
  No: integer;

begin
  if ItemGone(tblParts, PartCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    Code := tblPartsCode.value;
    Screen.cursor := crHourGlass;
    Failed := false;
    try
      fmPartAllowance := TfmPartAllowance.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    No := WidthNoForWidth(cbWidthsForRange.text);

    if not Failed then
    begin
      tblParts.Refresh;
      btnRefresh.Click;  //because there may have been a Knife Swap and it's better if the display is correct.
      fmPartAllowance.PassPartNameWidth(fmPartAllowance, self, Code, No, tblPartsSampleSize.Value, tblPartsCostedSize.Value, tblPartsSLMAllowance.Value, False);
      fmPartAllowance.LoadingAllowance := false;
    end;
  end;
end;

procedure TfmPartDetails.btnCopyWidthsClick(Sender: TObject);
begin
  fmCopyPartWidthKnives.PassPartName(fmPartDetails, PartCode);
  fmCopyPartWidthKnives.showModal;
end;

procedure TfmPartDetails.qPtWidAFCalcFields(DataSet: TDataSet);
begin
  qPtWidAFRealAdjFactor.value := dmAdjFact.PartAdjFactor(qPtWidAFPart.value, qPtWidAFWidthNo.value);
end;

procedure TfmPartDetails.tblPartsAfterPost(DataSet: TDataSet);
begin
  if not FormClosing then
    UpdateMaterialDescription;
end;

procedure TfmPartDetails.sgKnivesDblClick(Sender: TObject);
var
  RowNo, ColNo: integer;
  Failed: boolean;
  Code: string;
  fmSizeRelationshipDetails: TfmSizeRelationshipDetails;
  fmKnifeSetDetails : TfmKnifeSetDetails;

begin
  RowNo := sgKnives.Row;
  if RowNo <> -1 then
  begin
    if sgKnives.Columns[sgKnives.Col].Caption = 'Size Relationship' then
      WhichField := 'SizeRelationship'
    else if sgKnives.Columns[sgKnives.Col].Caption = 'Knife' then
      WhichField := 'Knives'
    else
      WhichField := '';

    if (RowNo >= 1) and (RowNo <= sgKnives.RowCount) then
    begin
      if (WhichField = 'Knives') or (WhichField = 'SizeRelationship') then
        Code := sgKnives.Cells[sgKnives.Col, sgKnives.Row];

      Failed := false;
      if (not (Code = '')) and (WhichField <> 'SizeRelationship') then
      begin
        if not ExistingToFront('Knife', Code) then
        begin
          Screen.cursor := crHourGlass;
          try
            fmKnifeSetDetails := TfmKnifeSetDetails.create(fmSumms);
          except
            fmMemoryError.TidyUp(self);
            Failed := true;
          end;

          if not Failed then
            fmKnifeSetDetails.PassKnifeName(fmKnifeSetDetails, Code);
        end;
      end;

      if (not (Code = '')) and (WhichField = 'SizeRelationship') then
      begin
        if not ExistingToFront('Size Relationship', Code) then
        begin
          Screen.cursor := crHourGlass;
          try
            fmSizeRelationshipDetails := TfmSizeRelationshipDetails.create(fmSumms);
          except
            fmMemoryError.TidyUp(self);
            Failed := true;
          end;

          if not Failed then
            fmSizeRelationshipDetails.PassSizeRelationshipName(fmSizeRelationshipDetails, Code);
        end;
      end;
    end;
  end;
end;

procedure TfmPartDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmPartDetails.sgKnivesKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    sgKnivesDblClick(Self);
end;

procedure TfmPartDetails.dbtWidthRangeDblClick(Sender: TObject);
var code:string;
    Failed:boolean;

begin
  Code := tblPartsWidthRange.value;

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

procedure TfmPartDetails.dbtSizeRangeDblClick(Sender: TObject);
var
  fmSizeRangeDetails: TfmSizeRangeDetails;
  Code : string;
  Failed : boolean;

begin
  Code := tblPartsSizeRange.value;

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

procedure TfmPartDetails.FinishSecondProcess(Sender: TObject);
begin
  SecondProcessInUse := False;
end;

procedure TfmPartDetails.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not SecondProcessInUse;

  if SecondProcessInUse then
    MessageDlgPos('Cannot close whilst loading', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

procedure TfmPartDetails.sgKnivesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    CanSelect := False;
end;

procedure TfmPartDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
  dbeMaterial.TabStop := Editing;
  dbeWidthRange.TabStop := Editing;
  cbSampleSize.TabStop := Editing;
  cbCostedSize.TabStop := Editing;
  dbcbManualAdjFactor.TabStop := Editing;
  dbcbMadeInPairs.TabStop := Editing;
  dbeMaxPairs.TabStop := Editing;
  dbeCostedAllowance.TabStop := Editing;
  dbeBatchSize.TabStop := Editing;
  dbcbSLMAllowance.TabStop := Editing;
  dbeRest.TabStop := Editing;
  dbeContingency.TabStop := Editing;
  dbrgPressTypeLeather.TabStop := Editing;
  dbrgPressTypeSynthetic.TabStop := Editing;
  dbrgFeedSystem.TabStop := Editing;
  dbrgPressTypeLeather.visible := Option_CuttingTimes and Editing;    //Radio Group TabStop status doesn't work
  dbrgPressTypeSynthetic.visible := Option_CuttingTimes and Editing;  //Radio Group TabStop status doesn't work
  dbrgFeedSystem.visible := Option_CuttingTimes and Editing;          //Radio Group TabStop status doesn't work
  dbeAdjfactor.TabStop := Editing;
  sgKnives.TabStop := not Editing;
  dbgPartWidthKnife.TabStop := Editing;
  dbmNotes.TabStop := Editing;
end;

procedure TfmPartDetails.tblPartsBeforePost(DataSet: TDataSet);
begin
  //CJY Uppercasing a Null returns a blank string which can upset RI
  if not tblPartsMaterial.IsNull then
    tblPartsMaterial.value := Uppercase(tblPartsMaterial.value);

  if Option_LegacySynthetics and (not Option_FullSynthetics) then
    tblPartsSLMAllowance.value := True;
end;

procedure TfmPartDetails.dbmNotesEnter(Sender: TObject);
begin
  tbMain.SetFocus;
end;

procedure TfmPartDetails.ReferToSyntheticResults(Scale, Size: String;
                                                 Sample: boolean);
var
  s, SubDesc, SubAbbrev: string;
  MaterialLength, MaterialWidth, ToFtMultiplier: double;
  Knife, MaterialUnits: string;
  AdjustedSize: string;
  RestrictiveMaterialCode: string;
  AdjustedSizesValid: Boolean;

begin
  Knife := sgKnives.Cells[1, sgKnives.Row];
  KnifeSize := Size;
  IsSample := Sample;
  qMaterials.open;
  Cutgap := qMaterialsCutGap.value;
  MaterialLength := qMaterialsLength.value;
  MaterialWidth := qMaterialsWidth.value;
  ToFtMultiplier := (qMaterialsToFeet.value / qMaterialsSubUnitsPerUnit.value);
  SubDesc := qMaterialsSubUnitDesc.Value;
  SubAbbrev := qMaterialsSubUnitAbbreviation.Value;
  MaterialUnits := qMaterialsUnits.value;
  RestrictiveMaterialCode := qMaterialsRestrictiveMaterialCode.value;

  MatLengthFt := MaterialLength * ToFtMultiplier;
  MatWidthFt := MaterialWidth * ToFtMultiplier;
  if qMaterialsType.value = 'R' then
  begin
    MatLengthFt := ROLLLENGTH_FT;
    MaterialLength := MatLengthFt / ToFtMultiplier;
  end;
  qMaterials.close;

  if tblKnifeSets.FindKey([Knife]) and tblKnifeSetsManualEntry.value then
    MessageDlgPos('This a manual knife.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else if Size <> '' then
  begin
    //Find Adjusted Size
    AdjustedSizesValid := True;
    qAdjustedKnifeSizes.ParamByName('PartCode').value := PartCode;
    qAdjustedKnifeSizes.ParamByName('WidthNo').value := WidthNoForWidth(cbWidthsForRange.text);
    qAdjustedKnifeSizes.Filter := 'Knife = ''' + Knife + '''';
    qAdjustedKnifeSizes.Filtered := True;
    qAdjustedKnifeSizes.open;
    //CJY: qAdjustedKnifeSizes.FetchOptions.RecordCountMode set to cmTotal
    if qAdjustedKnifeSizes.recordcount <> 0 then
    begin
      if Sample then
        AdjustedSize := qAdjustedKnifeSizes.FieldByName('AdjustedSampleSize').value
      else
        AdjustedSize := qAdjustedKnifeSizes.FieldByName('AdjustedCostedSize').value;
    end
    else
      AdjustedSizesValid := False;
    qAdjustedKnifeSizes.close;

    if (not AdjustedSizesValid) then
      MessageDlgPos('No knives for Width or' + #13 + 'invalid adjusted size.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else if not tblKnives.FindKey([Knife, Scale, AdjustedSize]) then
      MessageDlgPos('Knife ' + Knife + ', Size ' + AdjustedSize + ' not found.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      if (tblKnifeSetsCutGap.value > 0) and not(tblKnifeSetsCutGap.value = Cutgap) then
        MessageDlgPos('The Cut gap on this Knife is ' + intToStr(tblKnifeSetsCutGap.Value) +
                   ' mm. This will be ignored.' + #13#13 +
                   'The Cut gap on the Material will be used.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

      if fmSumms.LayplanningInterfaceOUT(fmPartDetails, Knife, Scale, AdjustedSize, SubDesc, SubAbbrev,
                                        MaterialLength, MaterialWidth, MaterialUnits, CutGap, RestrictiveMaterialCode) then
        fmLayplan.pcSelectionsResults.Activepage := fmLayplan.tsResults;
    end;
  end
  else
  begin
    if fmSumms.LayplanningInterfaceOUT(fmPartDetails, Knife, Scale, '', SubDesc,
         SubAbbrev, MaterialLength, MaterialWidth, MaterialUnits, CutGap,
         RestrictiveMaterialCode) then
    begin
      fmAllPatterns.edSearch.text := Knife;
      fmAllPatterns.cbExact.Checked := True;
      fmLayplan.OpenKnife;

      if fmLayplan.LayplanExists then
        fmLayplan.ReadLayplans;
    end;
  end;
end;

procedure TfmPartDetails.btnLayplanSampleClick(Sender: TObject);
begin
  if ItemGone(tblParts, PartCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
    ReferToSyntheticResults(tblPartsSizeScale.value, tblPartsSampleSize.Value, True);
end;

procedure TfmPartDetails.btnLayplanCostedClick(Sender: TObject);
begin
  if ItemGone(tblParts, PartCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
    ReferToSyntheticResults(tblPartsSizeScale.value, tblPartsCostedSize.Value, False);
end;

procedure TfmPartDetails.tblPartWidthKnifeSqFtPerPieceSetText(
  Sender: TField; const Text: String);
begin
  if (not(lblMaterialType.Caption = 'LEATHER') or Option_FullSynthetics) then
    Sender.Value := StrToFloat(Text) / MaterialUnitConversion;
end;

procedure TfmPartDetails.pcPartDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TfmPartDetails.btnLayplanClick(Sender: TObject);
begin
  if ItemGone(tblParts, PartCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
    ReferToSyntheticResults(tblPartsSizeScale.value, '', False);
end;

end.

