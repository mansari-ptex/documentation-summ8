unit KnifeInterlock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, General;

type
  TfmKnifeOrInterlock = class(TForm)
    imgKnifeOrInterlock: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmKnifeOrInterlock: TfmKnifeOrInterlock;

implementation

{$R *.dfm}

procedure TfmKnifeOrInterlock.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmKnifeOrInterlock.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
