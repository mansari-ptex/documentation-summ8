unit SwapKnvs;

interface

uses
  Classes, Controls, Forms, Dialogs, Grids, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  StdCtrls, ExtCtrls, Buttons, ToolWin, ComCtrls, DBGrids,
  DBGridPlus, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FDConnectionPlus;
                                                                 
type
  TfmSwapKnives = class(TForm)
    dsListKnives: TDataSource;
    qSwapKnives: TFDQueryPlus;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    btnSelectAll: TSpeedButton;
    btnDeselectAll: TSpeedButton;
    btnSwap: TSpeedButton;
    dbgSwapKnives: TDBGridPlus;
    qListKnives: TFDQueryPlus;
    qListKnivesPart: TStringField;
    qListKnivesWidth: TStringField;
    qListKnivesSelected: TBooleanField;
    qListKnivesWidthNo: TSmallintField;
    qToKnife: TFDQueryPlus;
    qToKnifeHowMany: TIntegerField;
    LocalConnectionSumms: TFDConnectionPlus;
    sbMain: TStatusBar;
    qListKnivesRecNo: TIntegerField;
    procedure ShowKnives(var NoParts, NoToKnife: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure btnSwapClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnDeselectAllClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FillArray(Flag: Boolean);
    procedure qListKnivesCalcFields(DataSet: TDataSet);
    procedure dbgSwapKnivesCellClick(Column: TColumn);
    procedure qListKnivesAfterOpen(DataSet: TDataSet);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qListKnivesAfterScroll(DataSet: TDataSet);
    procedure qListKnivesBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
    Selected: array of Boolean;
  public
    { Public declarations }
    OldCode, NewCode : string;
  end;

var
  fmSwapKnives: TfmSwapKnives;

implementation

uses
  SysUtils, Summs, KnivesToSwap, General, AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmSwapKnives.ShowKnives(var NoParts, NoToKnife: Boolean);
begin
  NoToKnife := False;
  if not(NewCode ='') then
  begin
    qToKnife.Close;
    qToKnife.ParamByName('NewCode').Value := NewCode;
    qToKnife.Open;
    if (qToKnifeHowMany.Value = 0) then
      NoToKnife := True;
  end;

  if not NoToKnife then
  begin
    qListKnives.Close;

    qListKnives.SQL.Text := 'SELECT PWK.Part, W.Width, PWK.WidthNo ' +
                            'FROM PtWidKnf PWK, Widths W ' +
                            'WHERE W.No = PWK.WidthNo AND PWK.Knife = ''' + QS(OldCode) + ''' ' +
                            'Order By PWK.Part, PWK.Part, PWK.WidthNo';

    if NewCode = '' then
      Caption := 'Remove Knife ' + OldCode
    else
      Caption:='Swap Knife From ' + OldCode + ' To ' + NewCode;

    qListKnives.Open;
    //CJY: qListKnives.FetchOptions.RecordCountMode set to cmTotal
    if qListKnives.RecordCount > 0 then
      NoParts := False
    else
      NoParts := True;
  end;
end;

procedure TfmSwapKnives.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmSwapKnives.btnSwapClick(Sender: TObject);
var
  DoneMessage, FirstTime: boolean;
  SQLString: string;
  errList: TStringList;
  EMessage: string;
  SQLCode, NativeCode: integer;

begin
  DoneMessage := True;
  FirstTime := True;

  if NewCode = '' then
    SQLString := 'DELETE FROM PtWidKnf ' +
                 'WHERE PtWidKnf.Knife = ''' + QS(OldCode) + ''' AND ('
  else
    SQLString := 'UPDATE PtWidKnf ' +
                 'SET Knife = ''' + QS(NewCode) + ''' ' +
                 'WHERE PtWidKnf.Knife = ''' + QS(OldCode) + ''' AND (';

  qListKnives.DisableControls;
  qListKnives.RecNo := 1; //CJY changed from qListKnives.First
  qListKnives.Prior; //CJY changed from qListKnives.First
  while not qListKnives.Eof do
  begin
    if qListKnivesSelected.Value then
    begin
      if not FirstTime then
        SQLString := SQLString + ' OR ';
      SQLString := SQLString +
                   '(PtWidKnf.Part = ''' + QS(qListKnivesPart.Value) + ''' AND PtWidKnf.WidthNo = ' + IntToStr(qListKnivesWidthNo.Value) + ') ';
      FirstTime := False;
    end;
    qListKnives.Next;
  end;
  qListKnives.EnableControls;

  qSwapKnives.SQL.Text := SQLString + ')';

  Screen.cursor := crHourGlass;

  try
    if not FirstTime then
    begin
      if not LocalConnectionSumms.Connected then
        LocalConnectionSumms.Connected := True;

      LocalConnectionSumms.StartTransaction;
      qSwapKnives.ExecSQL;
    end
    else
    begin
      MessageDlgPos('No Knives selected', mtInformation, [mbOk],0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      DoneMessage := False;
      Screen.cursor := crDefault;
      qListKnives.RecNo := 1; //CJY changed from qListKnives.First
      qListKnives.Prior; //CJY changed from qListKnives.First
    end;
  except
    on E: EFDDBEngineException do
    begin
      errList := TStringList.Create();
      errList := fmErrorHandler.ErrRegMatch((E as EFDDBEngineException).Message);

      EMessage := errList.Values['Message'];
      SQLCode := strToInt(errList.Values['SQLErrorCode']);
      NativeCode := strToInt(errList.Values['NativeErrorCode']);
      errList.Free;

      if NativeCode = 7057 then
        fmErrorHandler.DebugMessageDlg('Replacement Knife already on Part/Width' + #13 + 'Nothing swapped', E.Message, qSwapKnives.Text);
      DoneMessage := False;
      Screen.cursor := crDefault;
      LocalConnectionSumms.RollBack;
    end;
  end;

  if DoneMessage then
  begin
    LocalConnectionSumms.Commit;
    btnRefresh.Click;
    Screen.cursor := crDefault;
    MessageDlgPos('Swap completed', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    //CJY: qListKnives.FetchOptions.RecordCountMode set to cmTotal
    if qListKnives.RecordCount = 0 then
      close;
  end;
end;

procedure TfmSwapKnives.btnSelectAllClick(Sender: TObject);
begin
  FillArray(True);
  qListKnives.Refresh;
end;

procedure TfmSwapKnives.btnDeselectAllClick(Sender: TObject);
begin
  FillArray(False);
  qListKnives.Refresh;
end;

procedure TfmSwapKnives.btnRefreshClick(Sender: TObject);
begin
  FillArray(False);

  qListKnives.Close;
  qListKnives.Open;
end;

procedure TfmSwapKnives.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qListKnives.close;

  //Release lock
  LocksUnLockRecord(fmSumms.tblLocks, 'SWAP_KNIVES');
end;

procedure TfmSwapKnives.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);

  dbgSwapKnives.Columns[0].Width := 180;
  dbgSwapKnives.Columns[1].Width := 85;
  dbgSwapKnives.Columns[2].Width := 46;

  fmKnivesToSwap.Hide;
end;

procedure TfmSwapKnives.FillArray(Flag: Boolean);
var
  i: integer;

begin
  for i := 1 to Length(Selected) - 1 do
    Selected[i] := Flag;
end;

procedure TfmSwapKnives.qListKnivesCalcFields(DataSet: TDataSet);
begin
  //CJY - Recording return of RecNo for workaround RecNo = 0 issue
  DataSet.FieldByName('RecNo').AsInteger := DataSet.RecNo;

  if (qListKnives.RecNo < Length(Selected)) then
    qListKnivesSelected.Value := Selected[qListKnives.RecNo];
end;

procedure TfmSwapKnives.dbgSwapKnivesCellClick(Column: TColumn);
begin
  if Column.Field.FieldName = 'Selected' then
  begin
    Selected[qListKnives.RecNo] := not(Selected[qListKnives.RecNo]);
    qListKnives.Refresh;
  end;
end;

procedure TfmSwapKnives.qListKnivesAfterOpen(DataSet: TDataSet);
begin
  //CJY: qListKnives.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qListKnives.RecordCount + 1);
  FillArray(False);

  qListKnives.OnCalcFields := qListKnivesCalcFields;
end;

procedure TfmSwapKnives.qListKnivesAfterScroll(DataSet: TDataSet);
begin
  //CJY - qConstructions.RecNo sometimes returns 0 when attached to a DataGrid (when
  //      using .First and .Last). When scrolling is is possible to miss the first
  //      last values, especially when jumping to the start or the end (Ctrl + Home).
  if not (DataSet.FieldByName('RecNo').AsInteger > 0) then
    DataSet.Refresh;
end;

procedure TfmSwapKnives.qListKnivesBeforeOpen(DataSet: TDataSet);
begin
  qListKnives.OnCalcFields := nil;
end;

procedure TfmSwapKnives.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmSwapKnives.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.

