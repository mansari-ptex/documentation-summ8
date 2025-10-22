unit AdvErrorHandler;

interface

//VSTITCH is defined in the Project Options - Directories/Conditionals
//for the VisionStitch project only.

uses
  SysUtils, Forms, StdCtrls, ExtCtrls, Db, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Controls, Classes, Graphics, Buttons, CButton, CmnVars, General
{$IFDEF VSTITCH}
  , TranSys, Data
{$ENDIF}
  ;

type
  TfmErrorHandler = class(TForm)
    pnlMain: TPanel;
    qAllFields: TFDQuery;
    qAllFieldsFieldName: TStringField;
    qAllFieldsOurName: TStringField;
    lblDetails: TLabel;
    lblDatabasePasswordError: TLabel;
    lblDatabaseServerError: TLabel;
    lblUnexpectedError: TLabel;
    lblValidityCheck: TLabel;
    lblDatabaseServerLimit: TLabel;
    lblConversion: TLabel;
    lblPermissionDenied: TLabel;
    lblLockedbyanotheruser: TLabel;
    lblUserpasswordchangedbyanotheruser: TLabel;
    lblErrordiscoveringserver: TLabel;
    lblMaximumnumberofdatabaseconnectionsexceeded: TLabel;
    lblMaximumnumberofdatabaseWorkAreasexceeded: TLabel;
    lblMaximumnumberofdatabaseTablesexceeded: TLabel;
    lblMaximumnumberofdatabaseIndexFilesexceeded: TLabel;
    lblMaximumnumberofdatabaseDataLocksexceeded: TLabel;
    lblThisisinuseandcannotbechanged: TLabel;
    lblThiscannotbeblank: TLabel;
    lblThisistoosmall: TLabel;
    lblThisistoobig: TLabel;
    lblThisalreadyexists: TLabel;
    lblThisdoesnotexist: TLabel;
    lblSQLError: TLabel;
    lblCLOSESYSTEMandrestart: TLabel;
    lblOperationABORTEDWindowClosed: TLabel;
    lblThisisinvalid: TLabel;
    lblThismusthaveavalue: TLabel;
    pnlBottom: TPanel;
    btnOk: TColButton;
    lblNothingToDo: TLabel;
    lblCommunicationsError: TLabel;
    lblThisisbeingeditedelsewhere: TLabel;
    procedure FormShow(Sender: TObject);
    function ErrRegMatch(eMessage: string): TStringList;
    procedure FDDbErrMsg(E: Exception);
    procedure DbErrMsg(E: Exception);
    procedure ConvErrMsg(E: Exception);
    procedure OtherErrMsg(E: Exception);
    procedure Initialise;
    function FriendlyFieldName(Fieldname: string): string;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure DebugMessageDlg(OurMsg, ErrorMsg, SQLText: string);
    procedure btnOkKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOkKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FieldNames, OurNames: array of string;
    NoFields: integer;
    MainColor, MainFontColor: TColor;
  public
    { Public declarations }
    DebugNow: boolean;
    RaisedError, SQLString: string;
  end;

var
  fmErrorHandler: TfmErrorHandler;

implementation

{$R *.DFM}

uses System.RegularExpressions;

function ErrMessageRegMatch(eMessage: string): TStringList;
var
  errRegExMatch: TMatch;
  errRegExMatches: TMatchCollection;
  errFormatList: TStringList;
  errList: TStringList;
  i, j: integer;

begin
  errFormatList := TStringList.Create();
  errList := TStringList.Create();

  errFormatList.Add('([a-z]+) *\"([^\"]+)\"');
  errFormatList.Add('No (primary key) found in *([^\ ]+)');
  errFormatList.Add('The (key value) supplied for *[A-Z0-9-_]+:([A-Z0-9-_]+) is not unique.');

  i := 0;
  repeat
    errRegExMatches := TRegEx.Matches(eMessage, errFormatList[i], [roIgnoreCase]);

    j := 0;
    while j <= errRegExMatches.Count - 1 do
    begin
      errRegExMatch := errRegExMatches.Item[j];
      if (errRegExMatch.Groups.Count = 3) then
      begin
        if (errList.Count < 2) then
        begin
          errList.Values['SubjectType'] := errRegExMatch.Groups.Item[1].Value;
          errList.Values['SubjectName'] := errRegExMatch.Groups.Item[2].Value;
        end
        else
        begin
          errList.Values['SubjectType' + IntToStr(errList.Count div 2)] := errRegExMatch.Groups.Item[1].Value;
          errList.Values['SubjectName' + IntToStr(errList.Count div 2)] := errRegExMatch.Groups.Item[2].Value;
        end;
      end;
      Inc(j);
    end;

    Inc(i);
  until (i >= errFormatList.Count);

  Result := errList;
end;


function TfmErrorHandler.ErrRegMatch(eMessage: string): TStringList;
var
  errRegExMatch: TMatch;
  errList: TStringList;

begin
  errList := TStringList.Create();
  errList.Values['ServerType'] := 'UNK';
  errList.Values['SQLErrorCode'] := '0';
  errList.Values['NativeErrorCode'] := '0';
  errList.Values['Message'] := 'Unknown';

  errRegExMatch := TRegEx.Match(eMessage, '^\[[^\[\]]+\]\[[^\[\]]+\]\[([^\[\]]+)\] *Error *([0-9]+):[^;]+; *NativeError *= *([0-9]+);[^:]+: *(.*)$', []);

  if not ((errRegExMatch.Success) and (errRegExMatch.Groups.Count = 5)) then
  begin
    errRegExMatch := TRegEx.Match(eMessage, '^\[[^\[\]]+\]\[[^\[\]]+\]\[([^\[\]]+)\] *Error *(([0-9]+)): *(.*)$', []);
  end;

  if (errRegExMatch.Success) and (errRegExMatch.Groups.Count = 5) then
  begin
    errList.Values['ServerType'] := errRegExMatch.Groups.Item[1].Value;
    errList.Values['SQLErrorCode'] := errRegExMatch.Groups.Item[2].Value;
    errList.Values['NativeErrorCode'] := errRegExMatch.Groups.Item[3].Value;
    errList.Values['Message'] := errRegExMatch.Groups.Item[4].Value;
    errList.AddStrings(ErrMessageRegMatch(errList.Values['Message']));
  end;
  Result := errList;
end;

procedure TfmErrorHandler.FDDbErrMsg(E: Exception);
var
  SQLCode, NativeCode: integer;
  FieldName, OurName: string;
  EMessage: string;
  ErrorString: string;
  ActualError: boolean;
  ServerError: boolean;
  Unrecoverable: boolean;
  PasswordError: boolean;
  errList: TStringList;

begin
  errList := TStringList.Create();
  errList := ErrRegMatch((E as EFDDBEngineException).Message);

  EMessage := errList.Values['Message'];
  SQLCode := strToInt(errList.Values['SQLErrorCode']);
  NativeCode := strToInt(errList.Values['NativeErrorCode']);

  if (errList.Values['SubjectType'] = 'column') then
  begin
    FieldName := errList.Values['SubjectName'];
    OurName := FriendlyFieldname(Fieldname);
  end
{
  else
  if (errList.Values['SubjectType'] = 'primary key') or
     (errList.Values['SubjectType'] = 'key value') then
  begin
    FieldName := errList.Values['SubjectName'];
    OurName := Fieldname + ' key';
  end
}
  else
  begin
    FieldName := 'None';
    OurName := 'None';
  end;

  //Temp ignore rest
  //errList.Values['SubjectType2'];
  //errList.Values['SubjectName2'];

  errList.Free;

  RaisedError := EMessage;

  Unrecoverable := false;

  //Password wrong - Must have been changed by another instance....
  PasswordError := (SQLCode = 7078);

  ServerError :=
  (SQLCode = 6420) or  //Error discovering server
  (SQLCode = 6623) or  //Error discovering server/Communications error
  (SQLCode = 6610) or  //Communications error
  (SQLCode = 6303) or  //Maximum number of database Connections (Max 50 Per thread)
  (SQLCode = 7033) or  //Maximum number of database Connections (Total for Server)
  (SQLCode = 7004) or  //Maximum number of database Work Areas (Total for Server)
  (SQLCode = 7005) or  //Maximum number of database Tables (Total for Server)
  (SQLCode = 7006) or  //Maximum number of database Index Files (Total for Server)
  (SQLCode = 7007);    //Maximum number of database DataLocks (Total for Server)

  ActualError := False;
  case SQLCode of
    5054 : Errorstring := lblPermissionDenied.caption;
    7087 : Errorstring := lblPermissionDenied.caption;
    5035 : ErrorString := lblLockedbyanotheruser.caption;
    7078 : ErrorString := lblUserpasswordchangedbyanotheruser.caption;
    6420 : ErrorString := lblErrordiscoveringserver.caption;
    6623 : ErrorString := lblCommunicationsError.caption;
    6610 : ErrorString := lblCommunicationsError.caption;
    6303 : ErrorString := lblMaximumnumberofdatabaseconnectionsexceeded.caption;
    7033 : ErrorString := lblMaximumnumberofdatabaseconnectionsexceeded.caption;
    7004 : ErrorString := lblMaximumnumberofdatabaseWorkAreasexceeded.caption;
    7005 : ErrorString := lblMaximumnumberofdatabaseTablesexceeded.caption;
    7006 : ErrorString := lblMaximumnumberofdatabaseIndexFilesexceeded.caption;
    7007 : ErrorString := lblMaximumnumberofdatabaseDataLocksexceeded.caption;
    5141 : ErrorString := lblThisisinuseandcannotbechanged.caption;
    5147 : ErrorString := lblThiscannotbeblank.caption;
    5148 : ErrorString := lblThisistoosmall.caption;
    5149 : ErrorString := lblThisistoobig.caption;
    7057 : ErrorString := lblThisalreadyexists.caption;
    7076 : ErrorString := lblThisdoesnotexist.caption;
    7200, 5177 : begin     //SQL Errors often have additional error codes to identify them... (5177 = trigger failed)
             case NativeCode of
               5054 : Errorstring := lblPermissionDenied.caption;
               7087 : Errorstring := lblPermissionDenied.caption;
               5035 : ErrorString := lblLockedbyanotheruser.caption;
               7078 : ErrorString := lblUserpasswordchangedbyanotheruser.caption;
               6420 : ErrorString := lblErrordiscoveringserver.caption;
               6623 : ErrorString := lblCommunicationsError.caption;
               6303 : ErrorString := lblMaximumnumberofdatabaseconnectionsexceeded.caption;
               7033 : ErrorString := lblMaximumnumberofdatabaseconnectionsexceeded.caption;
               7004 : ErrorString := lblMaximumnumberofdatabaseWorkAreasexceeded.caption;
               7005 : ErrorString := lblMaximumnumberofdatabaseTablesexceeded.caption;
               7006 : ErrorString := lblMaximumnumberofdatabaseIndexFilesexceeded.caption;
               7007 : ErrorString := lblMaximumnumberofdatabaseDataLocksexceeded.caption;
               5141 : ErrorString := lblThisisinuseandcannotbechanged.caption;
               5147 : ErrorString := lblThiscannotbeblank.caption;
               5148 : ErrorString := lblThisistoosmall.caption;
               5149 : ErrorString := lblThisistoobig.caption;
               7057 : ErrorString := lblThisalreadyexists.caption;
               7076 : begin
                        if pos('involved in a transaction', E.Message) > 0 then
                          ErrorString := lblThisisbeingeditedelsewhere.Caption
                        else
                          ErrorString := lblThisdoesnotexist.Caption;
                      end
             else
               ErrorString := lblSQLError.caption;
             end;
           end
  else
    Unrecoverable := true;
    if pos('Client comm layer timed out', E.Message) > 0 then
    begin
      ServerError := true;
      ErrorString := lblCommunicationsError.caption;
    end
    else if pos('previous action is in progress', E.Message) > 0 then
    begin
      ServerError := true;
      ErrorString := lblDatabaseServerError.Caption;
    end
    else
      ActualError := True;
  end;

  if PasswordError then
  begin
    pnlMain.Color := clWhite;
    lblDetails.font.color := clBlue;
    fmErrorHandler.caption := lblDatabasePasswordError.caption;
    ErrorString := ErrorString + #13 + #13 + lblCloseSystemAndrestart.caption;
  end
  else if ServerError then
  begin
    pnlMain.Color := clBlue;
    lblDetails.font.color := clWhite;
    fmErrorHandler.caption := lblDatabaseServerError.caption;
    if (SQLCode <> 6623) and (not Unrecoverable) then
      ErrorString := ErrorString + #13 + #13 + lblOperationABORTEDWindowClosed.caption
    else
      ErrorString := ErrorString + #13 + #13 + lblCloseSystemAndrestart.caption;
  end
  else if ActualError then
  begin
    pnlMain.Color := clRed;
    lblDetails.font.color := clWhite;
    fmErrorHandler.caption := lblUnexpectedError.caption;
    ErrorString := EMessage;
    if (Unrecoverable) then
      ErrorString := ErrorString + #13 + #13 + lblCloseSystemAndrestart.caption;
  end
  else
  begin
    pnlMain.Color := MainColor;
    lblDetails.font.color := MainFontColor;
    fmErrorHandler.caption := lblValidityCheck.caption;
    //CJY Matches 7.4 Output
    if (SQLCode <> 5141) and (NativeCode <> 5141) and ((OurName <> '') and (OurName <> 'None')) then
      fmErrorHandler.caption := fmErrorHandler.caption + ' - ' + OurName;

    if (Unrecoverable) then
      ErrorString := ErrorString + #13 + #13 + lblCloseSystemAndrestart.caption;
  end;

  //0th Form is the top one which caused the Error
  //Special case, a 6623 makes Summs unstable, closing a window will not help
  if (PasswordError or ServerError) and (not HasClosed) and (SQLCode <> 6623) then
    Screen.Forms[0].close;
  HasClosed := False;

  if PasswordError or ServerError or ActualError then
    lblDetails.font.Style := [fsBold]
  else
    lblDetails.font.Style := [];
  lblDetails.AutoSize := False;
  lblDetails.Caption := ErrorString;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  //Resort out
  lblDetails.AutoSize := False;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  if not fmErrorHandler.Visible then fmErrorHandler.showmodal;
end;

procedure TfmErrorHandler.DbErrMsg(E: Exception);
var
  OurCode: integer;
  StartPos, EndPos: integer;
  FieldName, OurName: string;
  EMessage: string;
  ErrorString: string;
  ActualError: boolean;
  ServerError: boolean;

begin
  EMessage := (E as EDataBaseError).Message;
  OurCode := 0;
  RaisedError := EMessage;

  ServerError :=
  (pos('Error 6303', Emessage) > 0) or  //Maximum number of database Connections (Max 50 Per thread)
  (pos('Error 7033', Emessage) > 0) or  //Maximum number of database Connections (Total for Server)
  (pos('Error 7004', Emessage) > 0) or  //Maximum number of database Work Areas (Total for Server)
  (pos('Error 7005', Emessage) > 0) or  //Maximum number of database Tables (Total for Server)
  (pos('Error 7006', Emessage) > 0) or  //Maximum number of database Index Files (Total for Server)
  (pos('Error 7007', Emessage) > 0);    //Maximum number of database DataLocks (Total for Server)

  if pos('is not a valid value', EMessage) > 0 then
    OurCode := 1
  else if pos('must have a value', EMessage) > 0 then
    OurCode := 2
  else if pos('is not a valid floating point value', EMessage) > 0 then
    OurCode := 3
  else if pos('is not a valid integer value', EMessage) > 0 then
    OurCode := 4
  else if (pos('Cannot modify', EMessage) > 0) or (pos('Error 7087', EMessage) > 0) then
    OurCode := 5;

  if OurCode > 0 then
  begin
    StartPos := pos('FIELD', uppercase(EMessage)) + 7;
    ErrorString := copy(EMessage, StartPos, length(EMessage) - StartPos + 1);
    EndPos := pos('''', ErrorString) - 1;
    FieldName := Copy(ErrorString, 1, EndPos);
    OurName := FriendlyFieldname(Fieldname);
  end;

  ActualError := false;
  case OurCode of
    1 : ErrorString := lblThisisinvalid.caption;
    2 : ErrorString := lblThismusthaveavalue.caption;
    3 : ErrorString := lblThisisinvalid.caption;
    4 : ErrorString := lblThisisinvalid.caption;
    5 : ErrorString := lblPermissionDenied.caption;
  else if pos('Error 6303', Emessage) > 0 then
    ErrorString := lblMaximumnumberofdatabaseconnectionsexceeded.caption
  else  if pos('Error 7033', Emessage) > 0 then
    ErrorString := lblMaximumnumberofdatabaseconnectionsexceeded.caption
  else  if pos('Error 7044', Emessage) > 0 then
    ErrorString := lblMaximumnumberofdatabaseWorkAreasexceeded.caption
  else  if pos('Error 7005', Emessage) > 0 then
    ErrorString := lblMaximumnumberofdatabaseTablesexceeded.caption
  else  if pos('Error 7006', Emessage) > 0 then
    ErrorString := lblMaximumnumberofdatabaseIndexFilesexceeded.caption
  else  if pos('Error 7007', Emessage) > 0 then
    ErrorString := lblMaximumnumberofdatabaseDataLocksexceeded.caption
  else
    ActualError := True;
  end;

  if ServerError then
  begin
    pnlMain.Color := clBlue;
    lblDetails.font.color := clWhite;
    fmErrorHandler.caption := lblDatabaseServerLimit.caption;
  end
  else if ActualError then
  begin
    pnlMain.Color := clRed;
    lblDetails.font.color := clWhite;
    fmErrorHandler.caption := lblUnexpectedError.caption;
    ErrorString := EMessage;
  end
  else
  begin
    pnlMain.Color := MainColor;
    lblDetails.font.color := MainFontColor;
    fmErrorHandler.caption := lblValidityCheck.caption + ' - ' + OurName;
  end;

  if ServerError or ActualError then
    lblDetails.font.Style := [fsBold]
  else
    lblDetails.font.Style := [];
  lblDetails.AutoSize := False;
  lblDetails.Caption := ErrorString;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  //Resort out
  lblDetails.AutoSize := False;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  if not fmErrorHandler.Visible then fmErrorHandler.showmodal;
end;

procedure TfmErrorHandler.ConvErrMsg(E: Exception);
var
  OurCode: integer;
  EMessage: string;
  ErrorString: string;
  ActualError: boolean;

begin
  RaisedError := '';
  EMessage := (E as EConvertError).Message;
  OurCode := 0;

  if pos('is not a valid date', EMessage) > 0 then
    OurCode := 1;

  if pos('is not a valid integer', EMessage) > 0 then
    OurCode := 2;

  ActualError := false;
  case OurCode of
    1: ErrorString := EMessage;
    2: ErrorString := EMessage;
  else
    ActualError := True;
  end;

  if ActualError then
  begin
    pnlMain.Color := clRed;
    lblDetails.font.color := clWhite;
    fmErrorHandler.caption := lblUnexpectedError.caption;
    ErrorString := EMessage;
  end
  else
  begin
    pnlMain.Color := MainColor;
    lblDetails.font.color := MainFontColor;
    fmErrorHandler.caption := lblConversion.caption;
  end;

  if ActualError then
    lblDetails.font.Style := [fsBold]
  else
    lblDetails.font.Style := [];
  lblDetails.AutoSize := False;
  lblDetails.Caption := ErrorString;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  //Resort out
  lblDetails.AutoSize := False;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  if not fmErrorHandler.Visible then fmErrorHandler.showmodal;
end;

procedure TfmErrorHandler.OtherErrMsg(E: Exception);
begin
  RaisedError := '';
  pnlMain.Color := clRed;
  lblDetails.font.color := clWhite;
  fmErrorHandler.caption := lblUnexpectedError.caption;

  lblDetails.font.Style := [fsBold];
  lblDetails.AutoSize := False;
  lblDetails.Caption := E.message;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  //Resort out
  lblDetails.AutoSize := False;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  //Dont display dummy error
  if E.message <> 'NOERROR' then
    if not fmErrorHandler.Visible then fmErrorHandler.showmodal;
end;

procedure TfmErrorHandler.DebugMessageDlg(OurMsg, ErrorMsg, SQLText: string);
begin
  fmErrorHandler.caption := 'Information';

  pnlMain.Color := MainColor;
  lblDetails.font.color := MainFontColor;

  lblDetails.AutoSize := False;
  lblDetails.Caption := OurMsg;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  //Resort out
  lblDetails.AutoSize := False;
  lblDetails.AutoSize := True;
  lblDetails.Width := 300;

  RaisedError := ErrorMsg;
  SQLString := SQLText;

  if not fmErrorHandler.Visible then fmErrorHandler.showmodal;
end;

procedure TfmErrorHandler.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  DebugNow := False;
//  RaisedError := '';

//  Form := (Sender as TForm);
  Form := Application.MainForm;

  //Ok Button visible for validity checks - not errors.
  //Makes it look like messagedlg
  pnlBottom.visible := (lblDetails.font.Style = []);
  pnlBottom.color := pnlMain.color;

  screen.cursor := crDefault;
//  Form.Height := lblDetails.Height + 20;
//  if pnlBottom.visible then
//    Form.Height := Form.Height + pnlBottom.Height;
//  if Form.Height < 150 then
//    Form.Height := 170;
//  Form.Width := 328;

  Height := lblDetails.Height + 20;
  if pnlBottom.visible then
    Height := Height + pnlBottom.Height;
  if Height < 150 then
    Height := 170;
  Width := 328;

  lblDetails.top := (pnlMain.Height div 2) - (lblDetails.Height div 2);
  btnOk.Left := (pnlMain.Width div 2) - (btnOk.Width div 2);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

procedure TfmErrorHandler.Initialise;
var
  i: integer;

begin
  qAllFields.open;

  //CJY: qAllFields.FetchOptions.RecordCountMode set to cmTotal
  NoFields := qAllFields.recordcount;
  setLength(FieldNames, NoFields);
  setLength(OurNames, NoFields);

  i := -1;
  qAllFields.first;
  while not qAllFields.Eof do
  begin
    inc(i);
    FieldNames[i] := qAllFieldsFieldName.value;
    OurNames[i] := qAllFieldsOurName.value;
    qAllFields.next;
  end;
  qAllFields.close;
end;

function TfmErrorHandler.FriendlyFieldName(Fieldname: string): string;
var
  OurName: string;
  Found: boolean;
  i: integer;

begin
  Found := false;
  i := -1;
  while (not Found) and (i < (NoFields - 1)) do
  begin
    inc(i);
    if Fieldname = Fieldnames[i] then
    begin
      OurName := OurNames[i];
      Found := true;
    end;
  end;

  {$IFDEF VSTITCH}
  if Found then
    OurName := TranslateString(dm.tblGeneralLanguage.value, dm.tblTranslation, OurName);
  {$ENDIF}

  if FieldName = '' then
    OurName := ''
  else if not Found then
    OurName := '*** ' + Fieldname + ' ***';

  Result := OurName;
end;

procedure TfmErrorHandler.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fmErrorHandler.Color := MainColor;
  if not(Application.mainform.Name = 'fmVisionStitch') then
    btnOk.Color := MainColor;
  Application.ProcessMessages;
end;

procedure TfmErrorHandler.FormCreate(Sender: TObject);
begin
  {$IFDEF VSTITCH}
  LoadTags(dm.tblSystemWords, dm.tblTranslationLookUp, fmErrorHandler);
  Translate(dm.tblGeneralLanguage.value, dm.tblTranslation, dm.tblTranslationLookUp, fmErrorHandler);
  {$ENDIF}

  AutoColor(Self);

  MainColor := pnlMain.Color;
  MainFontColor := lblDetails.Font.Color;
end;

procedure TfmErrorHandler.btnOkClick(Sender: TObject);
var
  f: TextFile;

begin
  if DebugNow and not(RaisedError = '') then
  begin
    fmErrorHandler.Color := clLime;
    btnOk.Color := clLime;
    lblDetails.Caption := RaisedError;

    lblDetails.AutoSize := True;
    lblDetails.Width := 300;

    //Resort out
    lblDetails.AutoSize := False;
    lblDetails.AutoSize := True;
    lblDetails.Width := 300;
    lblDetails.top := (pnlMain.Height div 2) - (lblDetails.Height div 2);

    if not(SQLString = '') then
    begin
      AssignFile(f, ExtractFilePath(Application.ExeName) + 'SQLString.SQL');
      rewrite(f);
      writeln(f, SQLString);
      CloseFile(f);
    end;

    DebugNow := False;
  end
  else
  begin
    close;
  end;
end;

procedure TfmErrorHandler.btnOkKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) then
    DebugNow := True
  else
    DebugNow := False;
end;

procedure TfmErrorHandler.btnOkKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if not(ssAlt in Shift) then
    DebugNow := False;
end;

end.
