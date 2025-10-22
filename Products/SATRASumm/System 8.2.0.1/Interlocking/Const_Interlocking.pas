unit Const_Interlocking;

interface

const
//  PATTERNRES = 20;                         //50ths of an inch
  PATTERNRES = 10;                           //100ths of an inch
//We have currently settled on a resolution accurate to 100th of an inch.  We changed from a 50th because a 50th is about
//half a millimetre.  Half a millimetre is a poor level of accuracy to use when expanding patterns to give a cutgap.
//E.g.  A cut gap of 3 mm requires a pattern expansion of 1.5mm.  If we are only accurate to half a mm this means 1.5mm can
//only be represented by 3 units. Therefore any rounding runs the risk of rounding down to 1mm or up to 2mm meaning that
//the cutgap could end up being 2mm, 3mm or 4mm.

//Note: Since PATTERNRES became 10, in interlocking we now only check every other line.

  ROLLLENGTH_FT = 82.02;                     //25m Roll Length
  ROLL_LENGTH_WIDTH_RATIO = 2;

  UNDEFINED = -1000000000;
  RADIUSPOINTSDIST = 50;

  PAGE_EDGE_WIDTH = 10;
  SHAPE_EDGE_WIDTH = 6;

  AUTO_OVERWRITE_OFF = 0;
  AUTO_OVERWRITE_NO = 1;
  AUTO_OVERWRITE_YES = 2;

var
  KnifePreview: Boolean;

implementation

end.
