unit DigitiserPatternName;

interface

uses
  Forms, Controls, StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, Classes,
  General;

type
  TfmPatternName = class(TForm)
    ePatternName: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ePatternNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPatternName: TfmPatternName;

implementation

uses
  Windows, PathGlobals, DigitiserMain;

{$R *.DFM}

procedure TfmPatternName.FormShow(Sender: TObject);
begin
  ePatternName.SetFocus;
  ePatternName.Text := '';
end;

procedure TfmPatternName.btnSaveClick(Sender: TObject);
begin
  PatternRef := ePatternName.Text;
  if not(PatternRef = '') then
    ModalResult := mrOK;
end;

procedure TfmPatternName.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmPatternName.ePatternNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.click;
end;

procedure TfmPatternName.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmPatternName.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
