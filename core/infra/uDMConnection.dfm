object dmConnection: TdmConnection
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDConnection: TFDConnection
    Left = 40
    Top = 8
  end
  object FDTransaction: TFDTransaction
    Connection = FDConnection
    Left = 136
    Top = 8
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 240
    Top = 8
  end
end
