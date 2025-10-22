unit BrowseWidthRanges;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls,
  Grids, DBGridPlus, DBGrids, Buttons, ToolWin, ComCtrls;

type
  TfmBrowseWidthRanges = class(TForm)
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    lblWidthRange: TLabel;
    dbgWidthRanges: TDBGridPlus;
    dsWidthRanges: TDataSource;
    qWidthRanges: TFDQueryPlus;
    qWidthRangesCode: TStringField;
    qWidthRangesDescription: TStringField;
    lblSearch: TLabel;
    procedure dbgWidthRangesDblClick(Sender: TObject);
    procedure dbgWidthRangesKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgWidthRangesTitleClick(Column: TColumn);
    procedure dbgWidthRangesCellClick(Column: TColumn);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmBrowseWidthRanges: TfmBrowseWidthRanges;

implementation

uses
  Windows, Graphics, SummsVars, General, Summs;

{$R *.DFM}

procedure TfmBrowseWidthRanges.dbgWidthRangesDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmBrowseWidthRanges.dbgWidthRangesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgWidthRangesDblClick(Self);
end;

procedure TfmBrowseWidthRanges.edSearchChange(Sender: TObject);
begin
  if edSearch.Text = ActiveSearch then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmBrowseWidthRanges.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);

  edSearch.text := '';
  edSearch.SetFocus;
  edSearch.SelectAll;
  btnRefresh.Click;
end;

procedure TfmBrowseWidthRanges.FormHide(Sender: TObject);
begin
  lblWidthRange.caption := qWidthRangesCode.value;
end;

procedure TfmBrowseWidthRanges.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  ActiveSearch := '';
  qWidthRanges.ParamByName('Search').AsString := '%';
  qWidthRanges.Open;

  dbgWidthRanges.SortColumn := 0;
  dbgWidthRanges.SortOrder := soAscending;
  dbgWidthRanges.Refresh;
end;

procedure TfmBrowseWidthRanges.btnRefreshClick(Sender: TObject);
begin
  qWidthRanges.Close;
  if edSearch.Font.Color = clRed then
    qWidthRanges.ParamByName('Search').AsString := edSearch.text + '%';
  qWidthRanges.Open;

  edSearch.Font.Color := OurColor(clWindowText);
  ActiveSearch := edSearch.Text;

  //Fixes Missing Scrollbar on Windows 8
  //if Refresh with nothing selected then
  //refresh again with enough selected that
  //it SHOULD show Scrollbar. Was working
  //as it should on Windows 7 but needs
  //this 'twitch' to work with Windows 8.
  //Included in all 'All' forms.
  Width := Width + 1;
  Width := Width - 1;
end;

procedure TfmBrowseWidthRanges.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmBrowseWidthRanges.dbgWidthRangesTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  //if fmSumms.ActiveMDIChild = Self then
  begin
    dbgWidthRanges.OnDblClick := nil;

    if (Column.FieldName = 'Code') or (Column.Fieldname = 'Description') then
    begin
      SortOrder(dbgWidthRanges, Column, SQLString);

      qWidthRanges.Close;
      qWidthRanges.SQL.Text := 'SELECT Code, Description FROM WRngs WHERE Code LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
      qWidthRanges.Open;
    end;
  end;
end;

procedure TfmBrowseWidthRanges.dbgWidthRangesCellClick(Column: TColumn);
begin
  dbgWidthRanges.OnDblClick := dbgWidthRangesDblClick;
end;

end.

