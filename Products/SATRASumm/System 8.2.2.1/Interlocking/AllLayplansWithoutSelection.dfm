object fmAllLayplansWithoutSelection: TfmAllLayplansWithoutSelection
  Left = 374
  Top = 225
  Caption = 'Layplans Without Selection'
  ClientHeight = 368
  ClientWidth = 595
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dbgLayplans: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 589
    Height = 362
    Align = alClient
    BorderStyle = bsNone
    Color = clAqua
    DataSource = dsLayplans
    DrawingStyle = gdsClassic
    FixedColor = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleHotTrack]
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clFuchsia
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgLayplansDblClick
    OnKeyPress = dbgLayplansKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'KnifeCode'
        Title.Caption = 'Knife'
        Width = 177
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'KnifeSize'
        Title.Caption = 'Size'
        Width = 47
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MaterialLengthInUnits'
        Title.Alignment = taCenter
        Title.Caption = 'Length'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MaterialWidthInUnits'
        Title.Alignment = taCenter
        Title.Caption = 'Width'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MaterialCutGap'
        Title.Alignment = taCenter
        Title.Caption = 'Cut Gap'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MaterialCodeRestrictive'
        Title.Caption = 'Material Code Restrictive'
        Width = 150
        Visible = True
      end>
  end
  object dsLayplans: TDataSource
    DataSet = qLayplans
    Left = 154
    Top = 183
  end
  object qLayplans: TFDQueryPlus
    OnCalcFields = qLayplansCalcFields
    Connection = fmLayplan.LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT *'
      'FROM LayplanSets'
      'WHERE SelectedNo = -1'
      
        'Order By MaterialLength, MaterialLength, MaterialWidth, Material' +
        'Cutgap, MaterialCodeRestrictive')
    Left = 143
    Top = 175
    object qLayplansKnifeCode: TStringField
      FieldName = 'KnifeCode'
    end
    object qLayplansKnifeSizeScale: TStringField
      FieldName = 'KnifeSizeScale'
    end
    object qLayplansKnifeSize: TStringField
      FieldName = 'KnifeSize'
      Size = 10
    end
    object qLayplansSelectedNo: TIntegerField
      FieldName = 'SelectedNo'
    end
    object qLayplansMaterialLength: TIntegerField
      FieldName = 'MaterialLength'
    end
    object qLayplansMaterialWidth: TIntegerField
      FieldName = 'MaterialWidth'
    end
    object qLayplansMaterialCutGap: TIntegerField
      FieldName = 'MaterialCutGap'
    end
    object qLayplansMaterialCodeRestrictive: TStringField
      FieldName = 'MaterialCodeRestrictive'
    end
    object qLayplansMaterialLengthInUnits: TFloatField
      FieldKind = fkCalculated
      FieldName = 'MaterialLengthInUnits'
      DisplayFormat = '0.00'
      EditFormat = '0.00'
      Calculated = True
    end
    object qLayplansMaterialWidthInUnits: TFloatField
      FieldKind = fkCalculated
      FieldName = 'MaterialWidthInUnits'
      DisplayFormat = '0.00'
      EditFormat = '0.00'
      Calculated = True
    end
    object qLayplansMaterialEdge: TIntegerField
      FieldName = 'MaterialEdge'
    end
    object qLayplansKnifeAngle: TFloatField
      FieldName = 'KnifeAngle'
    end
  end
end
