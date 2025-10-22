unit BrowseSizeRanges;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls,
  Buttons, ComCtrls, Grids, DBGridPlus, DBGrids, ToolWin;

type
  TfmBrowseSizeRanges = class(TForm)
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    lblRange: TLabel;
    dbgSizeRanges: TDBGridPlus;
    qSizeRanges: TFDQueryPlus;
    qSizeRangesRange: TStringField;
    qSizeRangesScale: TStringField;
    qSizeRangesDescription: TStringField;
    dsSizeRanges: TDataSource;
    lblSearch: TLabel;
    procedure dbgSizeRangesDblClick(Sender: TObject);
    procedure dbgSizeRangesKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSizeRangesTitleClick(Column: TColumn);
    procedure dbgSizeRangesCellClick(Column: TColumn);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmBrowseSizeRanges: TfmBrowseSizeRanges;

implementation

uses
  Windows, Graphics, SummsVars, General;

{$R *.DFM}

procedure TfmBrowseSizeRanges.dbgSizeRangesDblClick(Sender: TObject);
begin
  Close;
end;

procedure TfmBrowseSizeRanges.dbgSizeRangesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgSizeRangesDblClick(Self);
end;

procedure TfmBrowseSizeRanges.edSearchChange(Sender: TObject);
begin
  if edSearch.Text = ActiveSearch then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmBrowseSizeRanges.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  edSearch.text := '';
  edSearch.SetFocus;
  edSearch.SelectAll;
  btnRefresh.Click;
end;

procedure TfmBrowseSizeRanges.FormHide(Sender: TObject);
begin
  lblRange.caption := qSizeRangesRange.value;
end;

procedure TfmBrowseSizeRanges.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  ActiveSearch := '';
  qSizeRanges.ParamByName('Search').AsString := '%';
  qSizeRanges.Open;

  dbgSizeRanges.SortColumn := 0;
  dbgSizeRanges.SortOrder := soAscending;
  dbgSizeRanges.Refresh;
end;

procedure TfmBrowseSizeRanges.btnRefreshClick(Sender: TObject);
begin
  qSizeRanges.Close;
  if edSearch.Font.Color = clRed then
    qSizeRanges.ParamByName('Search').AsString := edSearch.text + '%';
  qSizeRanges.Open;

  edSearch.Font.Color := OurColor(clWindowText);
  ActiveSearch := edSearch.Text;
end;

procedure TfmBrowseSizeRanges.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmBrowseSizeRanges.dbgSizeRangesTitleClick(Column: TColumn);
var
  SQLString: string;
  i: integer;

begin
  dbgSizeRanges.OnDblClick := nil;

  if (Column.FieldName = 'Range') or (Column.Fieldname = 'Description') then
  begin
    dbgSizeRanges.SortColumn := Column.Index;

    if dbgSizeRanges.SortOrder = soAscending then
    begin
      dbgSizeRanges.SortOrder := soDescending;
      SQLString := ' DESC';
    end
    else
    begin
      dbgSizeRanges.SortOrder := soAscending;
      SQLString := ' ASC';
    end;

    qSizeRanges.Close;
    qSizeRanges.SQL.Text := 'SELECT Range, Scale, Description FROM SizeRanges WHERE Range LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Range ' + SQLString ;
    qSizeRanges.Open;
  end;
end;

procedure TfmBrowseSizeRanges.dbgSizeRangesCellClick(Column: TColumn);
begin
  dbgSizeRanges.OnDblClick := dbgSizeRangesDblClick;
end;

end.

