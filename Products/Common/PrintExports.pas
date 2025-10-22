unit PrintExports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, frxExportPDF, frxExportHTML, frxExportRTF, frxExportCSV,
  frxExportText, frxExportImage, frxExportXLS;


type
  TfmPrintExports = class(TForm)
    frxPDFExport1: TfrxPDFExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxRTFExport1: TfrxRTFExport;
    frxBMPExport1: TfrxBMPExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxTIFFExport1: TfrxTIFFExport;
    frxGIFExport1: TfrxGIFExport;
    frxSimpleTextExport1: TfrxSimpleTextExport;
    frxCSVExport1: TfrxCSVExport;
    frxXLSExport1: TfrxXLSExport;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPrintExports: TfmPrintExports;

implementation

{$R *.dfm}

end.
