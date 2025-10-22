unit CompareOldNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridPlus, Vcl.DBGrids;

type
  TfmCompareOldNew = class(TForm)
    DBGrid1: TDBGridPlus;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCompareOldNew: TfmCompareOldNew;

implementation

uses
  VisualiserMain;

{$R *.dfm}

end.
