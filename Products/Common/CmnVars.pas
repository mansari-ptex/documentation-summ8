unit CmnVars;

interface

uses
  Forms, Graphics;

type
  TPath = (curve, curve1, curve2, curve3, curve4, curve5);
  TDragType = (dragKnife, dragSizeRelationship, dragPart, dragMaterial, dragSupplier, dragConstruction,
              //TimeLine
               dragMotion, dragElement, dragOperation, dragDepartment);
  TDragSort = (dragInsert, dragAppend, dragEdit);

  TLockedBy = record
    Locked: Boolean;
    User: string;
    Computer: string;
    Address: string;
  end;

var
  DragType: TDragType;
  DragSort: TDragSort;
  DragCode: string;
  Identifier: string;
  MultipleCopies, FullLockingInfo: Boolean;
  LegacySortLocale: Boolean;
  HasClosed: Boolean;
  ProductCode: string;
  SerialNumber: longint;
  Feature: longword;
  SystemName: string;
  SystemAbbrev: string;
  SystemAlias: string;
  SystemIniName: string;
  SystemPassword: AnsiString;
  SystemUserName: string;
  MasterPassword: string;
  ForceRedraw: boolean;
  MadeInPairsDefault: Boolean;
  SearchStyleDescriptionDefault: Boolean;
  DigitiserReset: Boolean;
  BrowsesCreated: boolean = FALSE;
  clMain, clBack, clBackDark, clBackVeryDark, clBackVeryVeryDark, clText, clData,
  clData2, clEditing, clWarningRed, clWarningAmber, clValueAdded,
  clNonValueAdded, clEquals, clNotEquals,
  clCatHighlight, clCatHeaderHighlight: TColor;
  CreatingFullReport: Boolean;

const
  mrFail = 100;
  DongleBlue = 1;
  DongleGreen = 2;

implementation

end.
