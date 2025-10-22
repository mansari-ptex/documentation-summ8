unit ImportTimeLineElements;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CButton, Mask, jpeg, ExtCtrls,
  General, DB,  Grids, DBGridPlus,  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  ToolWin, ComCtrls, CheckLst, DBCtrls, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, CmnVars, DBGrids, FDConnectionPlus;

type
  TfmImportTimeLineElements = class(TForm)
    ConnectionTimeLine: TFDConnectionPlus;
    tblElementTimes: TFDTablePlus;
    dsElements: TDataSource;
    qTimeLineElements: TFDQueryPlus;
    qTimeLineElementsCode: TStringField;
    qTimeLineElementsDescription: TStringField;
    qTimeLineElementsMachining: TBooleanField;
    qTimeLineElementsPerBatch: TBooleanField;
    qTimeLineElementsTime: TFloatField;
    qTimeLineElementsTimeDisplay: TFloatField;
    qTimeLineElementsPerBatchDisplay: TStringField;
    qTimeLineElementsSelected: TBooleanField;
    dsTimeLineElements: TDataSource;
    tbMain: TPanel;
    tblTimeLineLocks: TFDTablePlus;
    tblTimeLineElements: TFDTablePlus;
    tblTimeLineElementTimes: TFDTablePlus;
    tblElementTimesCode: TStringField;
    tblElementTimesTime: TFloatField;
    tblElements: TFDTablePlus;
    tblElementsCode: TStringField;
    tblElementsDescription: TStringField;
    tblElementsCuttingCategory: TStringField;
    tblElementTimesDescription: TStringField;
    tblTimeLineElementsCode: TStringField;
    tblTimeLineElementsDescription: TStringField;
    tblTimeLineElementsMachining: TBooleanField;
    tblTimeLineElementsMachiningFeedRate: TFloatField;
    tblTimeLineElementsCutting: TBooleanField;
    tblTimeLineElementsCuttingCategory: TStringField;
    tblTimeLineElementsNotes: TMemoField;
    tblTimeLineElementsValueAdded: TBooleanField;
    tblTimeLineElementTimesCode: TStringField;
    tblTimeLineElementTimesTime: TFloatField;
    tblElementTimesTimeLineTime: TFloatField;
    tblElementTimesTimeLineDescription: TStringField;
    pnlTitlesMain: TPanel;
    pnlTitles2: TPanel;
    pnlTitles1: TPanel;
    pnlTitles3: TPanel;
    dbgElements: TDBGridPlus;
    pnlTimeLineLogin: TPanel;
    btnCancel: TSpeedButton;
    btnSave: TSpeedButton;
    pnlTimeLineLoginMain: TPanel;
    imgTimeLineSplash: TImage;
    pnlLogin: TPanel;
    lblUserName: TLabel;
    lblPassword: TLabel;
    edtUserName: TEdit;
    medtPassword: TMaskEdit;
    btnLogin: TColButton;
    btnLoginCancel: TColButton;
    sbMain: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure edtUserNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnLoginClick(Sender: TObject);
    procedure btnLoginCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgElementsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmImportTimeLineElements: TfmImportTimeLineElements;

implementation

uses ParamGeneral, SummsVars;

{$R *.dfm}

procedure TfmImportTimeLineElements.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);

  if pnlTimeLineLogin.visible then
  begin
    edtUserName.Text := '';
    medtPassword.Text := '';
    edtUserName.setfocus;
  end
  else
  begin
    qTimeLineElements.close;
    qTimeLineElements.Open;
    tblElementTimes.Refresh;
    tblElementTimes.First;
    dbgElements.setfocus;
  end;
end;

procedure TfmImportTimeLineElements.edtUserNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(key) = VK_ESCAPE then
    close
  else if ord(key) = VK_RETURN then
    btnLogin.click;
end;

procedure TfmImportTimeLineElements.btnLoginClick(Sender: TObject);
var
  UserName, Password: string;

begin
  UserName := edtUserName.text;
  Password := medtPassword.text;

  Application.Processmessages;
  Connection(ConnectionTimeLine,  'TIMELINE2', UserName, Password, False);

  if not ConnectionTimeLine.Connected then
    close
  else
  begin
    pnlTimeLineLogin.visible := False;

    tblTimeLineLocks.Open;
    tblTimeLineElements.Open;
    qTimeLineElements.Open;
    tblElementTimes.open;
    dbgElements.setfocus;

    btnSave.enabled := True;
    btnCancel.enabled := True;
  end;
end;

procedure TfmImportTimeLineElements.btnSaveClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  screen.cursor := crHourGlass;

  tblElementTimes.DisableControls;
  MyBookmark := tblElementTimes.GetBookmark;

  ConnectionTimeLine.StartTransaction;

  try
    tblElementTimes.First;
    while not tblElementTimes.eof do
    begin
      tblElementTimes.edit;
      tblElementTimesTime.value := tblElementTimesTimeLineTime.value;
      tblElementTimes.post;

      tblElements.FindKey([tblElementTimesCode.Value]);
      tblElements.edit;
      tblElementsDescription.Value := tblElementTimesTimeLineDescription.value;
      tblElements.post;

      tblElementTimes.Next;
    end;
    ConnectionTimeLine.Commit;
  except
    ConnectionTimeLine.Rollback;
  end;

  tblElementTimes.Refresh;
  dbgElements.Refresh;

  try
    tblElementTimes.GotoBookmark(MyBookmark);
  except
  end;
  tblElementTimes.FreeBookmark(MyBookmark);
  tblElementTimes.EnableControls;

  screen.cursor := crDefault;

  close;
end;

procedure TfmImportTimeLineElements.btnLoginCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfmImportTimeLineElements.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fmParametersGeneral.tblParameters.cancel;
end;

procedure TfmImportTimeLineElements.dbgElementsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  s: ansistring;
  Time, TimeLineTime: integer;

begin
  s := Column.FieldName;

  //Compare to 4dp
  //What we want is below...
  //Time := round(tblElementTimesTime.value * 10000);
  //TimeLineTime := round(tblElementTimesTimeLineTime.value * 10000);
  //however e.g despite typing 0.21025 into the SATRASumm database the
  //figure comes back as 2102 rather than 2103. This is due to some
  //internal representation of the number. Rounding and then rerounding
  //gets around this.
  Time := round((round(tblElementTimesTime.value * 10000000000) / 1000000) * 10000);
  TimeLineTime := round((round(tblElementTimesTimeLineTime.value * 10000000000) / 1000000) * 10000);

  if (((Column.FieldName = 'Description') or (Column.FieldName = 'TimeLineDescription')) and
     (tblElementTimesDescription.value <> tblElementTimesTimeLineDescription.value)) or
     (((Column.FieldName = 'Time') or (Column.FieldName = 'TimeLineTime')) and
     (Time <> TimeLineTime)) then
  begin
    if not (gdSelected in State) then
      dbgElements.Canvas.Font.color := clRed
    else
      dbgElements.Canvas.Font.color := clYellow;
  end
  else
  begin
    if not (gdSelected in State) then
      dbgElements.Canvas.Font.color := OurColor(clWindowText)
    else
      dbgElements.Canvas.Font.Color := clHighlightText;
  end;

  dbgElements.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfmImportTimeLineElements.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmImportTimeLineElements.FormCreate(Sender: TObject);
begin
	AutoColor(Self);
end;

end.
