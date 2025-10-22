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
  Windows, Graphics, SummsVars, General;

{$R *.DFM}

procedure TfmBrowseSizeScales.dbgSizeScalesDblClick(Sender: TObject);
begin
  Close;
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
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);

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
  dbgSizeScales.OnDblClick := nil;

  if (Column.FieldName = 'Scale') or (Column.Fieldname = 'Description') then
  begin
    dbgSizeScales.SortColumn := Column.Index;

    if dbgSizeScales.SortOrder = soAscending then
    begin
      dbgSizeScales.SortOrder := soDescending;
      SQLString := ' DESC';
    end
    else
    begin
      dbgSizeScales.SortOrder := soAscending;
      SQLString := ' ASC';
    end;

    qSizeScales.Close;
    qSizeScales.SQL.Text := 'SELECT Scale, Description FROM SizeScales WHERE Scale LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Scale ' + SQLString ;
    qSizeScales.Open;
  end;
end;

procedure TfmBrowseSizeScales.dbgSizeScalesCellClick(Column: TColumn);
begin
  dbgSizeScales.OnDblClick := dbgSizeScalesDblClick;
end;

end.
