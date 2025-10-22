unit AllSyntheticMaterials;

interface

uses
  Classes, Controls, Forms, Types, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, ExtCtrls,
  Menus, Buttons, ComCtrls,   ToolWin, Grids, DBGridPlus, DBGrids,
  XStringGrid, XStringGridPlus, jpeg, General_Interlocking, Mask, DBCtrls;

type
  TfmAllSyntheticMaterials = class(TForm)
    dsMaterials: TDataSource;
    qMaterials: TFDQueryPlus;
    qMaterialsCode: TStringField;
    qMaterialsDescription: TStringField;
    qMaterialsLength: TFloatField;
    qMaterialsWidth: TFloatField;
    qMaterialsCutType: TStringField;
    qMaterialsCutGap: TSmallintField;
    qMaterialsUnits: TStringField;
    qMaterialsRestrictiveYesNo: TStringField;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    qMaterialsType: TStringField;
    dbgMaterials: TDBGridPlus;
    lblSearch: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure dbgMaterialsDblClick(Sender: TObject);
    procedure dbgMaterialsKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure dbgMaterialsTitleClick(Column: TColumn);
    procedure dbgMaterialsCellClick(Column: TColumn);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmAllSyntheticMaterials: TfmAllSyntheticMaterials;

implementation

uses
  SysUtils, Windows, Graphics, Dialogs, LayMain, SummsVars, General;

{$R *.DFM}

procedure TfmAllSyntheticMaterials.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmAllSyntheticMaterials.dbgMaterialsDblClick(Sender: TObject);
begin
  //CJY: qMaterials.FetchOptions.RecordCountMode set to cmTotal
  if (qMaterials.RecordCount >= 1) then
    ModalResult := mrOK
  else
    ModalResult := mrCancel;
end;

procedure TfmAllSyntheticMaterials.dbgMaterialsKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgMaterialsDblClick(Self);
end;

procedure TfmAllSyntheticMaterials.FormShow(Sender: TObject);
begin
  edSearch.Font.Color := clRed;
  ActiveSearch := '';
  qMaterials.ParamByName('Search').AsString := '%';
  qMaterials.Open;
  if not(edSearch.Text = '') then
    btnRefresh.click;
end;

procedure TfmAllSyntheticMaterials.btnRefreshClick(Sender: TObject);
begin
  qMaterials.Close;
  if edSearch.Font.Color = clRed then
    qMaterials.ParamByName('Search').AsString := edSearch.text + '%';
  qMaterials.Open;

  edSearch.Font.Color := OurColor(clWindowText);
  ActiveSearch := edSearch.Text;
end;

procedure TfmAllSyntheticMaterials.edSearchChange(Sender: TObject);
begin
  if edSearch.Text = ActiveSearch then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmAllSyntheticMaterials.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllSyntheticMaterials.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  dbgMaterials.SortColumn := 0;
  dbgMaterials.SortOrder := soAscending;
  dbgMaterials.Refresh;
end;

procedure TfmAllSyntheticMaterials.dbgMaterialsTitleClick(Column: TColumn);
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
    qMaterials.SQL.Text := 'SELECT Code, Description, Type, CutType, Length, Width, CutGap, Units, IIF(CutType = ''R'', ''Yes'', ''No'') as RestrictiveYesNo ' +
                           'FROM Material WHERE ((Type = ''R'') or (Type = ''S'')) AND (Code LIKE :Search) Order By UPPER(' +
                            Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
    qMaterials.Open;
  end;
end;

procedure TfmAllSyntheticMaterials.dbgMaterialsCellClick(Column: TColumn);
begin
  dbgMaterials.OnDblClick := dbgMaterialsDblClick;
end;

end.

