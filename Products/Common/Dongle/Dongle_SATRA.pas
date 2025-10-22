unit Dongle_SATRA;

interface

uses
  Dongle_Base;

type
  TSATRADongle = class(TDongle)
    private
      function GetCustomerName: string;
    protected
      procedure InitialiseType; override;
    public
      property CustomerName: string read GetCustomerName;
  end;

implementation



{ TSATRADongle}



function TSATRADongle.GetCustomerName: string;
begin
  Result := ArrayToString(FData, 0, Length(FData) - 1);
end;


procedure TSATRADongle.InitialiseType;
begin
  //Do not inherit - overrides

  FProductCodeRequired := 'SATRA';
  FExpiryDateNeeded := True;
  FDataTotalLength := 20;
end;


end.
