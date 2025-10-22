unit WidthNames;

interface

uses
  Classes, Controls, Forms, Grids, DBGridPlus, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  ExtCtrls, Buttons, ToolWin, ComCtrls,  XStringGrid, XStringGridPlus, CmnVars, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, Vcl.DBGrids, FDConnectionPlus;

type
  TfmWidthNames = class(TForm)
    tblWidthNames: TFDTablePlus;
    dsWidths: TDataSource;
    dbgWidthNames: TDBGridPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnRefresh: TSpeedButton;
    tblWidthNamesNo: TSmallintField;
    tblWidthNamesWidth: TStringField;
    pnlView1: TPanel;
    sgWidthNames: TXStringGridPlus;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEditClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UpdateWidthsCopy;
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure sgWidthNamesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SetTabStops(Editing: Boolean);
    procedure Pass;
    procedure FormCreate(Sender: TObject);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
    EditMode: boolean;
    CurrentRow: integer;
  public
    { Public declarations }
  end;

var
  fmWidthNames: TfmWidthNames;

implementation

uses
  Graphics, Dialogs, Summs, General, SummsVars;

{$R *.DFM}

procedure TfmWidthNames.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if EditMode then
  begin
    if MessageDlgPos('Save Changes to Width Names?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
      btnSave.click
    else
      btnCancel.click;
  end;
  
  action := caFree;
end;

procedure TfmWidthNames.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
  if EditMode then
    dbgWidthNames.SetFocus
  else
    sgWidthNames.SetFocus;
end;

procedure TfmWidthNames.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  //Attempt Lock
  LockSuccess := LockOption(fmSumms.tblLocks, oWidthNames);

  if LockSuccess then
  begin
    LocalConnectionSumms.StartTransaction;

    UpdateScreen(True);
  end;
end;

procedure TfmWidthNames.UpdateScreen(Editing : boolean);
begin
  if editing then
  begin
    tbMain.color := clEditing;
    dbgWidthnames.Columns[0].Color := clEditing;
    dbgWidthnames.Columns[1].Color := clEditing;
  end
  else
  begin
    tbMain.color := clBack;
    dbgWidthnames.Columns[0].Color := clBack;
    dbgWidthnames.Columns[1].Color := clBack;
  end;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnRefresh.enabled := not Editing;

  pnlView1.visible := not Editing;

  SetTabStops(Editing);

  SetColumnWidthsDetails1(fmWidthNames, sgWidthNames, dbgWidthNames, 1, Editing);

  EditMode := Editing;

  if Editing then
  begin
    if CurrentRow > 0 then
      tblWidthNames.recNo := CurrentRow - 1;
    dbgWidthNames.SelectedField := tblWidthNamesNo;
    dbgWidthNames.SetFocus;
  end
  else
  begin

    sgWidthNames.SetFocus;
  end;
end;

procedure TfmWidthNames.btnSaveClick(Sender: TObject);
var
  KeyNum, OnRow: integer;
  Failed: boolean;

begin
  Failed := False;

  if Failed then
    MessageDlgPos('Must have at least one Width Name', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
  begin
    //Save and commit
    if tblWidthNames.state in [dsEdit, dsInsert] then
      tblWidthNames.post;
    LocalConnectionSumms.commit;

    //Release lock
    LocksUnLockRecord(fmSumms.tblLocks, 'WIDTH_NAMES');

    UpdateWidthsCopy;
    UpdateScreen(False);

    sgWidthNames.Row := 1;
  end;
end;

procedure TfmWidthNames.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblWidthNames.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock
  LocksUnLockRecord(fmSumms.tblLocks, 'WIDTH_NAMES');

  tblWidthNames.refresh;
  UpdateScreen(False);

  sgWidthNames.SetFocus;
end;

procedure TfmWidthNames.btnRefreshClick(Sender: TObject);
begin
  UpdateWidthsCopy;
end;

procedure TfmWidthNames.UpdateWidthsCopy;
var
   i : integer;
   s : string;

begin
  if tblWidthNames.active then
  begin
    sgWidthNames.RowCount := 2;
    sgWidthNames.Cells[0, 1] := '';
    sgWidthNames.Cells[1, 1] := '';

    i := 0;
    tblWidthNames.refresh;
    tblWidthNames.first;
    while not tblWidthNames.eof do
    begin
      inc(i);
      if i > 1 then
         sgWidthNames.RowCount := sgWidthNames.RowCount + 1;
      str(tblWidthNamesNo.value : 0, s);
      sgWidthNames.Cells[0, i] := s;
      sgWidthNames.Cells[1, i] := tblWidthNamesWidth.value;
      tblWidthNames.next;
    end;
  end;
end;

procedure TfmWidthNames.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmWidthNames.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmWidthNames.sgWidthNamesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    CanSelect := False;
  CurrentRow := ARow;
end;

procedure TfmWidthNames.SetTabStops(Editing: Boolean);
begin
  sgWidthNames.TabStop := not Editing;
  dbgWidthNames.TabStop := Editing;
end;

procedure TfmWidthNames.Pass;
begin
  tblWidthnames.open;
  UpdateWidthsCopy;

  SetTabStops(False);
end;

procedure TfmWidthNames.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
