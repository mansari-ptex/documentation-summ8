unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.DB, FireDAC.Comp.Client, FDConnectionPlus,
  FireDAC.Comp.DataSet, FDTablePlus, FireDAC.Phys.ADS, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Vcl.ExtCtrls, adscnnct, adsdata, adsfunc, adstable;

type
  TTableType = (ttFireDac, ttAds);

  TForm4 = class(TForm)
    dsConPartsTable: TDataSource;
    dsConstructions: TDataSource;
    tblConstructions: TFDTablePlus;
    tblConstructionsConstruction: TStringField;
    tblConstructionsSizeScale: TStringField;
    tblConstructionsSizeRange: TStringField;
    tblConstructionsSampleSize: TStringField;
    tblConstructionsCostedSize: TStringField;
    tblConstructionsDescription: TStringField;
    tblConstructionsMadeInPairs: TBooleanField;
    tblConstructionsMadeInPairsYesNo: TStringField;
    LocalConnectionSumms: TFDConnectionPlus;
    tblParts: TFDTablePlus;
    dsParts: TDataSource;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    tblAdsParts: TAdsTable;
    LocalAdsConnectionSumms: TAdsConnection;
    dsAdsParts: TDataSource;
    dsAdsConstructions: TDataSource;
    tblAdsConstructions: TAdsTable;
    dsAdsConParts: TDataSource;
    tblAdsConParts: TAdsTable;
    tblAdsConstructionsConstruction: TAdsStringField;
    tblAdsConstructionsDescription: TAdsStringField;
    tblAdsConstructionsSizeScale: TAdsStringField;
    tblAdsConstructionsSizeRange: TAdsStringField;
    tblAdsConstructionsSampleSize: TAdsStringField;
    tblAdsConstructionsCostedSize: TAdsStringField;
    tblAdsConstructionsMadeInPairs: TBooleanField;
    tblAdsConPartsConstruction: TAdsStringField;
    tblAdsConPartsPart: TAdsStringField;
    tblAdsConPartsID: TIntegerField;
    tblAdsConPartsAltMaterial: TAdsStringField;
    tblAdsConPartsUse: TBooleanField;
    tblAdsConPartsPartDescription: TAdsStringField;
    pnlFireDac: TPanel;
    lbFireDac: TListBox;
    pnlFireDacButtons: TPanel;
    btnRefreshConstructions: TButton;
    btnParts: TButton;
    btnConnect: TButton;
    btnConstructions: TButton;
    btnConPartsTable: TButton;
    pnlFireDacGrids: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    pnlAds: TPanel;
    lbAds: TListBox;
    pnlAdButtons: TPanel;
    btnAdsConnect: TButton;
    tbnAdsDisconnect: TButton;
    btnAdsParts: TButton;
    btnAdsConstructions: TButton;
    btnAdsConParts: TButton;
    btnRefreshAdsConParts: TButton;
    pnlAdGrids: TPanel;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    btnRefreshConPartsQuery: TButton;
    btnRefreshAdsConstructions: TButton;
    tblAdsConPartsPartSizeScale: TStringField;
    tblAdsConPartsPartSizeRange: TStringField;
    tblAdsConPartsPartSampleSize: TStringField;
    tblAdsConPartsPartCostedSize: TStringField;
    tblAdsConPartsPartMadeInPairs: TStringField;
    qParts: TFDQuery;
    tblPartsCode: TStringField;
    tblPartsDescription: TStringField;
    tblPartsSizeScale: TStringField;
    tblPartsSizeRange: TStringField;
    tblPartsCostedSize: TStringField;
    tblPartsSampleSize: TStringField;
    tblPartsMadeInPairs: TBooleanField;
    tblConPartsTable: TFDTablePlus;
    tblConPartsTableConstruction: TStringField;
    tblConPartsTablePart: TStringField;
    tblConPartsTableID: TIntegerField;
    tblConPartsTableAltMaterial: TStringField;
    tblConPartsTableUse: TBooleanField;
    tblConPartsTablePartDescription: TStringField;
    tblConPartsTablePartSizeScale: TStringField;
    tblConPartsTablePartSizeRange: TStringField;
    tblConPartsTablePartSampleSize: TStringField;
    tblConPartsTablePartCostedSize: TStringField;
    tblConPartsTablePartMadeInPairs: TBooleanField;
    qPartsCode: TStringField;
    qPartsDescription: TStringField;
    qPartsSizeScale: TStringField;
    qPartsSizeRange: TStringField;
    qPartsCostedSize: TStringField;
    qPartsSampleSize: TStringField;
    qPartsMadeInPairs: TBooleanField;
    DBGrid7: TDBGrid;
    dsPartsQ: TDataSource;
    btnPartsQ: TButton;
    DBGrid8: TDBGrid;
    DBGrid9: TDBGrid;
    dsConPartsQuery: TDataSource;
    tblConPartsQuery: TFDTablePlus;
    StringField1: TStringField;
    StringField2: TStringField;
    IntegerField1: TIntegerField;
    StringField3: TStringField;
    BooleanField1: TBooleanField;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    dsConPartsNone: TDataSource;
    tblConPartsNone: TFDTablePlus;
    StringField15: TStringField;
    StringField16: TStringField;
    IntegerField2: TIntegerField;
    StringField17: TStringField;
    BooleanField3: TBooleanField;
    btnConPartsNone: TButton;
    btnConPartsQuery: TButton;
    btnRefreshConPartsTable: TButton;
    btnRefreshConPartsNone: TButton;
    tblConPartsNonePartDescription3: TStringField;
    tblConPartsNonePartSizeScale3: TStringField;
    tblConPartsNonePartSizeRange3: TStringField;
    tblConPartsNonePartSampleSize3: TStringField;
    tblConPartsNonePartCostedSize3: TStringField;
    tblConPartsNonePartMadeInPairs3: TStringField;
    DBGrid10: TDBGrid;
    dsConPartsNoneCalc: TDataSource;
    tblConPartsNoneCalc: TFDTablePlus;
    StringField4: TStringField;
    StringField5: TStringField;
    IntegerField3: TIntegerField;
    StringField6: TStringField;
    BooleanField2: TBooleanField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField18: TStringField;
    StringField19: TStringField;
    StringField20: TStringField;
    StringField21: TStringField;
    btnConPartsNoneCalc: TButton;
    btnRefreshConPartsNoneCalc: TButton;
    procedure btnRefreshConstructionsClick(Sender: TObject);
    procedure btnPartsClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnConstructionsClick(Sender: TObject);
    procedure btnConPartsTableClick(Sender: TObject);
    procedure btnAdsConnectClick(Sender: TObject);
    procedure btnAdsPartsClick(Sender: TObject);
    procedure btnAdsConstructionsClick(Sender: TObject);
    procedure btnAdsConPartsClick(Sender: TObject);
    procedure btnRefreshAdsConPartsClick(Sender: TObject);
    procedure tbnAdsDisconnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshConPartsQueryClick(Sender: TObject);
    procedure btnRefreshAdsConstructionsClick(Sender: TObject);
    procedure btnPartsQClick(Sender: TObject);
    procedure btnRefreshConPartsTableClick(Sender: TObject);
    procedure btnRefreshConPartsNoneClick(Sender: TObject);
    procedure btnConPartsQueryClick(Sender: TObject);
    procedure btnConPartsNoneClick(Sender: TObject);
    procedure btnConPartsNoneCalcClick(Sender: TObject);
    procedure btnRefreshConPartsNoneCalcClick(Sender: TObject);
    procedure tblConPartsNoneCalcCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    StartTime: TTime;
    procedure Start(ATask: string; ttTableType: TTableType);
    procedure Finish(ATask: string; ttTableType: TTableType);
    procedure Output(ATask: string; ttTableType: TTableType);
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}



procedure TForm4.btnAdsConstructionsClick(Sender: TObject);
const
  Task = 'Constructions open/close';

begin
  Start(Task, ttAds);
  tblAdsConstructions.Active := not tblAdsConstructions.Active;
  Finish(Task, ttAds);
end;


procedure TForm4.btnAdsPartsClick(Sender: TObject);
const
  Task = 'Parts open/close';

begin
  Start('Parts open/close', ttAds);
  tblAdsParts.Active := not tblAdsParts.Active;
  Finish('Parts open/close', ttAds);
end;


procedure TForm4.btnConnectClick(Sender: TObject);
const
  Task = 'Connection open/close';

begin
  Start(Task, ttFireDac);
  LocalConnectionSumms.Connected := not LocalConnectionSumms.Connected;
  Finish(Task, ttFireDac);
end;


procedure TForm4.btnConPartsNoneCalcClick(Sender: TObject);
const
  Task = 'ConParts with None Calc open/close';

begin
  Start(Task, ttFireDac);
  tblConPartsNoneCalc.Active := not tblConPartsNoneCalc.Active;
  Finish(Task, ttFireDac);
end;


procedure TForm4.btnConPartsNoneClick(Sender: TObject);
const
  Task = 'ConParts with None open/close';

begin
  Start(Task, ttFireDac);
  tblConPartsNone.Active := not tblConPartsNone.Active;
  Finish(Task, ttFireDac);
end;


procedure TForm4.btnConPartsQueryClick(Sender: TObject);
const
  Task = 'ConParts with Query open/close';

begin
  Start(Task, ttFireDac);
  tblConPartsQuery.Active := not tblConPartsQuery.Active;
  Finish(Task, ttFireDac);
end;


procedure TForm4.btnConPartsTableClick(Sender: TObject);
const
  Task = 'ConParts with Table open/close';

begin
  Start(Task, ttFireDac);
  tblConPartsTable.Active := not tblConPartsTable.Active;
  Finish(Task, ttFireDac);
end;


procedure TForm4.btnConstructionsClick(Sender: TObject);
const
  Task = 'Constructions open/close';

begin
  Start(Task, ttFireDac);
  tblConstructions.Active := not tblConstructions.Active;
  Finish(Task, ttFireDac);
end;


procedure TForm4.btnPartsClick(Sender: TObject);
const
  Task = 'Parts open/close';

begin
  Start(Task, ttFireDac);
  tblParts.Active := not tblParts.Active;
  Finish(Task, ttFireDac);
end;


procedure TForm4.btnPartsQClick(Sender: TObject);
const
  Task = 'Parts Query open/close';

begin
  Start(Task, ttFireDac);
  qParts.Active := not qParts.Active;
  Finish(Task, ttFireDac);
end;


procedure TForm4.btnRefreshConstructionsClick(Sender: TObject);
const
  Task = 'Refresh Constructions';

begin
  Start(Task, ttFireDac);
  tblConstructions.Refresh;
  Finish(Task, ttFireDac);
end;


procedure TForm4.btnRefreshConPartsNoneCalcClick(Sender: TObject);
const
  Task = 'Refresh ConParts with None Calc';

begin
  if tblConPartsNoneCalc.Active then
  begin
    Start(Task, ttFireDac);
    tblConPartsNoneCalc.Refresh;
    Finish(Task, ttFireDac);
  end
  else
    showmessage('Table not open');
end;


procedure TForm4.btnRefreshConPartsNoneClick(Sender: TObject);
const
  Task = 'Refresh ConParts with None';

begin
  if tblConPartsNone.Active then
  begin
    Start(Task, ttFireDac);
    tblConPartsNone.Refresh;
    Finish(Task, ttFireDac);
  end
  else
    showmessage('Table not open');
end;


procedure TForm4.btnRefreshConPartsQueryClick(Sender: TObject);
const
  Task = 'Refresh ConParts with Query';

begin
  if tblConPartsQuery.Active then
  begin
    Start(Task, ttFireDac);
    tblConPartsQuery.Refresh;
    Finish(Task, ttFireDac);
  end
  else
    showmessage('Table not open');
end;


procedure TForm4.btnRefreshConPartsTableClick(Sender: TObject);
const
  Task = 'Refresh ConParts with Table';

begin
  if tblConPartsTable.Active then
  begin
    Start(Task, ttFireDac);
    tblConPartsTable.Refresh;
    Finish(Task, ttFireDac);
  end
  else
    showmessage('Table not open');
end;


procedure TForm4.Finish(ATask: string; ttTableType: TTableType);
var
  Duration: TTime;

begin
  Duration := Now - StartTime;

  Output(ATask + ' finished ' + TimeToStr(Duration), ttTableType);
end;


procedure TForm4.FormCreate(Sender: TObject);
begin
  StartTime := 0;
end;


procedure TForm4.Output(ATask: string; ttTableType: TTableType);
var
  lb: TListBox;

begin
  case ttTableType of
    ttFireDac: lb := lbFireDac;
    ttAds: lb := lbAds;
  end;

  lb.AddItem(ATask, nil);
  lb.TopIndex := lb.Items.Count - 1;
end;


procedure TForm4.Start(ATask: string; ttTableType: TTableType);
begin
  StartTime := Now();

  Output(ATask + ' started', ttTableType);
end;


procedure TForm4.btnRefreshAdsConPartsClick(Sender: TObject);
const
  Task = 'Refresh ConParts';

begin
  Start(Task, ttAds);
  tblAdsConParts.Refresh;
  Finish(Task, ttAds);
end;


procedure TForm4.btnRefreshAdsConstructionsClick(Sender: TObject);
const
  Task = 'Refresh Constructions';

begin
  Start(Task, ttAds);
  tblAdsConstructions.Refresh;
  Finish(Task, ttAds);
end;


procedure TForm4.btnAdsConPartsClick(Sender: TObject);
const
  Task = 'ConParts open/close';

begin
  Start(Task, ttAds);
  tblAdsConParts.Active := not tblAdsConParts.Active;
  Finish(Task, ttAds);
end;


procedure TForm4.btnAdsConnectClick(Sender: TObject);
const
  Task = 'Connection open';

begin
  Start(Task, ttAds);
  LocalAdsConnectionSumms.Connect;
  Finish(Task, ttAds);
end;


procedure TForm4.tblConPartsNoneCalcCalcFields(DataSet: TDataSet);
begin
  if qParts.FindKey([tblConPartsNoneCalc.FieldByName('Part').AsString]) then
  begin
    tblConPartsNoneCalc.FieldByName('PartDescription3').AsString := qParts.FieldByName('Description').AsString;
    tblConPartsNoneCalc.FieldByName('PartSizeScale3').AsString := qParts.FieldByName('SizeScale').AsString;
    tblConPartsNoneCalc.FieldByName('PartSizeRange3').AsString := qParts.FieldByName('SizeRange').AsString;
    tblConPartsNoneCalc.FieldByName('PartSampleSize3').AsString := qParts.FieldByName('SampleSize').AsString;
    tblConPartsNoneCalc.FieldByName('PartCostedSize3').AsString := qParts.FieldByName('CostedSize').AsString;
    tblConPartsNoneCalc.FieldByName('PartMadeInPairs3').AsBoolean := qParts.FieldByName('MadeInPairs').AsBoolean;
  end
  else
    showmessage('Error');
end;


procedure TForm4.tbnAdsDisconnectClick(Sender: TObject);
const
  Task = 'Connection close';

begin
  Start(Task, ttAds);
  LocalAdsConnectionSumms.Disconnect;
  Finish(Task, ttAds);
end;


end.
