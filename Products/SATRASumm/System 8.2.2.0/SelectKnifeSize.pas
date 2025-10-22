unit SelectKnifeSize;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ToolWin, ComCtrls, SysUtils,
  DBCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Dialogs;

type
  TfmSelectKnifeSize = class(TForm)
    tbMain: TPanel;
    btnCancel: TSpeedButton;
    btnSave: TSpeedButton;
    cbMeasuredSize: TComboBox;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbMeasuredSizeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSelectKnifeSize: TfmSelectKnifeSize;

implementation

uses
  Windows, General, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmSelectKnifeSize.btnCancelClick(Sender: TObject);
begin
  fmSelectKnifeSize.ModalResult := mrCancel;
end;

procedure TfmSelectKnifeSize.FormActivate(Sender: TObject);
begin
  cbMeasuredSize.SetFocus;
end;

procedure TfmSelectKnifeSize.FormShow(Sender: TObject);
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

procedure TfmSelectKnifeSize.btnSaveClick(Sender: TObject);
var
  i, j: integer;

begin
  j := -1;
  for i := 0 to cbMeasuredSize.Items.Count - 1 do
  begin
    if cbMeasuredSize.Items[i] = cbMeasuredSize.Text then
      j := i;
  end;

  if j <> -1 then
  begin
    fmSelectKnifeSize.ModalResult := mrOK;

    if (j < cbMeasuredSize.Items.Count - 1) then
      NextSetSize := cbMeasuredSize.Items[j + 1];
  end
  else
    MessageDlgPos('Invalid size', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

procedure TfmSelectKnifeSize.cbMeasuredSizeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmSelectKnifeSize.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
