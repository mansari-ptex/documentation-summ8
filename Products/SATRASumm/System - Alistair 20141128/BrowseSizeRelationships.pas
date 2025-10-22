unit BrowseSizeRelationships;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls,
  Buttons, ComCtrls, Grids, DBGridPlus, DBGrids, ToolWin;

type
  TfmBrowseSizeRelationships = class(TForm)
    dsSizeRelationships: TDataSource;
    dbgSizeRelationships: TDBGridPlus;
    qSizeRelationships: TFDQueryPlus;
    qSizeRelationshipsRelationship: TStringField;
    qSizeRelationshipsRange: TStringField;
    qSizeRelationshipsDescription: TStringField;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    lblRelationship: TLabel;
    lblSearch: TLabel;
    procedure edSearchChange(Sender: TObject);
    procedure dbgSizeRelationshipsDblClick(Sender: TObject);
    procedure dbgSizeRelationshipsKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSizeRelationshipsTitleClick(Column: TColumn);
    procedure dbgSizeRelationshipsCellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmBrowseSizeRelationships: TfmBrowseSizeRelationships;

implementation

uses
  Windows, Graphics, SummsVars, General;

{$R *.DFM}

procedure TfmBrowseSizeRelationships.edSearchChange(Sender: TObject);
begin
  if edSearch.Text = ActiveSearch then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmBrowseSizeRelationships.dbgSizeRelationshipsDblClick(Sender: TObject);
begin
  Close;
end;

procedure TfmBrowseSizeRelationships.dbgSizeRelationshipsKeyPress(Sender: TObject;
                                                               var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgSizeRelationshipsDblClick(Self);
end;

procedure TfmBrowseSizeRelationships.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  ActiveSearch := '';
  qSizeRelationships.ParamByName('Search').AsString := '%';
  qSizeRelationships.Open;

  dbgSizeRelationships.SortColumn := 0;
  dbgSizeRelationships.SortOrder := soAscending;
  dbgSizeRelationships.Refresh;
end;

procedure TfmBrowseSizeRelationships.FormHide(Sender: TObject);
begin
  lblRelationship.caption := qSizeRelationshipsRelationship.value;
end;

procedure TfmBrowseSizeRelationships.FormShow(Sender: TObject);
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

procedure TfmBrowseSizeRelationships.btnRefreshClick(Sender: TObject);
begin
  qSizeRelationships.Close;
  if edSearch.Font.Color = clRed then
    qSizeRelationships.ParamByName('Search').AsString := edSearch.text + '%';
  qSizeRelationships.Open;

  edSearch.Font.Color := OurColor(clWindowText);
  ActiveSearch := edSearch.Text;
end;

procedure TfmBrowseSizeRelationships.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmBrowseSizeRelationships.dbgSizeRelationshipsTitleClick(
  Column: TColumn);
var
  SQLString: string;
  i: integer;

begin
  dbgSizeRelationships.OnDblClick := nil;

  if (Column.FieldName = 'Relationship') or (Column.Fieldname = 'Description') then
  begin
    dbgSizeRelationships.SortColumn := Column.Index;

    if dbgSizeRelationships.SortOrder = soAscending then
    begin
      dbgSizeRelationships.SortOrder := soDescending;
      SQLString := ' DESC';
    end
    else
    begin
      dbgSizeRelationships.SortOrder := soAscending;
      SQLString := ' ASC';
    end;

    qSizeRelationships.Close;
    qSizeRelationships.SQL.Text := 'SELECT Relationship, Range, Description FROM SizeRelationships WHERE Relationship LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Relationship ' + SQLString ;
    qSizeRelationships.Open;
  end;
end;

procedure TfmBrowseSizeRelationships.dbgSizeRelationshipsCellClick(
  Column: TColumn);
begin
  dbgSizeRelationships.OnDblClick := dbgSizeRelationshipsDblClick;
end;

end.
