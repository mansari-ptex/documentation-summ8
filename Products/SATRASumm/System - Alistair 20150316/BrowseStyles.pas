unit BrowseStyles;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls,
  Buttons, ComCtrls, Grids, DBGridPlus, DBGrids, ToolWin;

type
  TfmBrowseStyles = class(TForm)
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    lblStyle: TLabel;
    dbgStyles: TDBGridPlus;
    qStyles: TFDQueryPlus;
    qStylesStyle: TStringField;
    qStylesDescription: TStringField;
    dsqStyles: TDataSource;
    lblSearch: TLabel;
    procedure dbgStylesDblClick(Sender: TObject);
    procedure dbgStylesKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgStylesTitleClick(Column: TColumn);
    procedure dbgStylesCellClick(Column: TColumn);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmBrowseStyles: TfmBrowseStyles;

implementation

uses
  Windows, Graphics, SummsVars, General;

{$R *.DFM}

procedure TfmBrowseStyles.dbgStylesDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmBrowseStyles.dbgStylesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgStylesDblClick(Self);
end;

procedure TfmBrowseStyles.edSearchChange(Sender: TObject);
begin
  if edSearch.Text = ActiveSearch then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmBrowseStyles.FormShow(Sender: TObject);
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

procedure TfmBrowseStyles.FormHide(Sender: TObject);
begin
  lblStyle.caption := qStylesStyle.value;
end;

procedure TfmBrowseStyles.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  ActiveSearch := '';
  qStyles.ParamByName('Search').AsString := '%';
  qStyles.Open;

  dbgStyles.SortColumn := 0;
  dbgStyles.SortOrder := soAscending;
  dbgStyles.Refresh;
end;

procedure TfmBrowseStyles.btnRefreshClick(Sender: TObject);
begin
  qStyles.Close;
  if edSearch.Font.Color = clRed then
    qStyles.ParamByName('Search').AsString := edSearch.text + '%';
  qStyles.Open;

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

procedure TfmBrowseStyles.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmBrowseStyles.dbgStylesTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  dbgStyles.OnDblClick := nil;

  if (Column.FieldName = 'Style') or (Column.Fieldname = 'Description') then
  begin
    dbgStyles.SortColumn := Column.Index;

    if dbgStyles.SortOrder = soAscending then
    begin
      dbgStyles.SortOrder := soDescending;
      SQLString := ' DESC';
    end
    else
    begin
      dbgStyles.SortOrder := soAscending;
      SQLString := ' ASC';
    end;

    qStyles.Close;
    qStyles.SQL.Text := 'SELECT Style, Description FROM Styles WHERE Style LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Style ' + SQLString ;
    qStyles.Open;
  end;
end;

procedure TfmBrowseStyles.dbgStylesCellClick(Column: TColumn);
begin
  dbgStyles.OnDblClick := dbgStylesDblClick;
end;

end.

