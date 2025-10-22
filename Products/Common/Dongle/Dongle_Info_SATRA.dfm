inherited fmDongleInformationSATRA: TfmDongleInformationSATRA
  ClientHeight = 161
  ExplicitHeight = 189
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBackground: TPanel
    Height = 161
    inherited imgDongle: TImage
      Height = 161
    end
    inherited pnlInfo: TPanel
      Height = 161
      object lblCustomerName: TLabel
        Left = 150
        Top = 140
        Width = 9
        Height = 13
        Caption = '---'
      end
      object lblCustomerNameTitle: TLabel
        Left = 5
        Top = 140
        Width = 75
        Height = 13
        Caption = 'Customer Name'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
  end
end
