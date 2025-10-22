unit SummsVars;

interface

uses Graphics;

var
  Option_Leather: Boolean;                       //1
  Option_FullSynthetics: Boolean;                //2
  Option_LegacySynthetics: Boolean;              //4
  Option_Synthetics: Boolean;                    //   True if either of above 2 set
  Option_ProductionSystem: Boolean;              //8  As opposed to Costings Only
  Option_CuttingTimes: boolean;                  //16
  Option_CadFiles: boolean;                      //32
  Option_TicketsIn: boolean;                     //64
  Option_TicketsOut: boolean;                    //128
  Option_TicketAudit: boolean;                   //256
  Option_TicketUpdating: boolean;                //512
  Option_SinglesAllowed: boolean;                //1024
  Option_OverrideReleasedVersion: boolean;       //2048
  Option_AllConstructionAllowancesOut: Boolean;  //4096
  Force_FullSynthetics: boolean;
  Force_LegacySynthetics: boolean;

  LayplanIniName: string;

  LinesInLeatherGridForTicketSequence, RowsInLeatherGridForTicketSequence: integer;
  DifficultLeatherFacility: boolean;
  ThisTicketMadeInPairs: boolean;
  LastPartSizeRange, LastPartWidthRange: string;
  ImportPieceName, KnifeFileName, KnifeMeasuredSize, KnifeSizeScale, NextSetSize: string;
  SimpleDrawing, SimpleDrawingPrintoutsOnly: Boolean;
  PairsWord: string;

const
  clHide = clLtGray;
  clCut = clNavy;
  clInterlock = clWhite;
  clGhost = clWhite;

implementation

end.
