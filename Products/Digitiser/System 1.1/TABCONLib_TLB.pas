unit TABCONLib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 9/13/2004 10:29:03 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\TabletWorks SDK\TabCon.exe (1)
// LIBID: {09811543-1621-4306-AE4D-EAB4D087108C}
// LCID: 0
// Helpfile: 
// HelpString: GTCO Calcomp Tablet Interface Control 2.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
// Errors:
//   Hint: Parameter 'Type' of ITabletControl.TabletGetType changed to 'Type_'
//   Hint: Parameter 'Interface' of ITabletControl.TabletGetInterface changed to 'Interface_'
//   Hint: Parameter 'Type' of ITabletControl.TabletGetCursorInfo changed to 'Type_'
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  TABCONLibMajorVersion = 1;
  TABCONLibMinorVersion = 0;

  LIBID_TABCONLib: TGUID = '{09811543-1621-4306-AE4D-EAB4D087108C}';

  DIID__ITabletControlEvents: TGUID = '{09811542-1621-4306-AE4D-EAB4D087108C}';
  IID_ITabletControl: TGUID = '{09811541-1621-4306-AE4D-EAB4D087108C}';
  CLASS_TabletControl: TGUID = '{09811540-1621-4306-AE4D-EAB4D087108C}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TABLET_ERRORS
type
  TABLET_ERRORS = TOleEnum;
const
  E_BAD_DEVICEID = $80040201;
  E_BAD_CURSORID = $80040202;
  E_BAD_RESOLUTION = $80040203;
  E_NOT_AVAILABLE = $80040204;
  E_DEVICE_DISCONNECT = $80040205;
  E_ALREADY_DISCOVERING = $80040206;
  E_NOT_OPEN = $80040207;
  E_FILE = $80040208;
  E_TOO_MANY_OPENS = $80040209;

// Constants for enum TABLET_MAKE
type
  TABLET_MAKE = TOleEnum;
const
  TABLET_MAKE_UNKNOWN = $00000000;
  TABLET_MAKE_CALCOMP = $00000001;
  TABLET_MAKE_GTCO = $00000002;
  TABLET_MAKE_SUMMAGRAPHICS = $00000003;
  TABLET_MAKE_GTCO_CALCOMP = $00000004;

// Constants for enum TABLET_TYPE
type
  TABLET_TYPE = TOleEnum;
const
  TABLET_UNKNOWN = $00000000;
  TABLET_AT1 = $0000000A;
  TABLET_AT2 = $0000000B;
  TABLET_AT3 = $0000000C;
  TABLET_CADPRO = $00000014;
  TABLET_DB2 = $0000001E;
  TABLET_DB3 = $0000001F;
  TABLET_DB4 = $00000020;
  TABLET_DB5 = $00000021;
  TABLET_RUD1 = $00000028;
  TABLET_RUD2 = $00000029;
  TABLET_RUD3 = $0000002A;
  TABLET_RUDCDL = $0000002B;
  TABLET_SG5 = $00000032;
  TABLET_SG6 = $00000033;
  TABLET_SG7 = $00000034;
  TABLET_SL1 = $0000003C;
  TABLET_SL2 = $0000003D;
  TABLET_SL3 = $0000003E;
  TABLET_SL4 = $0000003F;
  TABLET_SLX = $00000040;
  TABLET_SS3UIOF = $00000046;
  TABLET_SS3MM = $00000047;
  TABLET_SSKETCH = $00000048;
  TABLET_SUMMAUIOF = $00000049;
  TABLET_SUMMAMM = $0000004A;
  TABLET_SUMMAMMFX = $0000004B;
  TABLET_STATION = $00000050;
  TABLET_DRAWINGSLATE = $00000051;
  TABLET_ULTRASLATE = $00000052;
  TABLET_MEETINGBOARD = $00000064;
  TABLET_MEETINGBOARD8 = $00000065;
  TABLET_MEETINGPADMGR = $0000006E;
  TABLET_MEETINGPAD = $00000078;
  TABLET_SCHOOLBOARD = $00000079;
  TABLET_SCHOOLPAD = $0000007A;
  TABLET_IPANEL = $00000082;

// Constants for enum TABLET_INTERFACE
type
  TABLET_INTERFACE = TOleEnum;
const
  TABLET_INTERFACE_UNKNOWN = $00000000;
  TABLET_INTERFACE_SERIAL = $00000001;
  TABLET_INTERFACE_USB = $00000002;
  TABLET_INTERFACE_BLUETOOTH = $00000003;
  TABLET_INTERFACE_MSBLUETOOTH = $00000004;
  TABLET_INTERFACE_ETHERNET = $00000005;
  TABLET_INTERFACE_80211 = $00000006;
  TABLET_INTERFACE_IRDA = $00000007;

// Constants for enum TABLET_TRANSDUCER
type
  TABLET_TRANSDUCER = TOleEnum;
const
  TABLET_TRANSDUCER_NONE = $00000000;
  TABLET_TRANSDUCER_UNKNOWN = $00000001;
  TABLET_TRANSDUCER_STYLUS = $00000002;
  TABLET_TRANSDUCER_PSTYLUS = $00000003;
  TABLET_TRANSDUCER_4BTN = $00000004;
  TABLET_TRANSDUCER_5BTN_MOUSE = $00000005;
  TABLET_TRANSDUCER_MOUSE = $00000006;
  TABLET_TRANSDUCER_PUCK = $00000007;
  TABLET_TRANSDUCER_16BTN = $00000010;
  TABLET_TRANSDUCER_PEN_NONINKING = $00000064;
  TABLET_TRANSDUCER_ERASER_SMALL = $00000065;
  TABLET_TRANSDUCER_ERASER_LARGE = $00000066;
  TABLET_TRANSDUCER_PEN_BLACK = $00000067;
  TABLET_TRANSDUCER_PEN_RED = $00000068;
  TABLET_TRANSDUCER_PEN_GREEN = $00000069;
  TABLET_TRANSDUCER_PEN_BLUE = $0000006A;
  TABLET_TRANSDUCER_PEN_YELLOW = $0000006B;
  TABLET_TRANSDUCER_PEN_ORANGE = $0000006C;
  TABLET_TRANSDUCER_PEN_BROWN = $0000006D;
  TABLET_TRANSDUCER_PEN_PURPLE = $0000006E;

// Constants for enum TABLET_FILTER
type
  TABLET_FILTER = TOleEnum;
const
  TABLET_FILTER_NONE = $00000000;
  TABLET_FILTER_POINT = $00000001;
  TABLET_FILTER_LINE = $00000002;
  TABLET_FILTER_TRACK = $00000003;
  TABLET_FILTER_RUN = $00000004;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _ITabletControlEvents = dispinterface;
  ITabletControl = interface;
  ITabletControlDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TabletControl = ITabletControl;


// *********************************************************************//
// DispIntf:  _ITabletControlEvents
// Flags:     (4096) Dispatchable
// GUID:      {09811542-1621-4306-AE4D-EAB4D087108C}
// *********************************************************************//
  _ITabletControlEvents = dispinterface
    ['{09811542-1621-4306-AE4D-EAB4D087108C}']
    procedure TabletPoint(AppHandle: Integer; X: Integer; Y: Integer; Z: Integer; Buttons: Integer; 
                          Transducer: Integer; Pressure: Integer; Prox: Integer; TimeStamp: Integer); dispid 1;
    procedure TabletFunctionBlock(AppHandle: Integer; Block: Integer); dispid 2;
    procedure TabletDisconnect(AppHandle: Integer; Reason: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: ITabletControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {09811541-1621-4306-AE4D-EAB4D087108C}
// *********************************************************************//
  ITabletControl = interface(IDispatch)
    ['{09811541-1621-4306-AE4D-EAB4D087108C}']
    function Get_TabletGetVersionOfControl: WideString; safecall;
    procedure TabletOpen(AppHandle: Integer; Mode: Integer); safecall;
    procedure TabletClose; safecall;
    procedure TabletFilter(FilterMap: Integer); safecall;
    function TabletGetType(out Make: Integer): Integer; safecall;
    function Get_TabletGetMake: WideString; safecall;
    function Get_TabletGetModel: WideString; safecall;
    function Get_TabletGetVersion: WideString; safecall;
    function Get_TabletGetIDString: WideString; safecall;
    function Get_TabletGetXSize: Integer; safecall;
    function Get_TabletGetYSize: Integer; safecall;
    function Get_TabletGetZSize: Integer; safecall;
    function Get_TabletResolution: Integer; safecall;
    function Get_TabletGetInterface(out pInterface: Integer): WideString; safecall;
    function Get_TabletGetAddress: WideString; safecall;
    function Get_TabletGetNetworkName: WideString; safecall;
    function Get_TabletGetSerialNumber: WideString; safecall;
    function Get_TabletGetBatteryLevel: Integer; safecall;
    function Get_TabletGetFunctionBlocks: Integer; safecall;
    function Get_TabletGetCursorList: OleVariant; safecall;
    function TabletGetCursorInfo(CursorID: Integer; out Pressure: Integer; out NumButtons: Integer): Integer; safecall;
    function Get_TabletPressure(CursorID: Integer): Integer; safecall;
    procedure Set_TabletPressure(CursorID: Integer; pPressure: Integer); safecall;
    function Get_TabletUnits: Integer; safecall;
    procedure TabletGetMouseArea(out Xorg: Integer; out Yorg: Integer; out Xext: Integer; 
                                 out Yext: Integer); safecall;
    procedure TabletEnableMouseArea(Enable: Integer; Mode: Integer); safecall;
    procedure TabletOpenDebugLog(const FileName: WideString; Mode: Integer; out Success: Integer); safecall;
    procedure TabletCloseDebugLog; safecall;
    property TabletGetVersionOfControl: WideString read Get_TabletGetVersionOfControl;
    property TabletGetMake: WideString read Get_TabletGetMake;
    property TabletGetModel: WideString read Get_TabletGetModel;
    property TabletGetVersion: WideString read Get_TabletGetVersion;
    property TabletGetIDString: WideString read Get_TabletGetIDString;
    property TabletGetXSize: Integer read Get_TabletGetXSize;
    property TabletGetYSize: Integer read Get_TabletGetYSize;
    property TabletGetZSize: Integer read Get_TabletGetZSize;
    property TabletResolution: Integer read Get_TabletResolution;
    property TabletGetInterface[out pInterface: Integer]: WideString read Get_TabletGetInterface;
    property TabletGetAddress: WideString read Get_TabletGetAddress;
    property TabletGetNetworkName: WideString read Get_TabletGetNetworkName;
    property TabletGetSerialNumber: WideString read Get_TabletGetSerialNumber;
    property TabletGetBatteryLevel: Integer read Get_TabletGetBatteryLevel;
    property TabletGetFunctionBlocks: Integer read Get_TabletGetFunctionBlocks;
    property TabletGetCursorList: OleVariant read Get_TabletGetCursorList;
    property TabletPressure[CursorID: Integer]: Integer read Get_TabletPressure write Set_TabletPressure;
    property TabletUnits: Integer read Get_TabletUnits;
  end;

// *********************************************************************//
// DispIntf:  ITabletControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {09811541-1621-4306-AE4D-EAB4D087108C}
// *********************************************************************//
  ITabletControlDisp = dispinterface
    ['{09811541-1621-4306-AE4D-EAB4D087108C}']
    property TabletGetVersionOfControl: WideString readonly dispid 1;
    procedure TabletOpen(AppHandle: Integer; Mode: Integer); dispid 2;
    procedure TabletClose; dispid 3;
    procedure TabletFilter(FilterMap: Integer); dispid 4;
    function TabletGetType(out Make: Integer): Integer; dispid 5;
    property TabletGetMake: WideString readonly dispid 6;
    property TabletGetModel: WideString readonly dispid 7;
    property TabletGetVersion: WideString readonly dispid 8;
    property TabletGetIDString: WideString readonly dispid 9;
    property TabletGetXSize: Integer readonly dispid 10;
    property TabletGetYSize: Integer readonly dispid 11;
    property TabletGetZSize: Integer readonly dispid 12;
    property TabletResolution: Integer readonly dispid 13;
    property TabletGetInterface[out pInterface: Integer]: WideString readonly dispid 14;
    property TabletGetAddress: WideString readonly dispid 15;
    property TabletGetNetworkName: WideString readonly dispid 16;
    property TabletGetSerialNumber: WideString readonly dispid 17;
    property TabletGetBatteryLevel: Integer readonly dispid 18;
    property TabletGetFunctionBlocks: Integer readonly dispid 19;
    property TabletGetCursorList: OleVariant readonly dispid 20;
    function TabletGetCursorInfo(CursorID: Integer; out Pressure: Integer; out NumButtons: Integer): Integer; dispid 21;
    property TabletPressure[CursorID: Integer]: Integer dispid 22;
    property TabletUnits: Integer readonly dispid 23;
    procedure TabletGetMouseArea(out Xorg: Integer; out Yorg: Integer; out Xext: Integer; 
                                 out Yext: Integer); dispid 24;
    procedure TabletEnableMouseArea(Enable: Integer; Mode: Integer); dispid 25;
    procedure TabletOpenDebugLog(const FileName: WideString; Mode: Integer; out Success: Integer); dispid 26;
    procedure TabletCloseDebugLog; dispid 27;
  end;

// *********************************************************************//
// The Class CoTabletControl provides a Create and CreateRemote method to          
// create instances of the default interface ITabletControl exposed by              
// the CoClass TabletControl. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTabletControl = class
    class function Create: ITabletControl;
    class function CreateRemote(const MachineName: string): ITabletControl;
  end;

  TTabletControlTabletPoint = procedure(ASender: TObject; AppHandle: Integer; X: Integer; 
                                                          Y: Integer; Z: Integer; Buttons: Integer; 
                                                          Transducer: Integer; Pressure: Integer; 
                                                          Prox: Integer; TimeStamp: Integer) of object;
  TTabletControlTabletFunctionBlock = procedure(ASender: TObject; AppHandle: Integer; Block: Integer) of object;
  TTabletControlTabletDisconnect = procedure(ASender: TObject; AppHandle: Integer; Reason: Integer) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTabletControl
// Help String      : GTCO Calcomp Tablet Interface Control
// Default Interface: ITabletControl
// Def. Intf. DISP? : No
// Event   Interface: _ITabletControlEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTabletControlProperties= class;
{$ENDIF}
  TTabletControl = class(TOleServer)
  private
    FOnTabletPoint: TTabletControlTabletPoint;
    FOnTabletFunctionBlock: TTabletControlTabletFunctionBlock;
    FOnTabletDisconnect: TTabletControlTabletDisconnect;
    FIntf:        ITabletControl;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTabletControlProperties;
    function      GetServerProperties: TTabletControlProperties;
{$ENDIF}
    function      GetDefaultInterface: ITabletControl;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_TabletGetVersionOfControl: WideString;
    function Get_TabletGetMake: WideString;
    function Get_TabletGetModel: WideString;
    function Get_TabletGetVersion: WideString;
    function Get_TabletGetIDString: WideString;
    function Get_TabletGetXSize: Integer;
    function Get_TabletGetYSize: Integer;
    function Get_TabletGetZSize: Integer;
    function Get_TabletResolution: Integer;
    function Get_TabletGetInterface(out pInterface: Integer): WideString;
    function Get_TabletGetAddress: WideString;
    function Get_TabletGetNetworkName: WideString;
    function Get_TabletGetSerialNumber: WideString;
    function Get_TabletGetBatteryLevel: Integer;
    function Get_TabletGetFunctionBlocks: Integer;
    function Get_TabletGetCursorList: OleVariant;
    function Get_TabletPressure(CursorID: Integer): Integer;
    procedure Set_TabletPressure(CursorID: Integer; pPressure: Integer);
    function Get_TabletUnits: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITabletControl);
    procedure Disconnect; override;
    procedure TabletOpen(AppHandle: Integer; Mode: Integer);
    procedure TabletClose;
    procedure TabletFilter(FilterMap: Integer);
    function TabletGetType(out Make: Integer): Integer;
    function TabletGetCursorInfo(CursorID: Integer; out Pressure: Integer; out NumButtons: Integer): Integer;
    procedure TabletGetMouseArea(out Xorg: Integer; out Yorg: Integer; out Xext: Integer; 
                                 out Yext: Integer);
    procedure TabletEnableMouseArea(Enable: Integer; Mode: Integer);
    procedure TabletOpenDebugLog(const FileName: WideString; Mode: Integer; out Success: Integer);
    procedure TabletCloseDebugLog;
    property DefaultInterface: ITabletControl read GetDefaultInterface;
    property TabletGetVersionOfControl: WideString read Get_TabletGetVersionOfControl;
    property TabletGetMake: WideString read Get_TabletGetMake;
    property TabletGetModel: WideString read Get_TabletGetModel;
    property TabletGetVersion: WideString read Get_TabletGetVersion;
    property TabletGetIDString: WideString read Get_TabletGetIDString;
    property TabletGetXSize: Integer read Get_TabletGetXSize;
    property TabletGetYSize: Integer read Get_TabletGetYSize;
    property TabletGetZSize: Integer read Get_TabletGetZSize;
    property TabletResolution: Integer read Get_TabletResolution;
    property TabletGetInterface[out pInterface: Integer]: WideString read Get_TabletGetInterface;
    property TabletGetAddress: WideString read Get_TabletGetAddress;
    property TabletGetNetworkName: WideString read Get_TabletGetNetworkName;
    property TabletGetSerialNumber: WideString read Get_TabletGetSerialNumber;
    property TabletGetBatteryLevel: Integer read Get_TabletGetBatteryLevel;
    property TabletGetFunctionBlocks: Integer read Get_TabletGetFunctionBlocks;
    property TabletGetCursorList: OleVariant read Get_TabletGetCursorList;
    property TabletPressure[CursorID: Integer]: Integer read Get_TabletPressure write Set_TabletPressure;
    property TabletUnits: Integer read Get_TabletUnits;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTabletControlProperties read GetServerProperties;
{$ENDIF}
    property OnTabletPoint: TTabletControlTabletPoint read FOnTabletPoint write FOnTabletPoint;
    property OnTabletFunctionBlock: TTabletControlTabletFunctionBlock read FOnTabletFunctionBlock write FOnTabletFunctionBlock;
    property OnTabletDisconnect: TTabletControlTabletDisconnect read FOnTabletDisconnect write FOnTabletDisconnect;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTabletControl
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTabletControlProperties = class(TPersistent)
  private
    FServer:    TTabletControl;
    function    GetDefaultInterface: ITabletControl;
    constructor Create(AServer: TTabletControl);
  protected
    function Get_TabletGetVersionOfControl: WideString;
    function Get_TabletGetMake: WideString;
    function Get_TabletGetModel: WideString;
    function Get_TabletGetVersion: WideString;
    function Get_TabletGetIDString: WideString;
    function Get_TabletGetXSize: Integer;
    function Get_TabletGetYSize: Integer;
    function Get_TabletGetZSize: Integer;
    function Get_TabletResolution: Integer;
    function Get_TabletGetInterface(out pInterface: Integer): WideString;
    function Get_TabletGetAddress: WideString;
    function Get_TabletGetNetworkName: WideString;
    function Get_TabletGetSerialNumber: WideString;
    function Get_TabletGetBatteryLevel: Integer;
    function Get_TabletGetFunctionBlocks: Integer;
    function Get_TabletGetCursorList: OleVariant;
    function Get_TabletPressure(CursorID: Integer): Integer;
    procedure Set_TabletPressure(CursorID: Integer; pPressure: Integer);
    function Get_TabletUnits: Integer;
  public
    property DefaultInterface: ITabletControl read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoTabletControl.Create: ITabletControl;
begin
  Result := CreateComObject(CLASS_TabletControl) as ITabletControl;
end;

class function CoTabletControl.CreateRemote(const MachineName: string): ITabletControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TabletControl) as ITabletControl;
end;

procedure TTabletControl.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{09811540-1621-4306-AE4D-EAB4D087108C}';
    IntfIID:   '{09811541-1621-4306-AE4D-EAB4D087108C}';
    EventIID:  '{09811542-1621-4306-AE4D-EAB4D087108C}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTabletControl.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as ITabletControl;
  end;
end;

procedure TTabletControl.ConnectTo(svrIntf: ITabletControl);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TTabletControl.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TTabletControl.GetDefaultInterface: ITabletControl;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTabletControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTabletControlProperties.Create(Self);
{$ENDIF}
end;

destructor TTabletControl.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTabletControl.GetServerProperties: TTabletControlProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TTabletControl.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    1: if Assigned(FOnTabletPoint) then
         FOnTabletPoint(Self,
                        Params[0] {Integer},
                        Params[1] {Integer},
                        Params[2] {Integer},
                        Params[3] {Integer},
                        Params[4] {Integer},
                        Params[5] {Integer},
                        Params[6] {Integer},
                        Params[7] {Integer},
                        Params[8] {Integer});
    2: if Assigned(FOnTabletFunctionBlock) then
         FOnTabletFunctionBlock(Self,
                                Params[0] {Integer},
                                Params[1] {Integer});
    3: if Assigned(FOnTabletDisconnect) then
         FOnTabletDisconnect(Self,
                             Params[0] {Integer},
                             Params[1] {Integer});
  end; {case DispID}
end;

function TTabletControl.Get_TabletGetVersionOfControl: WideString;
begin
    Result := DefaultInterface.TabletGetVersionOfControl;
end;

function TTabletControl.Get_TabletGetMake: WideString;
begin
    Result := DefaultInterface.TabletGetMake;
end;

function TTabletControl.Get_TabletGetModel: WideString;
begin
    Result := DefaultInterface.TabletGetModel;
end;

function TTabletControl.Get_TabletGetVersion: WideString;
begin
    Result := DefaultInterface.TabletGetVersion;
end;

function TTabletControl.Get_TabletGetIDString: WideString;
begin
    Result := DefaultInterface.TabletGetIDString;
end;

function TTabletControl.Get_TabletGetXSize: Integer;
begin
    Result := DefaultInterface.TabletGetXSize;
end;

function TTabletControl.Get_TabletGetYSize: Integer;
begin
    Result := DefaultInterface.TabletGetYSize;
end;

function TTabletControl.Get_TabletGetZSize: Integer;
begin
    Result := DefaultInterface.TabletGetZSize;
end;

function TTabletControl.Get_TabletResolution: Integer;
begin
    Result := DefaultInterface.TabletResolution;
end;

function TTabletControl.Get_TabletGetInterface(out pInterface: Integer): WideString;
begin
    Result := DefaultInterface.TabletGetInterface[pInterface];
end;

function TTabletControl.Get_TabletGetAddress: WideString;
begin
    Result := DefaultInterface.TabletGetAddress;
end;

function TTabletControl.Get_TabletGetNetworkName: WideString;
begin
    Result := DefaultInterface.TabletGetNetworkName;
end;

function TTabletControl.Get_TabletGetSerialNumber: WideString;
begin
    Result := DefaultInterface.TabletGetSerialNumber;
end;

function TTabletControl.Get_TabletGetBatteryLevel: Integer;
begin
    Result := DefaultInterface.TabletGetBatteryLevel;
end;

function TTabletControl.Get_TabletGetFunctionBlocks: Integer;
begin
    Result := DefaultInterface.TabletGetFunctionBlocks;
end;

function TTabletControl.Get_TabletGetCursorList: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.TabletGetCursorList;
end;

function TTabletControl.Get_TabletPressure(CursorID: Integer): Integer;
begin
    Result := DefaultInterface.TabletPressure[CursorID];
end;

procedure TTabletControl.Set_TabletPressure(CursorID: Integer; pPressure: Integer);
begin
  DefaultInterface.TabletPressure[CursorID] := pPressure;
end;

function TTabletControl.Get_TabletUnits: Integer;
begin
    Result := DefaultInterface.TabletUnits;
end;

procedure TTabletControl.TabletOpen(AppHandle: Integer; Mode: Integer);
begin
  DefaultInterface.TabletOpen(AppHandle, Mode);
end;

procedure TTabletControl.TabletClose;
begin
  DefaultInterface.TabletClose;
end;

procedure TTabletControl.TabletFilter(FilterMap: Integer);
begin
  DefaultInterface.TabletFilter(FilterMap);
end;

function TTabletControl.TabletGetType(out Make: Integer): Integer;
begin
  Result := DefaultInterface.TabletGetType(Make);
end;

function TTabletControl.TabletGetCursorInfo(CursorID: Integer; out Pressure: Integer; 
                                            out NumButtons: Integer): Integer;
begin
  Result := DefaultInterface.TabletGetCursorInfo(CursorID, Pressure, NumButtons);
end;

procedure TTabletControl.TabletGetMouseArea(out Xorg: Integer; out Yorg: Integer; 
                                            out Xext: Integer; out Yext: Integer);
begin
  DefaultInterface.TabletGetMouseArea(Xorg, Yorg, Xext, Yext);
end;

procedure TTabletControl.TabletEnableMouseArea(Enable: Integer; Mode: Integer);
begin
  DefaultInterface.TabletEnableMouseArea(Enable, Mode);
end;

procedure TTabletControl.TabletOpenDebugLog(const FileName: WideString; Mode: Integer; 
                                            out Success: Integer);
begin
  DefaultInterface.TabletOpenDebugLog(FileName, Mode, Success);
end;

procedure TTabletControl.TabletCloseDebugLog;
begin
  DefaultInterface.TabletCloseDebugLog;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTabletControlProperties.Create(AServer: TTabletControl);
begin
  inherited Create;
  FServer := AServer;
end;

function TTabletControlProperties.GetDefaultInterface: ITabletControl;
begin
  Result := FServer.DefaultInterface;
end;

function TTabletControlProperties.Get_TabletGetVersionOfControl: WideString;
begin
    Result := DefaultInterface.TabletGetVersionOfControl;
end;

function TTabletControlProperties.Get_TabletGetMake: WideString;
begin
    Result := DefaultInterface.TabletGetMake;
end;

function TTabletControlProperties.Get_TabletGetModel: WideString;
begin
    Result := DefaultInterface.TabletGetModel;
end;

function TTabletControlProperties.Get_TabletGetVersion: WideString;
begin
    Result := DefaultInterface.TabletGetVersion;
end;

function TTabletControlProperties.Get_TabletGetIDString: WideString;
begin
    Result := DefaultInterface.TabletGetIDString;
end;

function TTabletControlProperties.Get_TabletGetXSize: Integer;
begin
    Result := DefaultInterface.TabletGetXSize;
end;

function TTabletControlProperties.Get_TabletGetYSize: Integer;
begin
    Result := DefaultInterface.TabletGetYSize;
end;

function TTabletControlProperties.Get_TabletGetZSize: Integer;
begin
    Result := DefaultInterface.TabletGetZSize;
end;

function TTabletControlProperties.Get_TabletResolution: Integer;
begin
    Result := DefaultInterface.TabletResolution;
end;

function TTabletControlProperties.Get_TabletGetInterface(out pInterface: Integer): WideString;
begin
    Result := DefaultInterface.TabletGetInterface[pInterface];
end;

function TTabletControlProperties.Get_TabletGetAddress: WideString;
begin
    Result := DefaultInterface.TabletGetAddress;
end;

function TTabletControlProperties.Get_TabletGetNetworkName: WideString;
begin
    Result := DefaultInterface.TabletGetNetworkName;
end;

function TTabletControlProperties.Get_TabletGetSerialNumber: WideString;
begin
    Result := DefaultInterface.TabletGetSerialNumber;
end;

function TTabletControlProperties.Get_TabletGetBatteryLevel: Integer;
begin
    Result := DefaultInterface.TabletGetBatteryLevel;
end;

function TTabletControlProperties.Get_TabletGetFunctionBlocks: Integer;
begin
    Result := DefaultInterface.TabletGetFunctionBlocks;
end;

function TTabletControlProperties.Get_TabletGetCursorList: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.TabletGetCursorList;
end;

function TTabletControlProperties.Get_TabletPressure(CursorID: Integer): Integer;
begin
    Result := DefaultInterface.TabletPressure[CursorID];
end;

procedure TTabletControlProperties.Set_TabletPressure(CursorID: Integer; pPressure: Integer);
begin
  DefaultInterface.TabletPressure[CursorID] := pPressure;
end;

function TTabletControlProperties.Get_TabletUnits: Integer;
begin
    Result := DefaultInterface.TabletUnits;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TTabletControl]);
end;

end.
