unit SummsThreads;

interface

uses
  Classes, KnifeSetDetails, AllTickets, TicketsGroupCreate, PartDetails, MaterialDetails, PartAllowance,
  Analyse, CmnVars, SummsVars;

type
  KnifePictureThread = class(TThread)
  private
    { Private declarations }
    fmKnifeSetDetails : TfmKnifeSetDetails;
  protected
    procedure Execute; override;
  public
    procedure PassDetails(KnifeForm : TfmKnifeSetDetails);
  end;

  TicketsGroupCreateThread = class(TThread)
  private
    { Private declarations }
    fmAllTickets: TfmAllTickets;
  protected
    procedure Execute; override;
  public
    procedure PassDetails(AllTicketsForm: TfmAllTickets);
  end;

  PartMaterialDescriptionThread = class(TThread)
  private
    { Private declarations }
    fmPartDetails : TfmPartDetails;
  protected
    procedure Execute; override;
  public
    procedure PassDetails(PartForm : TfmPartDetails);
  end;

  MaterialTablesOpenThread = class(TThread)
  private
    { Private declarations }
    fmMaterialDetails : TfmMaterialDetails;
  protected
    procedure Execute; override;
  public
    procedure PassDetails(MaterialForm : TfmMaterialDetails);
  end;

  PartAllowanceThread = class(TThread)
  private
    { Private declarations }
    fmPartAllowance : TfmPartAllowance;
  protected
    procedure Execute; override;
  public
    procedure PassDetails(PartAllowanceForm : TfmPartAllowance);
  end;

  AnalysisThread = class(TThread)
  private
    { Private declarations }
    fmAnalyse: TfmAnalyse;
  protected
    procedure Execute; override;
  public
    procedure PassDetails(AnalyseForm : TfmAnalyse);
  end;

implementation

procedure KnifePictureThread.Execute;
begin
  try
    Synchronize(fmKnifeSetDetails.ViewPattern);
  except
    fmKnifeSetDetails.SecondProcessInUse := False;
    fmKnifeSetDetails.Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure KnifePictureThread.PassDetails(KnifeForm : TfmKnifeSetDetails);
begin
  fmKnifeSetDetails := KnifeForm;
end;

procedure TicketsGroupCreateThread.Execute;
begin
  try
    Synchronize(fmAllTickets.RunGroup);
  except
    fmAllTickets.SecondProcessInUse := False;
    fmAllTickets.Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure TicketsGroupCreateThread.PassDetails(AllTicketsForm: TfmAllTickets);
begin
  fmAllTickets := AllTicketsForm;
end;

procedure PartMaterialDescriptionThread.Execute;
begin
  try
    Synchronize(fmPartDetails.PartMaterialDescription);
  except
    fmPartDetails.SecondProcessInUse := False;
    fmPartDetails.Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure PartMaterialDescriptionThread.PassDetails(PartForm : TfmPartDetails);
begin
  fmPartDetails := PartForm;
end;

procedure MaterialTablesOpenThread.Execute;
begin
  try
    fmMaterialDetails.tblMatSupl.open;   //Used to be Synchronize(..) before conversion to FireDac
    Synchronize(fmMaterialDetails.UpdateSuppliersCopy);
  except
    fmMaterialDetails.SecondProcessInUse := False;
    fmMaterialDetails.Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure MaterialTablesOpenThread.PassDetails(MaterialForm : TfmMaterialDetails);
begin
  fmMaterialDetails := MaterialForm;
end;

procedure PartAllowanceThread.Execute;
begin
  try
    Synchronize(fmPartAllowance.CuttingQueries);
  except
    fmPartAllowance.SecondProcessInUse := False;
    fmPartAllowance.Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure PartAllowanceThread.PassDetails(PartAllowanceForm : TfmPartAllowance);
begin
  fmPartAllowance := PartAllowanceForm;
end;

procedure AnalysisThread.Execute;
begin
  try
    fmAnalyse.qCutterLocations.open;   //Used to be Synchronize(..) before conversion to FireDac
    fmAnalyse.qMaterialTypes.open;   //Used to be Synchronize(..) before conversion to FireDac
  except
    fmAnalyse.SecondProcessInUse := False;
    fmAnalyse.Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure AnalysisThread.PassDetails(AnalyseForm : TfmAnalyse);
begin
  fmAnalyse := AnalyseForm;
end;

end.
