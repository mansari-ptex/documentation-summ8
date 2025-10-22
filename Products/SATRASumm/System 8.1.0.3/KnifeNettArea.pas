unit KnifeNettArea;

interface

uses
  System.SysUtils, System.Classes, FDConnectionPlus, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus;

type
  TdmKnifeNettArea = class(TDataModule)
    qNettArea: TFDQueryPlus;
    qSizes: TFDQueryPlus;
    qKnifePoints: TFDQueryPlus;
  private
    FConnection: TFDConnectionPlus;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; AConnection: TFDConnectionPlus); overload;
    procedure NettArea(KnifeCode: string); overload;
    procedure NettArea(KnifeCode, SizeScale, KnifeSize: string); overload;
  end;

var
  dmKnifeNettArea: TdmKnifeNettArea;

implementation

uses
  Dialogs, General_Interlocking, Interlocking;


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}



{ TdmKnifeNettArea }



constructor TdmKnifeNettArea.Create(AOwner: TComponent);
begin
  inherited;

  FConnection := nil;
end;


constructor TdmKnifeNettArea.Create(AOwner: TComponent; AConnection: TFDConnectionPlus);
begin
  Create(AOwner);

  FConnection := AConnection;
end;


procedure TdmKnifeNettArea.NettArea(KnifeCode: string);
begin
  if FConnection <> nil then
  begin
    qSizes.Connection := FConnection;
    qSizes.ParamByName('KnifeCode').AsString := KnifeCode;
    qSizes.Open;

    qSizes.RecNo := 1;
    qSizes.Prior;
    while not qSizes.eof do
    begin
      NettArea(KnifeCode, qSizes.FieldByName('SizeScale').AsString,
        qSizes.FieldByName('MeasuredSize').AsString);

      qSizes.Next;
    end;
    qSizes.Close;
  end
  else
    showmessage('Error updating qSizes - Connection not set');
end;


procedure TdmKnifeNettArea.NettArea(KnifeCode, SizeScale, KnifeSize: string);
var
  Points: TPointArray;
  Pattern: TPattern;
  i: SmallInt;

begin
  if FConnection <> nil then
  begin
    qKnifePoints.Connection := FConnection;
    qKnifePoints.ParamByName('KnifeCode').AsString := KnifeCode;
    qKnifePoints.ParamByName('SizeScale').AsString := SizeScale;
    qKnifePoints.ParamByName('KnifeSize').AsString := KnifeSize;
    qKnifePoints.Open;

    SetLength(Points, qKnifePoints.RecordCount);
    i := -1;
    qKnifePoints.RecNo := 1;
    qKnifePoints.Prior;
    while not qKnifePoints.eof do
    begin
      inc(i);

      Points[i].X := qKnifePoints.FieldByName('X').AsInteger;
      Points[i].Y := qKnifePoints.FieldByName('Y').AsInteger;

      qKnifePoints.Next;
    end;

    qKnifePoints.Close;

    //Create pattern from the points which calculates its areas
    Pattern := CreatePattern(Points, 0, 0, True, False);

    qNettArea.Connection := FConnection;
    qNettArea.ParamByName('KnifeCode').AsString := KnifeCode;
    qNettArea.ParamByName('SizeScale').AsString := SizeScale;
    qNettArea.ParamByName('KnifeSize').AsString := KnifeSize;
    //GrossArea added for completion only, we can use the ExpandedGrossArea
    //because we know Kerf is always 0 here. Note that these areas MIGHT
    //change on assessment as the Expanded areas are written into these fields.
    qNettArea.ParamByName('GrossArea').AsFloat := Pattern.ExpandedGrossArea;
    qNettArea.ParamByName('NettArea').AsFloat := Pattern.PatternNettArea;
    qNettArea.ExecSQL;
  end
  else
    showmessage('Error updating qNettArea - Connection not set');
end;


end.
