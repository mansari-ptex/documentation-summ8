unit rp_Layplan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, QuickRpt, QRCtrls;

type
  TfmrpLayPlan = class(TForm)
    qrLayPlan: TQuickRep;
    qrbTitle: TQRBand;
    QRSysData1: TQRSysData;
    qrbGeneral: TQRBand;
    qrlblKnifeText: TQRLabel;
    qrlblMaterialLengthText: TQRLabel;
    qrlblCutGapText: TQRLabel;
    qrlblRemAreaText: TQRLabel;
    qrlblUtilisationText: TQRLabel;
    qrlblMaterialWidthText: TQRLabel;
    qrlblCutGap: TQRLabel;
    qrlblMaterialLength: TQRLabel;
    qrlblKnife: TQRLabel;
    qrlblUtilisation: TQRLabel;
    qrlblRemArea: TQRLabel;
    qrlblMaterialWidth: TQRLabel;
    mPieces: TQRLabel;
    qrlblPieces: TQRLabel;
    qrbAverage: TQRBand;
    qrimgLayPlan: TQRImage;
    qrlblDescription: TQRLabel;
    qrlblLayPlanCode: TQRLabel;
    qrimgKnifeW1: TQRImage;
    qrimgKnifeW2: TQRImage;
    qrlblAngleMessage: TQRLabel;
    qrlblSelvedgeText: TQRLabel;
    qrlblEdge: TQRLabel;
    qrlblKnifeSizeText: TQRLabel;
    qrlblKnifeSize: TQRLabel;
    qrlblRestrictiveMaterialText: TQRLabel;
    qrlblRestrictiveMaterial: TQRLabel;
    qrlblKnifeAreaText: TQRLabel;
    qrlblKnifeAreaUnits: TQRLabel;
    qrlblKnifeAreaSubUnits: TQRLabel;
    qrlblAreaSubUnits: TQRLabel;
    qrlblAreaUnits: TQRLabel;
    qrlblExplanation: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmrpLayPlan: TfmrpLayPlan;

implementation

{$R *.dfm}

end.
