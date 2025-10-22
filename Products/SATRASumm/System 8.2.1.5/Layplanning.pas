//Interface unit to separate Layplanning project
unit Layplanning;

interface

uses
  Classes, Forms, LayMain;

type
  TfmLayplanAsChild = class(TfmLayplan)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
  published
  end;
  TfmLayplanAsChildViewer = class(TfmLayplan)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
  published
  end;
  TfmLayplanAsBulkLayplanner = class(TfmLayplan)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
  published
  end;

implementation

constructor TfmLayplanAsChild.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormStyle := fsMDIChild;
  Position := poMainFormCenter;
end;

constructor TfmLayplanAsChildViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormStyle := fsMDIChild;

  BorderIcons := [];
  Height := 578;
  Width := 540;
  Position := poMainFormCenter;
  tbMain.Visible := False;
  pnlLeft.Visible := False;
  Tag := 1;
end;

constructor TfmLayplanAsBulkLayplanner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormStyle := fsMDIChild;
  Position := poMainFormCenter;

  SendToBack;
  BorderIcons := [];
  Tag := 2;
end;

end.
