object fmCompareOldNew: TfmCompareOldNew
  Left = 435
  Top = 8
  Caption = 'Compare Old and New Interlock Areas'
  ClientHeight = 726
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGridPlus
    Left = 0
    Top = 0
    Width = 405
    Height = 726
    Align = alClient
    DataSource = fmCaller.dsKnives
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Code'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MeasuredSize'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'OldInterlockArea'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NewInterlockArea'
        Visible = True
      end>
  end
end
