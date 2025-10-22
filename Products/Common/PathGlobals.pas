unit PathGlobals;

interface

uses
  Graphics, CmnVars;

const
  SmoothPointsPerPoint = 10;
  MaxRawPoints = 501;
  MaxSmoothPoints = ((MaxRawPoints - 1) * SmoothPointsPerPoint) + 1;

type
  TPathPointCharacteristic = (Normal, Corner, NewPath);
  TSplineType = (MakeDrawingPoints, SaveOutputFiles);
  TFeature = record
               Code, Description: string[30];
             end;
  TPathPoint = record
                  x, y: integer;                                          //x, y cordinates
                  c: TPathPointCharacteristic;                            //type of point
                  Feature: array [1..6] of TFeature;                      //3 features
                  PathType, PrevPathType: TPath;
                end;
  TSummsPoint = record
                  x, y: integer;
                end;
  TSummsPatternCollection = record
                              PatternName: string;
                              NoPoints: integer;
                              Points: array [1..MaxRawPoints] of TSummsPoint;
                            end;
var
  NoRawPts, NoSmoothPts: integer;
  RawPts: array [1..MaxRawPoints] of TPathPoint;
  SmoothPts: array [1..MaxSmoothPoints] of TPathPoint;
  SummsCollection: array [1..100] of TSummsPatternCollection;
  FileRef, PatternRef: string;
  NumberOfPatterns: integer;
  FileNeedsSaving: boolean;

implementation

end.
