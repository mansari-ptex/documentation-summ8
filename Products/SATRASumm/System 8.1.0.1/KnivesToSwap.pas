unit KnivesToSwap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus;

type
  TfmKnivesToSwap = class(TForm)
    tbMain: TPanel;
    btnOK: TSpeedButton;
    btnCancel: TSpeedButton;
    btnBrowse: TSpeedButton;
    tblParts: TFDTablePlus;
    eOldKnifeCode: TEdit;
    eNewKnifeCode: TEdit;
    lblFrom: TLabel;
    lblTo: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure sbBrowseNewKnivesClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sbBrowseOldKnivesClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure eAnyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmKnivesToSwap: TfmKnivesToSwap;

implementation

uses
  Dialogs, General, SwapKnvs, BrowseKnives, Summs, SummsVars;

{$R *.DFM}

procedure TfmKnivesToSwap.btnOKClick(Sender: TObject);
var
  LockSuccess, NoParts, NoToKnife : boolean;

begin
  //Attempt Lock
  LockSuccess := LockOption(fmSumms.tblLocks, oSwapKnives);

  if LockSuccess then
  begin
    fmSwapKnives.OldCode := eOldKnifeCode.text;
    fmSwapKnives.NewCode := eNewKnifeCode.text;
    fmSwapKnives.Position := poScreenCenter;
    fmSwapKnives.ClientHeight := 285;
    fmSwapKnives.ClientWidth := 336;

    //Attempt Lock
    tblParts.Open;
    LockSuccess := LockGroupIncStatusBar(oPart, fmSumms.tblLocks, tblParts, fmSwapKnives.sbMain);

    if LockSuccess then
    begin
      fmSwapKnives.ShowKnives(NoParts, NoToKnife);

      if not NoToKnife then
      begin
        if not(NoParts) then
        begin
          fmSwapKnives.ShowModal;
          Close;
        end
        else
        begin
          MessageDlgPos('''From'' Knife not used or does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
          LocksUnLockRecord(fmSumms.tblLocks, 'SWAP_KNIVES');
        end;
      end
      else
      begin
        MessageDlgPos('''To'' Knife does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
        LocksUnLockRecord(fmSumms.tblLocks, 'SWAP_KNIVES');
      end;

      //Release Lock
      LocksUnLockRecordIncStatusBar(fmSumms.tblLocks, 'GROUP_PARTS', fmSwapKnives.sbMain)
    end;

    LocksUnLockRecord(fmSumms.tblLocks, 'SWAP_KNIVES');
  end;
end;

procedure TfmKnivesToSwap.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmKnivesToSwap.sbBrowseNewKnivesClick(Sender: TObject);
begin
  fmBrowseKnives.ShowModal;
  eNewKnifeCode.text := fmBrowseKnives.lblKnife.caption;
end;

procedure TfmKnivesToSwap.sbBrowseOldKnivesClick(Sender: TObject);
begin
  fmBrowseKnives.ShowModal;
  eOldKnifeCode.text := fmBrowseKnives.lblKnife.caption;
end;

procedure TfmKnivesToSwap.FormActivate(Sender: TObject);
begin
  eOldKnifeCode.Text := '';
  eNewKnifeCode.Text := '';
  eOldKnifeCode.SetFocus;
end;

procedure TfmKnivesToSwap.btnBrowseClick(Sender: TObject);
begin
  if fmBrowseKnives.ShowModal = mrOK then
  begin
    if eOldKnifeCode.Focused then
      eOldKnifeCode.text := fmBrowseKnives.lblKnife.caption;

    if eNewKnifeCode.Focused then
      eNewKnifeCode.text := fmBrowseKnives.lblKnife.caption;
  end;
end;

procedure TfmKnivesToSwap.FormShow(Sender: TObject);
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

procedure TfmKnivesToSwap.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

procedure TfmKnivesToSwap.eAnyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOk.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

end.
