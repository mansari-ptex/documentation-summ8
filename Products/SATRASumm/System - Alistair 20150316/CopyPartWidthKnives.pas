unit CopyPartWidthKnives;

interface

uses
  Classes, Controls, Forms, StdCtrls, PartDetails, Buttons, ExtCtrls, ComCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Db, ToolWin;

type
  TfmCopyPartWidthKnives = class(TForm)
    cbWidthsForRange: TComboBox;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qCopyWidth: TFDQueryPlus;
    qKnivesOnWidth: TFDQueryPlus;
    lblCode: TLabel;
    procedure PassPartName(PartForm : TfmPartDetails; PartCode : string);
    procedure btnSaveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ParentPartForm : TfmPartDetails;
    ParentPartCode : string;
  public
    { Public declarations }
  end;

var
  fmCopyPartWidthKnives: TfmCopyPartWidthKnives;

implementation

uses
  Dialogs, General, Summs, SummsVars;

{$R *.DFM}

procedure TfmCopyPartWidthKnives.PassPartName(PartForm : TfmPartDetails; PartCode : string);
begin
  ParentPartForm := PartForm;
  ParentPartCode := PartCode;
  cbWidthsForRange.items := ParentPartForm.cbWidthsForRange.items;
end;

procedure TfmCopyPartWidthKnives.btnSaveClick(Sender: TObject);
var
  LockSuccess : boolean;
  OldWidthNo, NewWidthNo : integer;
  sOld, sNew : string;
  GoCopy: boolean;
  slSQL: TStrings;

begin
  OldWidthNo := ParentPartForm.WidthNoForWidth(ParentPartForm.cbWidthsForRange.text);
  NewWidthNo := ParentPartForm.WidthNoForWidth(cbWidthsForRange.text);

  GoCopy := False;
  if (OldWidthNo <= 0) then
    messagedlg('No Width to Copy from', mtInformation, [mbOk], 0)
  else if (NewWidthNo <= 0) then
    messagedlg('No Width to Copy to', mtInformation, [mbOk], 0)
  else if NewWidthNo = OldWidthNo then
    messagedlg('Cannot copy to same width', mtInformation, [mbOk], 0)
  else
    GoCopy := True;

  if GoCopy then
  begin
    qKnivesOnWidth.ParamByName('Part').Value := ParentPartCode;
    qKnivesOnWidth.ParamByName('WidthNo').Value := NewWidthNo;

    qKnivesOnWidth.Open;

    if qKnivesOnWidth.FieldByName('NumKnives').Value > 0 then
      if messagedlg('Overwrite knives on Width ' + cbWidthsForRange.text + '?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        GoCopy := False;

    qKnivesOnWidth.Close;
  end;

  if GoCopy then
  begin
    str(NewWidthNo, sNew);
    str(OldWidthNo, sOld);

    ParentPartForm.LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oPart, fmSumms.tblLocks, ParentPartForm.tblParts, ParentPartCode, True);

    if LockSuccess then
    try
      qCopyWidth.Connection := ParentPartForm.tblParts.Connection;
      qCopyWidth.SQL.Text := 'DELETE FROM PtWidKnf WHERE (WidthNo = ' + sNew + ') AND (Part = ''' + QS(ParentPartCode) + ''');' + #13 +
                             'DELETE FROM PtWidAF WHERE (WidthNo = ' + sNew + ') AND (Part = ''' + QS(ParentPartCode) + ''');' + #13 +
                             'INSERT INTO PtWidAF (Part, WidthNo, AdjFactor) SELECT ''' + QS(ParentPartCode) + ''', ' + sNew +
                             ', AdjFactor FROM PtWidAF WHERE (WidthNo = ' + sOld + ') AND (Part = ''' + QS(ParentPartCode) + ''');' + #13 +
                             'INSERT INTO PtWidKnf (Part, WidthNo, Knife, Seq, Frequency, SizeScale, SizeRange, SizeRelationship, SizeAdjustment) SELECT ''' +
                             QS(ParentPartCode) + ''', ' + sNew + ', Knife, Seq, Frequency, SizeScale, SizeRange, SizeRelationship, SizeAdjustment ' +
                             'FROM PtWidKnf WHERE (WidthNo = ' + sOld + ') AND (Part = ''' + QS(ParentPartCode) + ''');';
      qCopyWidth.ExecSQL;
      ParentPartForm.tblParts.Cancel;
      ParentPartForm.LocalConnectionSumms.Commit;
    except
//    finally
      //Unlock
      ParentPartForm.tblParts.Cancel;
      ParentPartForm.LocalConnectionSumms.Rollback;
    end;
  end;

  if NewWidthNo > 0 then
    close;
end;

procedure TfmCopyPartWidthKnives.FormActivate(Sender: TObject);
begin
  Left := (Screen.width div 2) - (Width div 2);
  Top := (Screen.height div 2) - (Height div 2);
end;

procedure TfmCopyPartWidthKnives.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfmCopyPartWidthKnives.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);
end;

procedure TfmCopyPartWidthKnives.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
