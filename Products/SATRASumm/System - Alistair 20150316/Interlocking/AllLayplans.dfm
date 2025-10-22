object fmAllLayplans: TfmAllLayplans
  Left = 374
  Top = 225
  Caption = 'Layplans for Pattern'
  ClientHeight = 368
  ClientWidth = 421
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
  object dbgLayPlans: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 415
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
    OnDblClick = dbgLayPlansDblClick
    OnKeyPress = dbgLayPlansKeyPress
    Columns = <
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
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MaterialCodeRestrictive'
        Title.Caption = 'Material Code Restrictive'
        Width = 150
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'SelectedYesNo'
        Title.Alignment = taCenter
        Title.Caption = 'Selected'
        Width = 50
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
      
        'WHERE (KnifeCode = :KnifeCode) AND (KnifeSizeScale = :KnifeScale' +
        ') AND (KnifeSize = :KnifeSize)'
      
        'Order By MaterialLength, MaterialLength, MaterialWidth, Material' +
        'Cutgap, MaterialCodeRestrictive')
    Left = 143
    Top = 175
    ParamData = <
      item
        Name = 'KnifeCode'
        ParamType = ptInput
      end
      item
        Name = 'KnifeScale'
        ParamType = ptInput
      end
      item
        Name = 'KnifeSize'
        ParamType = ptInput
      end>
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
    object qLayplansSelectedYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'SelectedYesNo'
      Calculated = True
    end
  end
end
