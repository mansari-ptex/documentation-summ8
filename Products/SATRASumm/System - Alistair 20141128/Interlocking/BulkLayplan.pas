unit BulkLayplan;

interface

uses
  Classes, Controls, Forms, StdCtrls, Mask, DBCtrls, DB,  
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons, ExtCtrls, ToolWin, ComCtrls,  Grids, DBGridPlus,
  SysUtils, IniFiles, Dialogs, Gauges, Spin, PBSpinEdit, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  Vcl.DBGrids;

type
  TfmBulkLayplan = class(TForm)
    LocalConnectionSumms: TFDConnection;
    dsLayplans: TDataSource;
    qLayplans: TFDQueryPlus;
    qLayplansStatus: TStringField;
    tbMain: TPanel;
    btnAbort: TSpeedButton;
    btnCreateLayPlans: TSpeedButton;
    pnlLoading: TPanel;
    pnlTop: TPanel;
    qLayplansKnife: TStringField;
    qLayplansSizeScale: TStringField;
    qLayplansAdjustedSize: TStringField;
    qLayplansCutGap: TIntegerField;
    qLayplansRestrictiveMaterialCode: TStringField;
    qLayplansSizeSeq: TFloatField;
    qLayplansSubUnitDesc: TStringField;
    qLayplansSubUnitAbbreviation: TStringField;
    qLayplansUnits: TStringField;
    tblKnives: TFDTablePlus;
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
    tblKnivesToleranceUsed: TIntegerField;
    tblKnivesSeq: TFloatField;
    tblKnivesAngle: TFloatField;
    qLayplansLength: TIntegerField;
    qLayplansWidth: TIntegerField;
    qLayplansLengthInunits: TFloatField;
    qLayplansWidthInUnits: TFloatField;
    qLayplansRealLength: TFloatField;
    qLayplansRealWidth: TFloatField;
    btnFindLayplans: TSpeedButton;
    pnlSelections: TPanel;
    pnlSelectionsTitle: TPanel;
    gbCuttingGuide: TGroupBox;
    lblCuttingGuide: TLabel;
    tbCuttingGuide: TTrackBar;
    pnlParameters1: TPanel;
    rgAdjustmentsAllowed: TRadioGroup;
    pnlParameters2: TPanel;
    rgOptimisation: TRadioGroup;
    rgRotationalIncrements: TRadioGroup;
    pnlParameters4: TPanel;
    rgStartingSide: TRadioGroup;
    rgStartingCriteria: TRadioGroup;
    pnlParameters3: TPanel;
    rgCornerAnchoring: TRadioGroup;
    rgAllowInvertion: TRadioGroup;
    pnlParameters5: TPanel;
    rgMaxGangs: TRadioGroup;
    pnlRest: TPanel;
    pnlLayplanSizes: TPanel;
    pnlLayplanSizesTitle: TPanel;
    pnlMaterial: TPanel;
    pnlMaterialTitle: TPanel;
    pnlResults: TPanel;
    pnlResultsTitle: TPanel;
    cbSelectTopChoice: TCheckBox;
    sedtEdge: TPBSpinEdit;
    lblEdge: TLabel;
    rgSizes: TRadioGroup;
    gProgress: TGauge;
    dbgLayplans: TDBGridPlus;
    qLayplansPrepare: TFDQueryPlus;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    StringField4: TStringField;
    FloatField1: TFloatField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    FloatField2: TFloatField;
    FloatField3: TFloatField;
    StringField8: TStringField;
    FloatField4: TFloatField;
    FloatField5: TFloatField;
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCreateLayPlansClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure ReadIni;
    procedure WriteIni;
    procedure tbCuttingGuideChange(Sender: TObject);
    procedure qLayplansCalcFields(DataSet: TDataSet);
    procedure UpdateScreen;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure qLayplansAfterOpen(DataSet: TDataSet);
    procedure btnFindLayplansClick(Sender: TObject);
    procedure FindLayplans;
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
    AbortBulkLayplan: Boolean;
    SummsLayplanINI: TIniFile;
    DetailsReady: Boolean;
  public
    { Public declarations }
    BulkLayplanning, LoadingLayplans: Boolean;
  end;

var
  fmBulkLayplan: TfmBulkLayplan;
  Details: array of string;
  RightsProblem: Boolean;

implementation

uses Summs, CmnVars, SummsVars, Laymain, Const_Interlocking, AdvErrorHandler,
			General;

{$R *.dfm}

procedure TfmBulkLayplan.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  tblKnives.open;
end;

procedure TfmBulkLayplan.LocalConnectionSummsBeforeConnect(Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmBulkLayplan.btnAbortClick(Sender: TObject);
begin
  AbortBulkLayplan := True;
  if (fmLayplan <> nil) then
    fmLayplan.AbortLayplanning := True;
  application.processmessages;
end;

procedure TfmBulkLayplan.btnCreateLayPlansClick(Sender: TObject);
var
  Saved: Boolean;
  s: string;
  i: integer;

begin
  FindLayplans;

  screen.cursor := crHourGlass;

  AbortBulkLayplan := False;
  BulkLayplanning := True;
  UpdateScreen;

  //Save Settings as Separate Layplanning
  //form will pick them up from INI file
  WriteIni;

  if not RightsProblem then
  begin
    gProgress.Visible := True;
    //CJY Would require gbProgress.FetchOptions.RecordCountMode set to cmTotal
//    gbProgress.Caption := 'Progress (0 of ' + inttostr(qLayplans.recordcount) + ' done)';
    gProgress.Progress := 0;

    i := 0;

    qLayplans.RecNo := 1; //CJY changed from qLayplans.First
    qLayplans.Prior; //CJY changed from qLayplans.First
    while (not qLayplans.eof) and (not AbortBulkLayplan) do
    begin
      Saved := False;

      Details[qLayplans.recNo - 1] := 'Calculating...';
      qLayplans.refresh;
      application.processmessages;

      //Quick Check to see if knife exists
      if not tblKnives.FindKey([qLayplansKnife.value,
                                qLayplansSizeScale.value,
                                qLayplansAdjustedSize.value]) then
        s := 'Knife missing'
      else
      begin
        if fmSumms.LayplanningInterfaceOUT(fmBulkLayplan,
                                        qLayplansKnife.value,
                                        qLayplansSizeScale.value,
                                        qLayplansAdjustedSize.value,
                                        qLayplansSubUnitDesc.value,
                                        qLayplansSubUnitAbbreviation.value,
                                        qLayplansRealLength.value,
                                        qLayplansRealWidth.value,
                                        qLayplansUnits.value,
                                        qLayplansCutGap.value,
                                        qLayplansRestrictiveMaterialCode.value) then
        begin
          if fmLayplan.KnifeCode <> '' then
          begin
            if not AbortBulkLayplan then
              fmLayplan.mnuLayPlansCreateClick(Self);
            if (not AbortBulkLayplan) and cbSelectTopChoice.checked then
            begin
              try
                fmLayplan.SelectedLayplan := 0;
              except
                AbortBulkLayplan := True;
              end;
            end;
            if not AbortBulkLayplan then
            begin
              try
                fmLayplan.AutoOverwrite := AUTO_OVERWRITE_NO;
                Saved := fmLayplan.CheckAndSaveLayplan;
              except
                AbortBulkLayplan := True;
              end;
            end;
            if AbortBulkLayplan then
              s := 'Aborted'
            else if Saved then
              s := 'Complete'
            else
              s := 'Complete (Not saved)';
          end
          else
            s := 'Knife missing';

          try
            fmLayplan.Close;
          except
            AbortBulkLayplan := True;
          end;
        end
        else
          AbortBulkLayplan := True;

        if AbortBulklayplan then
          s := 'Aborted';

      end;

      Details[qLayplans.recNo - 1] := s;

      inc(i);
//      gbProgress.Caption := 'Progress (x of y done)';
      //CJY Would require gbProgress.FetchOptions.RecordCountMode set to cmTotal
//      gbProgress.Caption := 'Progress (' + inttostr(i) + ' of ' + inttostr(qLayplans.recordcount) + ' done)';

      //CJY qLayplans.FetchOptions.RecordCountMode set to cmTotal
      gProgress.Progress := round(i / qLayplans.RecordCount * 100);

      qLayplans.refresh;
      application.processmessages;

      qLayplans.next;
    end;

    gProgress.Visible := False;
  end;

  BulkLayplanning := False;
  UpdateScreen;

  dbgLayplans.refresh;

  screen.cursor := crDefault;

  if AbortBulkLayplan then
    messagedlg('Bulk Layplanning Aborted', mtInformation, [mbOk], 0)
  else
    messagedlg('Bulk Layplanning Complete', mtInformation, [mbOk], 0);
end;

procedure TfmBulkLayplan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qLayplans.close;

  WriteIni;
  SummsLayplanINI.Free;

  Action := caFree;
end;

procedure TfmBulkLayplan.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (not BulkLayplanning) and (not LoadingLayplans);
end;

procedure TfmBulkLayplan.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  SummsLayplanINI := TIniFile.Create(LayplanIniName);
  ReadINI;

  //Forces Intermediate packs only for Costings Only System
  if not Option_ProductionSystem then
  begin
    cbSelectTopChoice.checked := True;
    pnlResults.visible := False;
    gbCuttingGuide.enabled := False;
    tbCuttingGuide.Position := 5;
  end;

  BulkLayplanning := False;
  LoadingLayplans := False;
  DetailsReady := False;

  RightsProblem := False;

  UpdateScreen;
end;

procedure TfmBulkLayplan.qLayplansAfterOpen(DataSet: TDataSet);
var
  i: integer;

begin
  //CJY qLayplans.FetchOptions.RecordCountMode set to cmTotal
  setLength(Details, qLayplans.RecordCount);
  //CJY qLayplans.FetchOptions.RecordCountMode set to cmTotal
  for i := 0 to qLayplans.RecordCount - 1 do
    Details[i] := '';
  DetailsReady := True;

  qLayplans.Refresh;
  dbgLayplans.refresh;
end;

procedure TfmBulkLayplan.qLayplansCalcFields(DataSet: TDataSet);
begin
  if DetailsReady then
    qLayplansStatus.value := Details[qLayplans.RecNo - 1];
  qLayplansLengthInUnits.value := qLayplansLength.value / (12000 / PATTERNRES);
  qLayplansWidthInUnits.value := qLayplansWidth.value / (12000 / PATTERNRES);
end;

procedure TfmBulkLayplan.ReadIni;
begin
  tbCuttingGuide.Position := SummsLayplanINI.ReadInteger('Cutting Guide', 'CUTTING_GUIDE', 11);
  rgAdjustmentsAllowed.ItemIndex := SummsLayplanINI.ReadInteger('Rotations', 'ROTATIONS_ADJUSTMENTS', 1);
  rgRotationalIncrements.ItemIndex := SummsLayplanINI.ReadInteger('Rotations', 'ROTATIONS_INCREMENTS', 1);
  rgAllowInvertion.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_ALLOWINVERTION', 0);
  rgCornerAnchoring.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_CORNER_ANCHORING', 1);
  rgStartingSide.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_STARTING_SIDE', 0);
  rgStartingCriteria.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_STARTING_CRITERIA', 0);
  rgOptimisation.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_OPTIMISATION', 0);
  rgMaxGangs.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_MAXGANGS', 5);
  rgSizes.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_BULK_SIZES', 0);
  sedtEdge.value := SummsLayplanINI.ReadInteger('Material', 'MATERIAL_SELVEDGE', 0);
  cbSelectTopChoice.Checked := SummsLayplanINI.ReadBool('Options', 'OPTIONS_BULK_RESULTS_TOPCHOICE', False);
end;

procedure TfmBulkLayplan.btnFindLayplansClick(Sender: TObject);
begin
  FindLayplans;
end;

procedure TfmBulkLayplan.tbCuttingGuideChange(Sender: TObject);
begin
  lblCuttingGuide.caption := intToStr(tbCuttingGuide.Position);
end;

procedure TfmBulkLayplan.WriteIni;
begin
  try
    SummsLayplanINI.WriteInteger('Cutting Guide', 'CUTTING_GUIDE', tbCuttingGuide.Position);
    SummsLayplanINI.WriteInteger('Rotations', 'ROTATIONS_ADJUSTMENTS', rgAdjustmentsAllowed.ItemIndex);
    SummsLayplanINI.WriteInteger('Rotations', 'ROTATIONS_INCREMENTS', rgRotationalIncrements.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_ALLOWINVERTION', rgAllowInvertion.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_CORNER_ANCHORING', rgCornerAnchoring.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_STARTING_SIDE', rgStartingSide.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_STARTING_CRITERIA', rgStartingCriteria.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_OPTIMISATION', rgOptimisation.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_MAXGANGS', rgMaxGangs.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_BULK_SIZES', rgSizes.ItemIndex);
    SummsLayplanINI.WriteInteger('Material', 'MATERIAL_SELVEDGE', sedtEdge.value);
    SummsLayplanINI.WriteBool('Options', 'OPTIONS_BULK_RESULTS_TOPCHOICE', cbSelectTopChoice.Checked);
  except
    on E: Exception do
      fmErrorHandler.DebugMessageDlg('SummsLayplan.ini NOT saved', E.Message, '');
  end;
end;

procedure TfmBulkLayplan.UpdateScreen;
begin
  btnFindLayplans.enabled := (not BulkLayplanning) and (not LoadingLayplans);
  btnCreateLayplans.enabled := (not BulkLayplanning) and (not LoadingLayplans);
  btnAbort.enabled :=  BulkLayplanning and (not LoadingLayplans);

  pnlTop.enabled := (not BulkLayplanning) and (not LoadingLayplans);
  tbCuttingGuide.enabled := pnlTop.enabled;
  lblCuttingGuide.enabled := pnlTop.enabled;
  rgAdjustmentsAllowed.enabled := pnlTop.enabled;
  rgRotationalIncrements.enabled := pnlTop.enabled;
  rgAllowInvertion.enabled := pnlTop.enabled;
  rgCornerAnchoring.enabled := pnlTop.enabled;
  rgStartingSide.enabled := pnlTop.enabled;
  rgStartingCriteria.enabled := pnlTop.enabled;
  rgOptimisation.enabled := pnlTop.enabled;
  rgMaxGangs.enabled := pnlTop.enabled;
  rgSizes.enabled := pnlTop.enabled;
  sedtEdge.enabled := pnlTop.enabled;
  cbselectTopChoice.enabled := pnlTop.enabled;
  dbgLayplans.enabled := pnlTop.enabled;

  pnlLoading.visible := LoadingLayplans;

  application.processmessages;
end;

procedure TfmBulkLayplan.FindLayplans;
var
  varPatternRes: integer;
  varRollLength_ft: real;

begin
  screen.cursor := crHourGlass;

  DetailsReady := False;
  LoadingLayplans := True;
  UpdateScreen;

  if qLayplans.active then
  begin
    //The temporary table #temp and #temp2 can not be dropped
    //(possibly due to some internal tranasction). Reconnecting
    //is the only way we could find to drop them.
    LocalconnectionSumms.Close;
    LocalconnectionSumms.open;
  end;
  application.processmessages;

  //Can not pass CONSTANTS as they do not respect
  //decimal separater set in locale settings.
  varPatternRes := PATTERNRES;
  varRollLength_ft := ROLLLENGTH_FT;

  qLayplansPrepare.ParamByname('AllSizes').value := rgSizes.ItemIndex;
  qLayplansPrepare.ParamByname('PatternRes').value := varPatternRes;
  qLayplansPrepare.ParamByname('RollLengthFt').value := varRollLength_ft;

  //Following check ASSUMES that all that can go wrong with this
  //query is that the user does not have rights for Layplans.
  RightsProblem := False;

  try
    qLayplansPrepare.ExecSQL;
    qLayplans.open;
  except
    RightsProblem := True;
  end;

  LoadingLayplans := False;

  UpdateScreen;

  screen.cursor := crDefault;

  if RightsProblem then
    messagedlg('Rights are not granted for User - ' + SystemUserName, mtInformation, [mbOk], 0)
  //CJY qLayplans.FetchOptions.RecordCountMode set to cmTotal
  else if qLayplans.recordCount = 0 then
    messagedlg('There are No Layplans required.', mtInformation, [mbOk], 0);
end;

end.

