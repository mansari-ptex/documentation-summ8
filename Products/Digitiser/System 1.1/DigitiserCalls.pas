unit DigitiserCalls;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TABCONLib_TLB;

const
  CMS_TO_INCHES = 0.393700787;  {1 / 2.54}
  SQFT_TO_SQINCHES = 144;
  SQINCHES_TO_SQFT = 0.006944444; {1 / 144}
  SQFT_TO_SQCMS = 929.0304;  

type
  TDigitiserState = (_On, _Off);

  TfmDigitiserCalls = class(TForm)
    { Event callbacks from TabCon }
    procedure TabletDisconnect(Sender: TObject; AppHandle, Reason: Integer);
    procedure TabletPoint(Sender: TObject; AppHandle, X, Y, Z,
      Buttons, Transducer, Pressure, Prox, TimeStamp: Integer);
    procedure TabletEventOn;
    procedure TabletEventOff;      

    function CreateDigitiserControl: boolean;
    procedure DestroyDigitiserControl;

    procedure StartDigitiser(Silent: boolean);
    procedure StopDigitiser;
    procedure DigitiserSizeInfo(var DigX, DigY, DigInt: Integer;
                                var DigRatio: real);
    function DigitiserSizeInt: integer;    
    function DigitiserSizeX: integer;
    function DigitiserSizeY: integer;
    function DigitiserSizeXYRatio: real;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDigitiserCalls: TfmDigitiserCalls;

implementation

uses
  DigitiserMain;

{$R *.dfm}

var
  Tablet: TTabletControl;

procedure TfmDigitiserCalls.TabletEventOn;
begin
  Tablet.OnTabletPoint := TabletPoint;
end;

procedure TfmDigitiserCalls.TabletEventOff;
begin
  Tablet.OnTabletPoint := nil;
end;

procedure TfmDigitiserCalls.TabletDisconnect(Sender: TObject; AppHandle, Reason: Integer);
begin
//  TabletConnected := false;
//  UpdateDisplay(fTablet);
end;

procedure TfmDigitiserCalls.TabletPoint(Sender: TObject; AppHandle, X, Y, Z, Buttons, Transducer, Pressure, Prox, TimeStamp: Integer);
begin
//This is the event which goes off all the time.
  fmDigitiser.SetDigitiser(X, Y, Buttons, Transducer, Pressure, Prox, TimeStamp);
end;

function TfmDigitiserCalls.CreateDigitiserControl: boolean;
begin
  try
    // Create an instance of the TabletControl
    Tablet := TTabletControl.Create(self);
    // Assign the event handlers
    Tablet.OnTabletPoint := TabletPoint;
    Tablet.OnTabletDisconnect := TabletDisconnect;

    // Create a connection with the control
    Tablet.Connect;
    result := True;
  except
    result := False;
  end;
end;

function TfmDigitiserCalls.DigitiserSizeX: integer;
begin
  if (Tablet.TabletGetXSize = 0) then
    result := 18000
  else
    result := Tablet.TabletGetXSize;
end;

function TfmDigitiserCalls.DigitiserSizeY: integer;
begin
  if (Tablet.TabletGetYSize = 0) then
    result := 12000
  else
    result := Tablet.TabletGetYSize;
end;

function TfmDigitiserCalls.DigitiserSizeXYRatio: real;
begin
  result := DigitiserSizeX / DigitiserSizeY;
end;

procedure TfmDigitiserCalls.DestroyDigitiserControl;
begin
  if (Assigned(Tablet)) then
    begin
      Tablet.DisConnect;
      FreeAndNil(Tablet);
    end;
end;

function TfmDigitiserCalls.DigitiserSizeInt: integer;
begin
  if (fmDigitiserCalls.DigitiserSizeX = 18000) and (fmDigitiserCalls.DigitiserSizeY = 12000) then
    Result := 1
  else if (fmDigitiserCalls.DigitiserSizeX = 24000) and (fmDigitiserCalls.DigitiserSizeY = 18000) then
    Result := 2
  else if (fmDigitiserCalls.DigitiserSizeX = 12000) and (fmDigitiserCalls.DigitiserSizeY = 12000) then
    Result := 3
  else
    Result := 0;
end;

procedure TfmDigitiserCalls.DigitiserSizeInfo(var DigX, DigY, DigInt: Integer;
                                              var DigRatio: real);
begin
  DigX := DigitiserSizeX;
  DigY := DigitiserSizeY;
  DigInt := DigitiserSizeInt;
  DigRatio := DigitiserSizeXYRatio;
end;

procedure TfmDigitiserCalls.StartDigitiser(Silent: boolean);
begin
  try
    Tablet.TabletOpen(0,0);
  except
    on E: Exception do
    begin
      fmDigitiser.DigitiserState := _Off;
      if Silent then
        Raise
      else
        MessageDlg(E.Message	, mtError, [mbOK]	, 0);
    end;
  end;
end;

procedure TfmDigitiserCalls.StopDigitiser;
begin
  try
    Tablet.TabletClose();
  except
    on E: Exception do MessageDlg(E.Message	, mtError, [mbOK]	, 0);
  end;
end;

end.
