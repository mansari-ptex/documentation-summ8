unit OutOfMemory;

//Used to be just for for Out of Memory errors hence name.
//Now other causes may generate this error window.

interface

uses
  Classes, Controls, Forms, StdCtrls, ExtCtrls
{$IFDEF VSTITCH}
  ,TranSys, Data
{$ENDIF}
  ;

type
  TfmMemoryError = class(TForm)
    pnlMain: TPanel;
    lblError: TLabel;
    lblIntro: TLabel;
    lblNote1: TLabel;
    lblNote3: TLabel;
    lblIntro2: TLabel;
    lblNote2: TLabel;
    procedure FormDeactivate(Sender: TObject);
    procedure TidyUp(Me : TComponent);
    procedure ShowError(Me : TComponent);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FirstTime: Boolean;
  public
    { Public declarations }
  end;

var
  fmMemoryError: TfmMemoryError;

implementation

{$R *.DFM}

procedure TfmMemoryError.FormDeactivate(Sender: TObject);
begin
  if fmMemoryError.visible then
    fmMemoryError.setfocus;
end;

procedure TfmMemoryError.TidyUp(Me : TComponent);
var
   s: string;
   MyOwner: TComponent;

begin
  s := 'could not complete this action.';

  {$IFDEF VSTITCH}
  s := TranslateString(dm.tblGeneralLanguage.value, dm.tblTranslation, s);
  {$ENDIF}

  lblError.caption := application.title + ' ' + s;

  MyOwner := Me.Owner;
  while (MyOwner <> application.MainForm) and (MyOwner <> nil) do
  begin
    Me := MyOwner;
    MyOwner := MyOwner.owner;
  end;

  if (Me <> application.MainForm) and (Me.name <> '') then
    if (Me is TForm) then  //always will be a TForm but to be sure...
      (Me as TForm).close;

  fmMemoryError.visible := true;
  fmMemoryError.setFocus;
end;

procedure TfmMemoryError.ShowError(Me : TComponent);
var
  s: string;

begin
  s := 'could not complete this action.';

  {$IFDEF VSTITCH}
  s := TranslateString(dm.tblGeneralLanguage.value, dm.tblTranslation, s);
  {$ENDIF}

  lblError.caption := application.title + ' ' + s;

  fmMemoryError.visible := true;
  fmMemoryError.setFocus;
end;

procedure TfmMemoryError.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  if FirstTime then
  begin
    fmMemoryError.top := -1000;
    FirstTime := false;
  end
  else
  begin
    screen.cursor := crDefault;
//    fmMemoryError.left := (Screen.Width div 2) - (fmMemoryError.Width div 2);
//    fmMemoryError.top := (Screen.Height div 2) - (fmMemoryError.Height div 2);

    Form := Application.MainForm;

    fmMemoryError.Left := Form.Left + (Form.Width div 2) - (fmMemoryError.Width div 2);
    fmMemoryError.Top := Form.Top + (Form.Height div 2) - (fmMemoryError.Height div 2);
    fmMemoryError.setFocus;
  end;
end;

procedure TfmMemoryError.FormCreate(Sender: TObject);
begin
  FirstTime := true;
end;

end.
