unit ExternalIn;

interface

uses
  Classes, Controls, Forms, Db,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, XStringGrid, XStringGridPlus, DBGridPlus,
   Grids, SummsVars, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, Vcl.DBGrids, FDConnectionPlus;

type
  TfmExternalIn = class(TForm)
    dbgErrors: TDBGridPlus;
    dsspExternalIn: TDataSource;
    LocalConnectionSumms: TFDConnectionPlus;
    spExternalIn: TFDStoredProc;
    mtblOutput: TFDMemTable;
    dsOutput: TDataSource;
    procedure ImportExternal(ExtFileName: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmExternalIn: TfmExternalIn;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs,
  AdvErrorHandler, ExternalInDM;

{$R *.DFM}

procedure TfmExternalIn.ImportExternal(ExtFileName: string);
var
  i: integer;
  f: TextFile;
  FileLine: String;
  InList, OutList: TStringList;
  CurFileName, NewFileName: PChar;
  tblOutput: TFDMemTable;

begin
  screen.cursor := crHourGlass;
  fmExternalIn.Refresh;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  try
//    spExternalIn.Close;
    InList := TStringList.Create;
    OutList := TStringList.Create;

    CurFileName := PChar(ExtFilename);
    NewFileName := PChar(CurFilename + '.BAK');
    CopyFile(CurFilename, NewFilename, False);

    InList.LoadFromFile(ExtFilename);
    //CJY ExternalIn has a var TStringList input that it ammends.
    OutList.Assign(InList);

    if OutList.Count > 0 then
    begin
      mtblOutput := ExternalInDM1.ExternalIn(OutList);
      mtblOutput.RecNo := 1;
      mtblOutput.Prior;

      if mtblOutput.RecordCount = 0 then
      begin
        MessageDlgPos('External Tickets Loaded', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
        Close;
        if fmSumms.mmDeleteExternalInAfterRead.Checked then
          DeleteFile(ExtFileName);

        DeleteFile(ExtFileName + '.BAK');
      end
      else
      begin
        if OutList.Count = InList.Count then
          DeleteFile(ExtFileName + '.BAK')
        else
        begin
          OutList.SaveToFile(ExtFilename, TEncoding.ANSI);
        end;
        fmErrorHandler.DebugMessageDlg('Errors - External Tickets not Loaded', 'No additional information', '');
        dsOutput.DataSet := mtblOutput;
        fmExternalIn.showModal;
      end;
    end
    else
    begin
      fmErrorHandler.DebugMessageDlg('Errors - External Tickets file is empty', 'No additional information', '');
    end;

{
    spExternalIn.FetchOptions.Items := spExternalIn.FetchOptions.Items - [fiMeta];
    spExternalIn.Command.FillParams(spExternalIn.Params);
    spExternalIn.Prepare;
    spExternalIn.ParamByName('InFile').Assign(InList);
    spExternalIn.Open;
}

    //CJY: spExternalIn.FetchOptions.RecordCountMode set to cmTotal

    InList.Free;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Errors - External Tickets not Loaded', E.Message, '');
      fmExternalIn.showModal;
    end;
  end;
  LocalConnectionSumms.Connected := False;

  screen.cursor := crDefault;
end;

procedure TfmExternalIn.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmExternalIn.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

procedure TfmExternalIn.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmExternalIn.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmExternalIn.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.

