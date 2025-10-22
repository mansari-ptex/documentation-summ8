unit Dongle_Green;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Menus, ComCtrls, DIALOGS {temp};

type
  TDongle = record
    Error: Boolean;
    Code: LongInt;
    CustomerName: string;
  end;
  drisType = packed record
    { the first 4 fields are never encrypted }
    header          : array[0..3] of AnsiChar;  { should be set to DRIS }
    { inputs }
    size            : longint;              	{ size of this structure }
    seed1           : longint;              	{ seed for data/dris encryption }
    seed2           : longint;              	{ as above }
    { maybe encrypted from now on }
    myfunction      : longint;              	{ specify only one function. NB can't name it "function" as it is a reserved keyword }
    flags           : longint;              	{ options for the function selected. To use more than one OR them together: OPTION1 or OPTION2... }
    execs_decrement : longword;             	{ amount by which to dec execs if we use flag: DEC_MANY_EXECS }
    data_crypt_key_num : longint;           	{ number of the key (1-3) that the dongle uses to encrypt or decrypt user data }
    rw_offset       : longint;              	{ offset in the dongle data area to read or write data }
    rw_length       : longint;              	{ length of data are to read/write/encrypt/decrypt }
    rw_data_ptr     : Pbyte;                	{ pointer to data to write / be read }
    alt_prog_name   : array[0..255] of AnsiChar;    { protection check for different program instead of this one, must be null-terminated }
    var_a           : longint;              	{ variable values for user algorithm }
    var_b           : longint;
    var_c           : longint;
    var_d           : longint;
    var_e           : longint;
    var_f           : longint;
    var_g           : longint;
    var_h           : longint;
    alg_number      : longint;              	{ the number of the user algorithm that you want to execute }
    { outputs }
    ret_code        : longint;              	{ return code from the protection check }
    ext_err         : longint;              	{ extended error }
    dongle_type     : longint;              	{ type of dongle detected. 1 = Pro, 2 = FD. NB "type" is a reserved word so I use dongle_type }
    model           : longint;              	{ model of dongle detected. 1= Lite, 2=Pro, 3=N1, 4=N5, 5=N10, 6=N50, 7=NU }
    sdsn            : longint;              	{ Software Developer's Serial Number }
    prodcode        : array[0..11] of AnsiChar;     { Product Code (null-terminated) }
    dongle_number   : longword;
    update_number   : longint;
    data_area_size  : longword;             	{ size of the data area in the dongle detected }
    max_alg_num     : longint;              	{ the maximum algorithm number in the dongle detected }
    execs           : longint;              	{ executions left: -1 indicates 'no limit' }
    exp_day         : longint;              	{ expiry day: -1 indicates 'no limit' }
    exp_month       : longint;              	{ expiry month: -1 indicates 'no limit' }
    exp_year        : longint;              	{ expiry year: -1 indicates 'no limit' }
    features        : longword;             	{ features value }
    net_users       : longint;              	{ maximum number of network users for the dongle detected: -1 indicates 'no limit' }
    alg_answer      : longint;              	{ answer to the user algorithm executed with the given variable values }
    fd_capacity     : longword;             	{ capacity of the data area in FD dongle. Currently fixed at ~10MB but may change in the future. }
    fd_drive        : array[0..3] of AnsiChar;      { drive letter of FD dongle detected (if any) 'f:\' }
  end;

const PROTECTION_CHECK = 1;           //checks for dongle, check program params...
const EXECUTE_ALGORITHM = 2;		      //protection check + calculate answer for specified algorithm with specified inputs
const WRITE_DATA_AREA = 3;		        //protection check + writes dongle data area
const READ_DATA_AREA = 4;		          //protection check + reads dongle data area
const ENCRYPT_USER_DATA = 5;		      //protection check + the dongle will encrypt user data
const DECRYPT_USER_DATA = 6;		      //protection check + the dongle will decrypt user data
const FAST_PRESENCE_CHECK = 7;        //checks for the presence of the correct dongle only with minimal security, no flags allowed

const DEC_ONE_EXEC = 1;		            //decrement execs by 1
const DEC_MANY_EXECS = 2;		          //decrement execs by number specified in execs_decrement
const START_NET_USER = 4;		          //starts a network user
const STOP_NET_USER = 8;		          //stops a network user (a protection check is NOT performed)
const USE_FUNCTION_ARGUMENT = 16;		  //use the extra argument in the function for pointers
const CHECK_LOCAL_FIRST = 32;		      //always look in local ports before looking in network ports
const CHECK_NETWORK_FIRST = 64;		    //always look on the network before looking in local ports
const USE_ALT_PROG_NAME = 128;		    //use name specified in prog_name instead of this program name
const DONT_SET_MAXDAYS_EXPIRY = 256;  //if the max days expiry date has not been calculated then do not do it this time
const MATCH_DONGLE_NUMBER = 512;		  //restrict the search to match the dongle number specified in the DRIS

var
  dris: drisType;
  NoChecks: integer = 0;

function CheckGreenDongle(MainForm: TForm; ErrorLabel: TLabel; ProtType: integer): TDongle;
function ProtCheck(ProtType: integer): TDongle;

implementation

uses
  CmnVars
  {$IFDEF VSTITCH}
  , ExtCtrls, Data, TranSys
  {$ENDIF}
  ;

{$IFDEF VSTITCH}
function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'VisionStitch9x32.dll';
{$ENDIF}
{$IFDEF SATRASUMM}
  {$IFDEF WIN32}
  function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'SATRASumm8x32.dll';
  {$ENDIF}
  {$IFDEF WIN64}
  function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'SATRASumm8x64.dll';
  {$ENDIF}
{$ENDIF}
{$IFDEF TIMELINE}
  {$IFDEF WIN32}
  function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'TimeLine2x32.dll';
  {$ENDIF}
  {$IFDEF WIN64}
  function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'TimeLine2x64.dll';
  {$ENDIF}
{$ENDIF}

procedure random_set(data: PByte; length: integer);
var
  i: integer;

begin
  Randomize();
  for i := 0 to length - 1 do
  begin
    data^ := Random(256);
    inc(data);
  end;
end;

function ProtCheck(ProtType: integer): TDongle;
var
  Dongle: TDongle;
  Code: LongInt;
  Error: Boolean;
  CustomerName: string;
  DataToRead: array [0..19] of AnsiChar;
  i: integer;
  c: AnsiChar;

begin
  CustomerName := 'Unchecked';

  random_set(@dris, SizeOf(dris));
  Move(AnsiString('DRIS'), dris.header, 4);
  dris.size := SizeOf(dris);
  dris.myfunction := ProtType; //FAST_PRESENCE_CHECK or PROTECTION_CHECK or READ_DATA_AREA;
  dris.flags := 0;
  dris.rw_offset := 0;
  dris.rw_length := 20;
  dris.rw_data_ptr := Addr(DataToRead);

  Code := DDProtCheck(@dris, NIL);

  if (Code = 0) and (ProtType = READ_DATA_AREA) then
  begin
    //First 20 characters of the Data is the Customer Name
    CustomerName := '';
    for i := 0 to Length(DataToRead) - 1 do
    begin
      c := DataToRead[i];
      if ord(c) = 0 then
        c := ' ';
      CustomerName := CustomerName + c;
    end;
  end;

  Dongle.Error := (Code <> 0);
  Dongle.Code := Code;
  Dongle.CustomerName := CustomerName;

  Result := Dongle;
end;

function DDErrors_Green(ErrNo: integer): string;
var
  UnKnownError: boolean;
  s: string;

begin
  UnKnownError := False;
  case ErrNo of
    401 : s := 'Cannot find green dongle';
    419 : s := 'Your system date has gone backwards';
    422 : s := 'Your dongle has expired';
  else
    UnKnownError := True;
    s := 'Invalid Dongle - Error';
  end;

  {$IFDEF VSTITCH}
  s := TranslateString(dm.tblGeneralLanguage.value, dm.tblTranslation, s);
  {$ENDIF}

  if UnKnownError then
    s := s + ' '  + Inttostr(ErrNo);

  Result := s;
end;

function CheckGreenDongle(MainForm: TForm; ErrorLabel: TLabel; ProtType: integer): TDongle;
var
  Dongle: TDongle;
  Error: string;
  ProgramProtected, DongleDetected, DongleError: Boolean;
  ExpiryDate: TDateTime;
  DaysToExpiry: integer;
  i: integer;
  Temp: TComponent;

begin
  if (ProtType = FAST_PRESENCE_CHECK) and
     (ErrorLabel.Caption <> '') and
     (not (pos('Licence will expire in', ErrorLabel.Caption) = 1)) then
    ProtType := PROTECTION_CHECK;

  //Every 100th Fast Check must be a full check
  if (ProtType = FAST_PRESENCE_CHECK) then
  begin
    inc(NoChecks);
    if NoChecks mod 100 = 0 then
      ProtType := PROTECTION_CHECK;
  end;

  Dongle := ProtCheck(ProtType);
  ProgramProtected := (Dongle.Code <> 413);
  DongleDetected := (Dongle.Code <> 401);

  DongleError := False;
  Error := '';

  if not ProgramProtected then
  begin
    DongleError := True;
    Error := 'Program not dongle protected';
  end
  else if DongleDetected then
  begin
    if Dongle.Code > 0 then
    begin
      DongleError := True;
      Error := DDErrors_Green(Dongle.Code);
    end
    else if (dris.exp_day = -1) and (dris.exp_month = -1) and (dris.exp_year = -1) then
    begin
      //Unlimited dongle returns
      //date of -1/-1/-1 - we should
      //never issue an unlimited dongle
      DongleError := True;
      Error := 'No expiry date on dongle';
    end;

    if (not DongleError) and (dris.sdsn <> 10347) then
    begin
      DongleError := True;
      Error := 'Not a SATRA dongle';
    end
  end
  else
  begin
    DongleError := True;
    Error := 'No green dongle detected';
  end;

  if DongleError then
  begin
    ExpiryDate := EncodeDate(1980, 1, 1);
    Feature := 65535;
  end
  else
  begin
    if ProtType = PROTECTION_CHECK then
    begin
      ExpiryDate := EncodeDate(dris.exp_year, dris.exp_month, dris.exp_Day);
      Feature := dris.features;

      DaysToExpiry := round(ExpiryDate - Date);
      if (DaysToExpiry > -1) and (DaysToExpiry < 29) then
      begin
        Error := 'Licence will expire in ' + IntToStr(DaysToExpiry + 1) + ' day';
        if DaysToExpiry <> 1 then
          Error := Error + 's';
      end;
    end;
  end;

  //Ensure any expiry message stays up if only done a simple
  //check, no errors detected and it was up before
  if (ProtType = FAST_PRESENCE_CHECK) and
     (Error = '') and
     (pos('Licence will expire in', ErrorLabel.Caption) = 1) then
    Error := ErrorLabel.Caption;

  ErrorLabel.Caption := Error;
  ErrorLabel.Visible := (Error <> '');

  //Enable/Disable main toolbar and all
  //menus except the dongle menu
  for i := 0 to MainForm.ComponentCount - 1 do
  begin
    Temp := MainForm.Components[i];

    {$IFNDEF VSTITCH}
    if (Temp is TToolbar) then
      (Temp as TToolBar).Enabled := (not DongleError);
    {$ENDIF}

    if (Temp is TMenuItem) then
    begin
      if ((Temp as TMenuItem).Name <> 'mmAbout') and
           ((Temp as TMenuItem).Name <> 'System1') and
           ((Temp as TMenuItem).Name <> 'Features1') and
         ((Temp as TMenuItem).Name <> 'mmMoreSystems') and
         ((Temp as TMenuItem).Name <> 'MoreSATRAProductionEfficiencySystems1') and
           ((Temp as TMenuItem).Name <> 'Timeline1') and
           ((Temp as TMenuItem).Name <> 'VisionStitch1') and
           ((Temp as TMenuItem).Name <> 'SATRA1') and
         ((Temp as TMenuItem).Name <> 'mmSATRASumm') and
         ((Temp as TMenuItem).Name <> 'mmTimeLine') and
         ((Temp as TMenuItem).Name <> 'mmVisionStitch') and
         ((Temp as TMenuItem).Name <> 'mmSATRA') and
         ((Temp as TMenuItem).Name <> 'mmDongle') and
         ((Temp as TMenuItem).Name <> 'mmDongleInfo') and
         ((Temp as TMenuItem).Name <> 'mmDongleChange') then
        (Temp as TMenuItem).Enabled := (not DongleError);
    end;

    {$IFDEF VSTITCH}
    if (Temp is TPanel) then
    begin
      if (Temp.Name = 'pnlWholeScreen') or (Temp.Name = 'pnlToolbarMain') then
        (Temp as TPanel).Enabled := (not DongleError);
    end;
    {$ENDIF}
  end;

  //Ensure the status of the toolbuttons match the toolbar
  //Shouldnt be necesary but toolbuttons intermittently becoming
  //greyed out despite no specific code disabling the individual buttons
  {$IFNDEF VSTITCH}
  for i := 0 to MainForm.ComponentCount - 1 do
  begin
    Temp := MainForm.Components[i];

    if (Temp is TToolButton) then
      (Temp as TToolButton).Enabled := (not DongleError);
  end;
  {$ENDIF}

  //Dongle.Code and .CustomerName uses actual from call
  Dongle.Error := DongleError;

  Result := Dongle;
end;

end.

