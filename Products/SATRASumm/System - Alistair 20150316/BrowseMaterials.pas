unit BrowseMaterials;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls,
  Buttons, ComCtrls, Grids, DBGridPlus, DBGrids, ToolWin;

type
  TfmBrowseMaterials = class(TForm)
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    lblMaterial: TLabel;
    dbgMaterials: TDBGridPlus;
    qMaterials: TFDQueryPlus;
    qMaterialsCode: TStringField;
    qMaterialsDescription: TStringField;
    dsqMaterials: TDataSource;
    lblSearch: TLabel;
    procedure dbgMaterialsDblClick(Sender: TObject);
    procedure dbgMaterialsKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgMaterialsTitleClick(Column: TColumn);
    procedure dbgMaterialsCellClick(Column: TColumn);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmBrowseMaterials: TfmBrowseMaterials;

implementation

uses
  Windows, Graphics, SummsVars, General;

{$R *.DFM}

procedure TfmBrowseMaterials.dbgMaterialsDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmBrowseMaterials.dbgMaterialsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgMaterialsDblClick(Self);
end;

procedure TfmBrowseMaterials.edSearchChange(Sender: TObject);
begin
  if edSearch.Text = ActiveSearch then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmBrowseMaterials.FormShow(Sender: TObject);
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

procedure TfmBrowseMaterials.FormHide(Sender: TObject);
begin
  lblMaterial.caption := qMaterialsCode.value;
end;

procedure TfmBrowseMaterials.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  ActiveSearch := '';
  qMaterials.ParamByName('Search').AsString := '%';
  qMaterials.Open;

  dbgMaterials.SortColumn := 0;
  dbgMaterials.SortOrder := soAscending;
  dbgMaterials.Refresh;
end;

procedure TfmBrowseMaterials.btnRefreshClick(Sender: TObject);
begin
  qMaterials.Close;
  if edSearch.Font.Color = clRed then
    qMaterials.ParamByName('Search').AsString := edSearch.text + '%';
  qMaterials.Open;

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

procedure TfmBrowseMaterials.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmBrowseMaterials.dbgMaterialsTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  dbgMaterials.OnDblClick := nil;

  if (Column.FieldName = 'Code') or (Column.Fieldname = 'Description') then
  begin
    dbgMaterials.SortColumn := Column.Index;

    if dbgMaterials.SortOrder = soAscending then
    begin
      dbgMaterials.SortOrder := soDescending;
      SQLString := ' DESC';
    end
    else
    begin
      dbgMaterials.SortOrder := soAscending;
      SQLString := ' ASC';
    end;

    qMaterials.Close;
    qMaterials.SQL.Text := 'SELECT Code,Description FROM Material WHERE Code LIKE :Search Order By UPPER(' +
                            Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
    qMaterials.Open;
  end;
end;

procedure TfmBrowseMaterials.dbgMaterialsCellClick(Column: TColumn);
begin
  dbgMaterials.OnDblClick := dbgMaterialsDblClick;
end;

end.

