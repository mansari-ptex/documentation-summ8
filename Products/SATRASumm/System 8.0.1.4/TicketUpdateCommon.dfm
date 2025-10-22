object dmTicketUpdateCommon: TdmTicketUpdateCommon
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 353
  Width = 680
  object qUpdateTickets: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    Left = 25
    Top = 14
  end
  object qClearBothTables: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    Left = 115
    Top = 13
  end
end
