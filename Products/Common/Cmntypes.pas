unit CmnTypes;

interface

uses FireDAC.Comp.Client;

type
  RealArray = array of real;
  StringArray = array of string;

  TComponentConnection = record
    Name: string;
    Connections: Array of TFDCustomConnection;
  end;

  TimeBreakdown = record
    Time1: real;
    Time2: real;
    Time3: real;
    Time4: real;
    Time5: real;
    Total: real;
  end;
  TKey = record
    Code : integer;
    Feature : longword;
  end;

  TMaterial = set of 'A'..'Z';

  TTicketIntsRec = record
                     AdjInterlocks: RealArray;
                     Part: string;
                     WidthNo: integer;
                     Sizes: real;
                   end;

  TTicketInts = array of TTicketIntsRec;

const
  Leathers: TMaterial = ['K','L','W'];
  Synthetics: TMaterial = ['R','S'];

implementation

end.
