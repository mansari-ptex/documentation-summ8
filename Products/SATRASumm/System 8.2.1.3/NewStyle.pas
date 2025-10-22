unit NewStyle;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBCtrls,
  Buttons, ExtCtrls, ComCtrls,  ToolWin, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmNewStyle = class(TForm)
    eNewStyleCode: TEdit;
    cbAutoCreateConstruction: TCheckBox;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qStyleConstructions: TFDQueryPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    qConstructionsAndStyles: TFDQueryPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eAnyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNewStyle: TfmNewStyle;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs, StyleDetails, OutOfMemory,
  AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmNewStyle.btnSaveClick(Sender: TObject);
var
  Code, ErrorMessage, SQLString: string;
  AddToStyle, Failed, StyleCreated: boolean;
  fmStyleDetails: TfmStyleDetails;

begin
  AddToStyle := cbAutoCreateConstruction.Checked;

  Code := eNewStyleCode.Text;
  if Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  SQLString := 'INSERT INTO Styles (Style) VALUES (''' + QS(Code) + ''');';

  if AddToStyle then
    SQLString := SQLString + #13 + 'INSERT INTO Construc (Construction) VALUES (''' + QS(Code) + ''');';

  StyleCreated := True;
  try
    qConstructionsAndStyles.SQL.Text := SQLString;
    qConstructionsAndStyles.ExecSQL;
  except
    on E: EDatabaseError do
    begin
      ErrorMessage := E.Message;
      if pos('STYLES:PRIMARY', E.Message) > 0 then
        StyleCreated := False;

      if pos('CONSTRUC:PRIMARY', E.Message) > 0 then
        if MessageDlgPos('Construction already exists - Add to Style?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrNo then
          AddToStyle := False;
    end
    else
    begin
      StyleCreated := False;

      raise;
    end;
  end;

  if not StyleCreated then
  begin
    LocalConnectionSumms.Rollback;
    fmErrorHandler.DebugMessageDlg('Style already exists', ErrorMessage, qConstructionsAndStyles.Text);
    eNewStyleCode.SetFocus;
    eNewStyleCode.SelectAll;
  end
  else
  begin
    LocalConnectionSumms.Commit;

    if AddToStyle then
    begin
      if not LocalConnectionSumms.Connected then
        LocalConnectionSumms.Connected := True;

      LocalConnectionSumms.StartTransaction;
      SQLString := 'INSERT INTO StyConst (Style, Construction) VALUES (''' + QS(Code) + ''', ''' + QS(Code) +''');';
      qStyleConstructions.SQL.Text := SQLString + #13 + 'UPDATE Styles SET CurrentCon = ''' + QS(Code) +
                                      ''' WHERE Style = ''' + QS(Code) + ''';';

      try
        qStyleConstructions.ExecSQL;
        LocalConnectionSumms.Commit;
      except
        MessageDlgPos('Construction NOT added to style', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
        LocalConnectionSumms.Rollback;
      end;
    end;

    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmStyleDetails := TfmStyleDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmStyleDetails.PassStyleName(fmStyleDetails, Code);
      if fmSumms.mmAutoEdit.Checked then
        fmStyleDetails.btnEdit.Click;
    end;

    Close;
  end;
end;

procedure TfmNewStyle.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewStyle.FormActivate(Sender: TObject);
begin
  eNewStyleCode.Text := '';
  eNewStyleCode.SetFocus;
end;

procedure TfmNewStyle.eAnyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewStyle.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  cbAutoCreateConstruction.Checked := AutoCreateConstruction;
end;

procedure TfmNewStyle.FormShow(Sender: TObject);
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

procedure TfmNewStyle.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmNewStyle.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

end.
