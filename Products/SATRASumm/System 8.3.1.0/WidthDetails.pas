unit WidthDetails;

interface

uses
  Classes, Controls, Forms, StdCtrls, Mask, DBCtrls, Grids, DBGridPlus, DB,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, ExtCtrls, Buttons, ToolWin, ComCtrls, 
  General, CmnVars, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, DBGrids,
  FireDAC.Phys, FDConnectionPlus;

type
  TfmWidthDetails = class(TForm)
    tblWidthRanges: TFDTablePlus;
    dsWidthRanges: TDataSource;
    tblWidthRangeWidths: TFDTablePlus;
    dsWidthRangeWidths: TDataSource;
    tblWidthRangeWidthsWidthNo: TSmallintField;
    tblWidthRangeWidthsRange: TStringField;
    tblWidthRangeWidthsWidth: TStringField;
    tblWidthRangesCode: TStringField;
    tblWidthRangesDescription: TStringField;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    btnRefresh: TSpeedButton;
    btnCopy: TSpeedButton;
    btnWhereUsed: TSpeedButton;
    pnlMain: TPanel;
    lblDescriptionConst: TLabel;
    dbeDescription: TDBEdit;
    pnlView1: TPanel;
    dbtDescription: TDBText;
    pnlWidths: TPanel;
    LocalConnectionSumms: TFDConnectionPlus;
    dbgWidths: TDBGridPlus;
    lblDefaultWidth: TLabel;
    dbtDefaultWidth: TDBText;
    tblWidthRangesWidthNo: TSmallintField;
    btnDefaultWidth: TSpeedButton;
    tblWidthRangesWidth: TStringField;
    qWidths: TFDQuery;
    qWidthsNo: TSmallintField;
    qWidthsWidth: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassWidthRangeName(var Code: string);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnWhereUsedClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure SetTabStops(Editing: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure tblWidthRangeWidthsBeforeDelete(DataSet: TDataSet);
    procedure btnDefaultWidthClick(Sender: TObject);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WidthRangeCode : string;
  end;

var
  fmWidthDetails: TfmWidthDetails;

implementation

uses
  SysUtils, Graphics, Dialogs, WidthRangeWhereUsed, Summs, CopyWidthRange,
  OutOfMemory, AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmWidthDetails.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if tblWidthRanges.state in [dsEdit, dsInsert] then
  begin
    if MessageDlgPos('Save Changes to Width Range ' + WidthRangeCode + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
      btnSave.click
    else
      btnCancel.click;
  end;

  action := caFree;
end;

procedure TfmWidthDetails.PassWidthRangeName(var Code: string);
begin
  WidthRangeCode := Code;

  Caption := 'Width Range : ' + WidthRangeCode;

  screen.cursor := crHourGlass;
  tblWidthRanges.open;
  tblWidthRanges.setRange([WidthRangeCode], [WidthRangeCode]);
  qWidths.open;
  tblWidthRangeWidths.open;
  screen.cursor := crDefault;

  if tblWidthRanges.recordcount = 0 then
  begin
    MessageDlgPos('Width Range ' + WidthRangeCode + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    close;
  end;
end;

procedure TfmWidthDetails.btnDefaultWidthClick(Sender: TObject);
begin
  tblWidthRangesWidthNo.Value := tblWidthRangeWidthsWidthNo.Value;
end;

procedure TfmWidthDetails.btnDeleteClick(Sender: TObject);
var
  LockSuccess : boolean;
  CanDelete : boolean;

begin
  if ItemGone(tblWidthRanges, WidthRangeCode) then
    Close
  else
  begin
    CanDelete := False;

    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingleWithoutOption(oWidthRange, tblWidthRanges, WidthRangeCode);

    if LockSuccess then
    begin
      CanDelete := (MessageDlgPos('Delete Width Range?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes);
      if CanDelete then
      begin
        try
          tblWidthRanges.delete;
        except
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Width Range in use', E.Message, '');
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
    tblWidthRangeWidths.Cancel;
    tblWidthRanges.cancel;
    if CanDelete then
      Close;
  end;
end;

procedure TfmWidthDetails.btnWhereUsedClick(Sender: TObject);
var
  Failed : boolean;

begin
  if ItemGone(tblWidthRanges, WidthRangeCode) then
    Close
  else
  begin
    if not ExistingToFront('Where Used for Width Range', WidthRangeCode) then
    begin
      Screen.cursor := crHourGlass;
      Failed := False;
      try
        fmWidthRangeWhereUsed := TfmWidthRangeWhereUsed.create(fmSumms);
      except
        fmMemoryError.TidyUp(Self);
        Failed := True
      end;

      if not Failed then
        fmWidthRangeWhereUsed.PassWidthRangeName(WidthRangeCode)
    end;
  end;
end;

procedure TfmWidthDetails.btnCopyClick(Sender: TObject);
begin
  if ItemGone(tblWidthRanges, WidthRangeCode) then
    Close
  else
  begin
    fmCopyWidthRange.BaseCode := tblWidthRangesCode.Value;
    fmCopyWidthRange.ShowModal;
  end;
end;

procedure TfmWidthDetails.btnEditClick(Sender: TObject);
var
  LockSuccess: boolean;

begin
  if ItemGone(tblWidthRanges, WidthRangeCode) then
    Close
  else
  begin
    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingleWithoutOption(oWidthRange, tblWidthRanges, WidthRangeCode);

    if LockSuccess then
      UpdateScreen(True)
    else
      LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmWidthDetails.UpdateScreen(Editing : boolean);
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

  btnCopy.enabled := not Editing;
  btnWhereUsed.enabled := not Editing;

  btnDefaultWidth.Enabled := Editing;

  pnlView1.visible := not Editing;

  SetTabStops(Editing);

  if Editing then
  begin
    dbgWidths.Options := dbgWidths.Options + [dgEditing, dgConfirmDelete];
    dbgWidths.color := clEditing;
    dbgWidths.Columns[0].color := clEditing;
  end
  else
  begin
    dbgWidths.Options := dbgWidths.Options - [dgEditing, dgConfirmDelete];
    dbgWidths.color := clBack;
    dbgWidths.Columns[0].color := clBack;
  end;

  if Editing then
    dbeDescription.setfocus
  else
    tbMain.setfocus;
end;

procedure TfmWidthDetails.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblWidthRangeWidths.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblWidthRanges.cancel;

  //Refresh Grids
  tblWidthRangeWidths.refresh;
  dbgWidths.refresh;

  UpdateScreen(False);
end;

procedure TfmWidthDetails.btnSaveClick(Sender: TObject);
var
  FoundDefaultWidth: Boolean;

begin
  if tblWidthRangeWidths.state in [dsEdit, dsInsert] then
    tblWidthRangeWidths.post;

  //Check Default Width is in still in Width Rangle ...
  FoundDefaultWidth := False;
  if not tblWidthRangesWidthNo.isNull then
  begin

    tblWidthRangeWidths.first;
    while not tblWidthRangeWidths.Eof do
    begin
      if tblWidthRangeWidthsWidthNo.value = tblWidthRangesWidthNo.Value then
        FoundDefaultWidth := True;

      tblWidthRangeWidths.next;
    end;
  end;

  //...& clear it if its not
  if not FoundDefaultWidth then
    tblWidthRangesWidthNo.Clear;

  tblWidthRanges.post;
  LocalConnectionSumms.commit;

  UpdateScreen(False);
end;

procedure TfmWidthDetails.btnRefreshClick(Sender: TObject);
begin
  if ItemGone(tblWidthRanges, WidthRangeCode) then
    Close
  else
    tblWidthRangeWidths.refresh;
end;

procedure TfmWidthDetails.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmWidthDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmWidthDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
end;

procedure TfmWidthDetails.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  SetTabStops(False);
end;

procedure TfmWidthDetails.tblWidthRangeWidthsBeforeDelete(
  DataSet: TDataSet);
begin
  if dbgWidths.Columns[0].color = clBack then
    Abort;
end;

end.
