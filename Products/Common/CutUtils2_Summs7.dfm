object dmCutUtils2_Summs7: TdmCutUtils2_Summs7
  OldCreateOrder = False
  Height = 480
  Width = 696
  object qAddCuttingElement: TFDQuery
    Left = 66
    Top = 24
  end
  object qRemoveCuttingElements: TFDQuery
    SQL.Strings = (
      'DELETE FROM Elements4CuttingValues'
      'WHERE Value = :ValName')
    Left = 63
    Top = 81
    ParamData = <
      item
        Name = 'ValName'
      end>
  end
  object qAdditionalCuttingElements: TFDQuery
    SQL.Strings = (
      
        'INSERT INTO Elements4CuttingValues (Value, Seq, Element, Categor' +
        'y, Adjustment, Quantity)'
      'SELECT Value, 100 + Seq, Element, '#39'A'#39', 0.0, Quantity'
      'FROM Elements4Values'
      'WHERE Value = :ValName')
    Left = 70
    Top = 153
    ParamData = <
      item
        Name = 'ValName'
      end>
  end
  object qReIndexCuttingElements: TFDQuery
    Left = 68
    Top = 225
  end
end
