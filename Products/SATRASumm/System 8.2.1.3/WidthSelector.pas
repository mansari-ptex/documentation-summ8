unit WidthSelector;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfmWidthSelector = class(TForm)
    lblWidth: TLabel;
    cbWidth: TComboBox;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddWidth(No: SmallInt; Name: string);
    function WidthNo: SmallInt;
  end;

implementation

{$R *.dfm}



{ TfmWidthSelector }



procedure TfmWidthSelector.AddWidth(No: SmallInt; Name: string);
begin
  cbWidth.Items.AddObject(Name, TObject(No));
  cbWidth.ItemIndex := 0;
end;


procedure TfmWidthSelector.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function TfmWidthSelector.WidthNo: SmallInt;
begin
  Result := Integer(cbWidth.Items.Objects[cbWidth.ItemIndex]);
end;


end.
