object dmCutUtils2_Summs8: TdmCutUtils2_Summs8
  OldCreateOrder = False
  Height = 480
  Width = 696
  object qAddCuttingElement: TFDQuery
    Left = 66
    Top = 24
  end
  object qRemoveCuttingElements: TFDQuery
    SQL.Strings = (
      'DELETE FROM Elements4Operations'
      'WHERE (Operation = :OpName)')
    Left = 63
    Top = 81
    ParamData = <
      item
        Name = 'OpName'
      end>
  end
  object qAdditionalCuttingElements: TFDQuery
    SQL.Strings = (
      
        'INSERT INTO Elements4Operations (Operation, Seq, Element, Quanti' +
        'ty, Every, PerBatch)'
      'SELECT Operation, 100 + Seq, Element, Quantity, Every, PerBatch'
      'FROM CuttingAdditionalElements4Operations'
      'WHERE Operation = :OpName')
    Left = 70
    Top = 153
    ParamData = <
      item
        Name = 'OpName'
      end>
  end
  object qReIndexCuttingElements: TFDQuery
    Left = 68
    Top = 225
  end
end
