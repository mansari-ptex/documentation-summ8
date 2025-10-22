unit BrowseSizeScales;

interface

uses
  Classes, Controls, Forms, ExtCtrls, StdCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  Buttons, ComCtrls, Grids, DBGridPlus, DBGrids, ToolWin;

type
  TfmBrowseSizeScales = class(TForm)
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    qSizeScales: TFDQueryPlus;
    qSizeScalesScale: TStringField;
    qSizeScalesDescription: TStringField;
    dsSizeScales: TDataSource;
    lblScale: TLabel;
    dbgSizeScales: TDBGridPlus;
    lblSearch: TLabel;
    procedure dbgSizeScalesDblClick(Sender: TObject);
    procedure dbgSizeScalesKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSizeScalesTitleClick(Column: TColumn);
    procedure dbgSizeScalesCellClick(Column: TColumn);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmBrowseSizeScales: TfmBrowseSizeScales;

implementation

uses
  Windows, Graphics, SummsVars, General, Summs;

{$R *.DFM}

procedure TfmBrowseSizeScales.dbgSizeScalesDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmBrowseSizeScales.dbgSizeScalesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgSizeScalesDblClick(Self);
end;

procedure TfmBrowseSizeScales.edSearchChange(Sender: TObject);
begin
  if edSearch.Text = ActiveSearch then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmBrowseSizeScales.FormShow(Sender: TObject);
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

procedure TfmBrowseSizeScales.FormHide(Sender: TObject);
begin
  lblScale.caption := qSizeScalesScale.value;
end;

procedure TfmBrowseSizeScales.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  ActiveSearch := '';
  qSizeScales.ParamByName('Search').AsString := '%';
  qSizeScales.Open;

  dbgSizeScales.SortColumn := 0;
  dbgSizeScales.SortOrder := soAscending;
  dbgSizeScales.Refresh;
end;

procedure TfmBrowseSizeScales.btnRefreshClick(Sender: TObject);
begin
  qSizeScales.Close;
  if edSearch.Font.Color = clRed then
    qSizeScales.ParamByName('Search').AsString := edSearch.text + '%';
  qSizeScales.Open;

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

procedure TfmBrowseSizeScales.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmBrowseSizeScales.dbgSizeScalesTitleClick(Column: TColumn);
var
  SQLString: string;

begin
//  if fmSumms.ActiveMDIChild = Self then
  begin
    dbgSizeScales.OnDblClick := nil;

    if (Column.FieldName = 'Scale') or (Column.Fieldname = 'Description') then
    begin
      SortOrder(dbgSizeScales, Column, SQLString);

      qSizeScales.Close;
      qSizeScales.SQL.Text := 'SELECT Scale, Description FROM SizeScales WHERE Scale LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Scale ' + SQLString ;
      qSizeScales.Open;
    end;
  end;
end;

procedure TfmBrowseSizeScales.dbgSizeScalesCellClick(Column: TColumn);
begin
  dbgSizeScales.OnDblClick := dbgSizeScalesDblClick;
end;

end.
