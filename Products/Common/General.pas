unit General;

interface

uses
  Windows, SysUtils, Forms, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Grids, DBGrids, XStringGrid, TypInfo, classes, Graphics,
  comCtrls, OutOfMemory, CmnVars, dialogs, controls, Types, ExtCtrls, Math, System.RegularExpressions,
  DBGridPlus, FDTablePlus, VCLTee.Chart, VCLTee.TeEngine, ShellAPI, Printers, FDConnectionPlus
{$IFDEF VSTITCH}
  ,TranSys, Data
{$ENDIF}
{$IFDEF TIMELINE}
  ,TimeLineVars
{$ENDIF}
  ;

const
  VER_SERVER_NT                       = $80000000;
  {$EXTERNALSYM VER_SERVER_NT}
  VER_WORKSTATION_NT                  = $40000000;
  {$EXTERNALSYM VER_WORKSTATION_NT}
  VER_SUITE_SMALLBUSINESS             = $00000001;
  {$EXTERNALSYM VER_SUITE_SMALLBUSINESS}
  VER_SUITE_ENTERPRISE                = $00000002;
  {$EXTERNALSYM VER_SUITE_ENTERPRISE}
  VER_SUITE_BACKOFFICE                = $00000004;
  {$EXTERNALSYM VER_SUITE_BACKOFFICE}
  VER_SUITE_COMMUNICATIONS            = $00000008;
  {$EXTERNALSYM VER_SUITE_COMMUNICATIONS}
  VER_SUITE_TERMINAL                  = $00000010;
  {$EXTERNALSYM VER_SUITE_TERMINAL}
  VER_SUITE_SMALLBUSINESS_RESTRICTED  = $00000020;
  {$EXTERNALSYM VER_SUITE_SMALLBUSINESS_RESTRICTED}
  VER_SUITE_EMBEDDEDNT                = $00000040;
  {$EXTERNALSYM VER_SUITE_EMBEDDEDNT}
  VER_SUITE_DATACENTER                = $00000080;
  {$EXTERNALSYM VER_SUITE_DATACENTER}
  VER_SUITE_SINGLEUSERTS              = $00000100;
  {$EXTERNALSYM VER_SUITE_SINGLEUSERTS}
  VER_SUITE_PERSONAL                  = $00000200;
  {$EXTERNALSYM VER_SUITE_PERSONAL}
  VER_SUITE_BLADE                     = $00000400;
  {$EXTERNALSYM VER_SUITE_BLADE}
  VER_SUITE_EMBEDDED_RESTRICTED       = $00000800;
  {$EXTERNALSYM VER_SUITE_EMBEDDED_RESTRICTED}
  VER_SUITE_SECURITY_APPLIANCE        = $00001000;
  {$EXTERNALSYM VER_SUITE_SECURITY_APPLIANCE}

const
  VER_NT_WORKSTATION              = $0000001;
  {$EXTERNALSYM VER_NT_WORKSTATION}
  VER_NT_DOMAIN_CONTROLLER        = $0000002;
  {$EXTERNALSYM VER_NT_DOMAIN_CONTROLLER}
  VER_NT_SERVER                   = $0000003;
  {$EXTERNALSYM VER_NT_SERVER}

const
  FontStyleNames: array[fsBold..fsStrikeOut] of string = ('Bold', 'Italic', 'Underline', 'Strikeout');
  SHGFP_TYPE_CURRENT = 0;

type
  POSVersionInfoEx = ^TOSVersionInfoEx;
  TOSVersionInfoEx = packed record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion     : DWORD;
    dwMinorVersion     : DWORD;
    dwBuildNumber      : DWORD;
    dwPlatformId       : DWORD;
    szCSDVersion       : array [0..127] of AnsiChar;
    wServicePackMajor  : Word;
    wServicePackMinor  : Word;
    wSuiteMask         : Word;
    wProductType       : Byte;
    wReserved          : Byte;
  end;

  TWhatToLock = (oKnifeSet, oKnife, oMaterial, oPart, oStyle, oSupplier,
                 oTicket, oConstruction, oWidthRange, oSizeRange, oSizeScale,
                 oSizeRelationShip, oWidthNames, oSwapKnives,
                 oAssessKnives, oMaterialDefaults, oKnifeDefaults,
                 oCutterNames, oCutterLocations, oParameters,
                 oGroupParts, oGroupConstructions, oGroupKnifeSets,
                 oGroupSuppliers, oGroupStyles, oGroupTickets, oGroupMaterials,
                 //TimeLine
                 oMotion, oElement, oOperation, oStyleDepartment, oTLStyle,
                 oLine, oOperationType, oGradeRates, oDigitisingFeatures,
                 oMachiningSettings, oDepartments, oOperationTypes, oMachines,
                 oSwapStyleDepartments, oSwapOperations, oSwapElements,
                 oCuttingDefaults, oSystemSettings, oLineSettings,
                 oHandlingCategories, oOperationDefinition, oMachineElements,
                 oCuttingDefinition);
var
  sAdsVersionFull: string;
  iAdsVersionMajor: Integer;

function GetSpecialFolderPath(Folder: integer): string;
function ExistingToFront(Title, Code: string): boolean;
function FormNo(Title, Code: string): integer;
function WinDir: string;
function QS(InString: string): string;
function LocksLockedBy(Table: TFDTablePlus; WhatToLock: TWhatToLock): TLockedBy;
function LocksUnLockRecord(Table: TFDTablePlus; Option: variant): boolean;
function LocksUnLockRecordIncStatusBar(Table: TFDTablePlus; Option: variant; sbActual: TStatusBar): boolean;
function LockSingle(WhatToLock: TWhatToLock; LocksTable, tblToLock: TFDTablePlus; Code: variant; NeedGroupLock: boolean): boolean;
function LockSingleWithoutOption(WhatToLock: TWhatToLock; tblToLock: TFDTablePlus; Code: variant): boolean;
function LockGroupIncStatusBar(WhatToLock: TWhatToLock; LocksTable, tblToLock: TFDTablePlus; sbActual: TStatusBar): boolean;
function LockOption(LocksTable: TFDTablePlus; WhatToLock: TWhatToLock): boolean;
function LockSingleOption(WhatToLock: TWhatToLock; tblToLock: TFDTablePlus): boolean;
procedure ADMessage(TheMessage: string);
procedure SetColumnWidthsAll3a(fmAll: TForm;
                              dbgNormal: TDBGridPlus;
                              dbgGroup: TDBGridPlus;
                              ColumnSelectedPosition, LastColNo: integer;
                              GroupDown: boolean);
function GetColumnSelectedPosition(sgGroup: TXStringGrid;
                                   LastColNo: integer): integer;
function GetColumnSelectedPosition3(dbgGroup: TDBGridPlus;
                                   LastColNo: integer): integer;
procedure SetColumnWidthsDetails1(fmDetail: TForm;
                                 gNormal: TXStringGrid;
                                 gEdit: TDBGridPlus;
                                 LastColNo: integer;
                                 Editing: boolean);
procedure SetColumnWidthsDetails2a(fmDetail: TForm;
                                  gNormal: TDBGridPlus;
                                  gEdit: TDBGridPlus;
                                  LastColNo: integer;
                                  Editing: boolean);
procedure SetColumnWidthsDetails3a(fmDetail: TForm;
                                  gNormal: TDBGridPlus;
                                  gEdit: TDBGridPlus;
                                  LastColNo: integer;
                                  Editing: boolean);
procedure ScreenShot(x, y, Width, Height: integer; bm: TBitMap);
function GetVerInfo(FileName: string): string;
function AdminConnection(TheConnection: TFDConnectionPlus;
                          AliasName, UserName, Password: string): Boolean;
procedure Connection(TheConnection: TFDConnectionPlus;
                     AliasName, UserName, Password: string; CheckVersion: Boolean);
procedure ConnectionSettings(Sender: TObject);
procedure ConnectionVersion(Sender: TObject);
procedure ConnectionModification(Sender: TObject);
procedure RejectApostrophe(Code: string);
procedure SetRowCount(AGrid: TXStringGrid;
                      imgNoTick: TImage;
                      var ActualRowCount: integer);
procedure TXStringGridDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
procedure DrawTab(PageControl: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
function FirstNChars(s: string; n: integer): string;
function GetOSVersionText: string;
function FontStyle(FontStyleString: string): TFontStyles;
function FontStyleString(FontSty: TFontStyles): string;
function OurColor(col: TColor): TColor;
procedure AutoColor(Form: TForm);
procedure ShowWebpage(Sender: TObject; Address: string);
function CustomMessageDlg(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; Captions: array of string): Integer;
function GetPaperSize: integer;
function GetTransactionNo(Option: string): integer;
procedure ClosePreviewForm(Name: string);
function ItemGone(var tbl: TFDTablePlus; ItemCode: string): Boolean;

function FloatToStrSQL(Value: Extended): string;
function FloatToStrFSQL(Value: Extended; Format: TFloatFormat; Precision, Digits: Integer): string;

procedure SortOrder(var dbg: TDBGridPlus; Column: TColumn; var SQLString: string);

var
  ProgramVersion: string;
{$IFDEF TIMELINE}
  MemberOfMotions, MemberOfElements, MemberOfStyles, MemberOfSystemSettings,
  MemberOfOperations, MemberOfLines: Boolean;
{$ENDIF}
  Company, DatabaseCompany: String;
  AutoCreateConstruction: boolean;
  AutoDeleteConstruction: boolean;
  SplitTickets: boolean;
  SplittingScheme: integer;
  CADDirectory, TicketsDirectory, StylePicDirectory, PicDirectory, VSDirectory: string;
  LinesInLeatherGrid, RowsInLeatherGrid: integer;
  TitleFontName, StandardFontName, FixedFontName, FixedCutFontName: string;
  TitleFontStyle, StandardFontStyle, FixedFontStyle, FixedCutFontStyle: TFontStyles;
  TitleFontSize, StandardFontSize, FixedFontSize, FixedCutFontSize: integer;
  TitleFontCharset, StandardFontCharset, FixedFontCharset, FixedCutFontCharset: integer;
  PrintTagNumbers, PrintCustomer, PrintTimes, ShowBarCodeNPic, AllowGroupDeleteTickets, ExtendedUpdatedOUT: boolean;
  LegacyCuttingTimes: Boolean;
  LegacyCuttingTimesExact: Boolean;
  LegacyCuttingTimesBase: Boolean;
  TicketTranslation: array of string;
  AuditPathName: string;
  ClearAuditAfterSave, OldAudit, ShortTagNo: boolean;
  TableLength: real;
  IssuedCutWeek, TicketCostedAlw, SummarisedDetailed: shortint;
  FoundDongle, PrintCutterValue, CutterPageThrow,
  ShowWaste, GroupPrintSyntheticTickets, CreateSyntheticTicketsList,
  UpdatedInitialisation: boolean;
  DefaultMaterialUnits, SaveOutBasic: string;
  InterlockingToleranceInterlock, InterlockingToleranceLayplans: integer;
  FDConnection: array[1..20] of TFDConnectionPlus; //Enough for spare

const
  MouseMovePixels = 15;

implementation

uses
  db, LockedDialog, AccessDenied, stdctrls, SHFolder, System.IOUtils;

function GetSpecialFolderPath(Folder: integer): string;
var
  path: array [0..MAX_PATH] of char;
begin
  if Succeeded(SHGetFolderPath(0, Folder, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := path
  else
    Result := '';
end;

function GetVerInfo(FileName: string): string;
var
  VerInfoSize: DWORD;
  VersionInfo: Pointer;
  GetInfoSizeJunk: DWORD;
  InfoPointer: Pointer;
  VersionInfoSize: UINT;
  wMaj, wMin, wRelease, wBuild: Word;
  FullFileName: string;

begin
  FullFileName := ExpandFileName(FileName);

  Result := '';
  if FullFileName = '' then exit;
  if not FileExists(FullFileName) then
  begin
    //File Does not exist
    Result := 'x.x.x.x';
    exit;
  end;

  VerInfoSize := GetFileVersionInfoSize(PChar(FullFileName), GetInfoSizeJunk);
  if VerInfoSize > 0 then
  begin
    GetMem(VersionInfo, VerInfoSize);
    GetFileVersionInfo(PChar(FullFileName), 0, VerInfoSize, VersionInfo);
    if VerQueryValue(VersionInfo, '\', InfoPointer, VersionInfoSize) then
    begin
      wMaj := LongRec(TVSFixedFileInfo(InfoPointer^).dwFileVersionMS).Hi;
      wMin := LongRec(TVSFixedFileInfo(InfoPointer^).dwFileVersionMS).Lo;
      wRelease := LongRec(TVSFixedFileInfo(InfoPointer^).dwFileVersionLS).Hi;
      wBuild := LongRec(TVSFixedFileInfo(InfoPointer^).dwFileVersionLS ).Lo;
      Result := Format('%d.%d.%d.%d', [wMaj, wMin, wRelease, wBuild]);
    end;
    FreeMem(VersionInfo, VerInfoSize);
  end
  else
    //No version Information
    Result := '*.*.*.*';
end;

function GetOSVersionInfo(var Info: TOSVersionInfoEx): Boolean;
begin
  FillChar(Info, SizeOf(TOSVersionInfoEx), 0);
  Info.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  Result := GetVersionEx(TOSVersionInfo(Addr(Info)^));
  if (not Result) then
  begin
    FillChar(Info, SizeOf(TOSVersionInfoEx), 0);
    Info.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
    Result := GetVersionEx(TOSVersionInfo(Addr(Info)^));
    if (not Result) then
      Info.dwOSVersionInfoSize := 0;
  end;
end;

function GetOSVersionText: string;
var
  Info: TOSVersionInfoEx;
  Key: HKEY;
begin

//Replaced in XE2 with TOSVersion.ToString
//Kept tempoarily for backward compatibility
//during porting from 2007, 2009 to XE2

  Result := '';
  if (not GetOSVersionInfo(Info)) then
    Exit;
  case Info.dwPlatformId of
    { Win32s }
    VER_PLATFORM_WIN32s:
      Result := 'Microsoft Win32s';
    { Windows 9x }
    VER_PLATFORM_WIN32_WINDOWS:
      if (Info.dwMajorVersion = 4) and (Info.dwMinorVersion = 0) then
      begin
        Result := 'Microsoft Windows 95';
        if (Info.szCSDVersion[1] in ['B', 'C']) then
          Result := Result +' OSR2';
      end
      else if (Info.dwMajorVersion = 4) and (Info.dwMinorVersion = 10) then
      begin
        Result := 'Microsoft Windows 98';
        if (Info.szCSDVersion[1] = 'A') then
          Result := Result + ' SE';
      end
      else if (Info.dwMajorVersion = 4) and (Info.dwMinorVersion = 90) then
        Result := 'Microsoft Windows Millennium Edition';
    { Windows NT }
    VER_PLATFORM_WIN32_NT:
      begin
        { Version }
        if (Info.dwMajorVersion = 6) and (Info.dwMinorVersion = 0) then
        begin
          if (Info.wProductType = VER_NT_WORKSTATION) then
            Result := 'Microsoft Windows Vista'
          else
            Result := 'Windows Server \"Longhorn\';
        end
        else if (Info.dwMajorVersion = 5) and (Info.dwMinorVersion = 2) then
          Result := 'Microsoft Windows Server 2003'
        else if (Info.dwMajorVersion = 5) and (Info.dwMinorVersion = 1) then
          Result := 'Microsoft Windows XP'
        else if (Info.dwMajorVersion = 5) and (Info.dwMinorVersion = 0) then
          Result := 'Microsoft Windows 2000'
        else
          Result := 'Microsoft Windows NT';
        { Extended }
        if (Info.dwOSVersionInfoSize >= SizeOf(TOSVersionInfoEx)) then
        begin
          { ProductType }
          if (Info.wProductType = VER_NT_WORKSTATION) then
          begin
            if (Info.dwMajorVersion = 4) then
              Result := Result + #10'Workstation 4.0'
            else if(Info.wSuiteMask and VER_SUITE_PERSONAL <> 0) then
              Result := Result + #10'Home Edition'
            else if (Info.dwMajorVersion < 6) then
              Result := Result + #10'Professional';
          end
          else if (Info.wProductType = VER_NT_SERVER) then
          begin
             if (Info.dwMajorVersion = 5) and (Info.dwMinorVersion = 2) then
             begin
               if (Info.wSuiteMask and VER_SUITE_DATACENTER <> 0) then
                 Result := Result + #10'Datacenter Edition'
               else if (Info.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
                 Result := Result + #10'Enterprise Edition'
               else if (Info.wSuiteMask = VER_SUITE_BLADE) then
                 Result := Result + #10'Web Edition'
               else
                 Result := Result + #10'Standard Edition';
             end
             else if (Info.dwMajorVersion = 5) and (Info.dwMinorVersion = 0) then
             begin
               if (Info.wSuiteMask and VER_SUITE_DATACENTER <> 0) then
                  Result := Result + #10'Datacenter Server'
               else if (Info.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
                  Result := Result + #10'Advanced Server'
               else
                  Result := Result + #10'Server';
             end
             else
             begin
               Result := Result + #10'Server ' +
                 IntToStr(Info.dwMajorVersion) + '.' +
                 IntToStr(Info.dwMinorVersion);
               if (Info.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
                 Result := Result + ', Enterprise Edition';
             end;
          end;
        end;
        { CSDVersion }
        if (Info.dwMajorVersion = 4) and
          (StrIComp(Info.szCSDVersion, 'Service Pack 6') = 0) and
          (RegOpenKeyEx(HKEY_LOCAL_MACHINE,
            'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\Q246009', 0,
            KEY_QUERY_VALUE, Key) = ERROR_SUCCESS) then
        begin
          Result := Result + #10'Service Pack 6a';
          RegCloseKey(Key);
        end
        else
          Result := Result + #10 + StrPas(Info.szCSDVersion);
        Result := Result + #10'(Build ' +
          IntToStr(Info.dwBuildNumber and $FFFF) + ')';
      end;
  end;
end;

procedure Connection(TheConnection: TFDConnectionPlus;
                     AliasName, UserName, Password: string;
                     CheckVersion: Boolean);
var
  VerMajor, VerMinor: integer;
  sMajor, sMinor: string;
  DataVersion: string;
  s: string;
  VSSuper: Boolean;
  ConnectionAdmin: TFDConnectionPlus;
  qSystem: TFDQuery;
  Continue: Boolean;

begin
  VSSuper := False;  //A bit dirty but Tim agreed this was the easiest way to add the required functionality at this late stage
  //NOT allowed to login as AdsSys as transactions
  //are not allowed on administrative connections.
  if uppercase(UserName) <> 'ADSSYS' then
  begin
    try
{$IFDEF VSTITCH}
      if Username = 'SUPERVISOR' then
        VSSuper := True;
{$ENDIF}
  //CJY
      TheConnection.DriverName := 'ADS';
      TheConnection.Params.Values['ServerTypes'] := 'Remote';
      TheConnection.Params.Values['Protocol'] := 'TCPIP';
  //(Sender as TFDConnectionPlus).Params.Values['CharacterSet'] := 'ANSI';  //Causes issues with ADS 9.0, 9.1, and 10.0
      TheConnection.Params.Values['Alias'] := AliasName;
      TheConnection.Params.Values['User_name'] := UserName;
      TheConnection.Params.Values['Password'] := Password;

//      TheConnection.FetchOptions.RecordCountMode := cmFetched;
      TheConnection.FetchOptions.RecordCountMode := cmVisible;
  // Some automated options that circumvent best practice programming.
      TheConnection.FetchOptions.AutoClose := false;
  //(Sender as TFDConnectionPlus).ResourceOptions.AutoConnect := false;  //Required, not all connections are connected
      TheConnection.ResourceOptions.MacroCreate := false;
      TheConnection.ResourceOptions.MacroExpand := false;

      TheConnection.Connected := True;

      qSystem := TFDQuery.Create(TheConnection);
      qSystem.Connection := TheConnection;
      qSystem.SQL.Add('select Version_Major, Version_Minor from system.dictionary');
      qSystem.Open;
      VerMajor := qSystem.FieldByName('Version_Major').Value;
      VerMinor := qSystem.FieldByName('Version_Minor').Value;
      qSystem.Close;

{$IFDEF TIMELINE}
      //Here do similar query based on group membership and permissions to get this info
      //None of these line will compile as they stand with TIMELINE defined
      MemberOfMotions := (pos('Grp Motions', pucProperty) > 0);
      MemberOfElements := (pos('Grp Elements', pucProperty) > 0);
      MemberOfStyles := (pos('Grp Styles', pucProperty) > 0);
      MemberOfSystemSettings := (pos('Grp System Settings', pucProperty) > 0);
      MemberOfOperations := (pos('Grp Operations', pucProperty) > 0);
      MemberOfLines := (pos('Grp Lines', pucProperty) > 0);
{$ENDIF}

      qSystem.Free;

      str(VerMajor : 1, sMajor);
      str(VerMinor : 1, sMinor);
      DataVersion := sMajor + '.' + sMinor;

      ProgramVersion := GetVerInfo(ExtractFileName(Application.EXEName));
      Continue := True;

{$IFDEF SATRASUMM}
      //Auto updating from 8.2 to 8.3 as there are no actual database changes
      //but it needed at least a minor version change

      if CheckVersion and ((copy(ProgramVersion, 1, length(DataVersion))) = '8.3') and (DataVersion = '8.2') then
      begin
        if messagedlg('Update database to 8.3 database?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          try
            ConnectionAdmin := TFDConnectionPlus.Create(nil);
            AdminConnection(ConnectionAdmin, 'SATRASUMM8', 'ADSSYS', 'monster');

            qSystem := TFDQuery.Create(ConnectionAdmin);
            qSystem.Connection := ConnectionAdmin;
            qSystem.SQL.Add('EXECUTE PROCEDURE sp_ModifyDatabase(''VERSION_MINOR'', ''3''); ');
            qSystem.ExecSQL;
            qSystem.Free;

            ConnectionAdmin.Free;

            DataVersion := '8.3';
          except
            Continue := False;
            messagedlg('Error updating database to 8.3', mtInformation, [mbOk], 0);
          end;
        end;
      end;
{$ENDIF}

      if CheckVersion and (copy(ProgramVersion, 1, length(DataVersion)) <> DataVersion) then
      begin
        //Program and Database versions are incompatible
        //Note : Not possible to use translation
        //module until connected to a valid database.
        s := 'Program and database versions do not match.' + #13#13 +
             'The program (' + ExtractFileName(Application.EXEName) +
             ') is version ' + ProgramVersion + ' but the database alias (' +
             AliasName + ') refers to a version ' + DataVersion +
             '.x.x database.';
        TheConnection.Connected := False;
      end
      else
      begin
//        TheConnection.Connected := True;
        if CheckVersion then
        begin
          SystemUserName := TheConnection.Params.Values['User_name'];
          SystemPassword := TheConnection.Params.Values['Password'];
        end;
      end;
    except on E: EDataBaseError do
      begin
        if (E is EFDDBEngineException) and not VSSuper then
        begin
          if (E as EFDDBEngineException).ErrorCode = 6420 then
          begin
            fmAccessDenied.caption := 'Advantage Database Server not detected';
            fmAccessDenied.imgNoEntry.picture := fmAccessDenied.imgNoAds.picture;
            fmAccessDenied.imgNoEntry.transparent := False;
            s := 'This system requires the Advantage Database Server to be running.' + #13 + #13 +
                 'Ensure Advantage running and try again.';
          end
          else if (E as EFDDBEngineException).ErrorCode = 7078 then
            s := 'Incorrect User Name or Password.' + #13 + #13 +
                 'Please try again.'
          else if (((E as EFDDBEngineException).ErrorCode = 5121) or
                   ((E as EFDDBEngineException).ErrorCode = 5004) or
                   ((E as EFDDBEngineException).ErrorCode = 5021)) then          //I don't think we get here any more - different errors occur
            s := 'Invalid or missing Alias (' + AliasName + ').'
          else if ((E as EFDDBEngineException).ErrorCode = 6414) then          //I don't think we get here any more - different errors occur
          begin
            {$IFDEF WIN64}
              s := 'ACE64.DLL is the incorrect version.';
            {$ELSE}
              s := 'ACE32.DLL is the incorrect version.';
            {$ENDIF}
          end
          else
            s := E.message;
          TheConnection.Connected := False;
        end
  {$IFDEF VSTITCH}
        else if VSSuper then
          Raise
  {$ENDIF}
        else
        begin
          if (Pos('Cannot load vendor library', E.Message) > 0) then
          begin
            {$IFDEF WIN64}
              s := 'ACE64.DLL is missing or the incorrect version.';
            {$ELSE}
              s := 'ACE32.DLL is missing or the incorrect version.';
            {$ENDIF}
          end
          else
            s := E.message;
        end;
      end
      else
        raise;
    end;
  end;

  if not TheConnection.Connected and not VSSuper then
  begin
    fmAccessDenied.lblMessage.caption := s;
    fmAccessDenied.showModal;
  end;
end;

function AdminConnection(TheConnection: TFDConnectionPlus; AliasName, UserName, Password: string): Boolean;
var
  s: string;

begin
  try
    TheConnection.DriverName := 'ADS';
    TheConnection.Params.Values['ServerTypes'] := 'Remote';
    TheConnection.Params.Values['Protocol'] := 'TCPIP';
    TheConnection.Params.Values['Alias'] := AliasName;
    TheConnection.Params.Values['User_name'] := UserName;
    TheConnection.Params.Values['Password'] := Password;

    TheConnection.FetchOptions.RecordCountMode := cmVisible;
    TheConnection.FetchOptions.AutoClose := false;
    TheConnection.ResourceOptions.MacroCreate := false;
    TheConnection.ResourceOptions.MacroExpand := false;

    TheConnection.Connected := True;
  except on E: EDataBaseError do
    begin
      if (E is EFDDBEngineException) then
      begin
        if (E as EFDDBEngineException).ErrorCode = 6420 then
        begin
          s := 'This system requires the Advantage Database Server to be running.' + #13 + #13 +
               'Ensure Advantage running and try again.';
        end
        else if (E as EFDDBEngineException).ErrorCode = 7078 then
          s := 'Incorrect User Name or Password.' + #13 + #13 +
               'Please try again.'
        else if (((E as EFDDBEngineException).ErrorCode = 5121) or
                 ((E as EFDDBEngineException).ErrorCode = 5004) or
                 ((E as EFDDBEngineException).ErrorCode = 5021)) then
          s := 'Invalid or missing Alias (' + AliasName + ').'
        else if ((E as EFDDBEngineException).ErrorCode = 6414) then
        begin
          {$IFDEF WIN64}
            s := 'ACE64.DLL is the incorrect version.';
          {$ELSE}
            s := 'ACE32.DLL is the incorrect version.';
          {$ENDIF}
        end
        else
          s := E.message;
        TheConnection.Connected := False;
      end
      else
      begin
        if (Pos('Cannot load vendor library', E.Message) > 0) then
        begin
          {$IFDEF WIN64}
            s := 'ACE64.DLL is missing or the incorrect version.';
          {$ELSE}
            s := 'ACE32.DLL is missing or the incorrect version.';
          {$ENDIF}
        end
        else
          s := E.message;
      end;

      ShowMessage(s);
    end;
  end;
end;

procedure ConnectionSettings(Sender: TObject);
begin
  //CJY
  (Sender as TFDConnectionPlus).DriverName := 'ADS';
  (Sender as TFDConnectionPlus).Params.Values['ServerTypes'] := 'Remote';
  (Sender as TFDConnectionPlus).Params.Values['Protocol'] := 'TCPIP';
  //(Sender as TFDConnectionPlus).Params.Values['CharacterSet'] := 'ANSI';  //Causes issues with ADS 9.0, 9.1, and 10.0
  (Sender as TFDConnectionPlus).Params.Values['Alias'] := SystemAlias;
  (Sender as TFDConnectionPlus).Params.Values['User_name'] := SystemUserName;
  (Sender as TFDConnectionPlus).Params.Values['Password'] := SystemPassword;

  if not LegacySortLocale then
    (Sender as TFDConnectionPlus).FormatOptions.SortLocale := 0;

//  (Sender as TFDConnectionPlus).FetchOptions.RecordCountMode := cmFetched;
  (Sender as TFDConnectionPlus).FetchOptions.RecordCountMode := cmVisible;
  //Some automated options that circumvent best practice programming.
  (Sender as TFDConnectionPlus).FetchOptions.AutoClose := false;
  //(Sender as TFDConnectionPlus).ResourceOptions.AutoConnect := false;  //Required, not all connections are connected
  (Sender as TFDConnectionPlus).TxOptions.AutoStart := false;
  (Sender as TFDConnectionPlus).TxOptions.AutoStop := false;
  (Sender as TFDConnectionPlus).TxOptions.AutoCommit := false;
  //'&' and '!' are recognised as Macro markers in the SQL if these are not set to false;
  (Sender as TFDConnectionPlus).ResourceOptions.MacroCreate := false;
  (Sender as TFDConnectionPlus).ResourceOptions.MacroExpand := false;
end;

procedure ConnectionVersion(Sender: TObject);
var
  Query: TFDQuery;
  s: string;
  Code: integer;

begin
  Query := TFDQuery.Create(nil);
  Query.Connection := (Sender as TFDConnectionPlus);

  Query.SQL.Add('EXECUTE PROCEDURE sp_mgGetInstallInfo();');
  Query.Active := True;

  sAdsVersionFull := Query.FieldByName('Version').AsString;
  Val(copy(sAdsVersionFull, 0, pos('.', sAdsVersionFull) - 1), iAdsVersionMajor, Code);
end;

procedure ConnectionModification(Sender: TObject);
begin
  if iAdsVersionMajor >= 12 then
    (Sender as TFDConnectionPlus).ExecSQL('EXECUTE PROCEDURE sp_SetStatementLimit(0)');
end;

function ExistingToFront(Title, Code: string): boolean;
var
  ExistingForm: integer;

begin
  ExistingForm := FormNo(Title, Code);
  if ExistingForm >= 0 then
  begin
    if Screen.Forms[ExistingForm].WindowState = wsMinimized then
      Screen.Forms[ExistingForm].WindowState := wsNormal;
    ExistingForm := FormNo(Title, Code);
    Screen.Forms[ExistingForm].BringToFront;
    ExistingToFront := true;
  end
  else
    ExistingToFront := false;
end;

function FormNo(Title, Code: string): integer;
var
  NewCaption: string;
  i: integer;

begin
  FormNo := -1;
  NewCaption := Title;
  if Code <> '' then
    NewCaption := NewCaption + ' : ' + Code;

  with Screen do
    for i := 0 to Screen.FormCount - 1 do
      if Pos(NewCaption, Screen.Forms[i].caption) = 1 then
        if (Title = 'Digitiser') or (Title = 'Path') or (Title = 'Synthetic Layplanning') then
          //Title format is a special case
          FormNo := i
        else
          begin
            if NewCaption = Screen.Forms[i].caption then
              FormNo := i
            else if length(Screen.Forms[i].caption) >= (length(NewCaption) + 4) then
            begin
              //Doesn't apply to OperationDefinitions (maybe other too)
              if copy(Screen.Forms[i].caption, 1, 22) <> 'Operation Definition :' then
              begin
                //Title maybe same but with ' (?)' after it where ? is anything
                if (copy(Screen.Forms[i].caption, length(NewCaption) + 1, 2) = ' (') and
                   (copy(Screen.Forms[i].caption, length(Screen.Forms[i].caption), 1) = ')') then
                  FormNo := i;
              end;
            end;
          end;
end;

function WinDir: string;
const
  WINBUF = 144;
var
  WinArray: array [0..WINBUF] of char;

begin
  GetWindowsDirectory(WinArray, WINBUF);
  WinDir := StrPas(WinArray);
end;

function QS(InString: string): string;
begin
  Result := StringReplace(InString, '''', '''''', [rfReplaceAll]);
end;
//CJY Replaceed with a one-liner.
{
var
  OutString: string;
  i: integer;

begin
  //QS stands for QuotedString

  //Checks for ' character within the string
  //and turns it into a literal character.
  //e.g. Code PART'ONE => PART''ONE

  OutString := '';
  for i := 1 to length(InString) do
  begin
    OutString := OutString + InString[i];
    if InString[i] = '''' then
      OutString := OutString + '''';
  end;

  Result := OutString;
end;
}

function LocksLockedBy(Table: TFDTablePlus; WhatToLock: TWhatToLock): TLockedBy;
var
  sField, sField2: string;
  sFieldValue, sFieldValue2: string;
  Connection: TFDConnectionPlus;
  sp: TFDStoredProc;
  LockedBy: string;

begin
  //Most only use 1 field
  sField2 := '';
  sFieldValue2 := '';

  if WhatToLock = oKnifeSet then
    sField := 'Code'
  else if WhatToLock = oMaterial then
    sField := 'Code'
  else if WhatToLock = oPart then
    sField := 'Code'
  else if WhatToLock = oStyle then
    sField := 'Style'
  else if WhatToLock = oSupplier then
    sField := 'Code'
  else if WhatToLock = oTicket then
  begin
    sField := 'WeekNo';
    sField2 := 'SequenceNo';
  end
  else if WhatToLock = oConstruction then
    sField := 'Construction'
  else if WhatToLock = oMotion then
    sField := 'Code'
  else if WhatToLock = oElement then
    sField := 'Code'
  else if WhatToLock = oOperation then
    sField := 'Code'
  else if WhatToLock = oStyleDepartment then
  begin
    sField := 'Code';
    sField2 := 'Department';
  end
  else if WhatTolock = oWidthRange then
    sField := 'Code'
  else if WhatTolock = oSizeScale then
    sField := 'Scale'
  else if WhatTolock = oSizeRange then
    sField := 'Range'
  else if WhatTolock = oSizeRelationship then
    sField := 'Relationship'
  else if (WhatToLock = oCutterNames) or
          (WhatToLock = oSwapKnives) or
          (WhatToLock = oCutterLocations) or
          (WhatToLock = oWidthNames) or
          (WhatToLock = oAssessKnives) or
          (WhatToLock = oGroupParts) or
          (WhatToLock = oGroupConstructions) or
          (WhatToLock = oGroupKnifeSets) or
          (WhatToLock = oGroupSuppliers) or
          (WhatToLock = oGroupStyles) or
          (WhatToLock = oGroupTickets) or
          (WhatToLock = oGroupMaterials) then
    sField := 'Option'
  else if (WhatToLock = oMaterialDefaults) then
    sField := 'Type'
  else if (WhatToLock = oKnifeDefaults) then
    sField := 'Type'
  else if (WhatToLock = oParameters) then
    sField := 'CADDirectory'
  else if WhatToLock = oTLStyle then
    sField := 'Code'
  else if WhatToLock = oLine then
    sField := 'Code'
  else if WhatToLock = oOperationDefinition then
    sField := 'Name';

  sFieldValue := Table.FieldByName(sField).Value;
  if sField2 <> '' then
    sFieldValue2 := Table.FieldByName(sField2).Value;

  //Bug in Advantage prior to 11.1 meant that functionsuser within this
  //stored procedure required Server:monitor rights. Only adssys has this
  //as default and so use an adssys connection to call this stored procedure.
  Connection := TFDConnectionPlus.Create(application.MainForm);
  ConnectionSettings(Connection);
  Connection.Params.Values['User_name'] := 'adssys';
  Connection.Params.Values['Password'] := MasterPassword;

  sp := TFDStoredProc.Create(application.MainForm);
  sp.Connection := Connection;
  sp.StoredProcName := 'LocksLockedBy';
  sp.FetchOptions.Items := sp.FetchOptions.Items - [fiMeta];
  sp.Command.FillParams(sp.Params);
  sp.Prepare;
  sp.ParamByName('LockingTable').AsString := Table.TableName;
  sp.ParamByName('LockingField').AsString := sField;
  sp.ParamByName('LockingField2').AsString := sField2;
  sp.ParamByName('LockingOption').AsString := sFieldValue;
  sp.ParamByName('LockingOption2').AsString := sFieldValue2;
  sp.ExecProc;

  with Result do
  begin
    Locked := True;
    User := sp.ParamByname('LockingUser').Value;
    Computer := '???';
    Address := '???';
  end;

  sp.Free;
  Connection.Free;
end;

function LocksUnLockRecord(Table: TFDTablePlus; Option: variant): boolean;
var
  Success: boolean;
  lReturn: LongInt;
  OptionNo: integer;

begin
  Success := False;
  if Table.findkey([Option]) then
  begin
    Table.Cancel;
    Success := True;
   end;

  OptionNo := GetTransactionNo(Option);
  if FDConnection[OptionNo] <> nil then
  begin
    FDConnection[OptionNo].RollBack;
    FreeAndNil(FDConnection[OptionNo]);
  end;

  Result := Success;
end;

function LocksUnLockRecordIncStatusBar(Table: TFDTablePlus; Option: variant; sbActual: TStatusBar): boolean;
var
  Success: boolean;
  lReturn: LongInt;
  i: integer;
  AnythingLocked: Boolean;
  OptionNo: integer;

begin
  Success := False;
  if Table.findkey([Option]) then
  begin
    Table.Cancel;
    Success := True;
  end;

  if Success then
  begin
    if Option = 'GROUP_LINES' then
    begin
      sbActual.Panels[1].Bevel := pbNone;
      sbActual.Panels[1].Text := '';
      sbActual.Panels[1].Width := 0;
    end
    else if Option = 'GROUP_STYLES' then
    begin
      sbActual.Panels[2].Bevel := pbNone;
      sbActual.Panels[2].Text := '';
      sbActual.Panels[2].Width := 0;
    end
    else if Option = 'GROUP_STYLEDEPARTMENTS' then
    begin
      sbActual.Panels[3].Bevel := pbNone;
      sbActual.Panels[3].Text := '';
      sbActual.Panels[3].Width := 0;
    end
    else if Option = 'GROUP_OPERATIONS' then
    begin
      sbActual.Panels[4].Bevel := pbNone;
      sbActual.Panels[4].Text := '';
      sbActual.Panels[4].Width := 0;
    end
    else if Option = 'GROUP_ELEMENTS' then
    begin
      sbActual.Panels[5].Bevel := pbNone;
      sbActual.Panels[5].Text := '';
      sbActual.Panels[5].Width := 0;
    end
    else if Option = 'GROUP_MOTIONS' then
    begin
      sbActual.Panels[6].Bevel := pbNone;
      sbActual.Panels[6].Text := '';
      sbActual.Panels[6].Width := 0;
    end
    else if Option = 'GROUP_CONSTRUCTIONS' then
    begin
      sbActual.Panels[7].Bevel := pbNone;
      sbActual.Panels[7].Text := '';
      sbActual.Panels[7].Width := 0;
    end
    else if Option = 'GROUP_KNIFESETS' then
    begin
      sbActual.Panels[8].Bevel := pbNone;
      sbActual.Panels[8].Text := '';
      sbActual.Panels[8].Width := 0;
    end
    else if Option = 'GROUP_MATERIALS' then
    begin
      sbActual.Panels[9].Bevel := pbNone;
      sbActual.Panels[9].Text := '';
      sbActual.Panels[9].Width := 0;
    end
    else if Option = 'GROUP_PARTS' then
    begin
      sbActual.Panels[10].Bevel := pbNone;
      sbActual.Panels[10].Text := '';
      sbActual.Panels[10].Width := 0;
    end
    else if Option = 'GROUP_SUPPLIERS' then
    begin
      sbActual.Panels[11].Bevel := pbNone;
      sbActual.Panels[11].Text := '';
      sbActual.Panels[11].Width := 0;
    end
    else if Option = 'GROUP_TICKETS' then
    begin
      sbActual.Panels[12].Bevel := pbNone;
      sbActual.Panels[12].Text := '';
      sbActual.Panels[12].Width := 0;
    end;

    AnythingLocked := False;
    for i := 1 to sbActual.Panels.Count - 1 do
      if sbActual.Panels[i].Text <> '' then
        AnythingLocked := True;

    if not AnythingLocked then
    begin
      sbActual.visible := False;
      sbActual.Parent.Height := sbActual.Parent.Height - sbActual.Height;
    end;
  end;

  OptionNo := GetTransactionNo(Option);
  if FDConnection[OptionNo] <> nil then
  begin
    FDConnection[OptionNo].RollBack;
    FreeAndNil(FDConnection[OptionNo]);
  end;

  Result := Success;
end;

function LockSingle(WhatToLock: TWhatToLock; LocksTable, tblToLock: TFDTablePlus; Code: variant; NeedGroupLock: boolean): boolean;
var
  LockSuccess: boolean;
  LockedBy: TLockedBy;
  lReturn: LongInt;
  sLookUp, sGroup, sSingle, sRights, sLocked, sField, sField2: string;
  EMessage: string;
  LockErrorNo: integer;
  qLock: TFDQuery;
  ConnectionLocking: TFDConnectionPlus;
  s: string;
  GroupWhatToLock: TWhatToLock;

begin
  //Most only use 1 field
  sField2 := '';

  if WhatToLock = oKnifeSet then
  begin
    sLookUp := 'KNIFESETS';
    sGroup := 'Knives';
    sSingle := 'Knife';
    sField := 'Code';
  end
//  else if WhatToLock = oKnife then  //Not used
//  begin
//    sLookUp := 'KNIVES';
//    sGroup := 'Knives';
//    sSingle := 'Knife';
//  end
  else if WhatToLock = oMaterial then
  begin
    sLookUp := 'MATERIALS';
    sGroup := 'Materials';
    sSingle := 'Material';
    sField := 'Code';
  end
  else if WhatToLock = oPart then
  begin
    sLookUp := 'PARTS';
    sGroup := 'Parts';
    sSingle := 'Part';
    sField := 'Code';
  end
  else if WhatToLock = oStyle then
  begin
    sLookUp := 'STYLES';
    sGroup := 'Styles';
    sSingle := 'Style';
    sField := 'Style';
  end
  else if WhatToLock = oSupplier then
  begin
    sLookUp := 'SUPPLIERS';
    sGroup := 'Suppliers';
    sSingle := 'Supplier';
    sField := 'Code';
  end
  else if WhatToLock = oTicket then
  begin
    sLookUp := 'TICKETS';
    sGroup := 'Tickets';
    sSingle := 'Ticket';
    sField := 'WeekNo';
    sField2 := 'SequenceNo';
  end
  else if WhatToLock = oConstruction then
  begin
    sLookUp := 'CONSTRUCTIONS';
    sGroup := 'Constructions';
    sSingle := 'Construction';
    sField := 'Construction';
  end
  else if WhatToLock = oMotion then
  begin
    sLookUp := 'MOTIONS';
    sGroup := 'Motions';
    sSingle := 'Motion';
    sField := 'Code';
  end
  else if WhatToLock = oElement then
  begin
    sLookUp := 'ELEMENTS';
    sGroup := 'Elements';
    sSingle := 'Element';
    sField := 'Code';
  end
  else if WhatToLock = oOperation then
  begin
    sLookUp := 'OPERATIONS';
    sGroup := 'Operations';
    sSingle := 'Operation';
    sField := 'Code';
  end
  else if WhatToLock = oStyleDepartment then
  begin
    sLookUp := 'STYLEDEPARTMENTS';
    sGroup := 'Style Departments';
    sSingle := 'Style';
    sField := 'Code';
    sField2 := 'Department';
  end
  else if WhatToLock = oTLStyle then
  begin
    sLookUp := 'STYLES';
    sGroup := 'Styles';
    sSingle := 'Style';
    sField := 'Code';
  end
  else if WhatToLock = oLine then
  begin
    sLookUp := 'LINES';
    sGroup := 'Lines';
    sSingle := 'Line';
    sField := 'Code';
  end
  else if WhatToLock = oOperationDefinition then
  begin
    sLookUp := 'OPERATION_DEFINITIONS';
    sGroup := 'Operation Definitions';
    sSingle := 'Operation Definition';
    sField := 'Name';
  end;

  sLookUp := 'GROUP_' + sLookUp;
  sGroup := 'All ' + sGroup + ' are locked';
  sLocked := sSingle + ' ' + Code + ' is locked';
  sRights := 'Rights are not granted for User - ' + SystemUserName;
  if WhatToLock = oLine then
    sGroup := sGroup + ' (preventing opening)';

  if NeedGroupLock then
  begin
    //Only need a local connection here as lock
    //is always removed within this procedure
    ConnectionLocking := TFDConnectionPlus.create(application.MainForm);
    ConnectionSettings(ConnectionLocking);
    ConnectionLocking.StartTransaction;

    LockSuccess := False;
    if LocksTable.findkey([sLookUp]) then
    begin
      qLock := TFDQuery.Create(application.MainForm);
      qLock.Connection := ConnectionLocking;
      qLock.SQL.Clear;
      //CJY Rogue New Line Chars preventing locking, combined lines in to one add.
      qLock.SQL.Add('UPDATE ' + LocksTable.TableName +
                      ' SET Option = Option' +
                      ' WHERE Option = ''' + LocksTable.FieldByName('Option').value + '''');

      LockSuccess := True;
      try
        qLock.ExecSQL;
      except
        LockSuccess := False;
      end;

      qLock.Free;
    end;
  end
  else
    LockSuccess := True;

  if not LockSuccess then
  begin
    case WhatToLock of
      oPart: GroupWhatToLock := oGroupParts;
      oConstruction: GroupWhatToLock := oGroupConstructions;
      oKnifeSet: GroupWhatToLock := oGroupKnifeSets;
      oSupplier: GroupWhatToLock := oGroupSuppliers;
      oStyle: GroupWhatToLock := oGroupStyles;
      oTicket: GroupWhatToLock := oGroupTickets;
      oMaterial: GroupWhatToLock := oGroupMaterials;
    end;

    LockedBy := LocksLockedBy(LocksTable, GroupWhatToLock);
    fmLockedDialog.LockMessage(sGroup, LockedBy);
  end
  else
  begin
    qLock := TFDQuery.Create(application.MainForm);
    qLock.Connection := tblToLock.Connection;
    qLock.SQL.Clear;

    //CJY Rogue New Line Chars preventing locking, combined lines in to one add.
    //    Rogue apostrophes in values interfering with locking
    s := ' WHERE ' + sField + ' = ';
    if tblToLock.FieldByName(sField).DataType = ftString then
      s := s + '''' + QS(tblToLock.FieldByName(sField).value) + ''''
    else
      s := s + IntToStr(tblToLock.FieldByName(sField).value);

    if sField2 <> '' then
    begin
      s := s + ' AND ' + sField2 + ' = ';
      if tblToLock.FieldByName(sField2).DataType = ftString then
        s := s + '''' + QS(tblToLock.FieldByName(sField2).value) + ''''
      else
        s := s + IntToStr(tblToLock.FieldByName(sField2).value);
    end;

    qLock.SQL.Add('UPDATE ' + tblToLock.TableName +
                    ' SET ' + sField + ' = ' + sField + s);

    LockSuccess := False;
    try
      qLock.ExecSQL;
      tblToLock.edit;
      LockSuccess := True;
    except on E:EDataBaseError do
      begin
        EMessage := (E as EDataBaseError).Message;
        // CJY Variatation in error message between FireDAC and ADS
        if (pos('Cannot modify a read-only dataset', EMessage) > 0) or
           (pos('permissions have not been granted to the user', EMessage) > 0) then
          LockErrorNo := 1
        else
          LockErrorNo := 2;
      end
      else
        raise;
    end;

    qLock.Free;

    if not LockSuccess then
    begin
      if LockErrorNo = 1 then
        ADMessage(sRights)
      else if LockErrorNo = 2 then
      begin
        LockedBy := LocksLockedBy(tblToLock, WhatToLock);
        fmLockedDialog.LockMessage(sLocked, LockedBy);
      end;
    end;
  end;

  if NeedGroupLock then
  begin
    ConnectionLocking.Rollback;
    ConnectionLocking.Free;
  end;

  Result := LockSuccess;
end;

function LockSingleWithoutOption(WhatToLock: TWhatToLock; tblToLock: TFDTablePlus; Code: variant): boolean;
var
  LockSuccess: boolean;
  LockedBy: TLockedBy;
  sSingle, sRights, sField, sValue: string;
  EMessage: string;
  qLock: TFDQuery;

begin
  LockSuccess := true;

  if WhatToLock = oWidthRange then
  begin
    sSingle := 'Width Range';
    sField := 'Code';
  end
  else if WhatToLock = oSizeRange then
  begin
    sSingle := 'Size Range';
    sField := 'Range';
  end
  else if WhatToLock = oSizeScale then
  begin
    sSingle := 'Size Scale';
    sField := 'Scale';
  end
  else if WhatToLock = oSizeRelationship then
  begin
    sSingle := 'Size Relationship';
    sField := 'Relationship';
  end
  else if WhatToLock = oOperationType then  //TimeLine
  begin
    sSingle := 'Operation Type';
    sField := 'Type';
  end;

  sSingle := sSingle + ' ' + Code + ' is locked';
  sRights := 'Rights are not granted for User - ' + SystemUserName;

  //CJY Not all values will be QuerySafe, therefore ' > ''
  sValue := QS(tblToLock.FieldByName(sField).value);

  qLock := TFDQuery.Create(application.MainForm);
  qLock.Connection := tblToLock.Connection;
  qLock.SQL.Clear;
  qLock.SQL.Add('UPDATE ' + tblToLock.TableName);
  qLock.SQL.Add('SET ' + sField + ' = ' + sField);
  qLock.SQL.Add('WHERE ' + sField + ' = ''' + sValue + ''';');

  qLock.Prepare;

  LockSuccess := False;
  try
    qLock.ExecSQL;
    tblToLock.edit;
    LockSuccess := True;
  except on E:EDataBaseError do
    begin
      EMessage := (E as EDataBaseError).Message;
      // CJY Variatation in error message between FireDAC and ADS
      if (pos('Cannot modify a read-only dataset', EMessage) > 0) or
         (pos('permissions have not been granted to the user', EMessage) > 0) then
        ADMessage(sRights)
      else
      begin
        {$IFNDEF TIMELINE}
        LockedBy := LocksLockedBy(tblToLock, WhatToLock);
        {$ENDIF}

        fmLockedDialog.LockMessage(sSingle, LockedBy);
      end;
    end
    else
      raise;
  end;

  qLock.Free;

  Result := LockSuccess;
end;

function LockGroupIncStatusBar(WhatToLock: TWhatToLock; LocksTable, tblToLock: TFDTablePlus; sbActual: TStatusBar): boolean;
var
  bSuccess, LockSuccess: boolean;
  LockedBy: TLockedBy;
  lReturn: LongInt;
  sLookUp, sGroup, sField: string;
  qLock: TFDQuery;
  ConnectionLocking: TFDConnectionPlus;

begin
  if WhatToLock = oKnifeSet then
  begin
    sLookUp := 'KNIFESETS';
    sGroup := 'Knives';
    sField := 'Code';
  end
  else if WhatToLock = oKnife then
  begin
    sLookUp := 'KNIVES';
    sGroup := 'Knives';
    sField := 'Code';
  end
  else if WhatToLock = oMaterial then
  begin
    sLookUp := 'MATERIALS';
    sGroup := 'Materials';
    sField := 'Code';
  end
  else if WhatToLock = oPart then
  begin
    sLookUp := 'PARTS';
    sGroup := 'Parts';
    sField := 'Code';
  end
  else if WhatToLock = oStyle then
  begin
    sLookUp := 'STYLES';
    sGroup := 'Styles';
    sField := 'Style';
  end
  else if WhatToLock = oSupplier then
  begin
    sLookUp := 'SUPPLIERS';
    sGroup := 'Suppliers';
    sField := 'Code';
  end
  else if WhatToLock = oTicket then
  begin
    sLookUp := 'TICKETS';
    sGroup := 'Tickets';
    sField := 'WeekNo';
  end
  else if WhatToLock = oConstruction then
  begin
    sLookUp := 'CONSTRUCTIONS';
    sGroup := 'Constructions';
    sField := 'Construction';
  end
  else if WhatToLock = oMotion then
  begin
    sLookUp := 'MOTIONS';
    sGroup := 'Motions';
    sField := 'Code';
  end
  else if WhatToLock = oElement then
  begin
    sLookUp := 'ELEMENTS';
    sGroup := 'Elements';
    sField := 'Code';
  end
  else if WhatToLock = oOperation then
  begin
    sLookUp := 'OPERATIONS';
    sGroup := 'Operations';
    sField := 'Code';
  end
  else if WhatToLock = oOperationTypes then
  begin
    sLookUp := 'OPERATIONTYPES';
    sGroup := 'Operation Types';
    sField := 'Code';
  end
  else if WhatToLock = oStyleDepartment then
  begin
    sLookUp := 'STYLEDEPARTMENTS';
    sGroup := 'Style Departments';
    sField := 'Code';
  end
  else if WhatToLock = oTLStyle then
  begin
    sLookUp := 'STYLES';
    sGroup := 'Styles';
    sField := 'Code';
  end
  else if WhatToLock = oLine then
  begin
    sLookUp := 'LINES';
    sGroup := 'Lines';
    sField := 'Code';
  end;

  sLookUp := 'GROUP_' + sLookUp;
  sGroup := 'One or more ' + sGroup + ' are locked';
  if WhatToLock = oLine then
    sGroup := sGroup + ' (because they are open)';

  ConnectionLocking := TFDConnectionPlus.create(application.MainForm);
  ConnectionSettings(ConnectionLocking);

  //Attempt Table Lock
  ConnectionLocking.StartTransaction;

  qLock := TFDQuery.Create(application.MainForm);
  qLock.Connection := ConnectionLocking;
  qLock.SQL.Clear;
  qLock.SQL.Add('UPDATE ' + tblToLock.TableName);
  qLock.SQL.Add('SET ' + sField + ' = ' + sField + ';');

  bSuccess := True;
  try
    qLock.ExecSQL;
  except
    bSuccess := False;
  end;

  qLock.Free;

  LockSuccess := bSuccess;
  if bSuccess then
  begin
    //Attempt Group Lock
    if (WhatToLock = oPart) then
      WhatToLock := oGroupParts            //inc KnivesToSwap
    else if (WhatToLock = oConstruction) then
      WhatToLock := oGroupConstructions
    else if (WhatToLock = oKnifeSet) then
      WhatToLock := oGroupKnifeSets
    else if (WhatToLock = oSupplier) then
      WhatToLock := oGroupSuppliers
    else if (WhatToLock = oStyle) then
      WhatToLock := oGroupStyles
    else if (WhatToLock = oTicket) then
      WhatToLock := oGroupTickets
    else if (WhatToLock = oMaterial) then
      WhatToLock := oGroupMaterials;

    LockSuccess := False;
    if LocksTable.findkey([sLookUp]) then
      LockSuccess := LockOption(LocksTable, WhatToLock);
  end
  else
  begin
    LockedBy.Locked := False;
    fmLockedDialog.LockMessage(sGroup, LockedBy);
  end;

  //Unlock Table Lock
  ConnectionLocking.Rollback;
  ConnectionLocking.Free;

  if (not sbActual.Visible) and LockSuccess then
    sbActual.Parent.Height := sbActual.Parent.Height + sbActual.Height;

  if LockSuccess then
  begin
    sbActual.Panels[0].Width := 160;
    if WhatToLock = oLine then
    begin
      sbActual.Panels[1].Bevel := pbLowered;
      sbActual.Panels[1].Text := 'Every Line';
      sbActual.Panels[1].Width := 120;
    end
    else if (WhatToLock = oTLStyle) or (WhatToLock = oGroupStyles) then
    begin
      sbActual.Panels[2].Bevel := pbLowered;
      sbActual.Panels[2].Text := 'Every Style';
      sbActual.Panels[2].Width := 120;
    end
    else if WhatToLock = oStyleDepartment then
    begin
      sbActual.Panels[3].Bevel := pbLowered;
      sbActual.Panels[3].Text := 'Every Style Department';
      sbActual.Panels[3].Width := 120;
    end
    else if WhatToLock = oOperation then
    begin
      sbActual.Panels[4].Bevel := pbLowered;
      sbActual.Panels[4].Text := 'Every Operation';
      sbActual.Panels[4].Width := 120;
    end
    else if WhatToLock = oElement then
    begin
      sbActual.Panels[5].Bevel := pbLowered;
      sbActual.Panels[5].Text := 'Every Element';
      sbActual.Panels[5].Width := 120;
    end
    else if WhatToLock = oMotion then
    begin
      sbActual.Panels[6].Bevel := pbLowered;
      sbActual.Panels[6].Text := 'Every Motion';
      sbActual.Panels[6].Width := 120;
    end
    else if WhatToLock = oGroupConstructions then
    begin
      sbActual.Panels[7].Bevel := pbLowered;
      sbActual.Panels[7].Text := 'Every Construction';
      sbActual.Panels[7].Width := 120;
    end
    else if WhatToLock = oGroupKnifeSets then
    begin
      sbActual.Panels[8].Bevel := pbLowered;
      sbActual.Panels[8].Text := 'Every Knife';
      sbActual.Panels[8].Width := 120;
    end
    else if WhatToLock = oGroupMaterials then
    begin
      sbActual.Panels[9].Bevel := pbLowered;
      sbActual.Panels[9].Text := 'Every Material';
      sbActual.Panels[9].Width := 120;
    end
    else if WhatToLock = oGroupParts then
    begin
      sbActual.Panels[10].Bevel := pbLowered;
      sbActual.Panels[10].Text := 'Every Part';
      sbActual.Panels[10].Width := 120;
    end
    else if WhatToLock = oGroupSuppliers then
    begin
      sbActual.Panels[11].Bevel := pbLowered;
      sbActual.Panels[11].Text := 'Every Supplier';
      sbActual.Panels[11].Width := 120;
    end
    else if WhatToLock = oGroupTickets then
    begin
      sbActual.Panels[12].Bevel := pbLowered;
      sbActual.Panels[12].Text := 'Every Ticket';
      sbActual.Panels[12].Width := 120;
    end;

    sbActual.visible := True;
  end;

  Result := LockSuccess;
end;

function LockOption(LocksTable: TFDTablePlus; WhatToLock: TWhatToLock): boolean;
var
  LockSuccess: boolean;
  LockedBy: TLockedBy;
  lReturn: LongInt;
  sLookUp, sOption: string;
  qLock: TFDQuery;
  OptionNo: integer;
  AlreadyLockedHere: Boolean;

begin
  if WhatToLock = oGroupParts then
  begin
    sLookUp := 'GROUP_PARTS';
    sOption := 'Group Parts';
  end
  else if WhatToLock = oGroupConstructions then
  begin
    sLookUp := 'GROUP_CONSTRUCTIONS';
    sOption := 'Group Constructions';
  end
  else if WhatToLock = oGroupKnifeSets then
  begin
    sLookUp := 'GROUP_KNIFESETS';
    sOption := 'Group Knives';
  end
  else if WhatToLock = oGroupSuppliers then
  begin
    sLookUp := 'GROUP_SUPPLIERS';
    sOption := 'Group Suppliers';
  end
  else if WhatToLock = oGroupStyles then
  begin
    sLookUp := 'GROUP_STYLES';
    sOption := 'Group Styles';
  end
  else if WhatToLock = oGroupTickets then
  begin
    sLookUp := 'GROUP_TICKETS';
    sOption := 'Group Tickets';
  end
  else if WhatToLock = oGroupMaterials then
  begin
    sLookUp := 'GROUP_MATERIALS';
    sOption := 'Group Materials';
  end
  else if WhatToLock = oWidthNames then
  begin
    sLookUp := 'WIDTH_NAMES';
    sOption := 'Width Names';
  end
  else if WhatToLock = oSwapKnives then
  begin
    sLookUp := 'SWAP_KNIVES';
    sOption := 'Swap Knives';
  end
  else if WhatToLock = oAssessKnives then
  begin
    sLookUp := 'ASSESS_KNIVES';
    sOption := 'Assess Knives';
  end
  else if WhatToLock = oCutterLocations then
  begin
    sLookUp := 'CUTTER_LOCATIONS';
    sOption := 'Cutter Locations';
  end
  else if WhatToLock = oCutterNames then
  begin
    sLookUp := 'CUTTER_NAMES';
    sOption := 'Cutter Names';
  end
  else if WhatToLock = oGradeRates then
  begin
    sLookUp := 'GRADE_RATES';
    sOption := 'Grade Rates';
  end
  else if WhatToLock = oDigitisingFeatures then
  begin
    sLookUp := 'PATH_FEATURES';
    sOption := 'Path Features';
  end
  else if WhatToLock = oMachiningSettings then
  begin
    sLookUp := 'MACHINING_SETTINGS';
    sOption := 'Machining Settings';
  end
  else if WhatToLock = oCuttingDefinition then
  begin
    sLookUp := 'CUTTING_DEFINITION';
    sOption := 'Definition : Cutting';
  end
  else if WhatToLock = oDepartments then
  begin
    sLookUp := 'DEPARTMENTS';
    sOption := 'Departments';
  end
  else if WhatToLock = oMachines then
  begin
    sLookUp := 'MACHINES';
    sOption := 'Machines';
  end
  else if WhatToLock = oSwapStyleDepartments then
  begin
    sLookUp := 'SWAP_STYLEDEPARTMENTS';
    sOption := 'Swap Style Departments';
  end
  else if WhatToLock = oSwapOperations then
  begin
    sLookUp := 'SWAP_OPERATIONS';
    sOption := 'Swap Operations';
  end
  else if WhatToLock = oSwapElements then
  begin
    sLookUp := 'SWAP_ELEMENTS';
    sOption := 'Swap Elements';
  end
  else if WhatToLock = oCuttingDefaults then
  begin
    sLookUp := 'CUTTING_DEFAULTS';
    sOption := 'Cutting Defaults';
  end
  else if WhatToLock = oHandlingCategories then
  begin
    sLookUp := 'HANDLING_CATEGORIES';
    sOption := 'Handling Categories';
  end
  else if WhatToLock = oSystemSettings then
  begin
    sLookUp := 'SYSTEM_SETTINGS';
    sOption := 'System Settings';
  end
  else if WhatToLock = oLineSettings then
  begin
    sLookUp := 'LINE_SETTINGS';
    sOption := 'Line Settings';
  end
  else if WhatToLock = oMachineElements then
  begin
    sLookUp := 'MACHINE_ELEMENTS';
    sOption := 'Machine Elements Configuration';
  end;

  sOption := sOption + ' locked';

  AlreadyLockedHere := False;
  LockSuccess := False;
  if LocksTable.findkey([sLookUp]) then
  begin
    OptionNo := GetTransactionNo(sLookup);
    if FDConnection[OptionNo] = nil then
    begin
      FDConnection[OptionNo] := TFDConnectionPlus.create(application.MainForm);
      ConnectionSettings(FDConnection[OptionNo]);
    end
    else
      //If cannot create the connection then the option must be locked by this
      //instance of the program e.g. SwapKnives tries to lock the Group_Parts
      //option (after locking swap_knives) which may have been already locked
      //here by simply grouping parts
      AlreadyLockedHere := True;

    if not AlreadyLockedHere then
    begin
      FDConnection[OptionNo].StartTransaction;

      qLock := TFDQuery.Create(application.MainForm);
      qLock.Connection := FDConnection[OptionNo];
      qLock.SQL.Clear;
      qLock.SQL.Add('UPDATE ' + LocksTable.TableName);
      qLock.SQL.Add('SET Option = Option');
      qLock.SQL.Add('WHERE Option = ''' + LocksTable.FieldByName('Option').value + ''';');

      LockSuccess := True;
      try
        qLock.ExecSQL;
      except
        LockSuccess := False;
      end;

      qLock.Free;
    end;

    if not LockSuccess then
      LockedBy := LocksLockedBy(LocksTable, WhatToLock);
  end
  else
  begin
    with LockedBy do
    begin
      Locked := True;
      User := 'ERROR - MISSING OPTION';
      Computer := '';
      Address := '';
    end;
  end;

  if not LockSuccess then
  begin
    fmLockedDialog.LockMessage(sOption, LockedBy);

    FDConnection[OptionNo].Free;
    FDConnection[OptionNo] := nil;
  end;

  Result := LockSuccess;
end;

function LockSingleOption(WhatToLock: TWhatToLock; tblToLock: TFDTablePlus): boolean;
var
  LockSuccess: boolean;
  LockedBy: TLockedBy;
  sSingle, sLocked, sRights, sField: string;
  EMessage: string;
  qLock: TFDQuery;

begin
  LockSuccess := True;

  if WhatToLock = oMaterialDefaults then
  begin
    sSingle := 'Material Defaults ';
    sField := 'Type';
  end
  else if WhatToLock = oKnifeDefaults then
  begin
    sSingle := 'Knife Defaults';
    sField := 'Type';
  end
  else if WhatToLock = oParameters then     //Summs Parameters
  begin
    sSingle := 'Parameters General';
    sField := 'CADDirectory';
  end
  else if WhatToLock = oSystemSettings then //System Settings (TimeLine)
  begin
    sSingle := 'System Settings';
    sField := 'Company';
  end
  else if WhatToLock = oLineSettings then   //Line Settings (TimeLine)
  begin
    sSingle := 'Line Settings';
    sField := 'MinutesSessionOne';
  end;

  sLocked := sSingle + ' is locked';
  sRights := 'Rights are not granted for User - ' + SystemUserName;

  qLock := TFDQuery.Create(application.MainForm);
  qLock.Connection := tblToLock.Connection;
  qLock.SQL.Clear;
  qLock.SQL.Add('UPDATE ' + tblToLock.TableName);
  qLock.SQL.Add('SET ' + sField + ' = ' + sField);

  LockSuccess := False;
  try
    qLock.ExecSQL;
    tblToLock.edit;
    LockSuccess := True;
  except on E:EDataBaseError do
    begin
      EMessage := (E as EDataBaseError).Message;
      // CJY Variatation in error message between FireDAC and ADS
      if (pos('Cannot modify a read-only dataset', EMessage) > 0) or
         (pos('permissions have not been granted to the user', EMessage) > 0) then
        ADMessage(sRights)
      else
      begin
        LockedBy := LocksLockedBy(tblToLock, WhatToLock);

        fmLockedDialog.LockMessage(sLocked, LockedBy);
      end;
    end
    else
      raise;
  end;

  qLock.Free;

  Result := LockSuccess;
end;

procedure ADMessage(TheMessage: string);
begin
  fmAccessDenied.lblMessage.caption := TheMessage + '.';
  fmAccessDenied.showModal;
end;

procedure SetColumnWidthsAll3a(fmAll: TForm;
                              dbgNormal: TDBGridPlus;
                              dbgGroup: TDBGridPlus;
                              ColumnSelectedPosition, LastColNo: integer;
                              GroupDown: boolean);
var
  WrongOrder: boolean;
  i, j: integer;

begin
  WrongOrder := False;
  if GroupDown then
  begin
    for i := 0 to LastColNo - 1 do
    begin
      if not(dbgGroup.Columns[i].FieldName = dbgNormal.Columns[i].FieldName) then
        WrongOrder := True;
    end;

    if WrongOrder then
    begin
      for i := 0 to LastColNo - 1 do
      begin
        for j := 0 to LastColNo - 1 do
        begin
          if dbgGroup.Columns[i].FieldName = dbgNormal.Columns[j].FieldName then
            dbgGroup.Columns[i].Index := j;
        end;
      end;
    end;

    for i:= 0 to LastColNo - 1 do
      dbgGroup.Columns[i].Width := dbgNormal.Columns[i].Width;

    if not(ColumnSelectedPosition = LastColNo) then
      dbgGroup.Columns[LastColNo].Index := ColumnSelectedPosition;

    fmAll.Width := fmAll.Width + dbgGroup.Columns[ColumnSelectedPosition].Width + 1;

    if (dgIndicator in dbgNormal.Options) then
      fmAll.Width := fmAll.Width - 11;
  end
  else
  begin
    if not(ColumnSelectedPosition = LastColNo) then
      dbgGroup.Columns[ColumnSelectedPosition].Index := LastColNo;

    for i := 0 to LastColNo - 1 do
    begin
      if not(dbgNormal.Columns[i].FieldName = dbgGroup.Columns[i].FieldName) then
        WrongOrder := True;
    end;

    if WrongOrder then
    begin
      for i := 0 to LastColNo - 1 do
      begin
        for j := 0 to LastColNo - 1 do
        begin
          if dbgNormal.Columns[i].FieldName = dbgGroup.Columns[j].FieldName then
            dbgNormal.Columns[i].Index := j;
        end;
      end;
    end;

    for i:= 0 to LastColNo - 1 do
      dbgNormal.Columns[i].Width := dbgGroup.Columns[i].Width;

    fmAll.Width := fmAll.Width - (dbgGroup.Columns[LastColNo].Width + 1);

    if (dgIndicator in dbgNormal.Options) then
      fmAll.Width := fmAll.Width + 11;
  end;
end;

function GetColumnSelectedPosition(sgGroup: TXStringGrid;
                                   LastColNo: integer): integer;
var
  i: short;

begin
  Result := -1;

  //Can't just use ToIndex when Selected Column itself is moved
  //because moving a different column can also effect it.
  //Difficult to find a unique way to ID the selected column - Had to use objects property of first cell in column
  //ID did not work because it got left behind and, as a read-only property, could not be reassigned.
  //DisplayName doesn't work because, although you appear to be able to assign to it, when you do, it doesn't get set.
  for i := 0 to LastColNo do
    if not(sgGroup.Objects[i, 1] = nil) then
      Result := i;
end;

function GetColumnSelectedPosition3(dbgGroup: TDBGridPlus;
                                   LastColNo: integer): integer;
var
  i: short;

begin
  Result := -1;

  //Can't just use ToIndex when Selected Column itself is moved
  //because moving a different column can also effect it.
  for i := 0 to LastColNo do
    if dbgGroup.Columns[i].FieldName = 'Selected' then
      Result := i;
end;

procedure SetColumnWidthsDetails1(fmDetail: TForm;      //same as previous except for Grid type (Combine later with override or remove one)
                                 gNormal: TXStringGrid;
                                 gEdit: TDBGridPlus;
                                 LastColNo: integer;
                                 Editing: boolean);
var
  TemporaryGrid: TXStringGrid;
  WrongOrder: boolean;
  i, j: integer;

begin
  WrongOrder := False;
  if Editing then
  begin
    for i := 0 to LastColNo do
    begin
      if not(gEdit.Columns[i].Title.Caption = gNormal.Columns[i].Caption) then
        WrongOrder := True;
    end;

    if WrongOrder then
    begin
      for i := 0 to LastColNo do
      begin
        for j := 0 to LastColNo do
        begin
          if gEdit.Columns[i].Title.Caption = gNormal.Columns[j].Caption then
            gEdit.Columns[i].Index := j;
        end;
      end;
    end;

    for i:= 0 to LastColNo do
      gEdit.Columns[i].Width := gNormal.Columns[i].Width;
  end
  else
  begin
    for i := 0 to LastColNo do
    begin
      if not(gNormal.Columns[i].Caption = gEdit.Columns[i].Title.Caption) then
        WrongOrder := True;
    end;

    if WrongOrder then
    begin
    //N.B.  This whole section has had to be written differently because the .index property of the XStringGrid does not
    //affect the column order as it does on all other grids.
      TemporaryGrid := TXStringGrid.Create(application.MainForm);
      TemporaryGrid.ColCount := LastColNo + 1; //TAH added because I can't see how this can work without it 24/08/05

      for i := 0 to LastColNo do
      begin
        for j := 0 to LastColNo do
        begin
          if gNormal.Columns[i].Caption = gEdit.Columns[j].Title.Caption then
            TemporaryGrid.Columns[j] := gNormal.Columns[i];   //I want the columns from the XStringGrid, but in the order of the DBGrid
        end;
      end;

      for i := 0 to LastColNo do
        gNormal.Columns[i] := TemporaryGrid.Columns[i];

      TemporaryGrid.Destroy;
    end;

    for i:= 0 to LastColNo do
      gNormal.Columns[i].Width := gEdit.Columns[i].Width;
  end;
end;

procedure SetColumnWidthsDetails2a(fmDetail: TForm;    //same as previous except for Grid type (Combine later with override or remove one)
                                  gNormal: TDBGridPlus;
                                  gEdit: TDBGridPlus;
                                  LastColNo: integer;
                                  Editing: boolean);
var
  TemporaryGrid: TDBGridPlus;
  WrongOrder: boolean;
  i, j: integer;

begin
  WrongOrder := False;
  if Editing then
  begin
    for i := 0 to LastColNo do
    begin
      if not(gEdit.Columns[i].Title.Caption = gNormal.Columns[i].Title.Caption) then
        WrongOrder := True;
    end;

    if WrongOrder then
    begin
      for i := 0 to LastColNo do
      begin
        for j := 0 to LastColNo do
        begin
          if gEdit.Columns[i].Title.Caption = gNormal.Columns[j].Title.Caption then
            gEdit.Columns[i].Index := j;
        end;
      end;
    end;

    for i:= 0 to LastColNo do
      gEdit.Columns[i].Width := gNormal.Columns[i].Width;
  end
  else
  begin
    for i := 0 to LastColNo do
    begin
      if not(gNormal.Columns[i].Title.Caption = gEdit.Columns[i].Title.Caption) then
        WrongOrder := True;
    end;

    if WrongOrder then
    begin
    //N.B.  This whole section has had to be written differently because the .index property of the XStringGrid does not
    //affect the column order as it does on all other grids.

      //TAH Left same even though this one is written for 2 DBAltGrids
      TemporaryGrid := TDBGridPlus.Create(application.MainForm);
      for i := 0 to LastColNo do
        TemporaryGrid.Columns.Add;

      for i := 0 to LastColNo do
      begin
        for j := 0 to LastColNo do
        begin
          if gNormal.Columns[i].Title.Caption = gEdit.Columns[j].Title.Caption then
            TemporaryGrid.Columns[j] := gNormal.Columns[i];   //I want the columns from the XStringGrid, but in the order of the DBGrid
        end;
      end;

      for i := 0 to LastColNo do
        gNormal.Columns[i] := TemporaryGrid.Columns[i];

      TemporaryGrid.Destroy;
    end;

    for i:= 0 to LastColNo do
      gNormal.Columns[i].Width := gEdit.Columns[i].Width;
  end;
end;

procedure SetColumnWidthsDetails3a(fmDetail: TForm;    //same as previous except for Grid type (Combine later with override or remove one)
                                  gNormal: TDBGridPlus;
                                  gEdit: TDBGridPlus;
                                  LastColNo: integer;
                                  Editing: boolean);
var
  TemporaryGrid: TDBGridPlus;
  WrongOrder: boolean;
  i, j: integer;

begin
  WrongOrder := False;
  if Editing then
  begin
    for i := 0 to LastColNo do
    begin
      if not(gEdit.Columns[i].Title.Caption = gNormal.Columns[i].Title.Caption) then
        WrongOrder := True;
    end;

    if WrongOrder then
    begin
      for i := 0 to LastColNo do
      begin
        for j := 0 to LastColNo do
        begin
          if gEdit.Columns[i].Title.Caption = gNormal.Columns[j].Title.Caption then
            gEdit.Columns[i].Index := j;
        end;
      end;
    end;

    for i:= 0 to LastColNo do
      gEdit.Columns[i].Width := gNormal.Columns[i].Width;
  end
  else
  begin
    for i := 0 to LastColNo do
    begin
      if not(gNormal.Columns[i].Title.Caption = gEdit.Columns[i].Title.Caption) then
        WrongOrder := True;
    end;

    if WrongOrder then
    begin
    //N.B.  This whole section has had to be written differently because the .index property of the XStringGrid does not
    //affect the column order as it does on all other grids.

      //TAH Left same even though this one is written for 2 DBAltGrids
      TemporaryGrid := TDBGridPlus.Create(application.MainForm);
      for i := 0 to LastColNo do
        TemporaryGrid.Columns.Add;

      for i := 0 to LastColNo do
      begin
        for j := 0 to LastColNo do
        begin
          if gNormal.Columns[i].Title.Caption = gEdit.Columns[j].Title.Caption then
            TemporaryGrid.Columns[j] := gNormal.Columns[i];   //I want the columns from the XStringGrid, but in the order of the DBGrid
        end;
      end;

      for i := 0 to LastColNo do
        gNormal.Columns[i] := TemporaryGrid.Columns[i];

      TemporaryGrid.Destroy;
    end;

    for i:= 0 to LastColNo do
      gNormal.Columns[i].Width := gEdit.Columns[i].Width;
  end;
end;

procedure ScreenShot(x, y, Width, Height: integer; bm: Graphics.TBitMap);
var
  dc: HDC;
  lpPal: PLOGPALETTE;

begin
  bm.Width := Width;
  bm.Height := Height;

  dc := GetDc(0);

  //do we have a palette device?
  if (GetDeviceCaps(dc, RASTERCAPS) and RC_PALETTE = RC_PALETTE) then
  begin
    //allocate memory for a logical palette
    GetMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
    //zero it out to be neat
    FillChar(lpPal^, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)), #0);
    //fill in the palette version
    lpPal^.palVersion := $300;
    //grab the system palette entries
    lpPal^.palNumEntries := GetSystemPaletteEntries(dc, 0, 256, lpPal^.palPalEntry);
    if (lpPal^.PalNumEntries <> 0) then
    begin
      //create the palette
      bm.Palette := CreatePalette(lpPal^);
    end;
    FreeMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
  end;

  //copy from the screen to the bitmap
  BitBlt(bm.Canvas.Handle, 0, 0, Width, Height, Dc, x, y, SRCCOPY);

  ReleaseDc(0, dc);
end;

procedure RejectApostrophe(Code: string);
begin
  if pos('''', Code) > 0 then
  begin
    messagedlg('Illegal character ''', mtInformation, [mbOK], 0);
    Screen.cursor := crDefault;
    abort;
  end;
end;

procedure SetRowCount(AGrid: TXStringGrid;
                      imgNoTick: TImage;
                      var ActualRowCount: integer);
var
  i: integer;

begin
  ActualRowCount := AGrid.RowCount;

  if ActualRowCount = 1 then
  begin
    AGrid.RowCount := 2;
    for i := 0 to AGrid.ColCount - 2 do
      AGrid.Cells[i, 1] := '';

    AGrid.FixedRows := 1;
    AGrid.Objects[AGrid.ColCount - 1, 1] := imgNoTick;
  end;
end;

procedure DrawGridText(AGrid: TXStringGrid; ARect: TRect;
                       AValue: string; Alignment: TAlignment);
var
  horzOffset: integer;
  vertOffset: integer;

begin
  // Note: The Handle property of TCanvas is a DC handle.
  with AGrid.Canvas do
  begin
    vertOffset := (((ARect.Bottom - ARect.Top) - TextExtent(AValue).CY) div 2);
    horzOffset := TextExtent('Mi').CX div 4;

    case Alignment of
      taLeftJustify: begin
                       SetTextAlign(Handle, TA_LEFT or TA_TOP or TA_NOUPDATECP);
                       ExtTextOut(Handle, ARect.Left + horzOffset,
                                  ARect.Top + vertOffset, ETO_CLIPPED or ETO_OPAQUE,
                                  @ARect, PChar(AValue), Length(AValue), nil);
                     end;


      taRightJustify: begin
                        SetTextAlign(Handle, TA_RIGHT or TA_TOP or TA_NOUPDATECP);
                        ExtTextOut(Handle, ARect.Right - horzOffset,
                                   ARect.Top + vertOffset, ETO_CLIPPED or ETO_OPAQUE,
                                   @ARect, PChar(AValue), Length(AValue), nil);
                      end;


      taCenter: begin
                  horzOffset := ((ARect.Right - ARect.Left) - TextExtent(AValue).CX) div 2;
                  SetTextAlign(Handle, TA_LEFT or TA_TOP or TA_NOUPDATECP);
                  ExtTextOut(Handle, ARect.Left + horzOffset,
                             ARect.Top + vertOffset, ETO_CLIPPED or ETO_OPAQUE,
                             @ARect, PChar(AValue), Length(AValue), nil);
                end;
    end;
  end;
end;

procedure TXStringGridDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Align: TAlignment;
  sText: string;
  LeftPos, TopPos: integer;

begin
  sText := (sender as TXStringGrid).Cells[Col, Row];

  if Row = 0 then    //TXStringGrid header line
  begin
    align := (sender as TXStringGrid).Columns[Col].HeaderAlignment;
   (sender as TXStringGrid).Canvas.Font := (sender as TXStringGrid).Columns[Col].HeaderFont;
  end
  else
  begin
    align := (sender as TXStringGrid).Columns[Col].Alignment;
   (sender as TXStringGrid).Canvas.Font := (sender as TXStringGrid).Columns[Col].Font;
  end;

  if gdSelected in State then
    (sender as TXStringGrid).Canvas.Font.Color := (sender as TXStringGrid).SelectedTextColor;

  if not((sender as TXStringGrid).Objects[Col, Row] = nil)  then
  begin
    //Centre image in cell
    LeftPos := Rect.Left + ((Rect.Right - Rect.Left) - ((sender as TXStringGrid).Objects[Col, Row] as TImage).Width) div 2;
    TopPos := Rect.Top + ((Rect.Bottom - Rect.Top) - ((sender as TXStringGrid).Objects[Col, Row] as TImage).Height) div 2;

    (sender as TXStringGrid).Canvas.Draw(LeftPos, TopPos, ((sender as TXStringGrid).Objects[Col, Row] as TImage).Picture.Graphic);
  end;

  if (sender as TXStringGrid).Objects[Col, Row] = nil then
    DrawGridText((sender as TXStringGrid), Rect, sText, Align);
end;

procedure DrawTab(PageControl: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  OutRect: TRect;
  TabText: string;
  i, NoTab: integer;

begin
  //To make tabs coloured.
  OutRect := Rect;

  //This block of code is a workaround for the fact that setting TabVisible to False
  //causes the tab labels to come out incorrectly.  NOTE: this code will not work if
  //we subsequently want to hide more than one tab in the middle and the last tab.
  NoTab := 999;
  for i := 0 to (PageControl as TPageControl).PageCount - 2 do
    if not (PageControl as TPageControl).Pages[i].TabVisible then
      NoTab := i;
  if TabIndex >= NoTab then
    TabIndex := TabIndex + 1;
  //end workaround code.

  TabText := (PageControl as TPageControl).Pages[TabIndex].Caption;

  DrawText(PageControl.Canvas.Handle, PChar(TabText), Length(TabText), OutRect,
           DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_EXPANDTABS or DT_NOCLIP);
end;

function FirstNChars(s: string; n: integer): string;
begin
  if Length(s) > n then
    s := copy(s, 1, n);

  Result := s;
end;

function FontStyle(FontStyleString: string): TFontStyles;
var
  i: TFontStyle;
  FontSet: TFontStyles;

begin
  FontSet := [];
  for i := fsBold to fsStrikeout do
    if Pos(FontStyleNames[i], FontStyleString) > 0 then
      Include(FontSet, i);
  Result := FontSet;
end;

function FontStyleString(FontSty: TFontStyles): string;
var
  i: TFontStyle;
  FSStr: string;

begin
  FSStr := '';
  for i := fsBold to fsStrikeout do
  begin
    if i in FontSty then
    begin
      if FSStr = '' then
        FSStr := FontStyleNames[i]
      else
        FSStr := FSStr + ', ' + FontStyleNames[i];
    end;
  end;
  Result := FSStr;
end;

function OurColor(col: TColor): TColor;
var
  newcol: TColor;

begin
  if col = clBtnFace then
    newcol := clMain
  else if col = clAqua then
    newcol := clBack
  else if col = clLime then
    newcol := clBackDark
  else if col = clTeal then
    newcol := clBackVeryDark
  else if col = clFuchsia then
    newcol := clText
  else if col = clWindowText then
    newcol := clData
  else if col = clHighlightText then
    newcol := clData2
  else if col = clWindow then
    newcol := clEditing
  else if col = clOlive then
    newcol := clValueAdded
  else if col = clMaroon then
    newcol := clNonValueAdded
  else if col = clRed then
    newcol := clWarningRed
  else if col = clYellow then
    newcol := clWarningAmber
  else
    newcol := col;

  Result := newcol;
end;

procedure AutoColor(Form: TForm);
var
  i, j: integer;
  theColor: TColor;
  theFont: TFont;
  theChartTitle: TChartTitle;
  theColumns: TDBGridColumns;
  theColumns2: TXStringColumns;
//  theControlLook: TControlLook; //AdvGrid
  theAxis: TChartAxis;

begin
  Form.Color := OurColor(Form.Color);

  for i := 0 to Form.ComponentCount - 1 do
  begin
    if ((Form.Components[i] is TControl) or (Form.Components[i] is TWinControl)) and (Form.Components[i].Tag <> -1) then
    begin
      if IsPublishedProp(Form.Components[i], 'Color') then
      begin
        theColor := TColor(GetOrdProp(Form.Components[i], 'Color'));
        theColor := OurColor(theColor);
        SetOrdProp(Form.Components[i], 'Color', integer(theColor));
      end;

      if IsPublishedProp(Form.Components[i], 'FixedColor') then
      begin
        theColor := TColor(GetOrdProp(Form.Components[i], 'FixedColor'));
        theColor := OurColor(theColor);
        SetOrdProp(Form.Components[i], 'FixedColor', integer(theColor));
      end;

      if IsPublishedProp(Form.Components[i], 'SelectedColor') then
      begin
        theColor := TColor(GetOrdProp(Form.Components[i], 'SelectedColor'));
        theColor := OurColor(theColor);
        SetOrdProp(Form.Components[i], 'SelectedColor', integer(theColor));
      end;

      if IsPublishedProp(Form.Components[i], 'GradientEndColor') then
      begin
        theColor := TColor(GetOrdProp(Form.Components[i], 'GradientEndColor'));
        theColor := OurColor(theColor);
        SetOrdProp(Form.Components[i], 'GradientEndColor', integer(theColor));
      end;

      if IsPublishedProp(Form.Components[i], 'GradientStartColor') then
      begin
        theColor := TColor(GetOrdProp(Form.Components[i], 'GradientStartColor'));
        theColor := OurColor(theColor);
        SetOrdProp(Form.Components[i], 'GradientStartColor', integer(theColor));
      end;

      if IsPublishedProp(Form.Components[i], 'Font') then
      begin
        theFont := TFont(GetOrdProp(Form.Components[i], 'Font'));
        theFont.Color := OurColor(theFont.Color);
      end;

      if IsPublishedProp(Form.Components[i], 'FixedFont') then
      begin
        theFont := TFont(GetOrdProp(Form.Components[i], 'FixedFont'));
        theFont.Color := OurColor(theFont.Color);
      end;

      if IsPublishedProp(Form.Components[i], 'TitleFont') then
      begin
        theFont := TFont(GetOrdProp(Form.Components[i], 'TitleFont'));
        theFont.Color := OurColor(theFont.Color);
      end;

      if IsPublishedProp(Form.Components[i], 'Title') then
      begin
        if (Form.Components[i] is TChart) then
        begin
          theChartTitle := TChartTitle(GetOrdProp(Form.Components[i], 'Title'));
          theChartTitle.Font.Color := OurColor(theChartTitle.Font.Color);
        end;
      end;

      if IsPublishedProp(Form.Components[i], 'Columns') then
      begin
        if (Form.Components[i] is TDBGridPlus) then
        begin
          theColumns := TDBGridColumns(GetOrdProp(Form.Components[i], 'Columns'));
          for j := 0 to theColumns.Count - 1 do
          begin
            //In XE2, if the column is the same colour as its parent it reports 0
            if theColumns[j].Color = 0 then
              theColumns[j].Color := TColor(GetOrdProp(Form.Components[i], 'Color'));

            theColumns[j].Color := OurColor(theColumns[j].Color);
            theColumns[j].Font.Color := OurColor(theColumns[j].Font.Color);
            theColumns[j].Title.Font.Color := OurColor(theColumns[j].Title.Font.Color);
          end;
        end;
        if (Form.Components[i] is TXStringGrid) then
        begin
          theColumns2 := TXStringColumns(GetOrdProp(Form.Components[i], 'Columns'));
          for j := 0 to theColumns2.Count - 1 do
          begin
            theColumns2[j].Color := OurColor(theColumns2[j].Color);
            theColumns2[j].Font.Color := OurColor(theColumns2[j].Font.Color);
            theColumns2[j].HeaderColor := OurColor(theColumns2[j].HeaderColor);
            theColumns2[j].HeaderFont.Color := OurColor(theColumns2[j].HeaderFont.Color);
          end;
        end;
      end;

//AdvGrid
//      if IsPublishedProp(Form.Components[i], 'ControlLook') then
//      begin
//        theControlLook := TControlLook(GetOrdProp(Form.Components[i], 'ControlLook'));
//        theControlLook.FixedGradientFrom := OurColor(theControlLook.FixedGradientFrom);
//        theControlLook.FixedGradientTo := OurColor(theControlLook.FixedGradientTo);
//      end;

      if IsPublishedProp(Form.Components[i], 'LeftAxis') then
      begin
        theAxis := TChartAxis(GetOrdProp(Form.Components[i], 'LeftAxis'));
        theAxis.Axis.Color := OurColor(theAxis.Axis.Color);
        theAxis.LabelsFont.Color := OurColor(theAxis.LabelsFont.Color);
        theAxis.Ticks.Color := OurColor(theAxis.LabelsFont.Color);
      end;

      if IsPublishedProp(Form.Components[i], 'BottomAxis') then
      begin
        theAxis := TChartAxis(GetOrdProp(Form.Components[i], 'BottomAxis'));
        theAxis.Axis.Color := OurColor(theAxis.Axis.Color);
        theAxis.LabelsFont.Color := OurColor(theAxis.LabelsFont.Color);
        theAxis.Ticks.Color := OurColor(theAxis.LabelsFont.Color);
      end;
    end;
  end;
end;

procedure ShowWebpage(Sender: TObject; Address: string);
begin
  try
    ShellExecute(Application.Handle,
                 PChar('open'),
                 PChar(Address),
                 PChar(0),
                 nil,
                 SW_NORMAL);
  except
    messagedlg('Internet access required.', mtInformation, [mbOk], 0);
  end;
end;

function CustomMessageDlg(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; Captions: array of string): Integer;
var
  aMsgDlg: TForm;
  i: Integer;
  dlgButton: TButton;
  CaptionIndex: Integer;

begin
  aMsgDlg := CreateMessageDialog(Msg, DlgType, Buttons);
  captionIndex := 0;

  for i := 0 to aMsgDlg.ComponentCount - 1 do
  begin
    if (aMsgDlg.Components[i] is TButton) then
    begin
      dlgButton := TButton(aMsgDlg.Components[i]);
      if CaptionIndex > High(Captions) then Break;

      dlgButton.Caption := Captions[CaptionIndex];
      Inc(CaptionIndex);
    end;
  end;

  Result := aMsgDlg.ShowModal;
end;

function GetPaperSize: integer;
var
  myPrinter: TPrinter;
//  Device: array[0..cchDevicename - 1] of Char;
  Device: array[0..1000 - 1] of Char;  //Above not big enough for SOME printers in 64 bit version
  Driver: array[0..(MAX_PATH) - 1] of Char;
  Port: array[0..32] of Char;
  hDMode: THandle;
  pDMode: PDevMode;
  PaperSize: integer;

begin
  PaperSize := 0;

  myPrinter := TPrinter.create;
  myPrinter.Refresh;
  myPrinter.GetPrinter(Device, Driver, Port, hDMode);
  if (hDMode <> 0) then
  begin
    pDMode := GlobalLock(hDMode);
    if pDMode <> nil then
      PaperSize := pDMode^.dmPaperSize;
    GlobalUnLock(hDMode);
  end;
  myPrinter.Free;

  Result := PaperSize;
end;

function GetTransactionNo(Option: string): integer;
var
  qLock: TFDQuery;
  Connection: TFDConnectionPlus;
  Base64: string;

begin
  Connection := TFDConnectionPlus.create(application.MainForm);
  ConnectionSettings(Connection);
  qLock := TFDQuery.Create(application.MainForm);
  qLock.Connection := Connection;
  qLock.SQL.Clear;

  Base64 := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  qlock.SQL.Add('SELECT ((Position(substring(ROWID, 13, 1) IN ''' + Base64 + ''') - 1) * 1073741824) + ');
  qlock.SQL.Add('       ((Position(substring(ROWID, 14, 1) IN ''' + Base64 + ''') - 1) * 16777216) + ');
  qLock.SQL.Add('       ((Position(substring(ROWID, 15, 1) IN ''' + Base64 + ''') - 1) * 262144) + ');
  qLock.SQL.Add('       ((Position(substring(ROWID, 16, 1) IN ''' + Base64 + ''') - 1) * 4096) + ');
  qLock.SQL.Add('       ((Position(substring(ROWID, 17, 1) IN ''' + Base64 + ''') - 1) * 64) + ');
  qLock.SQL.Add('        (Position(substring(ROWID, 18, 1) IN ''' + Base64 + ''')) as RecNo');
  qLock.SQL.Add('FROM Locks');
  qLock.SQL.Add('WHERE Option = ''' + Option + '''');

  qLock.Open;

  Result := qLock.FieldByname('RecNo').value;

  qLock.Free;
  Connection.Free;
end;

procedure ClosePreviewForm(Name: string);
var
  FormNo, i: integer;
  s: string;

begin
  //CJY Allow the close of unnammed Previews. If the Name is '' then Trim will
  //    find 'Preview'
  s := Trim('Preview ' + Name);

  FormNo := -1;
  with Screen do
    for i := 0 to Screen.FormCount - 1 do
      if Pos(s, Screen.Forms[i].caption) = 1 then
        FormNo := i;

  if FormNo >= 0 then
    Screen.Forms[FormNo].Close;
end;

function ItemGone(var tbl: TFDTablePlus; ItemCode: string): Boolean;
var
  ItemType, fn: string;
  Gone: Boolean;
  bHoldState: boolean;
  dsState: TDataSetState;

begin
  ItemType := '???';
  fn := Uppercase(TPath.GetFileNameWithoutExtension(tbl.TableName));
  if fn = 'MATERIAL' then
    ItemType := 'Material'
  else if fn = 'KNIFESETS' then
    ItemType := 'Knife'
  else if fn = 'PARTS' then
    ItemType := 'Part'
  else if fn = 'CONSTRUC' then
    ItemType := 'Construction'
  else if fn = 'STYLES' then
    ItemType := 'Style'
  else if fn = 'SIZESCALES' then
    ItemType := 'Size Scale'
  else if fn = 'SIZERANGES' then
    ItemType := 'Size Range'
  else if fn = 'SIZERELATIONSHIPS' then
    ItemType := 'Size Relationship'
  else if fn = 'WRNGS' then
    ItemType := 'Width Range'
  else if fn = 'SUPPLIER' then
    ItemType := 'Supplier'
  else if fn = 'TICKETSEQUENCES' then
    ItemType := 'Ticket';

  bHoldState := (tbl.recordcount = 1);
  dsState := tbl.State;

  tbl.refresh;
  Gone := tbl.recordcount = 0;
  if Gone then
    messagedlg(ItemType + ' ' + ItemCode + ' no longer exists', mtInformation, [mbOk], 0)
  else
  begin
    if (bHoldState) and
       (tbl.RecordCount = 1) and
       (dsState in [dsEdit, dsInsert]) then
      tbl.Edit;
  end;

  Result := Gone;
end;


function FloatToStrSQL(Value: Extended): string;
begin
  Result := FloatToStr(Value);
  Result := TRegEx.Replace(Result, '[\s]', '', [roIgnoreCase]);
  Result := TRegEx.Replace(Result, '[^-0-9]', '.', [roIgnoreCase]);
end;


function FloatToStrFSQL(Value: Extended; Format: TFloatFormat; Precision, Digits: Integer): string;
begin
  Result := FloatToStrF(Value, Format, Precision, Digits);
  Result := TRegEx.Replace(Result, '[\s]', '', [roIgnoreCase]);
  Result := TRegEx.Replace(Result, '[^-0-9]', '.', [roIgnoreCase]);
end;


procedure SortOrder(var dbg: TDBGridPlus; Column: TColumn; var SQLString: string);
var
  NewColumn: Boolean;

begin
  NewColumn := (dbg.SortColumn <> Column.Index);

  dbg.SortColumn := Column.Index;

  if not NewColumn then
  begin
    if dbg.SortOrder = soAscending then
      dbg.SortOrder := soDescending
    else
      dbg.SortOrder := soAscending;
  end;

  if dbg.SortOrder = soAscending then
    SQLString := ' ASC'
  else
    SQLString := ' DESC';
end;


end.




