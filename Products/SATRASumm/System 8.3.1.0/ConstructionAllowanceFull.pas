unit ConstructionAllowanceFull;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, ExtCtrls, Db, Vcl.Grids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, ComCtrls,
  XStringGrid, XStringGridPlus, Vcl.Dialogs;

type
  TWidth = record
    No: Short;
    Name: string;
  end;

  TPart = record
    Name: string;
    AltMaterial: string;
    SampleSize: string;
    CostedSize: string;
    SLMAllowance: Boolean;
  end;

  TfmConstructionAllowanceFull = class(TForm)
    qWidths: TFDQueryPlus;
    qWidthsNo: TSmallintField;
    qWidthsWidth: TStringField;
    qWidthsSampleSize: TStringField;
    qWidthsCommonIn: TIntegerField;
    qParts: TFDQueryPlus;
    qSizes: TFDQueryPlus;
    qSizesSeq: TFloatField;
    qSizesSize: TStringField;
    qSizesNo: TSmallintField;
    pnlCalculating: TPanel;
    pnlTitles: TPanel;
    lblProgressWidths: TLabel;
    lblProgressConstruction: TLabel;
    pnlProgressBars: TPanel;
    pbWidth: TProgressBar;
    pbConstruction: TProgressBar;
    sgSampleResults: TXStringGridPlus;
    sdFileOut: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure qSizesAfterOpen(DataSet: TDataSet);
    procedure qWidthsAfterOpen(DataSet: TDataSet);
    procedure qPartsAfterOpen(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FConstruction: string;
    FLoading: Boolean;
    Widths: array of TWidth;
    Parts: array of TPart;
    NoWidths: Integer;
    NoParts: Integer;
    function GetLoading: Boolean;
    procedure SetLoading(const Value: Boolean);
    procedure OpenQueries();
    procedure CloseQueries();
    procedure Processing(AFileName: string);
    function StripBrackets(s: string): string;
    function FileName: Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure AllAllowances(AConstruction: string);
    property Loading: Boolean read GetLoading write SetLoading;
  end;

implementation

uses
  System.SysUtils, System.StrUtils, General, Basicalw;

const
  FIXEDCOLS = 4;


{$R *.DFM}


procedure TfmConstructionAllowanceFull.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseQueries();

  action := caFree;
end;


procedure TfmConstructionAllowanceFull.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not Loading;

  if not CanClose then
    ShowMessage('Can not close busy window ''' + Caption + '''.');
end;


procedure TfmConstructionAllowanceFull.AllAllowances(AConstruction: string);
begin
  FConstruction := AConstruction;

  Caption := 'All allowances for Construction : ' + FConstruction;

  if FileName then
  begin
    Loading := True;

    OpenQueries();
    Processing(sdFileOut.FileName);

    Loading := False;
  end;

{$IFNDEF DEBUG}
  Close;
{$ENDIF}
end;


procedure TfmConstructionAllowanceFull.qWidthsAfterOpen(
  DataSet: TDataSet);
var
  i: Integer;

begin
  qWidths.FetchAll;
  NoWidths := qWidths.RecordCount;

  SetLength(Widths, NoWidths);

  qWidths.RecNo := 1;
  qWidths.Prior;
  for i := 0 to NoWidths - 1 do
  begin
    Widths[i].No := qWidthsNo.Value;
    Widths[i].Name := qWidthsWidth.asString;

    qWidths.Next;
  end;
end;


procedure TfmConstructionAllowanceFull.qPartsAfterOpen(DataSet: TDataSet);
var
  i: Integer;

begin
  qParts.FetchAll;
  NoParts := qParts.RecordCount;

  SetLength(Parts, NoParts);

  qParts.RecNo := 1;
  qParts.Prior;
  for i := 0 to NoParts - 1 do
  begin
    Parts[i].Name := qParts.FieldByName('Part').asString;
    Parts[i].AltMaterial := qParts.FieldByName('AltMaterial').asString;
    Parts[i].SampleSize := qParts.FieldByName('SampleSize').asString;
    Parts[i].CostedSize := qParts.FieldByName('CostedSize').asString;
    Parts[i].SLMAllowance := qParts.FieldByName('SLMAllowance').asBoolean;

    qParts.Next;
  end;
end;


procedure TfmConstructionAllowanceFull.qSizesAfterOpen(DataSet: TDataSet);
var
  NoSizes: Integer;
  i, j: Integer;

begin
  qSizes.FetchAll;
  NoSizes := qSizes.RecordCount;

  sgSampleResults.ColCount := FIXEDCOLS;
  sgSampleResults.ColCount := sgSampleResults.ColCount + NoSizes;

  qSizes.IndexFieldNames := 'Seq';
  qSizes.RecNo := 1;
  qSizes.Prior;
  for i := 1 to NoSizes do
  begin
    j := sgSampleResults.ColCount - NoSizes + i - 1;
    sgSampleResults.Cells[j, 0] := qSizes.FieldByName('Size').AsString;

    qSizes.Edit;
    qSizes.FieldbyName('No').AsInteger := i;
    qSizes.Post;

    qSizes.Next;
  end;

  qSizes.IndexFieldNames := 'Size;No';
end;


procedure TfmConstructionAllowanceFull.Processing(AFilename: string);
var
{$IFDEF DEBUG}
  RowNo: Integer;
  ColNo: Integer;
{$ENDIF}
  i, j, k: Integer;
  Allowances: GridArray;
  NumberOfSizes: integer;
  sAllowance: string;
  sMaterial: string;
  sUnits: string;
  F: TextFile;
  s: string;

begin
  pbWidth.Position := 0;
  pbConstruction.Position := 0;

  assignfile(F, AFileName);
  rewrite(F);

{$IFDEF DEBUG}
  RowNo := 0;
{$ENDIF}
  for i := 0 to NoWidths - 1 do
  begin
    for j := 0 to NoParts - 1 do
    begin
      sMaterial := Parts[j].AltMaterial;
      sUnits := '';
      dmBasAll.AllowanceAllCosts(Parts[j].Name, Widths[i].No, Allowances, NumberOfSizes, sMaterial, sUnits);
      sUnits := StripBrackets(sUnits);

{$IFDEF DEBUG}
      inc(RowNo);

      sgSampleResults.RowCount := RowNo + 1;

      sgSampleResults.Cells[0, RowNo] := Widths[i].Name;
      sgSampleResults.Cells[1, RowNo] := Parts[j].Name;
      sgSampleResults.Cells[2, RowNo] := sMaterial;
      sgSampleResults.Cells[3, RowNo] := sUnits;
{$ENDIF}

      for k := 1 to NumberOfSizes do
      begin
        if qSizes.FindKey([Allowances[k].Size]) then
        begin
          if Allowances[k].AdjustedAllowance > 0 then
            str(Allowances[k].AdjustedAllowance: 7: 4, sAllowance)
          else
            sAllowance := 'Unavailable';

{$IFDEF DEBUG}
          ColNo := FIXEDCOLS + qSizes.FieldByname('No').AsInteger - 1;
          sgSampleResults.Cells[ColNo, RowNo] := sAllowance;
{$ENDIF}
        end;

        s := FConstruction + ',' + Widths[i].Name + ', ' + Allowances[k].Size +
          ', ' + sMaterial + ', ' + sAllowance + ', '  + sUnits;
        Writeln(F, s);
      end;

      pbWidth.Position := Round((j + 1) / NoParts * 100);
      pbConstruction.Position := Round(((i * NoParts) + (j + 1)) / (NoWidths * NoParts) * 100);
      application.ProcessMessages;
    end;
  end;

  closefile(F);
end;


procedure TfmConstructionAllowanceFull.CloseQueries;
begin
  qParts.Close;
  qSizes.Close;
  qWidths.Close;
end;


constructor TfmConstructionAllowanceFull.Create(AOwner: TComponent);
begin
  inherited;

{$IFDEF DEBUG}
  sgSampleResults.Visible := True;
  Self.Height := 400;
{$ELSE}
  sgSampleResults.Visible := False;
  Self.Height := 94;
  Top := Top + 153;
{$ENDIF}

  FLoading := False;
end;


function TfmConstructionAllowanceFull.GetLoading: Boolean;
begin
  Result := FLoading;
end;


procedure TfmConstructionAllowanceFull.OpenQueries;
begin
  qSizes.ParamByName('Code').AsString := FConstruction;
  qSizes.Open();

  qWidths.ParamByName('Code').AsString := FConstruction;
  qWidths.Open;

  qParts.ParamByName('Code').AsString := FConstruction;
  qParts.Open;
end;


procedure TfmConstructionAllowanceFull.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;


function TfmConstructionAllowanceFull.FileName: Boolean;
begin
  if DirectoryExists(AuditPathName) then
    sdFileOut.InitialDir := AuditPathName
  else
    sdFileOut.InitialDir := ExtractFileDrive(ExpandFileName(Application.EXEName));

  Result := sdFileOut.Execute;
end;


procedure TfmConstructionAllowanceFull.SetLoading(const Value: Boolean);
begin
  FLoading := Value;

  Enabled := not FLoading;

  if FLoading then
    Screen.cursor := crHourGlass
  else
    Screen.cursor := crDefault;
end;


function TfmConstructionAllowanceFull.StripBrackets(s: string): string;
begin
  if (Length(s) > 0) and (LeftStr(s, 1) = '(') then
    s := copy(s, 2, Length(s) - 1);

  if (Length(s) > 0) and (RightStr(s, 1) = ')') then
    s := copy(s, 1, Length(s) - 1);

  Result := s;
end;


end.

