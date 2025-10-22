unit CopyKnife;

interface

uses
  Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBCtrls,
  Buttons, ExtCtrls, ToolWin, ComCtrls,  Db, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmCopyKnife = class(TForm)
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qKnives: TFDQueryPlus;
    eNewKnifeCode: TEdit;
    LocalConnectionSumms: TFDConnectionPlus;
    lblCode: TLabel;
    procedure eNewKnifeCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BaseCode : string;
    BaseManual: Boolean;
    ToBeAssessed : boolean;
  end;

var
  fmCopyKnife: TfmCopyKnife;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs, KnifeSetDetails, OutOfMemory,
  AdvErrorHandler, SummsVars, KnifeNettArea;

{$R *.DFM}

procedure TfmCopyKnife.btnSaveClick(Sender: TObject);
var
  Code, TBA: string;
  Failed, KnifeCreated: boolean;
  fmKnifeSetDetails: TfmKnifeSetDetails;
  dmKnifeNettArea: TdmKnifeNettArea;

begin
  Code := eNewKnifeCode.Text;
  if Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

//  if ToBeAssessed then
    TBA := 'TRUE' ;
//  else
//    TBA := 'FALSE';

  qKnives.SQL.Text := 'INSERT INTO KnifeSets (Code, Description, SizeScale, Type, ManualEntry, CutGap, ' +
                      'DoubleSided, Thin, Pieces, Punches, Clears, Bands, Marks) SELECT ''' +
                       QS(Code) + ''', Description, SizeScale, Type, ManualEntry, CutGap, ' +
                      'DoubleSided, Thin, Pieces, Punches, Clears, Bands, Marks ' +
                      'FROM KnifeSets WHERE Code = ''' + QS(BaseCode) + '''; ' + #13 +

                      'INSERT INTO Knives (Code, SizeScale, MeasuredSize, Seq, ' +
                      'GrossArea, NettArea, InterlockAreaPrimeSynthetic, InterlockAreaNonPrime, ' +
                      'ToBeAssessed, ImportFileName, PieceName, Angle) SELECT ''' +
                       QS(Code) + ''', K.SizeScale, K.MeasuredSize, K.Seq, ' +
                      'IIF(KS.ManualEntry = True, K.GrossArea, 0), ' +
                      'IIF(KS.ManualEntry = True, K.NettArea, 0), ' +
                      'IIF(KS.ManualEntry = True, K.InterlockAreaPrimeSynthetic, 0), ' +
                      'IIF(KS.ManualEntry = True, K.InterlockAreaNonPrime, 0), IIF(KS.ManualEntry = True, FALSE, TRUE), ' +
                          'K.ImportFileName, K.PieceName, K.Angle FROM Knives K, KnifeSets KS ' +
                      'WHERE K.Code = ''' + QS(BaseCode) + ''' AND KS.Code = ''' + QS(BaseCode) + '''; ' + #13 +

                      'INSERT INTO Patterns (Knife, SizeScale, MeasuredSize, Seq, X, Y) SELECT ''' + QS(Code) + ''', SizeScale, MeasuredSize, Seq, X, Y FROM Patterns ' +
                      'WHERE Knife = ''' + QS(BaseCode) + ''';' + #13 +

                      'INSERT INTO LayplanPlans (KnifeCode, KnifeSizeScale, KnifeSize, MaterialLength, MaterialWidth, ' +
                        'MaterialCutGap, MaterialCodeRestrictive, LayplanCode, Seq, SqFtPerPiece, StartLeft, RemHeight, RemWidth, ' +
                        'Details2, Details3, Details4, Details5, Details6, ToleranceUsed, Input_UsableMaterialLength, ' +
                        'Input_UsableMaterialWidth, Input_PatternHeight, Input_PatternWidth, Input_Square, Input_FixedStart, ' +
                        'Input_StartLeft, Input_W2, Input_FirstCutInCorner, Input_ForceW1First, Input_ForceW2First, Input_LocalInterlock_Used, ' +
                        'Input_LocalInterlock_Reversed, Input_LocalInterlock_PairedPatternHeight, Input_LocalInterlock_PairedPatternWidth, ' +
                        'Input_LocalInterlock_SinglePatternHeight, Input_LocalInterlock_SinglePatternWidth, Input_LocalInterlock_Vec1x, ' +
                        'Input_LocalInterlock_Vec1y, Input_LocalInterlock_W2, Input_LocalInterlock_Pat1_Left, Input_LocalInterlock_Pat1_Top, ' +
                        'Input_LocalInterlock_Pat1_Right, Input_LocalInterlock_Pat1_Bottom, Input_LocalInterlock_Pat2_Left, Input_LocalInterlock_Pat2_Top, ' +
                        'Input_LocalInterlock_Pat2_Right, Input_LocalInterlock_Pat2_Bottom, Input_LocalInterlock_LeftPat, Input_LocalInterlock_BottomPat, ' +
                        'Input_PackAngle, PropogationNo, KnifeNo) ' +
                      'SELECT ''' + QS(Code) + ''', KnifeSizeScale, KnifeSize, MaterialLength, MaterialWidth, MaterialCutGap, MaterialCodeRestrictive, LayplanCode, ' +
                        'Seq, SqFtPerPiece, StartLeft, RemHeight, RemWidth, Details2, Details3, Details4, Details5, Details6, ToleranceUsed, ' +
                        'Input_UsableMaterialLength, Input_UsableMaterialWidth, Input_PatternHeight, Input_PatternWidth, Input_Square, Input_FixedStart, ' +
                        'Input_StartLeft, Input_W2, Input_FirstCutInCorner, Input_ForceW1First, Input_ForceW2First, Input_LocalInterlock_Used, ' +
                        'Input_LocalInterlock_Reversed, Input_LocalInterlock_PairedPatternHeight, Input_LocalInterlock_PairedPatternWidth, ' +
                        'Input_LocalInterlock_SinglePatternHeight, Input_LocalInterlock_SinglePatternWidth, Input_LocalInterlock_Vec1x, ' +
                        'Input_LocalInterlock_Vec1y, Input_LocalInterlock_W2, Input_LocalInterlock_Pat1_Left, Input_LocalInterlock_Pat1_Top, ' +
                        'Input_LocalInterlock_Pat1_Right, Input_LocalInterlock_Pat1_Bottom, Input_LocalInterlock_Pat2_Left, Input_LocalInterlock_Pat2_Top, ' +
                        'Input_LocalInterlock_Pat2_Right, Input_LocalInterlock_Pat2_Bottom, Input_LocalInterlock_LeftPat, Input_LocalInterlock_BottomPat, ' +
                        'Input_PackAngle, PropogationNo, KnifeNo ' +
                       'FROM LayplanPlans ' +
                       'WHERE KnifeCode = ''' + QS(BaseCode) + ''';' + #13 +

                      'INSERT INTO LayplanPlanPacks (KnifeCode, KnifeSizeScale, KnifeSize, MaterialLength, MaterialWidth, ' +
                        'MaterialCutGap, MaterialCodeRestrictive, LayplanCode, Seq, W2, BR_Left, BR_Top, BR_Right, BR_Bottom) ' +
                        'SELECT ''' + QS(Code) + ''', KnifeSizeScale, KnifeSize, MaterialLength, MaterialWidth, ' +
                          'MaterialCutGap, MaterialCodeRestrictive, LayplanCode, Seq, W2, BR_Left, BR_Top, BR_Right, BR_Bottom ' +
                        'FROM LayplanPlanPacks ' +
                        'WHERE KnifeCode = ''' + QS(BaseCode) + ''';' + #13 +

                      'INSERT INTO LayplanSets (KnifeCode, KnifeSizeScale, KnifeSize, MaterialLength, MaterialWidth, MaterialCutGap, ' +
                        'MaterialCodeRestrictive, MaterialEdge, KnifeAngle, SelectedNo) ' +
                        'SELECT ''' + QS(Code) + ''', KnifeSizeScale, KnifeSize, MaterialLength, MaterialWidth, MaterialCutGap, ' +
                          'MaterialCodeRestrictive, MaterialEdge, KnifeAngle, SelectedNo ' +
                        'FROM LayplanSets ' +
                        'WHERE KnifeCode = ''' + QS(BaseCode) + ''';' + #13 +

                      'INSERT INTO LayplanSetKnives (KnifeCode, KnifeSizeScale, KnifeSize, MaterialLength, MaterialWidth, ' +
                        'MaterialCutGap, MaterialCodeRestrictive, KnifeNo, RealNotExpanded, W2, Seq, X, Y) ' +
                        'SELECT ''' + QS(Code) + ''', KnifeSizeScale, KnifeSize, MaterialLength, MaterialWidth, ' +
                          'MaterialCutGap, MaterialCodeRestrictive, KnifeNo, RealNotExpanded, W2, Seq, X, Y ' +
                        'FROM LayplanSetKnives ' +
                        'WHERE KnifeCode = ''' + QS(BaseCode) + ''';';

  KnifeCreated := True;
  try
    qKnives.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Knife already exists', E.Message, qKnives.Text);
      KnifeCreated := False;
    end;
  end;

  if not KnifeCreated then
  begin
    LocalConnectionSumms.Rollback;
    eNewKnifeCode.SetFocus;
    eNewKnifeCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;

    if (not BaseManual) then
    begin
      dmKnifeNettArea := TdmKnifeNettArea.Create(Self, LocalConnectionSumms);
      dmKnifeNettArea.NettArea(QS(Code));
      dmKnifeNettArea.Free;
    end;

    LocalConnectionSumms.Commit;

    Failed := False;
    try
      fmKnifeSetDetails := TfmKnifeSetDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmKnifeSetDetails.PassKnifeName(fmKnifeSetDetails, Code);

    Close;
  end;
end;

procedure TfmCopyKnife.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCopyKnife.FormActivate(Sender: TObject);
begin
  eNewKnifeCode.text := '';
  eNewKnifeCode.setfocus;
end;

procedure TfmCopyKnife.eNewKnifeCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmCopyKnife.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

procedure TfmCopyKnife.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmCopyKnife.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCopyKnife.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.

