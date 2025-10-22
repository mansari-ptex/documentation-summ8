unit KnifeSetDetails;

interface

uses
  Windows, Printers, Winspool, Forms, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBCtrls, StdCtrls,
  ExtCtrls, Buttons, SysUtils, ComCtrls,  Mask, Controls, Classes, ToolWin,
  Grids, XStringGrid, XStringGridPlus, Types, DBGridPlus, Dialogs, Results, Math,
  General_Interlocking, Graphics, CButton, frxClass, frxDBSet, frxPrinter,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  Vcl.DBGrids, frxReportPlus, convexhull, FASTGeo;

type
  TfmKnifeSetDetails = class(TForm)
    tblKnifeSets: TFDTablePlus;
    tblKnifeSetsCode: TStringField;
    tblKnifeSetsSizeScale: TStringField;
    tblKnifeSetsDescription: TStringField;
    tblKnifeSetsType: TStringField;
    tblKnifeSetsCutGap: TSmallintField;
    tblKnifeSetsPieces: TSmallintField;
    tblKnifeSetsDoubleSided: TBooleanField;
    tblKnifeSetsThin: TBooleanField;
    tblKnifeSetsPunches: TSmallintField;
    tblKnifeSetsBands: TFloatField;
    tblKnifeSetsMarks: TFloatField;
    tblKnifeSetsClears: TSmallintField;
    dsKnifeSets: TDataSource;
    dsSizeScales: TDataSource;
    dsSizeScaleSizes: TDataSource;
    LocalConnectionSumms: TFDConnection;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnRefresh: TSpeedButton;
    btnDelete: TSpeedButton;
    qKnifeInUse: TFDQueryPlus;
    qKnifeInUseEXPR: TIntegerField;
    qSizeScales: TFDQueryPlus;
    qSizeScaleSizes: TFDQueryPlus;
    qSizeScaleSizesScale: TStringField;
    qSizeScaleSizesSize: TStringField;
    qMatCats: TFDQueryPlus;
    dsMatCats: TDataSource;
    qMatCatsCode: TStringField;
    qSizeScalesScale: TStringField;
    tblKnifeSetsCutsLRYesNo: TStringField;
    tblKnifeSetsThinsYesNo: TStringField;
    qSizeScaleSizesSeq: TFloatField;
    pnlKeepPreview: TPanel;
    btnWhereUsed: TSpeedButton;
    btnCopy: TSpeedButton;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    tblKnifeSetsMaterialType: TStringField;
    tblKnives: TFDTablePlus;
    dsKnives: TDataSource;
    tblKnivesCode: TStringField;
    tblKnivesMeasuredSize: TStringField;
    tblKnivesGrossArea: TFloatField;
    tblKnivesNettArea: TFloatField;
    tblKnivesInterlockAreaPrimeSynthetic: TFloatField;
    tblKnivesInterlockAreaNonPrime: TFloatField;
    tblKnivesToBeAssessed: TBooleanField;
    tblKnivesImportFilename: TStringField;
    tblKnivesPiecename: TStringField;
    tblKnivesInterlockArea: TFloatField;
    tblKnifeSetsManualEntry: TBooleanField;
    dlgOpenPatternFile: TOpenDialog;
    tblKnivesSizeScale: TStringField;
    tblKnivesSeq: TFloatField;
    qAddKnifeSize: TFDQueryPlus;
    StringField1: TStringField;
    SmallintField1: TSmallintField;
    SmallintField2: TSmallintField;
    SmallintField3: TSmallintField;
    tblKnivesAssessed: TStringField;
    btnAddSize: TSpeedButton;
    btnRemoveSize: TSpeedButton;
    qCheckForLayplans: TFDQueryPlus;
    qCheckForLayplansPerSize: TFDQueryPlus;
    qCheckForLayplansNoLayplans: TIntegerField;
    qCheckForLayplansPerSizeNoLayplans: TIntegerField;
    tblSizeScaleSizes: TFDTablePlus;
    tblSizeScaleSizesScale: TStringField;
    tblSizeScaleSizesSize: TStringField;
    tblSizeScaleSizesSeq: TFloatField;
    qInterlocks: TFDQueryPlus;
    qInterlocksKnifeCode: TStringField;
    qInterlocksKnifeSizeScale: TStringField;
    qInterlocksKnifeSize: TStringField;
    qInterlocksSeq: TSmallintField;
    qInterlocksW2: TBooleanField;
    qInterlocksGhost: TBooleanField;
    qInterlocksBR_Left: TIntegerField;
    qInterlocksBR_Top: TIntegerField;
    qInterlocksBR_Right: TIntegerField;
    qInterlocksBR_Bottom: TIntegerField;
    qInterlockKnives: TFDQueryPlus;
    qInterlockKnivesKnifeCode: TStringField;
    qInterlockKnivesKnifeSizeScale: TStringField;
    qInterlockKnivesKnifeSize: TStringField;
    qInterlockKnivesRealNotExpanded: TBooleanField;
    qInterlockKnivesW2: TBooleanField;
    qInterlockKnivesSeq: TSmallintField;
    qInterlockKnivesX: TIntegerField;
    qInterlockKnivesY: TIntegerField;
    tblKnivesAssessedVersion: TSmallintField;
    btnReassess: TSpeedButton;
    qPattInts: TFDQueryPlus;
    qPattIntsKnife: TStringField;
    qPattIntsInterlockNo: TSmallintField;
    qPattIntsTrxx: TSmallintField;
    qPattIntsTryy: TSmallintField;
    qPattIntsRev: TBooleanField;
    qPattIntsW2: TBooleanField;
    qMarkForReassessment: TFDQueryPlus;
    qPatterns: TFDQueryPlus;
    qPatternsKnife: TStringField;
    qPatternsSeq: TSmallintField;
    qPatternsX: TSmallintField;
    qPatternsY: TSmallintField;
    qPatternsSizeScale: TStringField;
    qPatternsMeasuredSize: TStringField;
    tblKnivesToleranceUsed: TIntegerField;
    tblKnivesAngle: TFloatField;
    qDeleteLayplans: TFDQueryPlus;
    frKnife: TfrxReportPlus;
    frDBdsKnives: TfrxDBDataset;
    tblKnivesAssessedPlusVersion: TStringField;
    pnlTop: TPanel;
    lblDescription: TLabel;
    dbeDescription: TDBEdit;
    pnlView1: TPanel;
    dbtDescription: TDBText;
    pnlView2: TPanel;
    dbtMaterialCat: TDBText;
    dbtPieces: TDBText;
    lblMatCats: TLabel;
    lblPieces: TLabel;
    dbePieces: TDBEdit;
    cbMatCat: TDBComboBox;
    lblSizeScale: TLabel;
    dbtSizeScale: TDBText;
    pnlBottom: TPanel;
    pnlKnifePictures: TPanel;
    imgKnife: TImage;
    imgInterlock: TImage;
    lblManualEntry: TLabel;
    lblSumms6Assessed: TLabel;
    btnAngle: TColButton;
    pnlSizes: TPanel;
    dbgManualKnives: TDBGridPlus;
    pnlView9: TPanel;
    sgKnives: TXStringGridPlus;
    dbeMatCat: TDBEdit;
    pnlCutting: TPanel;
    lblPeels: TLabel;
    lblBands: TLabel;
    lblMarks: TLabel;
    lblClears: TLabel;
    dbePeels: TDBEdit;
    dbeBands: TDBEdit;
    dbcbDoubleSided: TDBCheckBox;
    dbcbThin: TDBCheckBox;
    dbeClears: TDBEdit;
    dbeMarks: TDBEdit;
    pnlView3: TPanel;
    dbtClears: TDBText;
    pnlView4: TPanel;
    dbtThinYesNo: TDBText;
    pnlCutGap: TPanel;
    lblCutGap: TLabel;
    dbcbCutGap: TDBComboBox;
    pnlView3a: TPanel;
    dbtCutGap: TDBText;
    lblLegacyCutGap: TLabel;
    dbtCutsLRYesNo: TDBText;
    dbtMarks: TDBText;
    dbtBands: TDBText;
    dbtPeels: TDBText;
    frKnifePrint: TfrxReportPlus;
    imgPrint: TImage;
    frDBdsKnifeSets: TfrxDBDataset;
    btnPrintKnifeRealSize: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassKnifeName(KnifeForm: TfmKnifeSetDetails; var Code: string);
    procedure ViewPattern;
    function KnifeInUse: boolean;
    procedure FormCreate(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnWhereUsedClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure tblKnifeSetsAfterOpen(DataSet: TDataSet);
    procedure cbMatCatDropDown(Sender: TObject);
    procedure tblKnifeSetsCalcFields(DataSet: TDataSet);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure CaptionHintsAndPicture;
    procedure FinishSecondProcess(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure dbtSizeScaleDblClick(Sender: TObject);
    procedure SetTabStops(Editing: Boolean);
    procedure btnAddSizeClick(Sender: TObject);
    procedure UpdateKnivesGrid;
    procedure sgKnivesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnRemoveSizeClick(Sender: TObject);
    procedure tblKnivesCalcFields(DataSet: TDataSet);
    procedure dbeMatCatChange(Sender: TObject);
    function CloseChildren: boolean;
    procedure tblKnivesBeforePost(DataSet: TDataSet);
    function ReadInterlock(KnifeSizeToUse: string): Boolean;
    procedure DisplayInterlock(img: TImage);
    procedure btnReassessClick(Sender: TObject);
    procedure LocalDrawResults(Canvas: TCanvas; XOffset, YOffset: integer);
    procedure imgDblClick(Sender: TObject);
    procedure imgKnifeDblClick(Sender: TObject);
    procedure imgInterlockDblClick(Sender: TObject);
    procedure btnAngleClick(Sender: TObject);
    procedure frKnifeGetValue(const VarName: string; var Value: Variant);
    procedure frKnifeBeforePrint(Sender: TfrxReportComponent);
    procedure btnPrintKnifeRealSizeClick(Sender: TObject);
    {Functions for calculating printer page margins}
    function GetPageWidth: Integer;
    function GetPageHeight: Integer;
    function GetPageOffsetLeft: Integer;
    function GetPageOffsetRight: Integer;
    function GetPageOffsetTop: Integer;
    function GetPageOffsetBottom: Integer;
    function GetPixelsPerInchX: Integer;
    function GetPixelsPerInchY: Integer;
    procedure frKnifePrintGetValue(const VarName: string; var Value: Variant);
    function DisplayPatternRealSize(Code, Scale, Size: String;
                                     clBackground, clPattern: integer;
                                     var KnifeIn: TPointArray;
                                     RotationAngle: Real; imgPattern: TImage): Real;
    procedure frKnifePrintBeforePrint(Sender: TfrxReportComponent);
    procedure sgKnivesDblClick(Sender: TObject);
    function MakeConvexHull(Points: TPointArray): TPolygon2D;
  private
    { Private declarations }
    fmKnifeSetDetails: TfmKnifeSetDetails;
    Closing, ManualEntry, ShowReassessButton, MarkedForReassessment: boolean;
    LocalCutResults: TCutResult;
    LocalKnivesUsed: array of array[0..1] of TPattern;
    FormWidth: integer;
    CanChangeAngle: Boolean;
    KnifeAtAngle: TPointArray;
  public
    { Public declarations }
    KnifeCode, KnifeSizeScale, KnifeSize: string;
    SecondProcessInUse: Boolean;
    RowNo: integer;
    AvailableSizes: TStringList;
    NewStyleInterlock: Boolean;
  end;

var
  GroupPrinting, PrintingCancelled: boolean;
  HullPerimeter: Real;

implementation

uses
  General, SummsVars, CmnVars, Menus, KnivesWhereUsed, SizeScaleDetails, Summs, CopyKnife,
  OutOfMemory, SummsThreads, SelectKnifeSize, ImportKnife, AdvErrorHandler, PatternDrawing,
  KnifeInterlock, KnifeSpinner, Dongle_Green;

{$R *.DFM}

procedure TfmKnifeSetDetails.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Closing := True;
  if tblKnifeSets.state in [dsEdit, dsInsert] then
  begin
    if messagedlg('Save Changes to Knife ' + KnifeCode + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      btnSave.click
    else
      btnCancel.click;
  end;

  AvailableSizes.Free;

  action := caFree;
end;

procedure TfmKnifeSetDetails.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmKnifeSetDetails.PassKnifeName(KnifeForm: TfmKnifeSetDetails; var Code: string);
begin
  NextSetSize := '';
  Closing := False;

  try
    fmKnifeSetDetails := KnifeForm;
    KnifeCode := Code;

    Caption := 'Knife : ' + KnifeCode;

    screen.cursor := crHourGlass;

    //We need to ensure that the OnChange doesn't go off
    //until the FindKey has been done....
    dbeMatCat.OnChange := nil;
    tblKnifeSets.open;
    tblKnifeSets.findKey([KnifeCode]);
    dbeMatCat.OnChange := dbeMatCatChange;
    //...and it must go off once
    dbeMatCatChange(Self);

    KnifeSizeScale := tblKnifeSetsSizeScale.Value;
    ManualEntry := tblKnifeSetsManualEntry.Value;

    btnAddSize.Visible := not ManualEntry;
    btnRemoveSize.Visible := not ManualEntry;
    lblManualEntry.Visible := ManualEntry;

    tblKnives.Open;
    screen.cursor := crDefault;

    if tblKnifeSets.RecordCount = 0 then
    begin
      messagedlg('Knife' + KnifeCode + ' does not exist', mtInformation, [mbOk], 0);
      close;
    end
    else
    begin
      if tblKnives.RecordCount > 0 then
      begin
        tblKnives.RecNo := 1;
        tblKnives.Prior;
        RowNo := 1;
        UpdateKnivesGrid;

        CaptionHintsandPicture;
      end;
    end;

    UpdateScreen(False);
  except
    Close;
    HasClosed := True;
    raise;
  end;
end;

procedure TfmKnifeSetDetails.ViewPattern;
var
  Assessed, HasKnife: Boolean;
  KnifeSizeToUse: string;
  IsAKnife: Boolean;
  Knife: TPointArray;
  s: string;
  Seq: Real;

begin
  IsAKnife := (tblKnives.RecordCount > 0);

  //Header
  if not IsAKnife then
    KnifeSize := '';

  //Hold KnifeSize so that it does not change
  //during this iteration of ViewPattern
  KnifeSizeToUse := KnifeSize;

  s := tblKnives.IndexName;
  tblKnives.Indexname := 'PRIMARY';
  tblKnives.FindKey([KnifeCode, KnifeSizeScale, KnifeSizeToUse]);
  Seq := tblKnivesSeq.value;
  tblKnives.Indexname := s;
  tblKnives.FindKey([KnifeCode, Seq]);

  Assessed := False;
  HasKnife := True;
  NewStyleInterlock := False;

  //Draw Squares
  if IsAKnife then
  begin
    imgKnife.Canvas.Brush.Color := clHide;
    imgKnife.Canvas.FillRect(Rect(0, 0, imgKnife.Picture.Bitmap.Width, imgKnife.Picture.Bitmap.Height));
    imgKnife.Visible := True;

    imgInterlock.Canvas.Brush.Color := clHide;
    imgInterlock.Canvas.FillRect(Rect(0, 0, imgInterlock.Picture.Bitmap.Width, imgInterlock.Picture.Bitmap.Height));
    imgInterlock.Visible := True;
  end
  else
  begin
    imgKnife.Visible := False;
    imgInterlock.Visible := False;
  end;

  if (tblKnifeSetsType.value = 'S') and (not Option_LegacySynthetics) then
    imgInterlock.Visible := False;

  //Display assessed message even if there is no stored
  //interlock picture if it HAS been assessed
  lblSumms6Assessed.Visible := (tblKnivesAssessedVersion.Value = 6);

  if not ManualEntry then
  begin
    dmPatternDrawing.DisplayPattern(KnifeCode, KnifeSizeScale, KnifeSizeToUse, clHide, clCut, imgKnife, Knife, 0);
    dmPatternDrawing.DisplayPattern(KnifeCode, KnifeSizeScale, KnifeSizeToUse, clHide, clCut, imgKnife, KnifeAtAngle, tblKnivesAngle.value);

    //See if there is a new style interlock
    NewStyleInterlock := ReadInterlock(KnifeSizeToUse);

    if imgInterlock.Visible then
    begin
      if NewStyleInterlock then
        DisplayInterlock(imgInterlock)
      else if tblKnivesAssessedVersion.Value = 6 then
        dmPatternDrawing.DrawVersion6Interlock(KnifeCode, KnifeSizeScale, KnifeSizeToUse, clHide, clCut, imgInterlock, Knife);
    end;
  end;
end;

function TfmKnifeSetDetails.KnifeInUse: boolean;
var
  InUse : boolean;

begin
  qKnifeInUse.ParamByName('KnifeCode').value := KnifeCode;
  qKnifeInUse.open;
  InUse := (qKnifeInUseEXPR.value > 0);
  qKnifeInUse.close;

  result := InUse;
end;

procedure TfmKnifeSetDetails.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  FormWidth := self.Width;

  SecondProcessInUse := False;

  if not Option_CuttingTimes then
  begin
    lblClears.Enabled := false;
    lblPeels.Enabled := false;
    lblBands.Enabled := false;
    lblMarks.Enabled := false;

    dbcbDoubleSided.Enabled := false;
    dbcbThin.Enabled := false;
    dbcbDoubleSided.DataField := '';
    dbcbThin.DataField := '';

    dbtCutsLRYesNo.Enabled := false;
    dbtThinYesNo.Enabled := false;

    dbtCutsLRYesNo.DataField := '';
    dbtThinYesNo.DataField := '';

    dbeClears.Enabled := false;
    dbePeels.Enabled := false;
    dbeBands.Enabled := false;
    dbeMarks.Enabled := false;

    dbeClears.DataField := '';
    dbePeels.DataField := '';
    dbeBands.DataField := '';
    dbeMarks.DataField := '';

    dbtClears.Enabled := false;
    dbtPeels.Enabled := false;
    dbtBands.Enabled := false;
    dbtMarks.Enabled := false;

    dbtClears.DataField := '';
    dbtPeels.DataField := '';
    dbtBands.DataField := '';
    dbtMarks.DataField := '';
  end;

  pnlCutGap.Visible := Option_LegacySynthetics;
  if not Option_LegacySynthetics then
    Height := Height - pnlCutGap.Height - pnlCutGap.Margins.Top - pnlCutGap.Margins.Bottom;
  pnlCutting.Visible := Option_CuttingTimes;
  if not Option_CuttingTimes then
    Height := Height - pnlCutting.Height - pnlCutting.Margins.Top - pnlCutting.Margins.Bottom;

  if GroupPrinting then
  begin
    Enabled := False;
    Position := poMainFormCenter;
  end;

  SetTabStops(False);
  AvailableSizes := TStringList.Create;
end;

procedure TfmKnifeSetDetails.frKnifeBeforePrint(Sender: TfrxReportComponent);
begin
  frKnife.PreviewOptions.AllowEdit := False;
  frKnife.PreviewOptions.Buttons := frKnife.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frKnife.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frKnife.PreviewOptions.ZoomMode := zmDefault
  else
    frKnife.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmKnifeSetDetails.frKnifeGetValue(const VarName: string;
  var Value: Variant);
var
  s: string;

begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := 'Knife : ' + KnifeCode;
  if (VarName = 'Description') then
    Value := tblKnifeSetsDescription.value;
  if (VarName = 'SizeScale') then
    Value := tblKnifeSetsSizeScale.value;
  if (VarName = 'MaterialCat') then
    Value := tblKnifeSetsMaterialType.value;
  if (VarName = 'CutsLR') then
    Value := tblKnifeSetsCutsLRYesNo.value;
  if (VarName = 'Thin') then
    Value := tblKnifeSetsThinsYesNo.value;
  if (VarName = 'SelectedSize') then
    Value := sgKnives.Cells[0, sgKnives.Row];
  if (VarName = 'CutGap') then
  begin
    str(tblKnifeSetsCutGap.value : 3, s);
    Value := s;
  end;
  if (VarName = 'Pieces') then
  begin
    str(tblKnifeSetsPieces.value : 3, s);
    Value := s;
  end;
  if (VarName = 'Pieces') then
  begin
    str(tblKnifeSetsPieces.value : 3, s);
    Value := s;
  end;
  if (VarName = 'Punches') then
  begin
    str(tblKnifeSetsPunches.value : 3, s);
    Value := s;
  end;
  if (VarName = 'Bands') then
  begin
    str(tblKnifeSetsBands.value : 7 : 2, s);
    Value := s;
  end;
  if (VarName = 'Marks') then
  begin
    str(tblKnifeSetsMarks.value : 7 : 2, s);
    Value := s;
  end;
  if (VarName = 'Clears') then
  begin
    str(tblKnifeSetsClears.value : 3, s);
    Value := s;
  end;
end;

procedure TfmKnifeSetDetails.frKnifePrintBeforePrint(
  Sender: TfrxReportComponent);
begin
  frKnifePrint.PreviewOptions.AllowEdit := False;
  frKnifePrint.PreviewOptions.Buttons := frKnife.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frKnifePrint.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frKnifePrint.PreviewOptions.ZoomMode := zmDefault
  else
    frKnifePrint.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmKnifeSetDetails.frKnifePrintGetValue(const VarName: string;
  var Value: Variant);
var
  NA: Real;

begin
  if (VarName = 'Size') then
    Value := sgKnives.Cells[0, sgKnives.Row];
  if (VarName = 'Perim') then
    Value := HullPerimeter;
  if (VarName = 'NettA') then
    Value := sgKnives.Cells[2, sgKnives.Row];
  if (VarName = 'PerimOverNA') then
  begin
    NA := StrToFloat(sgKnives.Cells[2, sgKnives.Row]);

    Value := HullPerimeter / NA;
  end;
end;

function TfmKnifeSetDetails.GetPageHeight: Integer;
begin
	Result := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT)
end;

function TfmKnifeSetDetails.GetPageOffsetBottom: Integer;
begin
	Result := GetPageHeight - GetPageOffsetTop - GetDeviceCaps(Printer.Handle, VERTRES)
end;

function TfmKnifeSetDetails.GetPageOffsetLeft: Integer;
begin
	Result := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX)
end;

function TfmKnifeSetDetails.GetPageOffsetRight: Integer;
begin
	Result := GetPageWidth - GetPageOffsetLeft - GetDeviceCaps(Printer.Handle, HORZRES)
end;

function TfmKnifeSetDetails.GetPageOffsetTop: Integer;
begin
	Result := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY)
end;

function TfmKnifeSetDetails.GetPageWidth: Integer;
begin
	Result := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH)
end;

function TfmKnifeSetDetails.GetPixelsPerInchX: Integer;
begin
	Result := GetDeviceCaps(Printer.Handle, LOGPIXELSX)
end;

function TfmKnifeSetDetails.GetPixelsPerInchY: Integer;
begin
	Result := GetDeviceCaps(Printer.Handle, LOGPIXELSY)
end;

procedure TfmKnifeSetDetails.imgDblClick(Sender: TObject);
var
  Code: string;
  Failed: boolean;
  fmKnifeOrInterlock: TfmKnifeOrInterlock;
  Knife: TPointArray;
  s: string;

begin
  Code := KnifeCode + ' / ' + KnifeSize;

  if (Sender as TImage).Name = 'imgKnife' then
    s := 'Knife'
  else
    s := 'Interlock';

  if not (Code = '') then
  begin
    if not ExistingToFront(s, Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmKnifeOrInterlock := TfmKnifeOrInterlock.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
      begin
        fmKnifeOrInterlock.Caption := s + ' : ' + Code;

        if imgKnife.Visible and ((Sender as TImage).Name = 'imgKnife') then
          dmPatternDrawing.DisplayPattern(KnifeCode, KnifeSizeScale, KnifeSize, clHide, clCut, fmKnifeOrInterlock.imgKnifeOrInterlock, KnifeAtAngle, tblKnivesAngle.value)
        else if imgInterlock.visible and ((Sender as TImage).Name = 'imgInterlock') then
        begin
          fmKnifeOrInterlock.imgKnifeOrInterlock.Canvas.Brush.Color := clHide;
          fmKnifeOrInterlock.imgKnifeOrInterlock.Canvas.FillRect(Rect(0, 0, fmKnifeOrInterlock.imgKnifeOrInterlock.Picture.Bitmap.Width, fmKnifeOrInterlock.imgKnifeOrInterlock.Picture.Bitmap.Height));
          fmKnifeOrInterlock.imgKnifeOrInterlock.Visible := True;

          if not ManualEntry then
          begin
            if imgInterlock.Visible then
            begin
              if NewStyleInterlock then
                DisplayInterlock(fmKnifeOrInterlock.imgKnifeOrInterlock)
              else if tblKnivesAssessedVersion.Value = 6 then
                dmPatternDrawing.DrawVersion6Interlock(KnifeCode, KnifeSizeScale, KnifeSize, clHide, clCut, fmKnifeOrInterlock.imgKnifeOrInterlock, Knife);
            end;
          end;
        end;
      end;
      Screen.cursor := crDefault;
    end;
  end;
end;

procedure TfmKnifeSetDetails.imgInterlockDblClick(Sender: TObject);
begin
  if lblSumms6Assessed.Visible then
    messagedlg('Cannot enlarge knives assessed in Version 6', mtInformation, [mbOk], 0)
  else
    imgDblClick(Sender);
end;

procedure TfmKnifeSetDetails.imgKnifeDblClick(Sender: TObject);
begin
  imgDblClick(Sender);
end;

function TfmKnifeSetDetails.CloseChildren: boolean;
var
  i: integer;

begin
  Result := True;
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TForm) and ((Components[i] as TForm).Owner = fmKnifeSetDetails) then
    try
      (Components[i] as TForm).close;
    except
      Result := False;
    end;
  end;
end;

procedure TfmKnifeSetDetails.btnAngleClick(Sender: TObject);
var
  MyBookmark: TBookmark;
  Spinner: TModalResult;
  s: string;

begin
  if CanChangeAngle then
  begin
    fmKnifeSpinner.LoadKnife(KnifeCode, KnifeSizeScale, KnifeSize, tblKnivesAngle.value);
    Spinner := fmKnifeSpinner.showmodal;
    if (Spinner = mrYes) or (Spinner = mrYesToAll) then
    begin
      if (not (tblKnives.State = dsEdit)) then
        tblKnives.edit;
      tblKnivesAngle.value := fmKnifeSpinner.AdjustmentAngle;
      tblKnives.post;
      dmPatternDrawing.DisplayPattern(KnifeCode, KnifeSizeScale, KnifeSize, clHide, clCut, imgKnife, KnifeAtAngle, tblKnivesAngle.value);
    end;

    if (Spinner = mrYesToAll) then
    begin
      MyBookmark := tblKnives.GetBookmark;
      tblKnives.DisableControls;

      tblKnives.RecNo := 1;
      tblKnives.Prior;
      while not tblKnives.Eof do
      begin
        tblKnives.edit;
        tblknivesAngle.value := fmKnifeSpinner.AdjustmentAngle;
        tblKnives.post;

        tblKnives.next;
      end;

      tblKnives.GotoBookmark(MyBookmark);
      tblKnives.EnableControls;
      tblKnives.FreeBookmark(MyBookmark);
    end;

    if (Spinner = mrYes) or (Spinner = mrYesToAll) then
      UpdateKnivesGrid;
  end
  else
  begin
    //Horrible solution but necesary as until knives are saved, the points are
    //not added to the database and so can't be angled. Allowing existing knives
    //to be angled also causes problems. This solution works if a little ugly.
    s := 'Cannot change angles when adding/removing sizes.' + #13#13 +
         'Save or Cancel and Edit Knife again to change angles.';
    messagedlg(s, mtInformation, [mbOk], 0);
  end;
end;

procedure TfmKnifeSetDetails.btnEditClick(Sender: TObject);
var
  LockSuccess, ToBeAssessedStatus: Boolean;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    tblKnifeSets.refresh;
    if tblKnifeSets.recordcount = 0 then
    begin
      messagedlg('Knife ' + KnifeCode + ' has been deleted', mtInformation, [mbOk], 0);
      close;
    end
    else
    begin
      LocalConnectionSumms.StartTransaction;

      //Attempt Lock
      LockSuccess := LockSingle(oKnifeSet, fmSumms.tblLocks, tblKnifeSets, KnifeCode, True);

      if LockSuccess then
      begin
        UpdateKnivesGrid;  //Ensures 'enabled' for Cut Gap is set correctly

//CJY Suspected issue, changing index whilst in edit mode
//        tblKnives.Edit;

        UpdateScreen(True);

        //Can change angles until add or remove knives
        CanChangeAngle := True;
      end
      else
        LocalConnectionSumms.Rollback;
    end;
  end;
end;

procedure TfmKnifeSetDetails.btnSaveClick(Sender: TObject);
var
  i: integer;
  SQLString: string;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ManualEntry then
    begin
      if CloseChildren then
      begin
        screen.cursor := crHourGlass;

        SQLString := '';
        if tblKnifeSets.State in [dsEdit, dsInsert] then
          tblKnifeSets.post;

        tblKnifeSets.Edit;

        LocalConnectionSumms.commit;

        LocalConnectionSumms.StartTransaction;

        for i := 1 to sgKnives.RowCount - 1 do
          SQLString := SQLString + sgKnives.Cells[6, i];

        if not(SQLString = '') then
        begin
          qAddKnifeSize.SQL.Text := SQLString;
          try
            qAddKnifeSize.ExecSQL;
          except
            on E: Exception do
              fmErrorHandler.DebugMessageDlg('Invalid data. ' + #13 + 'Check Sizes exist.', E.Message, qAddKnifeSize.Text);
          end;
          qAddKnifeSize.SQL.Text := '';
        end;

        if MarkedForReassessment then
        begin
          qMarkForReassessment.SQL.Text :=
            'DELETE FROM InterlockKnives' + #13 +
            'WHERE KnifeCode = ''' + QS(KnifeCode) + ''' AND KnifeSizeScale = ''' + QS(KnifeSizeScale) + ''';' + #13 + #13 +
            'DELETE FROM Interlocks' + #13 +
            'WHERE KnifeCode = ''' + QS(KnifeCode) + ''' AND KnifeSizeScale = ''' + QS(KnifeSizeScale) + ''';' + #13 + #13 +
            'DELETE FROM PattInts' + #13 +
            'WHERE Knife = ''' + QS(KnifeCode) + ''' AND SizeScale = ''' + QS(KnifeSizeScale) + ''';' + #13 + #13 +
            'UPDATE Knives' + #13 +
            'SET GrossArea = 0,' + #13 +
            '    NettArea = 0,' + #13 +
            '    InterlockAreaPrimeSynthetic = 0,' + #13 +
            '    InterlockAreaNonPrime = 0,' + #13 +
            '    ToBeAssessed = True,' + #13 +
            '    AssessedVersion = NULL' + #13 +
            'WHERE Code = ''' + QS(KnifeCode) + ''' AND SizeScale = ''' + QS(KnifeSizeScale) + '''';
          qMarkForReassessment.ExecSQL;

          MarkedForReassessment := False;
        end;

        if tblKnifeSets.State in [dsEdit, dsInsert] then
          tblKnifeSets.post;

        LocalConnectionSumms.commit;

        if not Closing then
        begin
          tblKnives.RecNo := 1;
          tblKnives.Prior;
          RowNo := 1;
          UpdateKnivesGrid;
          UpdateScreen(False);
        end;

        screen.cursor := crDefault;
      end
      else
        messagedlg('Cannot close child form', mtInformation, [mbOK], 0);
    end
    else
    begin
      if tblKnives.State in [dsEdit, dsInsert] then
        tblKnives.Post;

      if tblKnifeSets.State in [dsEdit, dsInsert] then
        tblKnifeSets.post;

      LocalConnectionSumms.commit;
      UpdateScreen(False);
      if tblKnives.RecordCount > 0 then
      begin
        tblKnives.RecNo := 1;
        tblKnives.Prior;
        RowNo := 1;
      end;
      UpdateKnivesGrid;
    end;

    if not Closing then
      CaptionHintsandPicture;
  end;
end;

procedure TfmKnifeSetDetails.btnCancelClick(Sender: TObject);
begin
  if CloseChildren then
  begin
    //Cancel Non saved edits
    tblKnives.cancel;

    LocalConnectionSumms.Rollback;

    //Release lock
    tblKnifeSets.Cancel;

    if not Closing then
    begin
      UpdateKnivesGrid;
      UpdateScreen(False);
    end;
  end
  else
    messagedlg('Cannot close child form', mtInformation, [mbOK], 0);
end;

procedure TfmKnifeSetDetails.btnDeleteClick(Sender: TObject);
var
  CanDelete, DeleteLayplans, LockSuccess : boolean;
  s: string;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    CanDelete := False;

    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oKnifeSet, fmSumms.tblLocks, tblKnifeSets, KnifeCode, True);

    if LockSuccess then
    begin
      qCheckForLayplans.ParamByName('KnifeCode').Value := KnifeCode;
      qCheckForLayplans.open;

      if qCheckForLayplansNoLayplans.Value > 0 then
      begin
        s := 'Delete Knife and its associated ' + intToStr(qCheckForLayplansNoLayplans.Value) + ' layplan(s)?';
        DeleteLayplans := True;
      end
      else
      begin
        s := 'Delete Knife?';
        DeleteLayplans := False;
      end;
      qCheckForLayplans.close;

      CanDelete := (messagedlg(s , mtConfirmation, [mbYes, mbNo], 0) = mrYes);
      if CanDelete then
      begin
        LocalConnectionSumms.StartTransaction;
        try
          if DeleteLayplans then
          begin
            qDeleteLayplans.ParamByName('KnifeCode').Value := KnifeCode;
            qDeleteLayplans.ExecSQL;
          end;
          tblKnifeSets.delete;
        except
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Knife in use', E.Message, '');
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
    tblKnives.Cancel;
    tblKnifeSets.Cancel;
    if CanDelete then
      Close;
  end;
end;

procedure TfmKnifeSetDetails.btnRefreshClick(Sender: TObject);
begin
  tblKnifeSets.refresh;
  if tblKnifeSets.recordcount = 0 then
  begin
    messagedlg('Knife ' + KnifeCode + ' has been deleted', mtInformation, [mbOk], 0);
    close;
  end
  else
  begin
    UpdateKnivesGrid;
    CaptionHintsandPicture;
  end;
end;

procedure TfmKnifeSetDetails.btnPrintClick(Sender: TObject);
var
  KnifePic: TfrxPictureView;
  mMemo: TfrxMemoView;
  Box: TfrxShapeView;

begin
  frKnife.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  tblKnifeSets.refresh;
  if tblKnifeSets.recordcount = 0 then
  begin
    messagedlg('Knife' + KnifeCode + ' has been deleted', mtInformation, [mbOk], 0);
    close;
  end
  else
  begin
    btnPrint.Enabled := False;
    btnPrintPreview.Enabled := False;

    KnifePic := frKnife.FindObject('pKnife') as TfrxPictureView;
    KnifePic.Picture.Bitmap := imgKnife.Picture.Bitmap;
    KnifePic.Visible := (not tblKnifeSetsManualEntry.Value);
    KnifePic := frKnife.FindObject('pInterlock') as TfrxPictureView;
    KnifePic.Picture.Bitmap := imgInterlock.Picture.Bitmap;
    mMemo := frKnife.FindObject('mAssessedIn6') as TfrxMemoView;
    mMemo.Visible := lblSumms6Assessed.Visible;

    if tblKnifeSetsManualEntry.value = True then
    begin
      KnifePic.Visible := False; //pInterlock
      mMemo := frKnife.FindObject('mAssessedTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mAssessed') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mAngleTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mAngle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mSelectedSizeTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mSelectedSize') as TfrxMemoView;
      mMemo.Visible := False;
      //CJY sBox not in form
      //Box := frKnife.FindObject('sBox') as TfrxShapeView;
      //Box.Visible := False;
    end
    else if (tblKnifeSetsType.value = 'S') and (not Option_LegacySynthetics) then
    begin
      KnifePic.Visible := False; //pInterlock
      mMemo := frKnife.FindObject('mGrossAreaTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mGrossArea') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mNettAreaTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mNettArea') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mInterlockAreaTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mInterlockArea') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mAssessedTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mAssessed') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mAngleTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mAngle') as TfrxMemoView;
      mMemo.Visible := False;
    end;
    if not Option_FullSynthetics then
    begin
      mMemo := frKnife.FindObject('mAngleTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mAngle') as TfrxMemoView;
      mMemo.Visible := False;
    end;

    mMemo := frKnife.FindObject('mAngleTitle') as TfrxMemoView;
      mMemo := frKnife.FindObject('mGrossAreaTitle') as TfrxMemoView;
    //Move Angle column left
    if (frKnife.FindObject('mAngleTitle') as TfrxMemoView).Visible and
      not (frKnife.FindObject('mGrossAreaTitle') as TfrxMemoView).Visible then
    begin
      mMemo := frKnife.FindObject('mAngleTitle') as TfrxMemoView;
      mMemo.Left := 100;
      mMemo := frKnife.FindObject('mAngle') as TfrxMemoView;
      mMemo.Left := 100;
    end;

    if not Option_LegacySynthetics then
    begin
      mMemo := frKnife.FindObject('mCutGapTitle') as TfrxMemoView;
      mMemo.Visible := False;
      mMemo := frKnife.FindObject('mCutGap') as TfrxMemoView;
      mMemo.Visible := False;
    end;

    mMemo := frKnife.FindObject('mCutsLRTitle') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mCutsLR') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mThinTitle') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mThin') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mPunchesTitle') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mPunches') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mBandsTitle') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mBands') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mMarksTitle') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mMarks') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mClearsTitle') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;
    mMemo := frKnife.FindObject('mClears') as TfrxMemoView;
    mMemo.Visible := Option_CuttingTimes;

    frKnife.PrintOptions.PrintMode := pmScale;
    frKnife.PrintOptions.PrintOnSheet := GetPaperSize;
    frKnife.PrepareReport;
    frKnife.PrintOptions.ShowDialog := not GroupPrinting;
    if ((Sender as TSpeedButton) = btnPrintPreview) then
      frKnife.ShowPreparedReport
    else
      PrintingCancelled := not frKnife.Print;

    btnPrint.Enabled := True;
    btnPrintPreview.Enabled := True;
  end;

  if ForceRedraw then
    CaptionHintsAndPicture;
end;


procedure TfmKnifeSetDetails.btnCopyClick(Sender: TObject);
begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    fmCopyKnife.BaseCode := KnifeCode;
    fmCopyKnife.ShowModal;
  end;
end;

procedure TfmKnifeSetDetails.btnWhereUsedClick(Sender: TObject);
var
  Failed: boolean;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Where Used for Knife', KnifeCode) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmKnivesWhereUsed := TfmKnivesWhereUsed.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmKnivesWhereUsed.PassKnifeName(KnifeCode);
    end;
  end;
end;

procedure TfmKnifeSetDetails.UpdateScreen(Editing: boolean);
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
  btnPrintKnifeRealSize.Visible := not ManualEntry;
  btnPrintKnifeRealSize.Enabled := not Editing;
  btnCopy.enabled := not Editing;
  btnWhereUsed.enabled := not Editing;

  btnAddSize.Enabled := Editing;
  btnRemoveSize.Enabled := Editing;
  btnReassess.Visible := ShowReassessButton;
  btnReassess.Enabled := Editing;

  btnAngle.Visible := Option_FullSynthetics and (not ManualEntry) and Editing;

  pnlCutting.Enabled := Editing; //Stops Clicking on Labels of Tick boxes
  pnlView1.visible := not Editing;
  pnlView2.visible := not Editing;
  pnlView3.visible := not Editing;
  pnlView3a.visible := not Editing;
  if Option_CuttingTimes then
    pnlView4.visible := not Editing;
  if ManualEntry then
    pnlView9.visible := not Editing;

  if Editing then
  begin
    dbeDescription.setfocus;
    if ManualEntry then
    begin
      //Move the 'implied' focus back
      //to the 1st column in the grid
      if dbgManualKnives.enabled then
      begin
        TStringGrid(dbgManualKnives).Col := 1;
        TStringGrid(dbgManualKnives).setfocus;
      end;
    end;
  end
  else if fmKnifeSetDetails.Enabled then       //this if required to prevent 'Cannot focus...' error when group printing.
    tbMain.setfocus;

  SetTabStops(Editing);
end;

procedure TfmKnifeSetDetails.tblKnifeSetsAfterOpen(DataSet: TDataSet);
begin
  tblKnifeSets.setRange([KnifeCode], [KnifeCode]);

  cbMatCat.DataField := '';
  cbMatCat.Items.Add(tblKnifeSetsType.value);
  cbMatCat.DataField := 'Type';
end;

procedure TfmKnifeSetDetails.cbMatCatDropDown(Sender: TObject);
var
  AddThisOne: Boolean;

begin
  screen.cursor := crHourGlass;

  if not qMatCats.active then
  begin
    qMatCats.open;

    //Load list box
    cbMatCat.DataField := '';
    cbMatCat.Items.Clear;
    qMatCats.RecNo := 1; //CJY changed from qMatCats.First
    qMatCats.Prior; //CJY changed from qMatCats.First
    while not qMatCats.eof do
    begin
      AddThisOne := True;

      if (not Option_Leather) and ((qMatCatsCode.value = 'P') or (qMatCatsCode.value = 'N')) then
        AddThisOne := False;
      if (not Option_Synthetics) and (qMatCatsCode.value = 'S') then
        AddThisOne := False;

      if AddThisOne then
        cbMatCat.Items.Add(qMatCatsCode.value);
      qMatCats.next;
    end;

    cbMatCat.DataField := 'Type';
  end;

  screen.cursor := crDefault;
end;

procedure TfmKnifeSetDetails.tblKnifeSetsCalcFields(DataSet: TDataSet);
begin
  if tblKnifeSetsType.value = 'N' then
    tblKnifeSetsMaterialType.value := 'Non Prime'
  else if tblKnifeSetsType.value = 'P' then
    tblKnifeSetsMaterialType.value := 'Prime'
  else if tblKnifeSetsType.value = 'S' then
    tblKnifeSetsMaterialType.value := 'Synthetic';

  if tblKnifeSetsDoubleSided.value then
    tblKnifeSetsCutsLRYesNo.value := 'Yes'
  else
    tblKnifeSetsCutsLRYesNo.value := 'No';

  if tblKnifeSetsThin.value then
    tblKnifeSetsThinsYesNo.value := 'Yes'
  else
    tblKnifeSetsThinsYesNo.value := 'No';
end;

procedure TfmKnifeSetDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmKnifeSetDetails.CaptionHintsAndPicture;
var
  SecondProcess: KnifePictureThread;

begin
  if not ManualEntry then
    ViewPattern;

  //Used to use a thread. However this now gives missing pictures
  //seemingly at random at in an illogical way on some PCs - works
  //on others. Thread removed and problem went away.

{
  //Start Thread to draw knife pictures
  if not ManualEntry and not SecondProcessInUse then
  begin
    ViewPattern;

    SecondProcessInUse := True;
    UpdateScreen(False);

    SecondProcess := KnifePictureThread.Create(true);
    SecondProcess.Priority := tpHighest;
    SecondProcess.FreeOnTerminate := True;
    SecondProcess.OnTerminate := FinishSecondProcess;
    SecondProcess.PassDetails(fmKnifeSetDetails);
    SecondProcess.Resume;
  end;}
end;

procedure TfmKnifeSetDetails.FinishSecondProcess(Sender: TObject);
begin
  SecondProcessInUse := False;
  UpdateScreen(False);
end;

procedure TfmKnifeSetDetails.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not SecondProcessInUse;

  if SecondProcessInUse then
    messagedlg('Cannot close whilst drawing pictures', mtInformation, [mbOk], 0);
end;

procedure TfmKnifeSetDetails.dbtSizeScaleDblClick(Sender: TObject);
var
  fmSizeScaleDetails: TfmSizeScaleDetails;
  Code : string;
  Failed : boolean;

begin
  Code := tblKnifeSetsSizeScale.value;

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

procedure TfmKnifeSetDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
  cbMatCat.TabStop := Editing;
  dbcbCutGap.TabStop := Editing;
  dbcbDoubleSided.TabStop := Editing;
  dbcbThin.TabStop := Editing;
  dbePieces.TabStop := Editing;
  dbePeels.TabStop := Editing;
  dbeBands.TabStop := Editing;
  dbeMarks.TabStop := Editing;
  dbeClears.TabStop := Editing;
end;

procedure TfmKnifeSetDetails.btnAddSizeClick(Sender: TObject);
var
  Failed: boolean;
  SSSV: string;
  i, j: smallint;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    btnAddSize.Enabled :=False;
    btnRemoveSize.Enabled :=False;

    Failed := false;

    if DirectoryExists(CADDirectory) then
      dlgOpenPatternFile.InitialDir := CADDirectory
    else
    begin
      messagedlg('Parameters | Pattern File directory does not exist', mtInformation, [mbOK], 0);
      dlgOpenPatternFile.InitialDir := ExtractFileDrive(Application.EXEName);
    end;

    dlgOpenPatternFile.FileName := '';
    if (dlgOpenPatternFile.Execute) then
    begin
      try
        fmKnifeImport := TfmKnifeImport.create(fmKnifeSetDetails);    //to make import screen close when knife does
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;
      if not Failed then
      begin
        fmKnifeImport.PassKnifeInfo(dlgOpenPatternFile.FileName, KnifeCode, tblKnifeSetsSizeScale.value, fmKnifeSetDetails, 'Set');

        if not qSizeScaleSizes.active then
        begin
          qSizeScaleSizes.ParamByName('SizeScale').value := tblKnifeSetsSizeScale.value;
          qSizeScaleSizes.open;
        end;

        //Load list box
        AvailableSizes.Clear;
        qSizeScaleSizes.RecNo := 1; //CJY changed from qSizeScaleSizes.First
        qSizeScaleSizes.Prior; //CJY changed from qSizeScaleSizes.First
        while not qSizeScaleSizes.eof do
        begin
          SSSV := qSizeScaleSizesSize.value;
          for i := 1 to sgKnives.RowCount - 1 do
            if SSSV = sgKnives.Cells[0, i] then
              SSSV := '';

          if not(SSSV = '') then
            AvailableSizes.Add(qSizeScaleSizesSize.value);
          qSizeScaleSizes.next;
        end;
      end
      else
      begin
        btnAddSize.Enabled := True;
        btnRemoveSize.Enabled := True;
      end;
    end
    else
    begin
      btnAddSize.Enabled := True;
      btnRemoveSize.Enabled := True;
    end;

    //Can't change angles if adding/removing knives
    CanChangeAngle := False;
  end;
end;

procedure TfmKnifeSetDetails.UpdateKnivesGrid;
var
  i, r: integer;
  s: string;

begin
  r := sgKnives.Row;

  ShowReassessButton := False;
  MarkedForReassessment := False;

  if tblKnives.active then
  begin
    sgKnives.OnSelectCell := nil;

    sgKnives.RowCount := 2;
    sgKnives.Cells[0, 1] := '';
    sgKnives.Cells[1, 1] := '';
    sgKnives.Cells[2, 1] := '';
    sgKnives.Cells[3, 1] := '';
    sgKnives.Cells[4, 1] := '';
    sgKnives.Cells[5, 1] := '';
    sgKnives.Cells[6, 1] := '';

    dbcbCutGap.Enabled := True;

    tblKnives.Refresh;
    if tblKnives.RecordCount > 0 then
    begin
      i := 0;
      tblKnives.RecNo := 1;
      tblKnives.Prior;
      while not tblKnives.eof do
      begin
        inc(i);
        if i > 1 then
           sgKnives.RowCount := sgKnives.RowCount + 1;
        sgKnives.Cells[0, i] := tblKnivesMeasuredSize.value;
        str(tblKnivesGrossArea.value : 8 : 3, s);
        sgKnives.Cells[1, i] := s;
        str(tblKnivesNettArea.value : 8 : 3, s);
        sgKnives.Cells[2, i] := s;
        str(tblKnivesInterlockArea.value : 8 : 3, s);
        sgKnives.Cells[3, i] := s;
        if tblKnivesToBeAssessed.Value then
          s := 'No'
        else
        begin
          if tblKnivesAssessedVersion.value <> 80 then
          begin
            s := 'Yes (pre 8)';
            if (Option_Leather or Option_LegacySynthetics) then
              ShowReassessButton := True;
          end
          else
            s := 'Yes';
          if tblKnifeSetsManualEntry.value then   //Cutgap cannot be edited once any assess has been done
            s := 'N/A'
          else
            dbcbCutGap.Enabled := false;
        end;

        sgKnives.Cells[4, i] := s;
        str(tblKnivesAngle.value : 8 : 1, s);
        sgKnives.Cells[5, i] := s;
        sgKnives.Cells[6, i] := '';
        tblKnives.next;
      end;

      sgKnives.RowCount := sgKnives.RowCount + 1; //Set here so that when Row changes below it triggers OnSelectCell -
      sgKnives.Row := sgKnives.RowCount - 1;      //have had to contrive this addition of a row because if I use row 0
                                                  //it adds a second copied line of titles because row 0 is unselectable.
      sgKnives.OnSelectCell := sgKnivesSelectCell;

      tblKnives.RecNo := 1;
      tblKnives.Prior;

      if RowNo > sgKnives.RowCount - 1 then
        RowNo := sgKnives.RowCount - 1;
      sgKnives.Row := RowNo;
      KnifeSize := sgKnives.Cells[0, RowNo];
      sgKnives.RowCount := sgKnives.RowCount - 1;  //removes additional row.
    end;
  end;

  if (r < sgKnives.RowCount) then
    sgKnives.Row := r;
end;

procedure TfmKnifeSetDetails.sgKnivesDblClick(Sender: TObject);
var
  GridSelect: TGridRect;

begin
  //CJY Replaces single cell selection with full row selection if editing is disabled
//  if  sgKnives.Options * [goEditing] = [] then
//  begin
//    GridSelect := sgKnives.Selection;
//    GridSelect.Left := 0;
//    GridSelect.Right := sgKnives.ColCount - 1;
//    sgKnives.Selection := GridSelect;
//  end;
end;

procedure TfmKnifeSetDetails.sgKnivesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if not tblKnifeSets.IsEmpty then
    if not tblKnifeSetsManualEntry.value then
    begin
      if (ACol > -1) and (ARow > 0) then
        KnifeSize := sgKnives.Cells[0, ARow];
    end;

  CaptionHintsandPicture;
end;

procedure TfmKnifeSetDetails.btnPrintKnifeRealSizeClick(Sender: TObject);
var
	KnifePic: TfrxPictureView;
  Knife: TPointArray;
  ReportPage: TfrxReportPage;
  myPrinter: TPrinter;
  myPrinterDialog: TPrintDialog;
  paperx, papery: extended;
//  Device: array[0..cchDevicename - 1] of Char;
  Device: array[0..1000 - 1] of Char;  //Above not big enough for SOME printers in 64 bit version
  Driver: array[0..(MAX_PATH) - 1] of Char;
  Port: array[0..32] of Char;
  hDMode: THandle;
  pDMode: PDevMode;

  OriginalPaperSize: smallint;
  PageSizeSelected: Boolean;
  CentreImage: Boolean;
  PrintCanceled: Boolean;
  sStill: string;
  ppmm: real;

begin
  frKnifePrint.ReportOptions.Name := 'Preview ' + 'Whole ' + Caption;
  ClosePreviewForm('Whole ' + Caption);

  btnPrintKnifeRealSize.Enabled := False;

	tblKnifeSets.refresh;
  if tblKnifeSets.recordcount = 0 then
  begin
    messagedlg('Knife' + KnifeCode + ' has been deleted', mtInformation, [mbOk], 0);
    close;
  end
  else
  begin
 		ReportPage := TfrxReportPage(frKnifePrint.Pages[1]);
  	ReportPage.Orientation := poPortrait;
    CentreImage := True;

    ppmm := screen.pixelsperinch / 25.4; //pixels per mm

  	HullPerimeter := DisplayPatternRealSize(KnifeCode, KnifeSizeScale, sgKnives.Cells[0, sgKnives.Row], clHide, clCut, Knife, tblKnivesAngle.value, imgPrint);

    //CJY - User actions to check for
    PageSizeSelected := false;
    PrintCanceled := false;
    sStill := '';

    //Adjust Papersize to that of default printer if there is one
    //CJY - Use the existing global Printer
//    myPrinter := TPrinter.Create;
//    myPrinter := Printer;
    Printer.Refresh;
    Printer.GetPrinter(Device, Driver, Port, hDMode);

    if (hDMode <> 0) then
    begin
      pDMode := GlobalLock(hDMode);
      if pDMode <> nil then
        OriginalPaperSize := pDMode^.dmPaperSize;
    end;

    repeat
      Printer.Refresh;
      Printer.GetPrinter(Device, Driver, Port, hDMode);

      if (hDMode <> 0) then
      begin
        pDMode := GlobalLock(hDMode);
        if pDMode <> nil then
          ReportPage.PaperSize := pDMode^.dmPaperSize;
      end;

      paperx := (ReportPage.PaperWidth - (ReportPage.LeftMargin + ReportPage.RightMargin)) * ppmm;
      papery := (ReportPage.PaperHeight - (ReportPage.TopMargin + ReportPage.BottomMargin)) * ppmm;

      //CJY - this conditional logic seemed wrong to me! Alternate version is
      //      If it doesn't fit this way and will fit that way then bother.
//      Rotate paper if one of sides doesn't for so may fit on orientated paper.
//      Don't' bother if both don't fit as it can't make a difference.
//      if ((imgPrint.width > paperx) and (imgPrint.height <= papery) or
//          (imgPrint.height > papery) and (imgPrint.width <= paperx)) then
      if ((imgPrint.width > paperx) or (imgPrint.height > papery)) and
         ((imgPrint.width <= papery) and (imgPrint.height <= paperx)) then
      begin
        ReportPage.Orientation := poLandscape;

        paperx := (ReportPage.PaperWidth - (ReportPage. LeftMargin + ReportPage.RightMargin)) * ppmm;
        papery := (ReportPage.PaperHeight - (ReportPage.TopMargin + ReportPage.BottomMargin)) * ppmm;
      end;

      if (imgPrint.width > paperx) or (imgPrint.height > papery) then
      begin
        //CJY - Ask user to select bigger paper or ignore paper issue
        //      PageSize can only be selected if it fits or user ignores size issue
        case MessageDlg('Knife is ' + sStill + 'too big for paper size and/or will print in margin area.' + sLineBreak + sLineBreak + 'Select a larger paper size.', mtWarning, [mbIgnore, mbOK, mbCancel], 0) of
          mrIgnore:
          begin
            PageSizeSelected := True;
            CentreImage := False;
          end;
          mrCancel:
            PrintCanceled := True;
          mrOK:
          begin
            myPrinterDialog := TPrintDialog.Create(self);
            try
              myPrinterDialog.Execute;
              sStill := 'still ';
            finally
              myPrinterDialog.Free;
            end;
          end;
        end;
      end
      else
      begin
        PageSizeSelected := True;
      end;
      //CJY - Try again if nothing has been selected.
    until PageSizeSelected or PrintCanceled;

//    myPrinter.Free;
    Printer.Refresh;

    if not PrintCanceled then
    begin
      KnifePic := frKnifePrint.FindObject('pKnife') as TfrxPictureView;
      KnifePic.Picture.Bitmap := imgPrint.Picture.Bitmap;
      KnifePic.Visible := true;

      if CentreImage then
      begin
        KnifePic.Top := round((papery / 2) - (imgPrint.Height div 2));
        KnifePic.Left := round((paperx / 2) - (imgPrint.Width div 2));
      end
      else
      begin
        KnifePic.Top := 0;
        KnifePic.Left := 0;
      end;

      frKnifePrint.PrintOptions.PrintMode := pmSplit;
      frKnifePrint.PrintOptions.PrintOnSheet := ReportPage.PaperSize;
      frKnifePrint.PrepareReport;
      frKnifePrint.ShowPreparedReport;
    end;

    btnPrintKnifeRealSize.Enabled := True;

    //CJY - Attempt to rest the page size to default, doesn't seem to work
    pDMode^.dmPaperSize := OriginalPaperSize;
    GlobalUnlock(hDMode);
    Printer.SetPrinter(Device, Driver, Port, hDMode);
  end;
end;

procedure TfmKnifeSetDetails.btnRemoveSizeClick(Sender: TObject);
var
  i: integer;
  s: string;
  CanDelete, DeleteLayplans: boolean;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    RowNo := sgKnives.Row;
    KnifeSize := sgKnives.Cells[0, RowNo];

    qCheckForLayplansPerSize.ParamByName('KnifeCode').Value := KnifeCode;
    qCheckForLayplansPerSize.ParamByName('KnifeSizeScale').Value := KnifeSizeScale;
    qCheckForLayplansPerSize.ParamByName('KnifeSize').Value := KnifeSize;
    qCheckForLayplansPerSize.open;

    if qCheckForLayplansPerSizeNoLayplans.Value > 0 then
    begin
      s := 'Delete Knife and its associated ' + intToStr(qCheckForLayplansPerSizeNoLayplans.Value) + ' layplan(s)?';
      DeleteLayplans := True;
    end
    else
    begin
      s := 'Delete Knife?';
      DeleteLayplans := False;
    end;
    qCheckForLayplansPerSize.close;

    CanDelete := (messagedlg(s , mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if CanDelete then
    begin
      try
        if DeleteLayplans then
        begin
          qDeleteLayplans.ParamByName('KnifeCode').Value := KnifeCode;
          qDeleteLayplans.ExecSQL;
        end;
        tblKnives.IndexName := 'PRIMARY';
        if tblKnives.FindKey([KnifeCode, KnifeSizeScale, KnifeSize]) then
          tblKnives.Delete;
        tblKnives.IndexName := 'CODESEQ';

        if (RowNo > 1) or (sgKnives.RowCount > 2) then
        begin
          sgKnives.RowCount := sgKnives.RowCount - 1;
          for i := RowNo to sgKnives.RowCount - 1 do
            sgKnives.Rows[i] := sgKnives.Rows[i + 1];
          if RowNo > sgKnives.RowCount - 1 then
            RowNo := sgKnives.RowCount - 1;
          sgKnives.Row := RowNo;
          KnifeSize := sgKnives.Cells[0, RowNo];
        end
        else
          for i := 0 to sgKnives.ColCount - 1 do
            sgKnives.Cells[i, 1] := '';

//CJY Suspected issue, changing index whilst in edit mode
//        tblKnives.Edit;
      except
        on E: Exception do
        begin
          fmErrorHandler.DebugMessageDlg('Knife in use', E.Message, '');
          CanDelete := false;
        end;
      end;
    end;

    //Can't change angles if adding/removing knives
    CanChangeAngle := False;
  end;
end;

procedure TfmKnifeSetDetails.tblKnivesCalcFields(DataSet: TDataSet);
var
  Ver: string;

begin
  if tblKnifeSetsType.Value = 'N' then
    tblKnivesInterlockArea.Value := tblKnivesInterlockAreaNonPrime.Value
  else
    tblKnivesInterlockArea.Value := tblKnivesInterlockAreaPrimeSynthetic.Value;

  if tblKnivesToBeAssessed.Value then
    tblKnivesAssessed.Value := 'No'
  else
    tblKnivesAssessed.Value := 'Yes';

  if tblKnivesToBeAssessed.Value then
    Ver := ''
  else
  begin
    if tblKnivesAssessedVersion.value = 6 then
      Ver := ' (6)'
    else if tblKnivesAssessedVersion.value = 7 then
      Ver := ' (7.0)';
  end;

  if tblKnifeSetsManualEntry.value then   
    tblKnivesAssessedPlusVersion.Value := 'N/A'
  else
    tblKnivesAssessedPlusVersion.Value := tblKnivesAssessed.Value + Ver;
end;

procedure TfmKnifeSetDetails.dbeMatCatChange(Sender: TObject);
begin
  //Show Knife details for Leather knives or all knives if
  //Legacy Synthetics set because if that case all knives
  //will need to be assessed. Also Manuual Knives need all
  //the details
  if tblKnifeSetsManualEntry.Value or (tblKnifeSetsType.value <> 'S') or Option_LegacySynthetics then
  begin
    sgKnives.Columns[1].Width := 70;
    sgKnives.Columns[2].Width := 70;
    sgKnives.Columns[3].Width := 70;
    sgKnives.Columns[4].Width := 70;
    sgKnives.Columns[5].Width := -1;
  end
  else
  begin
    sgKnives.Columns[1].Width := -1;
    sgKnives.Columns[2].Width := -1;
    sgKnives.Columns[3].Width := -1;
    sgKnives.Columns[4].Width := -1;
    sgKnives.Columns[5].Width := -1;
    fmKnifeSetDetails.Width := FormWidth - 157;
  end;

  if Option_FullSynthetics then
    sgKnives.Columns[5].Width := 40;
end;

procedure TfmKnifeSetDetails.tblKnivesBeforePost(DataSet: TDataSet);
begin
  if ManualEntry then
  begin
    if not tblSizeScaleSizes.Active then
      tblSizeScaleSizes.Open;

    //CJY: NewValue and Value replaced by Value and OldValue respectively
//    if tblSizeScaleSizes.FindKey([tblKnifeSetsSizeScale.Value, tblKnivesMeasuredSize.NewValue]) then
    if tblSizeScaleSizes.FindKey([tblKnifeSetsSizeScale.Value, tblKnivesMeasuredSize.Value]) then
    begin
      tblKnivesCode.Value := tblKnifeSetsCode.Value;
      tblKnivesSizeScale.Value := tblKnifeSetsSizeScale.Value;
      tblKnivesToBeAssessed.Value := False;
      tblKnivesSeq.Value := tblSizeScaleSizesSeq.Value;
    end
    else
    begin
      messagedlg('Invalid Size', mtInformation, [mbOK], 0);
      abort;
    end;
  end;
end;

function TfmKnifeSetDetails.ReadInterlock(KnifeSizeToUse: string): Boolean;
var
  i: integer;

begin
  //Pieces...
  qInterlocks.ParamByName('KnifeCode').value := KnifeCode;
  qInterlocks.ParamByName('KnifeSizeScale').value := KnifeSizeScale;
  qInterlocks.ParamByName('KnifeSize').value := KnifeSizeToUse;
  qInterlocks.Open;

  SetLength(LocalCutResults, 0);
  i := 0;
  while not qInterlocks.eof do
  begin
    inc(i);
    SetLength(LocalCutResults, i);

    LocalCutResults[i - 1].KnifeNo := 1;
    LocalCutResults[i - 1].W2 := qInterlocksW2.Value;
    LocalCutResults[i - 1].Ghost := qInterlocksGhost.Value;
    LocalCutResults[i - 1].BoundingRect.Left := qInterlocksBR_Left.Value;
    LocalCutResults[i - 1].BoundingRect.Top := qInterlocksBR_Top.Value;
    LocalCutResults[i - 1].BoundingRect.Right := qInterlocksBR_Right.Value;
    LocalCutResults[i - 1].BoundingRect.Bottom := qInterlocksBR_Bottom.Value;
    LocalCutResults[i - 1].Colour := 0;

    qInterlocks.Next;
  end;

  qInterlocks.Close;

  //...then Knives used
  qInterlockKnives.ParamByName('KnifeCode').value := KnifeCode;
  qInterlockKnives.ParamByName('KnifeSizeScale').value := KnifeSizeScale;
  qInterlockKnives.ParamByName('KnifeSize').value := KnifeSizeToUse;
  qInterlockKnives.Open;

  SetLength(LocalKnivesUsed, 1);
  SetLength(LocalKnivesUsed[0, 0].PatternPoints, 0);
  SetLength(LocalKnivesUsed[0, 1].PatternPoints, 0);
  SetLength(LocalKnivesUsed[0, 0].ExpandedPoints, 0);
  SetLength(LocalKnivesUsed[0, 1].ExpandedPoints, 0);

  qInterlockKnives.Filter := '(RealNotExpanded = TRUE) AND (W2 = FALSE)';
  i := 0;
  qInterlockKnives.RecNo := 1; //CJY changed from qInterlockKnives.First
  qInterlockKnives.Prior; //CJY changed from qInterlockKnives.First
  while not qInterlockKnives.eof do
  begin
    inc(i);
    SetLength(LocalKnivesUsed[0, 0].PatternPoints, i);

    LocalKnivesUsed[0, 0].PatternPoints[i - 1].X := qInterlockKnivesX.value;
    LocalKnivesUsed[0, 0].PatternPoints[i - 1].Y := qInterlockKnivesY.value;

    qInterlockKnives.Next;
  end;

  qInterlockKnives.Filter := '(RealNotExpanded = TRUE) AND (W2 = TRUE)';
  i := 0;
  qInterlockKnives.RecNo := 1; //CJY changed from qInterlockKnives.First
  qInterlockKnives.Prior; //CJY changed from qInterlockKnives.First
  while not qInterlockKnives.eof do
  begin
    inc(i);
    SetLength(LocalKnivesUsed[0, 1].PatternPoints, i);

    LocalKnivesUsed[0, 1].PatternPoints[i - 1].X := qInterlockKnivesX.value;
    LocalKnivesUsed[0, 1].PatternPoints[i - 1].Y := qInterlockKnivesY.value;

    qInterlockKnives.Next;
  end;

  qInterlockKnives.Filter := '(RealNotExpanded = FALSE) AND (W2 = FALSE)';
  i := 0;
  qInterlockKnives.RecNo := 1; //CJY changed from qInterlockKnives.First
  qInterlockKnives.Prior; //CJY changed from qInterlockKnives.First
  while not qInterlockKnives.eof do
  begin
    inc(i);
    SetLength(LocalKnivesUsed[0, 0].ExpandedPoints, i);

    LocalKnivesUsed[0, 0].ExpandedPoints[i - 1].X := qInterlockKnivesX.value;
    LocalKnivesUsed[0, 0].ExpandedPoints[i - 1].Y := qInterlockKnivesY.value;

    qInterlockKnives.Next;
  end;

  qInterlockKnives.Filter := '(RealNotExpanded = FALSE) AND (W2 = TRUE)';
  i := 0;
  qInterlockKnives.RecNo := 1; //CJY changed from qInterlockKnives.First
  qInterlockKnives.Prior; //CJY changed from qInterlockKnives.First
  while not qInterlockKnives.eof do
  begin
    inc(i);
    SetLength(LocalKnivesUsed[0, 1].ExpandedPoints, i);

    LocalKnivesUsed[0, 1].ExpandedPoints[i - 1].X := qInterlockKnivesX.value;
    LocalKnivesUsed[0, 1].ExpandedPoints[i - 1].Y := qInterlockKnivesY.value;

    qInterlockKnives.Next;
  end;

  qInterlockKnives.Close;

  Result := (Length(LocalCutResults) > 0);
end;

procedure TfmKnifeSetDetails.DisplayInterlock(img: TImage);
var
  ClipRect: TRect;
  bmpResults: TBitmap;
  i, minx, miny, maxx, maxy: integer;
  InterlockHeight, InterlockWidth, InterlockXOffset, InterlockYOffset: integer;
  SquareSize: integer;
  BigSquareSize: real;
  ExtraHeightOffset, ExtraWidthOffset: integer;

begin
  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;

  for i := 0 to Length(LocalCutResults) - 1 do
  begin
    if LocalCutResults[i].BoundingRect.Left < minx then
      minx := LocalCutResults[i].BoundingRect.Left;
    if LocalCutResults[i].BoundingRect.Top < miny then
      miny := LocalCutResults[i].BoundingRect.Top;
    if LocalCutResults[i].BoundingRect.Right > maxx then
      maxx := LocalCutResults[i].BoundingRect.Right;
    if LocalCutResults[i].BoundingRect.Bottom > maxy then
      maxy := LocalCutResults[i].BoundingRect.Bottom;
  end;

  ClipRect.Left := minx;
  ClipRect.Top := miny;
  ClipRect.Right := maxx;
  ClipRect.Bottom := maxy;

  InterlockHeight := ClipRect.Bottom - ClipRect.Top;
  InterlockWidth := ClipRect.Right - ClipRect.Left;
  ExtraHeightOffset := 0;
  ExtraWidthOffset := 0;
  if InterlockHeight < img.Height then
  begin
    ExtraHeightOffset := (img.Height - InterlockHeight) div 2;
    InterlockHeight := img.Height;
  end;
  if InterlockWidth < img.Width then
  begin
    ExtraWidthOffset := (img.Width - InterlockWidth) div 2;
    InterlockWidth := img.Width;
  end;
  SquareSize := max(InterlockHeight, InterlockWidth);
  BigSquareSize := 1.1 * SquareSize;

  InterlockXOffset := 0;
  InterlockYOffset := 0;
  if InterlockHeight > InterlockWidth then
    InterlockXOffset := (InterlockHeight - InterlockWidth) div 2
  else if InterlockWidth > InterlockHeight then
    InterlockYOffset := (InterlockWidth - InterlockHeight) div 2;
  InterlockXOffset := InterlockXOffset + ((round(BigSquareSize) - SquareSize) div 2) + ExtraWidthOffset;
  InterlockYOffset := InterlockYOffset + ((round(BigSquareSize) - SquareSize) div 2) + ExtraHeightOffset;

  bmpResults := TBitmap.Create;
  bmpResults.PixelFormat := pf16bit;
  bmpResults.Height := round(BigSquareSize);
  bmpResults.Width := round(BigSquareSize);

  bmpResults.Canvas.brush.Color := clHide;
  bmpResults.Canvas.FillRect(Rect(0, 0, bmpResults.Width, bmpResults.Height));

  //Change Colours
  LocalCutResults[0].Colour := clCut;
  for i := 1 to Length(LocalCutResults) - 1 do
  begin
    LocalCutResults[i].Colour := clInterlock;
    if LocalCutResults[i].Ghost then
    begin
      LocalCutResults[i].Ghost := False;
      LocalCutResults[i].Colour := clGhost;
    end;
  end;

  LocalDrawResults(bmpResults.Canvas, InterlockXOffset, InterlockYOffset);

  img.Visible := False;
  img.Picture.Bitmap := bmpResults;
  img.Visible := True;

  bmpResults.Free;
end;

procedure TfmKnifeSetDetails.btnReassessClick(Sender: TObject);
var
  i: integer;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if messagedlg('Reassess knife?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      MarkedForReAssessment := True;
      for i := 1 to sgKnives.RowCount do
      begin
        if sgKnives.Cells[4, i] <> 'No' then
          sgKnives.Cells[4, i] := 'Reassess';
      end;
    end;
  end;
end;

procedure TfmKnifeSetDetails.LocalDrawResults(Canvas: TCanvas; XOffset, YOffset: integer);
var
  i, j: integer;
  xy: TPointArray;
  Pattern: TPattern;

begin
  //Routine is a cut Down Version of DrawResults from unit Results
  //Uses Local versions of CutResults and KnivesUsed

  Canvas.Pen.Width := 1;

  //Points
  for i := 0 to Length(LocalCutResults) - 1 do
  begin
    if (yOffset + LocalCutResults[i].BoundingRect.Bottom) > 0 then
    begin
      //Select knife
      if not LocalCutResults[i].W2 then
        Pattern := LocalKnivesUsed[LocalCutResults[i].KnifeNo - 1, 0]
      else
        Pattern := LocalKnivesUsed[LocalCutResults[i].KnifeNo - 1, 1];

      SetLength(xy, Length(Pattern.PatternPoints));
      for j := 0 to Length(Pattern.PatternPoints) - 1 do
      begin
        xy[j].x := XOffset + (LocalCutResults[i].BoundingRect.Left + round(Pattern.PatternPoints[j].x));
        xy[j].y := YOffset + (LocalCutResults[i].BoundingRect.Top + round(Pattern.PatternPoints[j].y));
      end;

      Canvas.Pen.Color := LocalCutResults[i].Colour;
      Canvas.Brush.Color := LocalCutResults[i].Colour;
      Canvas.Polygon(xy);
    end;
  end;
end;

function TfmKnifeSetDetails.DisplayPatternRealSize(Code, Scale, Size: String;
  clBackground, clPattern: integer; var KnifeIn: TPointArray;
  RotationAngle: Real; imgPattern: TImage): Real;
var
  minx, miny, maxx, maxy: integer;
  i, width, height: integer;
  ppi: real;
  Picture: TPointArray;
  Hull: TPolygon2D;
  HullPerim: Real;

begin
  qPatterns.ParamByName('KnifeCode').value := Code;
  qPatterns.ParamByName('KnifeSizeScale').value := Scale;
  qPatterns.ParamByName('MeasuredSize').value := Size;
  qPatterns.open;

  SetLength(KnifeIn, 0);

  //Read Pattern
  qPatterns.RecNo := 1; //CJY changed from qPatterns.First
  qPatterns.Prior; //CJY changed from qPatterns.First
  while not qPatterns.eof do
  begin
    SetLength(KnifeIn, Length(KnifeIn) + 1);
    KnifeIn[Length(KnifeIn) - 1].X := qPatternsX.Value;
    KnifeIn[Length(KnifeIn) - 1].Y := qPatternsY.Value;
    qPatterns.Next;
  end;

  //Add last point
  SetLength(KnifeIn, Length(KnifeIn) + 1);
  KnifeIn[Length(KnifeIn) - 1].X := KnifeIn[0].X;
  KnifeIn[Length(KnifeIn) - 1].Y := KnifeIn[0].Y;

  if RotationAngle <> 0 then
    RotatePattern(RotationAngle, KnifeIn);

  //find the most outer points of the shape
  maxx := -999999;
  maxy := -999999;
  minx := 999999;
  miny := 999999;

  for i := 0 to Length(KnifeIn) - 1 do
  begin
    if KnifeIn[i].X < minx then
    	minx := round(KnifeIn[i].X);
    if KnifeIn[i].Y < miny then
    	miny := round(KnifeIn[i].Y);
    if KnifeIn[i].X > maxx then
    	maxx := round(KnifeIn[i].X);
    if KnifeIn[i].Y > maxy then
     	maxy := round(KnifeIn[i].Y);
  end;

  //translate minx and miny to 0,0
  for i := 0 to Length(KnifeIn) - 1 do
  begin
  	KnifeIn[i].X := KnifeIn[i].X - minx;
  	KnifeIn[i].Y := KnifeIn[i].Y - miny;
  end;

  ppi := screen.pixelsperinch / 1000; //pixels per inch as 000's of an inch (like the knife)




  Hull := MakeConvexHull(KnifeIn);
  HullPerim := Perimeter(Hull) / 1000 / 12; //In feet







  //get image box dimensions and multiply it by factor to get correct image box size
  //multiply by ppi to get exact tight box around the shape
  //+ 2 to give a 1 pixel margin around
 	height := round(maxy - miny);
  width := round(maxx - minx);
  imgPattern.height := round(height * ppi) + 2;
  imgPattern.Width := round(width * ppi) + 2;
  imgPattern.Picture.Bitmap := nil;

  SetLength(Picture, Length(KnifeIn));
  //Draw Knife
  for i := 0 to Length(Picture) - 1 do
  begin
    //+ 1 to offset by 1 pixel, leaving edge of 1 pixel all around
    Picture[i].x := round((KnifeIn[i].X) * ppi) + 1;
    Picture[i].y := imgPattern.height - (round((KnifeIn[i].Y) * ppi) + 1);
  end;

  imgPattern.Canvas.pen.width := 2;
  imgPattern.Canvas.pen.Color := clPattern;
  imgPattern.Canvas.Polyline(Picture);

  qPatterns.close;

  Result := HullPerim;
end;




function TfmKnifeSetDetails.MakeConvexHull(Points: TPointArray): TPolygon2D;
var
  Hull: TPolygon2D;

begin
  //Create Hull and close it
  Hull := CreateConvexHull(ConvertTPointArray_TPoint2DArray(Points));
  SetLength(Hull, length(Hull) + 1);
  Hull[length(Hull) - 1] := Hull[0];

  Result := Hull;
end;


end.

