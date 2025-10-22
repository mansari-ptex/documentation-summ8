unit Dongle_SLIPRIG;

interface

uses
  Dongle_Base;

type
  TSlipRigDongle = class(TDongle)
    private
      function GetVersion: string;
      function GetMachineID: string;
      procedure SetMachineID(const Value: string);
    protected
      procedure InitialiseType; override;
    public
      property Version: string read GetVersion;
      property MachineID: string read GetMachineID write SetMachineID;
  end;

implementation



{ TSlipRigDongle }



function TSlipRigDongle.GetMachineID: string;
begin
  Result := ArrayToString(FData, 11, 40);
end;


function TSlipRigDongle.GetVersion: string;
begin
  Result := ArrayToString(FData, 0, 10);
end;


procedure TSlipRigDongle.InitialiseType;
begin
  //Do not inherit - overrides

  FProductCodeRequired := 'SLIPRIG';
  FExpiryDateNeeded := False;
  FDataTotalLength := 48;
end;


procedure TSlipRigDongle.SetMachineID(const Value: string);
var
  sMachineID: string;

begin
  sMachineID := Value + StringOfChar(' ', 30 - Length(Value));

  CheckAndWriteData(11, 30, sMachineID);
end;


end.
