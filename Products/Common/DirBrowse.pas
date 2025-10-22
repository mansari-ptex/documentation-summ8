unit DirBrowse;

interface

uses
  Controls, Forms, FileCtrl, Buttons, ExtCtrls, ComCtrls, StdCtrls,
  Classes, ToolWin, General;

type
  TfmBrowseDirectories = class(TForm)
    tbMain: TPanel;
    pnlMain: TPanel;
    dlbBrowse: TDirectoryListBox;
    pnlDrive: TPanel;
    dcbBrowse: TDriveComboBox;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    procedure dlbBrowseDblClick(Sender: TObject);
    procedure BrowseInfo(Dir: string);
    procedure FormShow(Sender: TObject);
    procedure pnlDriveResize(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmBrowseDirectories: TfmBrowseDirectories;

implementation

{$R *.DFM}

uses
  Sysutils;

procedure TfmBrowseDirectories.BrowseInfo(Dir: string);
var
  Drive: char;
  s: string;

begin
  try
    Drive := Dir[1];
    dlbBrowse.Drive := Drive;
    dlbBrowse.Directory := Dir;
  except
    //use application drive as it's the only one which definitely exists.
    s := ExtractFileDrive(ExpandFileName(Application.EXEName));
    dlbBrowse.Drive := s[1];
    dlbBrowse.Directory := s;
  end;
end;

procedure TfmBrowseDirectories.dlbBrowseDblClick(Sender: TObject);
begin
  dlbBrowse.OpenCurrent;
end;

procedure TfmBrowseDirectories.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);

  dlbBrowse.setfocus;
end;

procedure TfmBrowseDirectories.pnlDriveResize(Sender: TObject);
begin
  dcbBrowse.width := pnlDrive.width;
end;

procedure TfmBrowseDirectories.btnSaveClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmBrowseDirectories.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfmBrowseDirectories.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
