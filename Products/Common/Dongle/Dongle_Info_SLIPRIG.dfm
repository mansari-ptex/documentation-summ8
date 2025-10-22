inherited fmDongleInformationSlipRig: TfmDongleInformationSlipRig
  ClientHeight = 180
  ExplicitHeight = 208
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBackground: TPanel
    Height = 180
    inherited imgDongle: TImage
      Height = 180
    end
    inherited pnlInfo: TPanel
      Height = 180
      object lblMachineIDTitle: TLabel
        Left = 5
        Top = 160
        Width = 55
        Height = 13
        Caption = 'Machine ID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblVersion: TLabel
        Left = 150
        Top = 140
        Width = 9
        Height = 13
        Caption = '---'
      end
      object lblMachineID: TLabel
        Left = 150
        Top = 160
        Width = 9
        Height = 13
        Caption = '---'
      end
      object lblVersionTitle: TLabel
        Left = 5
        Top = 140
        Width = 35
        Height = 13
        Caption = 'Version'
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
