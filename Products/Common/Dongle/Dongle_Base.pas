unit Dongle_Base;

interface

uses
  dris_for_dll;

type
  TDongleCheck = (dcQuick, dcFull, dcFullAndRead, dcFullAndWrite);

  TDongle = class
    private
      FDongleCheck: TDongleCheck;
      Fdris: drisType;
      FDataToWrite: array[0..63] of AnsiChar;

      FCheckCode: LongInt;
      FProductCode: array[0..11] of AnsiChar;
      FDongleSerialNumber: LongInt;
      FSATRASerialNumber: LongWord;
      FExpiryDay: LongInt;
      FExpiryMonth: LongInt;
      FExpiryYear: LongInt;
      FFeatures: LongWord;
      FUpdateNumber: LongInt;

      FError: Boolean;
      FWarning: Boolean;
      FMessageString: string;

      FUpdateConfirmationCode: LongInt;
      FUpdateExtendedError: LongInt;

      function GetProductCode: string;
      function GetExpiryDateUsed: Boolean;
      function GetExpiryDate: TDateTime;
      function GetExpiryDateAsString: AnsiString;
      function GetExpiryDateDays: LongInt;
      function GetExpiryDateSoon: Boolean;
      function GetExpired: Boolean;
      function GetDongleDetected: Boolean;
      function GetSATRADongle: Boolean;
      function GetCorrectDongle: Boolean;
      function GetProgramProtected: Boolean;

      procedure RandomSet(Data: PByte; Length: Integer);
      procedure Initialise;

      function ProtectionType: SmallInt;
      procedure ProtectionInitialise;
      procedure ProtectionInitialiseRead;
      procedure ProtectionInitialiseWrite(DataOffset, DataLength: Integer; Data: String);
      procedure ProtectionCheck;
      procedure ProtectionResults;
      procedure ProtectionSummary;
    protected
      FData: array[0..63] of AnsiChar;
      FDataTotalLength: SmallInt;

      FProductCodeRequired: string;
      FExpiryDateNeeded: Boolean;

      procedure InitialiseType; virtual;
      function ArrayToString(a: array of AnsiChar; First, Last: SmallInt): String;
      procedure CheckAndWriteData(DataOffset, DataLength: LongInt; Data: String);
    public
      constructor Create;
      destructor Destroy;

      procedure Check(ADongleCheck: TDongleCheck);
      function UpdateCode(ACode: AnsiString): LongInt;

      property CheckCode: LongInt read FCheckCode;
      property ProductCode: string read GetProductCode;
      property DongleDetected: Boolean read GetDongleDetected;
      property SATRADongle: Boolean read GetSATRADongle;
      property CorrectDongle: Boolean read GetCorrectDongle;
      property ProgramProtected: Boolean read GetProgramProtected;
      property SerialNumber: LongWord read FSATRASerialNumber;
      property ExpiryDateUsed: Boolean read GetExpiryDateUsed;
      property ExpiryDate: TDateTime read GetExpiryDate;
      property ExpiryDateAsString: AnsiString read GetExpiryDateAsString;
      property ExpiryDateNeeded: Boolean read FExpiryDateNeeded;
      property ExpiryDateDays: LongInt read GetExpiryDateDays;
      property ExpiryDateSoon: Boolean read GetExpiryDateSoon;
      property Expired: Boolean read GetExpired;
      property Features: LongWord read FFeatures;
      property UpdateNumber: LongInt read FUpdateNumber;

      property Error: Boolean read FError;
      property Warning: Boolean read FWarning;
      property MessageString: string read FMessageString;

      property UpdateConfirmationCode: LongInt read FUpdateConfirmationCode;
      property UpdateExtendedError: LongInt read FUpdateExtendedError;
  end;

implementation

uses
  SysUtils, DateUtils, const_for_change;




{ TDongle }



function TDongle.ArrayToString(a: array of AnsiChar; First, Last: SmallInt): String;
var
  s: string;
  i: SmallInt;

begin
  s := '';
  for i := First to Last do
    s := s + a[i];

  Result := TrimRight(s);
end;


procedure TDongle.Check(ADongleCheck: TDongleCheck);
begin
  FDongleCheck := ADongleCheck;

  ProtectionInitialise;
  if (FDongleCheck = dcFullAndRead) then
    ProtectionInitialiseRead;
  ProtectionCheck;
end;


procedure TDongle.CheckAndWriteData(DataOffset, DataLength: Integer; Data: String);
begin
  FDongleCheck := dcFullAndWrite;

  ProtectionInitialise;
  ProtectionInitialiseWrite(DataOffset, DataLength, Data);
  ProtectionCheck;

  //ReCheck to Read Changes
  Check(dcFullAndRead);
end;


constructor TDongle.Create;
begin
  inherited;

  Initialise;
end;


destructor TDongle.Destroy;
begin

  inherited;
end;


function TDongle.GetCorrectDongle: Boolean;
begin
  Result := (FProductCode = FProductCodeRequired);
end;


function TDongle.GetDongleDetected: Boolean;
begin
  Result := (FCheckCode <> 401);
end;


function TDongle.GetExpired: Boolean;
begin
  Result := (FCheckCode = 422);
end;


function TDongle.GetExpiryDate: TDateTime;
var
  td: TDateTime;

begin
  try
    td := EncodeDate(FExpiryYear, FExpiryMonth, FExpiryDay);
  except
    td := EncodeDate(1901, 1, 1);
  end;

  Result := td;
end;


function TDongle.GetExpiryDateAsString: AnsiString;
begin
  Result := DateToStr(ExpiryDate);
end;


function TDongle.GetExpiryDateDays: LongInt;
begin
  Result := round(ExpiryDate - Date);
end;


function TDongle.GetExpiryDateSoon: Boolean;
begin
  Result := (ExpiryDateDays >= 0) and (ExpiryDateDays <= 28);
end;


function TDongle.GetExpiryDateUsed: Boolean;
begin
  Result := (FExpiryDay <> -1) and (FExpiryMonth <> -1) and (FExpiryYear <> -1);
end;


function TDongle.GetProductCode: string;
begin
  Result := ArrayToString(FProductCode, 0, Length(FProductCode) - 1);
end;


function TDongle.GetProgramProtected: Boolean;
begin
  Result := (FCheckCode <> 413);
end;


function TDongle.GetSATRADongle: Boolean;
begin
  Result := (FDongleSerialNumber = MY_SDSN);
end;


procedure TDongle.Initialise;
begin
  FDongleCheck := dcFull;

  FCheckCode := -1;
  FProductCode := '';
  FDongleSerialNumber := -1;
  FSATRASerialNumber := 0;
  FExpiryDay := -1;
  FExpiryMonth := -1;
  FExpiryYear := -1;
  FFeatures := 0;
  FUpdateNumber := -999;

  FError := False;
  FWarning := False;
  FMessageString := '';

  FUpdateConfirmationCode := 0;
  FUpdateExtendedError := 0;

  InitialiseType;
end;


procedure TDongle.ProtectionCheck;
begin
  FCheckCode := DDProtCheck(@Fdris, NIL);

  ProtectionResults;
  ProtectionSummary;
end;


procedure TDongle.ProtectionInitialise;
begin
  RandomSet(@Fdris, SizeOf(Fdris));
  Move(AnsiString('DRIS'), Fdris.header, 4);
  Fdris.size := SizeOf(Fdris);
  Fdris.myfunction := ProtectionType;
  Fdris.flags := 0;
end;


procedure TDongle.ProtectionInitialiseRead;
begin
  Fdris.rw_offset := 0;
  Fdris.rw_length := FDataTotalLength;
  Fdris.rw_data_ptr := Addr(FData);
end;


procedure TDongle.ProtectionInitialiseWrite(DataOffset, DataLength: Integer; Data: String);
var
  i: SmallInt;

begin
  if Length(Data) + DataOffSet > 64 then
    Data := '';

  Fdris.rw_offset := DataOffset;
  Fdris.rw_length := DataLength;
  for i := 1 to Length(Data) do
    FDataToWrite[i - 1] := AnsiChar(Data[i]);

  Fdris.rw_data_ptr := Addr(FDataToWrite);
end;


procedure TDongle.ProtectionResults;
begin
  Move(Fdris.prodcode, FProductCode, 11);
  FDongleSerialNumber := Fdris.sdsn;
  FSATRASerialNumber := Fdris.dongle_number;
  FExpiryDay := Fdris.exp_day;
  FExpiryMonth := Fdris.exp_month;
  FExpiryYear := Fdris.exp_year;
  FFeatures := Fdris.features;
  FUpdateNumber := Fdris.update_number
end;


procedure TDongle.ProtectionSummary;
begin
  FError := False;
  FWarning := False;
  FMessageString := '';

  if not ProgramProtected then
  begin
    FError := True;
    FMessageString := 'Program not dongle protected';
  end
  else if DongleDetected then
  begin
    if not SATRADongle then
    begin
      FError := True;
      FMessageString := 'Not a SATRA dongle';
    end
    else if not CorrectDongle then
    begin
      FError := True;
      FMessageString := 'Incorrect SATRA dongle';
    end
    else if Expired then
    begin
      FError := True;
      FMessageString := 'Your dongle has expired';
    end
    else if FCheckCode > 0 then
    begin
      FError := True;

      case FCheckCode of
        419 : FMessageString := 'Your system date has gone backwards';
      else
        FMessageString := 'Invalid Dongle - Error' + ' '  + Inttostr(FCheckCode);
      end;
    end
    else
    begin
      if ExpiryDateNeeded and (not ExpiryDateUsed) then
      begin
        FError := True;
        FMessageString := 'No expiry date on dongle';
      end
      else if ExpiryDateSoon then
      begin
        FWarning := True;
        FMessageString := 'Licence will expire in ' + IntToStr(ExpiryDateDays + 1) + ' day(s)';
      end;
    end;
  end
  else
  begin
    Initialise;

    FError := True;
    FMessageString := 'Cannot find dongle';
  end;
end;


procedure TDongle.InitialiseType;
begin
  FProductCodeRequired := '';
  FExpiryDateNeeded := False;
  FDataTotalLength := 0;
end;


function TDongle.ProtectionType: SmallInt;
var
  iProtectionType: SmallInt;

begin
  case FDongleCheck of
    dcQuick :        iProtectionType := FAST_PRESENCE_CHECK;
    dcFull :         iProtectionType := PROTECTION_CHECK;
    dcFullAndRead :  iProtectionType := READ_DATA_AREA;
    dcFullAndWrite : iProtectionType := WRITE_DATA_AREA;
  end;

  Result := iProtectionType;
end;


procedure TDongle.RandomSet(Data: PByte; Length: Integer);
var
  i: Integer;

begin
  Randomize();
  for i := 0 to Length - 1 do
  begin
    Data^ := Random(256);
    inc(Data);
  end;
end;


function TDongle.UpdateCode(ACode: AnsiString): LongInt;
var
  update_code: array[0..255] of AnsiChar;

begin
  StrPCopy(update_code, AnsiString(ACode));
  Result := DCDoUpdateCodeString(@update_code, @FUpdateConfirmationCode, @FUpdateExtendedError);
end;


end.
