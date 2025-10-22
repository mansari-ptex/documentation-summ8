unit NewKnifeSet;

interface

uses
  Classes, Controls, Forms, StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons, ExtCtrls, ComCtrls, Db, ToolWin,
  General_Interlocking, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys;

type
  TAuto = record
    NoPatts: integer;
    Patts: TPointArray;
    PointsInPatts: array of integer;
  end;

  TfmNewKnifeSet = class(TForm)
    eNewKnifeCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    LocalConnectionSumms: TFDConnection;
    qNewKnifeSet: TFDQueryPlus;
    eSizeScale: TEdit;
    btnBrowse: TSpeedButton;
    cbMeasuredSize: TComboBox;
    qSizeScaleSizes: TFDQueryPlus;
    qSizeScaleSizesScale: TStringField;
    qSizeScaleSizesSize: TStringField;
    qSizeScaleSizesSeq: TFloatField;
    qSizeRelationshipSizes: TFDQueryPlus;
    qSizeRelationshipSizesScale: TStringField;
    qSizeRelationshipSizesSeq: TFloatField;
    qSizeRelationshipSizesKnifeSize: TStringField;
    lblNewKnifeCode: TLabel;
    lblMeasuredSize: TLabel;
    lblSizeScale: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure eSizeScaleEnter(Sender: TObject);
    procedure eSizeScaleExit(Sender: TObject);
    procedure eAnyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnBrowseClick(Sender: TObject);
    procedure eSizeScaleChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Auto, Manual, Single: boolean;
    CreatedFormHeight: Integer;
    SizeRelnScale: string;
  end;

var
  fmNewKnifeSet: TfmNewKnifeSet;
  ToBeAssessed: Boolean;
  ImportFilename: string;
  ImportPiecename: string;
  ImportPoints: integer;
  ImportPatterns: TPointArray;
  AutoRec: TAuto;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs, KnifeSetDetails, OutOfMemory, SummsVars,
  BrowseSizeScales, BrowseSizeRelationships, AdvErrorHandler;

{$R *.DFM}

procedure TfmNewKnifeSet.btnSaveClick(Sender: TObject);
var
  Code, SizeScale: string;
  Failed: boolean;
  i, j, k, PattIndex, SoFar, Start, Stop: integer;
  ToBeAssessedString, ManualString, s, sx, sy, SQLString: string;
  EnoughSizes, KnifeCreated: boolean;
  fmKnifeSetDetails: TfmKnifeSetDetails;

begin
  screen.Cursor := crHourGlass;
  SQLString := '';

  Code := eNewKnifeCode.Text;
  if Auto then
    SizeScale := SizeRelnScale 
  else
  begin
    SizeScale := eSizeScale.Text;
    KnifeSizeScale := SizeScale;
    KnifeMeasuredSize := cbMeasuredSize.Text;
    for i := 0 to cbMeasuredSize.Items.Count - 1 do
    begin
      if cbMeasuredSize.Items[i] = cbMeasuredSize.Text then
        j := i;
    end;
    if (j < cbMeasuredSize.Items.Count - 1) then
      NextSetSize := cbMeasuredSize.Items[j + 1];
  end;

  if (Code = '') or (SizeScale = '') or
//CJY Manual without measuered size
     ((Manual) and (cbMeasuredSize.Text = '')) then
  begin
    screen.Cursor := crDefault;
    abort;
  end;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  KnifeCreated := true;

  if Manual then
    ManualString := 'TRUE'
  else
    ManualString := 'FALSE';

  if Option_LegacySynthetics then
    qNewKnifeSet.SQL.Text := 'INSERT INTO KnifeSets (Code, SizeScale, Type, CutGap, Pieces, ' +
                             'DoubleSided, Thin, Punches, Bands, Marks, Clears, ManualEntry) ' +
                             'SELECT ''' + QS(Code) + ''', ''' + QS(SizeScale) + ''', Type, CutGap, Pieces, DoubleSided, Thin, ' +
                             '  Punches, Bands, Marks, Clears, ' + ManualString +
                             ' FROM KnfDflts; '
  else
    qNewKnifeSet.SQL.Text := 'INSERT INTO KnifeSets (Code, SizeScale, Type, CutGap, Pieces, ' +
                             'DoubleSided, Thin, Punches, Bands, Marks, Clears, ManualEntry) ' +
                             'SELECT ''' + QS(Code) + ''', ''' + QS(SizeScale) + ''', Type, 0, Pieces, DoubleSided, Thin, ' +
                             '  Punches, Bands, Marks, Clears, ' + ManualString +
                             ' FROM KnfDflts; ';

  if Single or Manual then
  begin
    if Manual then
    begin
      KnifeFileName := '';
      ImportPiecename := '';
    end;

    if ToBeAssessed then
      ToBeAssessedString := 'TRUE'
    else
      ToBeAssessedString := 'FALSE';

    qNewKnifeSet.SQL.Text := qNewKnifeSet.SQL.Text +
      'INSERT INTO Knives (Code, SizeScale, MeasuredSize, Seq, ToBeAssessed, ImportFilename, Piecename) ' +
      'SELECT ''' + QS(Code) + ''', ''' + QS(SizeScale) + ''', ''' + QS(cbMeasuredSize.Text) + ''', Seq, ' + ToBeAssessedString +
      ',''' + QS(KnifeFileName) + ''', ''' + QS(FirstNChars(ImportPiecename, 20)) + '''' +
      ' FROM SizeScaleSizes' +
      ' WHERE Scale = ''' + SizeScale + ''' AND Size = ''' + QS(cbMeasuredSize.Text) + '''; ';

    if not Manual then
    begin
      for i := 0 to ImportPoints - 1 do
      begin
        str(i, s);
        str(ImportPatterns[i].x, sx);
        str(ImportPatterns[i].y, sy);
        qNewKnifeSet.SQL.Text := qNewKnifeSet.SQL.Text + #13 +
                                 'INSERT INTO Patterns (Knife, Seq, X, Y, SizeScale, MeasuredSize) VALUES(''' + QS(Code) +
                                 '''' + ', ' + s + ', ' + sx + ', ' + sy +', ''' + QS(SizeScale) + ''', ''' + QS(cbMeasuredSize.Text) + '''); ';
      end;
    end;
  end
  else if Auto then
  begin
    SoFar := 0;
    PattIndex := -1;
    if fmSumms.mmLargeToSmall.Checked then
    begin
      Start := cbMeasuredSize.ItemIndex + (AutoRec.NoPatts - 1);
      Stop := cbMeasuredSize.ItemIndex;
      i := Start + 1;
      if ((Start + 1) > cbMeasuredSize.Items.Count) then
        EnoughSizes := False
      else
        EnoughSizes := True;
    end
    else
    begin
      Start := cbMeasuredSize.ItemIndex;
      Stop := cbMeasuredSize.ItemIndex + (AutoRec.NoPatts - 1);
      i := Start - 1;
      if ((Stop + 1) > cbMeasuredSize.Items.Count) then
        EnoughSizes := False
      else
        EnoughSizes := True;
    end;

    if EnoughSizes then
    begin
      while not(i = Stop) do
      begin
        if fmSumms.mmLargeToSmall.Checked then
          dec(i)
        else
          inc(i);

        inc(PattIndex);
        qNewKnifeSet.SQL.Text := qNewKnifeSet.SQL.Text +
          'INSERT INTO Knives (Code, SizeScale, MeasuredSize, Seq, ToBeAssessed, ImportFilename) ' +
          'SELECT ''' + QS(Code) + ''', ''' + QS(SizeScale) + ''', ''' + QS(cbMeasuredSize.Items[i]) + ''', Seq, TRUE' +
          ',''' + QS(KnifeFileName) + '''' +
          ' FROM SizeScaleSizes' +
          ' WHERE Scale = ''' + SizeScale + ''' AND Size = ''' + QS(cbMeasuredSize.Items[i]) + '''; ';

        k := -1;
        for j := SoFar to SoFar + Autorec.PointsInPatts[PattIndex] - 1 do
        begin
          inc(k);
          str(k, s);
          str(AutoRec.Patts[j].x, sx);
          str(AutoRec.Patts[j].y, sy);
          qNewKnifeSet.SQL.Text := qNewKnifeSet.SQL.Text + #13 +
                                   'INSERT INTO Patterns (Knife, Seq, X, Y, SizeScale, MeasuredSize) VALUES(''' + QS(Code) +
                                   '''' + ', ' + s + ', ' + sx + ', ' + sy +', ''' + QS(SizeScale) + ''', ''' + QS(cbMeasuredSize.Items[i]) + '''); ';
        end;
        SoFar := j;
      end;
    end
    else
    begin
      LocalConnectionSumms.Rollback;
      messagedlg('Not enough sizes in Relationship', mtInformation, [mbOK], 0);
      abort;
    end;
  end;

  try
    qNewKnifeSet.ExecSQL;
  except                           
    on E: Exception do
    begin
      if (Pos('Error 7057', E.Message) > 0) then
        s := 'Knife already exists'
      else if (Pos('KNIVES:PRIMARY', E.Message) > 0) then
        s := 'Invalid Size'
      else if (Pos('SIZESCALES:PRIMARY', E.Message) > 0) then
        s := 'Size Scale does not exist'
      else if (Pos('Error 5179', E.Message) > 0) then
      begin
        if (Pos('Field: "X"', E.Message) > 0) or (Pos('Field: "Y"', E.Message) > 0) then
          s := 'Knife is too large. Check Digitiser/Plot file scale.'
        else
          s := 'Unknown Error';
      end
      else
        s := 'Unknown Error';
      fmErrorHandler.DebugMessageDlg(s, E.Message, qNewKnifeSet.Text);
      KnifeCreated := false;
    end;
  end;

  if not KnifeCreated then
  begin
    LocalConnectionSumms.Rollback;
    eNewKnifeCode.SetFocus;
    eNewKnifeCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;

    LocalConnectionSumms.Commit;

    Failed := false;
    try
      fmKnifeSetDetails := TfmKnifeSetDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmKnifeSetDetails.PassKnifeName(fmKnifeSetDetails, Code);
      if fmSumms.mmAutoEdit.Checked then
        fmKnifeSetDetails.btnEdit.Click;
    end;

    Close;
  end;

  screen.Cursor := crDefault;
end;

procedure TfmNewKnifeSet.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewKnifeSet.FormActivate(Sender: TObject);
begin
  eNewKnifeCode.SetFocus;
  eNewKnifeCode.SelectAll;
end;

procedure TfmNewKnifeSet.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  lblMeasuredSize.Visible := (Form.Height = CreatedFormHeight);

  if Auto then
  begin
    if lblSizeScale.caption = 'Size Scale' then
      cbMeasuredSize.Text := '';

    lblSizeScale.caption := 'Size Relationship';
    lblMeasuredSize.Caption := 'Smallest Size';
  end
  else
  begin
    if lblSizeScale.caption = 'Size Relationship' then
      cbMeasuredSize.Text := KnifeMeasuredSize;

    lblSizeScale.caption := 'Size Scale';
    lblMeasuredSize.Caption := 'Measured Size';
  end;
end;

procedure TfmNewKnifeSet.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmNewKnifeSet.eSizeScaleEnter(Sender: TObject);
begin
  btnBrowse.enabled := True;
  btnBrowse.Hint := 'Browse Size Scale';
end;

procedure TfmNewKnifeSet.eSizeScaleExit(Sender: TObject);
begin
  btnBrowse.enabled := False;
end;

procedure TfmNewKnifeSet.eAnyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewKnifeSet.btnBrowseClick(Sender: TObject);
begin
  if Auto then
  begin
    fmBrowseSizeRelationships.ShowModal;
    eSizeScale.text := fmBrowseSizeRelationships.lblRelationship.caption;
  end
  else
  begin
    fmBrowseSizeScales.ShowModal;
    eSizeScale.text := fmBrowseSizeScales.lblScale.caption;
  end;
end;

procedure TfmNewKnifeSet.eSizeScaleChange(Sender: TObject);
begin
  if Auto then
  begin
    qSizeRelationshipSizes.ParamByName('Relationship').value := QS(eSizeScale.Text);
    qSizeRelationshipSizes.open;

    //Load list box
    cbMeasuredSize.Items.Clear;
    qSizeRelationshipSizes.RecNo := 1; //CJY changed from qSizeRelationshipSizes.First
    qSizeRelationshipSizes.Prior; //CJY changed from qSizeRelationshipSizes.First
    SizeRelnScale := qSizeRelationshipSizesScale.Value;
    while not qSizeRelationshipSizes.eof do
    begin
      cbMeasuredSize.Items.Add(qSizeRelationshipSizesKnifeSize.value);
      qSizeRelationshipSizes.next;
    end;
    qSizeRelationshipSizes.Close;

    cbMeasuredSize.ItemIndex := 0;
  end
  else
  begin
    if not(eSizeScale.Text = '') then
    begin
      qSizeScaleSizes.ParamByName('SizeScale').value := QS(eSizeScale.Text);
      qSizeScaleSizes.open;

      //Load list box
      cbMeasuredSize.Items.Clear;
      qSizeScaleSizes.RecNo := 1; //CJY changed from qSizeScaleSizes.First
      qSizeScaleSizes.Prior; //CJY changed from qSizeScaleSizes.First
      while not qSizeScaleSizes.eof do
      begin
        cbMeasuredSize.Items.Add(qSizeScaleSizesSize.value);
        qSizeScaleSizes.next;
      end;
      qSizeScaleSizes.Close;

      cbMeasuredSize.Text := KnifeMeasuredSize;
    end;
  end;
end;

procedure TfmNewKnifeSet.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  CreatedFormHeight := Height;
end;

end.

