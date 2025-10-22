unit BrowseKnives;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls,
  Buttons, ComCtrls, Grids, DBGridPlus, ToolWin, DBGrids;

type
  TfmBrowseKnives = class(TForm)
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    lblKnife: TLabel;
    dbgKnives: TDBGridPlus;
    qKnives: TFDQueryPlus;
    qKnivesCode: TStringField;
    qKnivesDescription: TStringField;
    dsqKnives: TDataSource;
    lblSearch: TLabel;
    procedure dbgKnivesDblClick(Sender: TObject);
    procedure dbgKnivesKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgKnivesTitleClick(Column: TColumn);
    procedure dbgKnivesCellClick(Column: TColumn);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
  end;

var
  fmBrowseKnives: TfmBrowseKnives;

implementation

uses
  Windows, Graphics, SummsVars, General, Summs;

{$R *.DFM}

procedure TfmBrowseKnives.dbgKnivesDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmBrowseKnives.dbgKnivesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgKnivesDblClick(Self);
end;

procedure TfmBrowseKnives.edSearchChange(Sender: TObject);
begin
  if edSearch.Text = ActiveSearch then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmBrowseKnives.FormShow(Sender: TObject);
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

procedure TfmBrowseKnives.FormHide(Sender: TObject);
begin
  lblKnife.caption := qKnivesCode.value;
end;

procedure TfmBrowseKnives.FormCreate(Sender: TObject);
var
  i: integer;

begin
	AutoColor(Self);

  ActiveSearch := '';
  qKnives.ParamByName('Search').AsString := '%';
  qKnives.Open;

  dbgKnives.SortColumn := 0;
  dbgKnives.SortOrder := soAscending;
  dbgknives.Refresh;
end;

procedure TfmBrowseKnives.btnRefreshClick(Sender: TObject);
begin
  qKnives.Close;
  if edSearch.Font.Color = clRed then
    qKnives.ParamByName('Search').AsString := edSearch.text + '%';
  qKnives.Open;

  edSearch.Font.Color := OurColor(clWindowText);
  ActiveSearch := edSearch.Text;

  dbgKnives.SortColumn := 0;
  dbgKnives.SortOrder := soAscending;
  dbgKnives.Refresh;

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

procedure TfmBrowseKnives.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmBrowseKnives.dbgKnivesTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  if fmSumms.ActiveMDIChild = Self then
  begin
    dbgKnives.OnDblClick := nil;

    if (Column.FieldName = 'Code') or (Column.Fieldname = 'Description') then
    begin
      dbgKnives.SortColumn := Column.Index;

      if dbgKnives.SortOrder = soAscending then
      begin
        dbgKnives.SortOrder := soDescending;
        SQLString := ' DESC';
      end
      else
      begin
        dbgKnives.SortOrder := soAscending;
        SQLString := ' ASC';
      end;

      qKnives.Close;
      qKnives.SQL.Text := 'SELECT Code, Description FROM KnifeSets WHERE Code LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
      qKnives.Open;
    end;
  end;
end;

procedure TfmBrowseKnives.dbgKnivesCellClick(Column: TColumn);
begin
  dbgKnives.OnDblClick := dbgKnivesDblClick;
end;

end.

