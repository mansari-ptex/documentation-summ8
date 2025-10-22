unit dris_for_dll;

interface

uses Windows;

  TYPE
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
        alt_licence_name : array[0..255] of AnsiChar;    { protection check for different licence instead of the default one, must be null-terminated }
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
        model           : longint;              	{ model of dongle detected. 1 = Lite, 2 = Plus, 4 = Net 5, 7 = Net Unlimited }
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
        fd_drive        : array[0..127] of AnsiChar;    { drive letter of FD dongle detected (if any) 'f:\' }
        swkey_type      : longint;                  { 0 = no swkey detected, 1 = temporary software key, 2 = demo software key }
        swkey_exp_day   : longint;                  { software key expiry date (if software key detected) }
        swkey_exp_month : longint;
        swkey_exp_year  : longint;
  end;

  TYPE
        nu_infoType = packed record
        licenceName     : array[0..255] of AnsiChar;
        userName        : array[0..49] of AnsiChar;
        computerName    : array[0..255] of AnsiChar;
        ipAddress       : array[0..15] of AnsiChar;
  end;

  const MY_SDSN = 10347;

  { function constants - specify one only }
  const PROTECTION_CHECK = 1;                     { checks for dongle, check program params... }
  const EXECUTE_ALGORITHM = 2;		                { protection check + calculate answer for specified algorithm with specified inputs }
  const WRITE_DATA_AREA = 3;                      { protection check + writes dongle data area }
  const READ_DATA_AREA = 4;                       { protection check + reads dongle data area }
  const ENCRYPT_USER_DATA = 5;                    { protection check + the dongle will encrypt user data }
  const DECRYPT_USER_DATA = 6;                    { protection check + the dongle will decrypt user data }
  const FAST_PRESENCE_CHECK = 7;                  { checks for the presence of the correct dongle only with minimal security, no flags allowed. }

  { flag constants - can specify more than one }
  const DEC_ONE_EXEC = 1;		                      { decrement execs by 1 }
  const DEC_MANY_EXECS = 2;                       { decrement execs by number specified in execs_decrement }
  const START_NET_USER = 4;                       { starts a network user }
  const STOP_NET_USER = 8;                        { stops a network user (a protection check is NOT performed) }
  const USE_FUNCTION_ARGUMENT = 16;               { use the extra argument in the function for pointers }
  const CHECK_LOCAL_FIRST = 32;                   { always look in local ports before looking in network ports }
  const CHECK_NETWORK_FIRST = 64;                 { always look on the network before looking in local ports }
  const USE_ALT_LICENCE_NAME = 128;               { use name specified in alt_licence_name instead of the default one }
  const DONT_SET_MAXDAYS_EXPIRY = 256;            { if the max days expiry date has not been calculated then do not do it this time }
  const MATCH_DONGLE_NUMBER = 512;                { restrict the search to match the dongle number specified in the DRIS }

//{$IFDEF WIN32}
//  function DDProtCheck( dris, data:pointer ):LongInt; stdcall; external 'dpwin32.dll';
//  function DDGetNetUserList(licence_name:PAnsiChar; num_net_users:PLongInt; nu_info:pointer; num_info_structs:LongInt; extended_error:PLongInt):LongInt; stdcall; external 'dpwin32.dll';
//{$ELSE}
//  function DDProtCheck( dris, data:pointer ):LongInt; stdcall; external 'dpwin64.dll';
//  function DDGetNetUserList(licence_name:PAnsiChar; num_net_users:PLongInt; nu_info:pointer; num_info_structs:LongInt; extended_error:PLongInt):LongInt; stdcall; external 'dpwin64.dll';
//{$ENDIF}

{$IFDEF SATRASUMM}
  {$IFDEF WIN32}
    {$IFDEF RELEASE}
      function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'SATRASumm8x32.dll';
    {$ENDIF}
    {$IFDEF DEBUG}
      function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'SATRASumm8x32debug.dll';
    {$ENDIF}
  {$ENDIF}
  {$IFDEF WIN64}
    {$IFDEF RELEASE}
      function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'SATRASumm8x64.dll';
    {$ENDIF}
    {$IFDEF DEBUG}
      function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'SATRASumm8x64debug.dll';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$IFDEF TIMELINE}
  {$IFDEF WIN32}
    {$IFDEF RELEASE}
      function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'TimeLine2x32.dll';
    {$ENDIF}
    {$IFDEF DEBUG}
      function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'TimeLine2x32debug.dll';
    {$ENDIF}
  {$ENDIF}
  {$IFDEF WIN64}
    {$IFDEF RELEASE}
      function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'TimeLine2x64.dll';
    {$ENDIF}
    {$IFDEF DEBUG}
      function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'TimeLine2x64debug.dll';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$IFDEF VSTITCH}
  {$IFDEF RELEASE}
    function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'VisionStitch9x32.dll';
  {$ENDIF}
  {$IFDEF DEBUG}
    function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'VisionStitch9x32debug.dll';
  {$ENDIF}
{$ENDIF}
{$IFDEF SLIPMASTER}
  {$IFDEF RELEASE}
    function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'slipMaster5x32.dll';
  {$ENDIF}
  {$IFDEF DEBUG}
    function DDProtCheck(dris, data:pointer ):LongInt; stdcall; external 'slipMaster5x32debug.dll';
  {$ENDIF}
{$ENDIF}

implementation

end.



