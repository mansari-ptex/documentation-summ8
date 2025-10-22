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
    cbSearchDescription: TCheckBox;
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
    procedure cbSearchDescriptionClick(Sender: TObject);
  private
    { Private declarations }
    ActiveSearch: String;
    ActiveSearchDescription: Boolean;
    procedure SearchChanged;
    procedure SetSearchQuerySQL;
  public
    { Public declarations }
  end;

var
  fmBrowseStyles: TfmBrowseStyles;

implementation

uses
  Windows, Graphics, SummsVars, General, Summs;

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
  SearchChanged;
end;

procedure TfmBrowseStyles.FormShow(Sender: TObject);
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

procedure TfmBrowseStyles.SearchChanged;
begin
  if (edSearch.Text = ActiveSearch) and (cbSearchDescription.Checked = ActiveSearchDescription) then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmBrowseStyles.SetSearchQuerySQL;
var
  SQLUpDown: string;

begin
  if dbgStyles.SortOrder = soAscending then
    SQLUpDown := 'ASC'
  else
    SQLUpDown := 'DESC';

  qStyles.SQL.Clear;
  qStyles.SQL.Add('SELECT Style, Description, CurrentCon');
  qStyles.SQL.Add('FROM Styles');
  if edSearch.Text <> '' then
  begin
    if not cbSearchDescription.Checked then
      qStyles.SQL.Add('WHERE UPPER(Style) LIKE ''' + edSearch.text + '%''')
    else
    begin
      qStyles.SQL.Add('WHERE ((UPPER(Style) LIKE ''' + edSearch.text + '%'') OR ');
      qStyles.SQL.Add('       (UPPER(Description) LIKE ''%' + edSearch.text + '%''))');
    end;
  end;
  if (dbgStyles.SortColumn = 0) then
    qStyles.SQL.Add('ORDER BY Style ' + SQLUpDown + ', Style ' + SQLUpDown)
  else
    qStyles.SQL.Add('ORDER BY UPPER(Description) ' + SQLUpDown + ', Style ' + SQLUpDown);
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

  dbgStyles.SortColumn := 0;
  dbgStyles.SortOrder := soAscending;

  ActiveSearch := '';
  ActiveSearchDescription := cbSearchDescription.Checked;
  SetSearchQuerySQL;
  qStyles.Open;
end;

procedure TfmBrowseStyles.btnRefreshClick(Sender: TObject);
begin
  qStyles.Close;
  if edSearch.Font.Color = clRed then
    SetSearchQuerySQL;
  qStyles.Open;

  edSearch.Font.Color := OurColor(clWindowText);
  ActiveSearch := edSearch.Text;
  ActiveSearchDescription := cbSearchDescription.Checked;

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
begin
  dbgStyles.OnDblClick := nil;

  if (Column.FieldName = 'Style') or (Column.Fieldname = 'Description') then
  begin
    dbgStyles.SortColumn := Column.Index;

    if dbgStyles.SortOrder = soAscending then
      dbgStyles.SortOrder := soDescending
    else
      dbgStyles.SortOrder := soAscending;

    qStyles.Close;
    SetSearchQuerySQL;
    qStyles.Open;
  end;
end;

procedure TfmBrowseStyles.cbSearchDescriptionClick(Sender: TObject);
begin
  SearchChanged;
end;

procedure TfmBrowseStyles.dbgStylesCellClick(Column: TColumn);
begin
  dbgStyles.OnDblClick := dbgStylesDblClick;
end;

end.

