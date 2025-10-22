program SATRASumm8;

uses
  Windows,
  Forms,
  Dialogs,
  SysUtils,
  Controls,
  iniFiles,
  Summs in 'Summs.pas' {fmSumms},
  Splash in 'Splash.pas' {fmSplashScreen},
  MaterialDetails in 'MaterialDetails.pas' {fmMaterialDetails},
  AllParts in 'AllParts.pas' {fmAllParts},
  AllConstructions in 'AllConstructions.pas' {fmAllConstructions},
  ConstructionDetails in 'ConstructionDetails.pas' {fmConstructionDetails},
  AllKnifeSets in 'AllKnifeSets.pas' {fmAllKnifeSets},
  OpenTicket in 'OpenTicket.pas' {fmOpenTicket},
  AllSizeRelationships in 'AllSizeRelationships.pas' {fmAllSizeRelationships},
  AllSizeRanges in 'AllSizeRanges.pas' {fmAllSizeRanges},
  AllSizeScales in 'AllSizeScales.pas' {fmAllSizeScales},
  AllWidthRanges in 'AllWidthRanges.pas' {fmAllWidthRanges},
  About in 'About.pas' {fmAboutBox},
  CutterNames in 'CutterNames.pas' {fmCutterNames},
  AllSuppliers in 'AllSuppliers.pas' {fmAllSuppliers},
  NewWidthRange in 'NewWidthRange.pas' {fmNewWidthRange},
  OpenWidthRange in 'OpenWidthRange.pas' {fmOpenWidthRange},
  WidthDetails in 'WidthDetails.pas' {fmWidthDetails},
  KnivesToSwap in 'KnivesToSwap.pas' {fmKnivesToSwap},
  SizeRangeDetails in 'SizeRangeDetails.pas' {fmSizeRangeDetails},
  OpenSizeRange in 'OpenSizeRange.pas' {fmOpenSizeRange},
  OpenKnife in 'OpenKnife.pas' {fmOpenKnife},
  KnifeSetDetails in 'KnifeSetDetails.pas' {fmKnifeSetDetails},
  OpenSizeReln in 'OpenSizeReln.pas' {fmOpenSizeRelationship},
  OpenSizeScale in 'OpenSizeScale.pas' {fmOpenSizeScale},
  NewSizeScale in 'NewSizeScale.pas' {fmNewSizeScale},
  ChangePassword in 'ChangePassword.pas' {fmChangePassword},
  NewMaterial in 'NewMaterial.pas' {fmNewMaterial},
  NewPart in 'NewPart.pas' {fmNewPart},
  NewConstruction in 'NewConstruction.pas' {fmNewConstruction},
  NewSupplier in 'NewSupplier.pas' {fmNewSupplier},
  NewTicket in 'NewTicket.pas' {fmNewTicket},
  OpenMaterial in 'OpenMaterial.pas' {fmOpenMaterial},
  OpenPart in 'OpenPart.pas' {fmOpenPart},
  OpenConstruction in 'OpenConstruction.pas' {fmOpenConstruction},
  OpenSupplier in 'OpenSupplier.pas' {fmOpenSupplier},
  SizeScaleDetails in 'SizeScaleDetails.pas' {fmSizeScaleDetails},
  SizeRelationshipDetails in 'SizeRelationshipDetails.pas' {fmSizeRelationshipDetails},
  SizeScaleWhereUsed in 'SizeScaleWhereUsed.pas' {fmSizeScaleWhereUsed},
  SizeRangeWhereUsed in 'SizeRangeWhereUsed.pas' {fmSizeRangeWhereUsed},
  SizeRelationshipWhereUsed in 'SizeRelationshipWhereUsed.pas' {fmSizeRelationshipWhereUsed},
  SupplierDetails in 'SupplierDetails.pas' {fmSupplierDetails},
  SuppliersWhereUsed in 'SuppliersWhereUsed.pas' {fmSupplierWhereUsed},
  MaterialsWhereUsed in 'MaterialsWhereUsed.pas' {fmMaterialWhereUsed},
  KnivesWhereUsed in 'KnivesWhereUsed.pas' {fmKnivesWhereUsed},
  NewKnifeSet in 'NewKnifeSet.pas' {fmNewKnifeSet},
  PartsWhereUsed in 'PartsWhereUsed.pas' {fmPartsWhereUsed},
  WidthRangeWhereUsed in 'WidthRangeWhereUsed.pas' {fmWidthRangeWhereUsed},
  BrowseSizeRanges in 'BrowseSizeRanges.pas' {fmBrowseSizeRanges},
  BrowseSizeRelationships in 'BrowseSizeRelationships.pas' {fmBrowseSizeRelationships},
  BrowseWidthRanges in 'BrowseWidthRanges.pas' {fmBrowseWidthRanges},
  BrowseKnives in 'BrowseKnives.pas' {fmBrowseKnives},
  ImportKnife in 'ImportKnife.pas' {fmKnifeImport},
  MatDflts in 'MatDflts.pas' {fmMaterialDefaults},
  Basicalw in 'Basicalw.pas' {dmBasAll: TDataModule},
  PartAllowance in 'PartAllowance.pas' {fmPartAllowance},
  PartDetails in 'PartDetails.pas' {fmPartDetails},
  BrowseSizeScales in 'BrowseSizeScales.pas' {fmBrowseSizeScales},
  Analyse in 'Analyse.pas' {fmAnalyse},
  Adjfact in 'Adjfact.pas' {dmAdjFact: TDataModule},
  CopyKnife in 'CopyKnife.pas' {fmCopyKnife},
  CopyPart in 'CopyPart.pas' {fmCopyPart},
  CopyMaterial in 'CopyMaterial.pas' {fmCopyMaterial},
  CopyConstruction in 'CopyConstruction.pas' {fmCopyConstruction},
  CopySizeRange in 'CopySizeRange.pas' {fmCopySizeRange},
  CopySizeReln in 'CopySizeReln.pas' {fmCopySizeRelationship},
  CopyWidthRange in 'CopyWidthRange.pas' {fmCopyWidthRange},
  Cututils in '..\..\Common\Cututils.pas' {dmCutUtils: TDataModule},
  Cmntypes in '..\..\Common\Cmntypes.pas',
  Times2 in 'Times2.pas' {dmTimes2: TDataModule},
  SummsVars in 'SummsVars.pas',
  General in '..\..\Common\General.pas',
  ExternalIn in 'ExternalIn.pas' {fmExternalIn},
  SMRate in 'SMRate.pas' {fmSMRateTable},
  Audit in 'Audit.pas' {fmAudit},
  AllCosts in 'AllCosts.pas' {fmAllCosts},
  TktUpdate in 'TktUpdate.pas' {fmTicketUpdate},
  TktBlkUp in 'TktBlkUp.pas' {fmTicketBulkUpdate},
  TicketsNotUpdated in 'TicketsNotUpdated.pas' {fmTicketsNotUpdated},
  SwapKnvs in 'SwapKnvs.pas' {fmSwapKnives},
  NewSizeRange in 'NewSizeRange.pas' {fmNewSizeRange},
  BrowseMaterials in 'BrowseMaterials.pas' {fmBrowseMaterials},
  SyntheticTicketsList in 'SyntheticTicketsList.pas' {fmSyntheticTicketsList},
  ConstructionAllowance in 'ConstructionAllowance.pas' {fmConstructionAllowance},
  NewStyle in 'NewStyle.pas' {fmNewStyle},
  StyleDetails in 'StyleDetails.pas' {fmStyleDetails},
  OpenStyle in 'OpenStyle.pas' {fmOpenStyle},
  AllStyles in 'AllStyles.pas' {fmAllStyles},
  BrowseStyles in 'BrowseStyles.pas' {fmBrowseStyles},
  StylesWhereUsed in 'StylesWhereUsed.pas' {fmStylesWhereUsed},
  CopyStyle in 'CopyStyle.pas' {fmCopyStyle},
  SystemStatus in 'SystemStatus.pas' {fmSystemStatus},
  DirBrowse in '..\..\Common\DirBrowse.pas' {fmBrowseDirectories},
  OutOfMemory in '..\..\Common\OutOfMemory.pas' {fmMemoryError},
  AdvErrorHandler in '..\..\Common\AdvErrorHandler.pas' {fmErrorHandler},
  KnifeDefaults in 'KnifeDefaults.pas' {fmKnifeDefaults},
  SummsThreads in 'SummsThreads.pas',
  CopyPartWidthKnives in 'CopyPartWidthKnives.pas' {fmCopyPartWidthKnives},
  TicketsBreakdown in 'TicketsBreakdown.pas' {fmTicketsBreakdown},
  CopyTicket in 'CopyTicket.pas' {fmCopyTicket},
  TicketsGroupError in 'TicketsGroupError.pas' {fmTicketsGroupError},
  CutterLocations in 'CutterLocations.pas' {fmCutterLocations},
  Times in 'Times.pas' {dmTimes: TDataModule},
  CutUtils2 in '..\..\Common\CutUtils2.pas' {dmCutUtils2: TDataModule},
  TktBlkUpErrors in 'TktBlkUpErrors.pas' {fmTicketBulkUpdateErrors},
  NewSizeReln in 'NewSizeReln.pas' {fmNewSizeRelationship},
  CancelPrinting in '..\..\Common\CancelPrinting.pas' {fmCancelPrinting},
  LockedDialog in '..\..\Common\LockedDialog.pas' {fmLockedDialog},
  AccessDenied in '..\..\Common\AccessDenied.pas' {fmAccessDenied},
  CmnVars in '..\..\Common\CmnVars.pas',
  WidthNames in 'WidthNames.pas' {fmWidthNames},
  AllTickets in 'AllTickets.pas' {fmAllTickets},
  TicketsGroupCreate in 'TicketsGroupCreate.pas' {fmTicketsGroupCreate},
  ImportTimeLineElements in 'ImportTimeLineElements.pas' {fmImportTimeLineElements},
  KnifeSpinner in 'Interlocking\KnifeSpinner.pas' {fmKnifeSpinner},
  AllPatterns in 'Interlocking\AllPatterns.pas' {fmAllPatterns},
  General_Interlocking in 'Interlocking\General_Interlocking.pas',
  FastGEO in 'Interlocking\FastGEO.pas',
  Interlocking in 'Interlocking\Interlocking.pas',
  Expansion in 'Interlocking\Expansion.pas',
  ConvexHull in 'Interlocking\ConvexHull.pas',
  PolygonOverlaps in 'Interlocking\PolygonOverlaps.pas',
  Debugger in 'Interlocking\Debugger.pas' {fmDebugger},
  Results in 'Interlocking\Results.pas',
  Merge in 'Interlocking\Merge.pas',
  PlanIt in 'Interlocking\PlanIt.pas',
  Concavities in 'Interlocking\Concavities.pas',
  Layplanning in 'Layplanning.pas',
  SelectKnifeSize in 'SelectKnifeSize.pas' {fmSelectKnifeSize},
  AllLayplansWithoutSelection in 'Interlocking\AllLayplansWithoutSelection.pas' {fmAllLayplansWithoutSelection},
  Const_Interlocking in 'Interlocking\Const_Interlocking.pas',
  AllSyntheticMaterials in 'Interlocking\AllSyntheticMaterials.pas' {fmAllSyntheticMaterials},
  AllMaterials in 'AllMaterials.pas' {fmAllMaterials},
  BulkAssessKnives in 'BulkAssessKnives.pas' {fmAssessKnives},
  PatternDrawing in 'PatternDrawing.pas' {dmPatternDrawing: TDataModule},
  LegacyCheck in 'LegacyCheck.pas' {fmLegacyCheck},
  Filt in 'Filt.pas',
  ManualKnifeCheck in 'ManualKnifeCheck.pas' {fmManualKnifeCheck},
  KnifeInterlock in 'KnifeInterlock.pas' {fmKnifeOrInterlock},
  BulkLayplan in 'Interlocking\BulkLayplan.pas' {fmBulkLayplan},
  AllLayplans in 'Interlocking\AllLayplans.pas' {fmAllLayplans},
  LayMain in 'Interlocking\LayMain.pas' {fmLayplan},
  Edges in 'Interlocking\Edges.pas',
  Dongle_Green in '..\..\Common\Dongle_Green.pas',
  DongleChange_Green in '..\..\Common\DongleChange_Green.pas' {fmDongleChangeGreen},
  DongleInfo_Green in '..\..\Common\DongleInfo_Green.pas' {fmDongleInformationGreen},
  fr_MaterialSummary in 'fr_MaterialSummary.pas' {fmfrMaterialSummary},
  ConstructionsWhereUsed in 'ConstructionsWhereUsed.pas' {fmConstructionsWhereUsed},
  fr_Ticket in 'fr_Ticket.pas' {fmfrTicket},
  TotalReport2 in 'TotalReport2.pas' {dmTotalReport2: TDataModule},
  Features in 'Features.pas' {fmFeatures},
  PrintExports in '..\..\Common\PrintExports.pas' {fmPrintExports},
  ParamGeneral in 'ParamGeneral.pas' {fmParametersGeneral},
  ExternalInDM in 'ExternalInDM.pas' {ExternalInDM1: TDataModule},
  TicketsAllDM in 'TicketsAllDM.pas' {dmTicketsAll: TDataModule},
  TotalReport in 'TotalReport.pas' {dmTotalReport: TDataModule},
  WidthSelector in 'WidthSelector.pas' {fmWidthSelector},
  KnifeNettArea in 'KnifeNettArea.pas' {dmKnifeNettArea: TDataModule};

{$R *.RES}

var
  SplashScreen: TfmSplashScreen;
  MultipleCopies: Boolean;
  SystemIni: TIniFile;
  LoginComplete: Boolean;

begin
  //Initial Read of INI file to decide whether to start a second copy
  SystemIni := TIniFile.Create(SystemIniName);
  MultipleCopies := SystemIni.ReadBool('Client', 'MULTIPLECOPIES', False);
  SystemIni.Free;

  if not MultipleCopies then
  begin
    CreateMutex(nil, false, 'SATRASumm8');
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      messagedlg('SATRASumm 8 is already running', mtInformation, [mbOk], 0);

      Halt(0);
    end;
  end;

  Application.CreateForm(TfmSumms, fmSumms);
  Application.CreateForm(TfmAccessDenied, fmAccessDenied);
  Application.CreateForm(TfmDongleChangeGreen, fmDongleChangeGreen);
  Application.CreateForm(TfmDongleInformationGreen, fmDongleInformationGreen);
  Application.CreateForm(TfmPrintExports, fmPrintExports);
  Application.CreateForm(TExternalInDM1, ExternalInDM1);
  Application.CreateForm(TdmTicketsAll, dmTicketsAll);
  Application.CreateForm(TdmTotalReport, dmTotalReport);
  SplashScreen := TfmSplashScreen.Create(Application);
  SplashScreen.Show;
  SplashScreen.Initialise;
  Application.Initialize;

  SplashScreen.Update;

  LoginComplete := False;
  while not LoginComplete do
  begin
    while not SplashScreen.Login do
    begin
      sleep(1);
      application.Processmessages;
    end;

    SplashScreen.pnlLogin.Enabled := False;

    if not SplashScreen.Cancel then
    begin
      Application.Processmessages;
      Connection(fmSumms.ConnectionSumms,
                 'SATRASUMM8', SplashScreen.UserName, SplashScreen.Password, True);

      if not fmSumms.ConnectionSumms.Connected then
        SplashScreen.Initialise;
    end;

    LoginComplete := SplashScreen.Login or SplashScreen.Cancel;
  end;

  if fmSumms.ConnectionSumms.Connected then
  begin
    fmSumms.StartUp;

    Application.CreateForm(TfmCancelPrinting, fmCancelPrinting);
    Application.CreateForm(TfmLockedDialog, fmLockedDialog);
    Application.CreateForm(TfmAccessDenied, fmAccessDenied);
    Application.CreateForm(TdmPatternDrawing, dmPatternDrawing);
    dmpatternDrawing.Pass(fmSumms.ConnectionSumms);

    Application.CreateForm(TfmMemoryError, fmMemoryError);
//    Application.CreateForm(TdmTicketsGeneral, dmTicketsGeneral);
    Application.CreateForm(TfmBrowseKnives, fmBrowseKnives);
    Application.CreateForm(TfmBrowseMaterials, fmBrowseMaterials);
    Application.CreateForm(TfmBrowseSizeRelationships, fmBrowseSizeRelationships);
    Application.CreateForm(TfmBrowseSizeRanges, fmBrowseSizeRanges);
    Application.CreateForm(TfmBrowseSizeScales, fmBrowseSizeScales);
    Application.CreateForm(TfmBrowseStyles, fmBrowseStyles);
    Application.CreateForm(TfmBrowseWidthRanges, fmBrowseWidthRanges);
    Application.CreateForm(TfmCopyConstruction, fmCopyConstruction);
    Application.CreateForm(TfmCopyKnife, fmCopyKnife);
    Application.CreateForm(TfmCopyMaterial, fmCopyMaterial);
    Application.CreateForm(TfmCopyPart, fmCopyPart);
    Application.CreateForm(TfmCopyPartWidthKnives, fmCopyPartWidthKnives);
    Application.CreateForm(TfmCopySizeRange, fmCopySizeRange);
    Application.CreateForm(TfmCopySizeRelationship, fmCopySizeRelationship);
    Application.CreateForm(TfmCopyStyle, fmCopyStyle);
    Application.CreateForm(TfmCopyTicket, fmCopyTicket);
    Application.CreateForm(TfmCopyWidthRange, fmCopyWidthRange);
    Application.CreateForm(TfmNewConstruction, fmNewConstruction);
    Application.CreateForm(TfmNewKnifeSet, fmNewKnifeSet);
    Application.CreateForm(TfmNewMaterial, fmNewMaterial);
    Application.CreateForm(TfmNewPart, fmNewPart);
    Application.CreateForm(TfmNewSizeRange, fmNewSizeRange);
    Application.CreateForm(TfmNewSizeRelationship, fmNewSizeRelationship);
    Application.CreateForm(TfmNewSizeScale, fmNewSizeScale);
    Application.CreateForm(TfmNewStyle, fmNewStyle);
    Application.CreateForm(TfmNewSupplier, fmNewSupplier);
    Application.CreateForm(TfmNewTicket, fmNewTicket);
    Application.CreateForm(TfmNewWidthRange, fmNewWidthRange);
    Application.CreateForm(TfmOpenConstruction, fmOpenConstruction);
    Application.CreateForm(TfmOpenKnife, fmOpenKnife);
    Application.CreateForm(TfmOpenMaterial, fmOpenMaterial);
    Application.CreateForm(TfmOpenPart, fmOpenPart);
    Application.CreateForm(TfmOpenSizeRange, fmOpenSizeRange);
    Application.CreateForm(TfmOpenSizeRelationship, fmOpenSizeRelationship);
    Application.CreateForm(TfmOpenSizeScale, fmOpenSizeScale);
    Application.CreateForm(TfmOpenSupplier, fmOpenSupplier);
    Application.CreateForm(TfmOpenTicket, fmOpenTicket);
    Application.CreateForm(TfmOpenWidthRange, fmOpenWidthRange);
    Application.CreateForm(TfmAboutBox, fmAboutBox);
    Application.CreateForm(TfmKnivesToSwap, fmKnivesToSwap);
    Application.CreateForm(TfmSwapKnives, fmSwapKnives);
//    Application.CreateForm(TdmTicketsCreate, dmTicketsCreate);
//    Application.CreateForm(TdmTicketsSplit, dmTicketsSplit);
    Application.CreateForm(TfmTicketsGroupError, fmTicketsGroupError);
    Application.CreateForm(TfmBrowseDirectories, fmBrowseDirectories);
    Application.CreateForm(TfmLockedDialog, fmLockedDialog);
    Application.CreateForm(TfmOpenStyle, fmOpenStyle);
    Application.CreateForm(TfmNewSizeRelationship, fmNewSizeRelationship);
    Application.CreateForm(TfmChangePassword, fmChangePassword);
    Application.CreateForm(TfmTicketsGroupCreate, fmTicketsGroupCreate);
    Application.CreateForm(TfmImportTimeLineElements, fmImportTimeLineElements);
    Application.CreateForm(TfmSelectKnifeSize, fmSelectKnifeSize);
    Application.CreateForm(TfmKnifeSpinner, fmKnifeSpinner);

    SplashScreen.Hide;
    SplashScreen.Free;

    Application.Run;
  end;
end.

