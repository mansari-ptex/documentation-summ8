unit NewSizeReln;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls,  ToolWin, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmNewSizeRelationship = class(TForm)
    eNewSizeRelationshipCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnBrowse: TSpeedButton;
    eSizeRange: TEdit;
    qSizeRelationships: TFDQueryPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    tblSizeRanges: TFDTablePlus;
    tblSizeRangesScale: TStringField;
    tblSizeRangesRange: TStringField;
    tblSizeRangesDescription: TStringField;
    tblSizeRangesSampleSize: TStringField;
    tblSizeRangesCostedSize: TStringField;
    lblCode: TLabel;
    lblSizeRange: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure eSizeRangeEnter(Sender: TObject);
    procedure eSizeRangeExit(Sender: TObject);
    procedure eAnyKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AutoCreate: Boolean;
  end;

var
  fmNewSizeRelationship: TfmNewSizeRelationship;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs, SizeRelationshipDetails,
  BrowseSizeRanges, OutOfMemory, AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmNewSizeRelationship.btnSaveClick(Sender: TObject);
var
  fmSizeRelationshipDetails: TfmSizeRelationshipDetails;
  Code : string;
  Failed, RelationshipFocus, SizeRelationshipCreated : boolean;
  LockSuccess : boolean;
  SizeRangeCode : string;

begin
  RelationshipFocus := True;

  Code := eNewSizeRelationshipCode.Text;
  if  Code = '' then
    abort;

  //Attempt Lock
  if not tblSizeRanges.active then
    tblSizeRanges.open;

  SizeRangeCode := eSizeRange.text;
  tblSizeRanges.setRange([SizeRangeCode], [SizeRangeCode]);

  //CJY Catch invalid size ranges before attempting to lock
  if (tblSizeRanges.RecordCount <= 0) then
  begin
    fmErrorHandler.DebugMessageDlg('Size Range does not exist', '', qSizeRelationships.Text);
    Abort;
  end;

  LocalConnectionSumms.StartTransaction;

  LockSuccess := LockSingleWithoutOption(oSizeRange, tblSizeRanges, SizeRangeCode);

  if LockSuccess then
  begin
    qSizeRelationships.SQL.Text := 'INSERT INTO SizeRelationships (Scale, Range, Relationship) SELECT Scale, Range, ''' + QS(Code) +
                                   ''' FROM SizeRanges WHERE Range = ''' + QS(eSizeRange.Text) + ''';' + #13 +
                                   'INSERT INTO SizeRelationshipSizes (Scale, Range, Relationship, ShoeSize, Seq, KnifeSize)' +
                                   ' SELECT S.Scale, S.Range, S.Relationship, SRS.Size, SRS.Seq, SRS.Size' +
                                   ' FROM SizeRelationships S, SizeRangeSizes SRS' +
                                   ' WHERE S.Relationship = ''' + QS(Code) + ''' AND SRS.Range = S.Range;';

    SizeRelationshipCreated := True;

    try
      qSizeRelationships.ExecSQL;
    except
      on E: EDatabaseError do
      begin
        if pos('SIZERELATIONSHIPS:RANGE',E.Message) > 0 then
        begin
          fmErrorHandler.DebugMessageDlg('Size Range does not exist', E.Message, qSizeRelationships.Text);
          RelationshipFocus := False;   //This error doesn't happen but left code here just in case
        end
        else
        begin
          fmErrorHandler.DebugMessageDlg('Size Relationship already exists', E.Message, qSizeRelationships.Text);
          RelationshipFocus := True;
        end;
        SizeRelationshipCreated := False;
      end
      else
      begin
        SizeRelationshipCreated := False;

        Raise;
      end;
    end;

    //CJY Only raise this error if not already raised
    if SizeRelationshipCreated and (qSizeRelationships.RowsAffected = 0) then
    begin
      MessageDlgPos('Size Range does not exist ' + #13 + 'or' + #13 + 'No sizes in Size Range', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      SizeRelationshipCreated := False;
    end;

    //Unlock
    tblSizeRanges.cancel;

    if SizeRelationshipCreated then
    begin
      LocalConnectionSumms.Commit;

      fmSumms.qSizeRelationships.Refresh;

      if not AutoCreate then
      begin
        Screen.cursor := crHourGlass;
        Failed := False;
        try
          fmSizeRelationshipDetails := TfmSizeRelationshipDetails.create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
        begin
          fmSizeRelationshipDetails.PassSizeRelationshipName(fmSizeRelationshipDetails, Code);
          if fmSumms.mmAutoEdit.Checked then
            fmSizeRelationshipDetails.btnEdit.Click;
        end;
      end;

      Close;
    end
    else
    begin
      LocalConnectionSumms.Rollback;

      if RelationshipFocus then
      begin
        eNewSizeRelationshipCode.SetFocus;
        eNewSizeRelationshipCode.SelectAll;
      end
      else
      begin
        eSizeRange.SetFocus;
        eSizeRange.SelectAll;
      end;
    end;
  end
  else
    LocalConnectionSumms.Rollback;
end;

procedure TfmNewSizeRelationship.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewSizeRelationship.FormActivate(Sender: TObject);
begin
  eNewSizeRelationshipCode.text := '';
  eSizeRange.text := '';
  eNewSizeRelationshipCode.SetFocus;
  eNewSizeRelationshipCode.SelectAll;
end;

procedure TfmNewSizeRelationship.btnBrowseClick(Sender: TObject);
begin
  if fmBrowseSizeRanges.ShowModal = mrOK then
    eSizeRange.text := fmBrowseSizeRanges.lblRange.caption;
end;

procedure TfmNewSizeRelationship.eSizeRangeEnter(Sender: TObject);
begin
  btnBrowse.enabled := True;
end;

procedure TfmNewSizeRelationship.eSizeRangeExit(Sender: TObject);
begin
  btnBrowse.enabled := False;
end;

procedure TfmNewSizeRelationship.eAnyKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewSizeRelationship.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);

  AutoCreate := False;
end;

procedure TfmNewSizeRelationship.LocalConnectionSummsAfterConnect(
  Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmNewSizeRelationship.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmNewSizeRelationship.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
