unit AllPatterns;

interface

uses
  Classes, Controls, Forms, Types, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, ExtCtrls,
  Menus, Buttons, ComCtrls,   ToolWin, Grids, DBGridPlus, DBGrids,
  XStringGrid, XStringGridPlus, jpeg, General_Interlocking, Mask, DBCtrls,
  Const_Interlocking;

type
  TfmAllPatterns = class(TForm)
    dsqKnives: TDataSource;
    pnlSearch: TPanel;
    edSearch: TEdit;
    qKnives: TFDQueryPlus;
    qKnivesCode: TStringField;
    qKnivesDescription: TStringField;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlPicture: TPanel;
    imgPattern: TImage;
    dbeKnifeCode: TDBEdit;
    qKnivesMeasuredSize: TStringField;
    dbeKnifeSize: TDBEdit;
    qKnivesSizeScale: TStringField;
    qKnivesKnifeCutGap: TSmallintField;
    cbExact: TCheckBox;
    qKnivesDone: TBooleanField;
    qKnivesAngle: TFloatField;
    dbgKnives: TDBGridPlus;
    lblSearch: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edSearchChange(Sender: TObject);
    procedure dbgKnivesOldKeyPress(Sender: TObject; var Key: Char);
    procedure dbgKnivesDblClick(Sender: TObject);
    procedure dbgKnivesKeyPress(Sender: TObject; var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure dbeKnifeCodeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qKnivesBeforeOpen(DataSet: TDataSet);
    procedure cbExactClick(Sender: TObject);
    procedure dbgKnivesTitleClick(Column: TColumn);
    procedure dbgKnivesCellClick(Column: TColumn);
  private
    { Private declarations }
    ActiveSearch: String;
  public
    { Public declarations }
    KnifeCode, KnifeScale, KnifeSize: string;
    KnifeAngle: Real;
    CreatedFormWidth: Integer;
    MatLength, MatWidth: Real;
    MatCutGap, MatEdge: integer;
    MatRestrictive, OrderBy: string;
  end;

var
  fmAllPatterns: TfmAllPatterns;

implementation

uses
  SysUtils, Windows, Graphics, Dialogs, PatternDrawing, General
  {$IFDEF SATRASUMM}
    , LayMain
    {$DEFINE USESUMMSVARS}
  {$ELSE}
    , VisualiserMain
  {$ENDIF}

  {$IFDEF DEBUGFULL}
    {$DEFINE USESUMMSVARS}
  {$ENDIF}

  {$IFDEF USESUMMSVARS}
  , SummsVars
  {$ENDIF}
  ;

{$R *.DFM}

procedure TfmAllPatterns.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qKnives.close;
end;

procedure TfmAllPatterns.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmAllPatterns.dbgKnivesDblClick(Sender: TObject);
begin
  if {$IFDEF SATRASUMM} Option_LegacySynthetics and {$ENDIF} (qKnivesKnifeCutGap.Value <> MatCutGap) then
    messagedlg('The Cut gap on this Knife is ' + intToStr(qKnivesKnifeCutGap.Value) +
               ' mm. This will be ignored.' + #13#13 +
               'The Cut gap on the Material will be used.', mtInformation, [mbOk], 0);

  KnifeCode := qKnivesCode.value;
  KnifeScale := qKnivesSizeScale.value;
  KnifeSize := qKnivesMeasuredSize.value;
  KnifeAngle := qKnivesAngle.value;
  ModalResult := mrOK;
end;

procedure TfmAllPatterns.edSearchChange(Sender: TObject);
begin
  if edSearch.Text = ActiveSearch then
    edSearch.Font.Color := OurColor(clWindowText)
  else
    edSearch.Font.Color := clRed;
end;

procedure TfmAllPatterns.dbgKnivesOldKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgKnivesDblClick(Self);
end;

procedure TfmAllPatterns.dbgKnivesKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgKnivesDblClick(Self);
end;

procedure TfmAllPatterns.btnRefreshClick(Sender: TObject);
begin
  qKnives.Close;
  qKnives.Open;

  ActiveSearch := edSearch.Text;
  edSearch.Font.Color := OurColor(clWindowText);
end;

procedure TfmAllPatterns.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllPatterns.FormShow(Sender: TObject);
begin
  pnlPicture.Visible := KnifePreview;
  if KnifePreview then
    width := CreatedFormWidth
  else
    width := CreatedFormWidth - pnlPicture.width;
  left := (screen.width - width) div 2;
  top := (screen.height - height) div 2;

  edSearch.Font.Color := clRed;
  ActiveSearch := '';
  qKnives.Open;
  if not(edSearch.Text = '') then
    btnRefresh.click;
end;

procedure TfmAllPatterns.dbeKnifeCodeChange(Sender: TObject);
var
  Knife: TPointArray; //Try to get rid of this later!!!

begin
  if KnifePreview then
  begin
    if (not qKnivesCode.IsNull) and (not qKnivesMeasuredSize.IsNull) then
      dmPatternDrawing.DisplayPattern(qKnivesCode.Value, qKnivesSizeScale.Value, qKnivesMeasuredSize.Value, clHide, clCut, imgPattern, Knife, 0);
  end;
end;

procedure TfmAllPatterns.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  CreatedFormWidth := Width;
  OrderBy := 'Order By K.Code, K.Code, K.Seq';

  dbgKnives.SortColumn := 0;
  dbgKnives.SortOrder := soAscending;
  dbgKnives.Refresh;
end;

procedure TfmAllPatterns.qKnivesBeforeOpen(DataSet: TDataSet);
var
  s, MatRes: string;

begin
  if MatRestrictive = '' then
    MatRes := 'IS NULL'
  else
    MatRes := ' = ''' + MatRestrictive + '''';
    
  s := 'SELECT K.Code, K.SizeScale, K.MeasuredSize, K.Angle, KS.Description, KS.CutGap as KnifeCutGap, ' +
       '(IIF(0 < (SELECT COUNT(L.KnifeCode) ' +
 	     'FROM LayplanSets L ' +
       'WHERE (L.KnifeCode = K.Code) AND (L.KnifeSizeScale = K.SizeScale) AND (L.KnifeSize = K.MeasuredSize) AND ' +
			       '(L.MaterialLength = ' + FloatToStr(MatLength) + ') AND (L.MaterialWidth = ' + FloatToStr(MatWidth) +
             ') AND (L.MaterialCutGap = ' + IntToStr(MatCutGap) + ') AND (L.MaterialEdge = ' + IntToStr(MatEdge) + ') AND ' +
				     '(L.MaterialCodeRestrictive ' + MatRes + ')), TRUE, FALSE)) as Done ' +
       'FROM Knives K, KnifeSets KS ' +
       'WHERE (ManualEntry = False) AND ';

  if edSearch.Text <> '' then
  begin
    s := s + '(K.Code ';
    if cbExact.Checked then
      s := s + '= '
    else
      s := s + 'LIKE ';
    s := s + '''' + QS(edSearch.text);
    if not cbExact.Checked then
      s := s + '%';
    s := s + ''') AND ';
  end;

  s := s +
      '(KS.Code = K.Code) ' + OrderBy;
  qKnives.SQL.Clear;
  qKnives.SQL.Text := s;
end;

procedure TfmAllPatterns.cbExactClick(Sender: TObject);
begin
  btnRefresh.click;
end;

procedure TfmAllPatterns.dbgKnivesTitleClick(Column: TColumn);
var
  SQLString: string;
  i: integer;

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
    if Column.FieldName = 'Code' then
      OrderBy := 'Order By UPPER(K.'
    else
      OrderBy := 'Order By UPPER(KS.';
    OrderBy := OrderBy + Column.FieldName + ') ' + SQLString + ', K.Code, K.Seq ' + SQLString ;
    qKnives.Open;
  end;
end;

procedure TfmAllPatterns.dbgKnivesCellClick(Column: TColumn);
begin
  dbgKnives.OnDblClick := dbgKnivesDblClick;
end;

end.

