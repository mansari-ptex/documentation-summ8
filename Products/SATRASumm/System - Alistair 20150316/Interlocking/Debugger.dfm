object fmDebugger: TfmDebugger
  Left = 294
  Top = 121
  Caption = 'Debugger'
  ClientHeight = 547
  ClientWidth = 928
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pcDebugger: TPageControl
    Left = 0
    Top = 0
    Width = 928
    Height = 547
    ActivePage = tsMerge
    Align = alClient
    TabOrder = 0
    object tsFilter: TTabSheet
      Caption = 'Filtering'
      ImageIndex = 23
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbFilter: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgFilter: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsPattern: TTabSheet
      Caption = 'Pattern'
      ImageIndex = 13
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Image2: TImage
        Left = 1
        Top = 0
        Width = 100
        Height = 100
        AutoSize = True
        Proportional = True
      end
      object sbPattern: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgPattern: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsInts: TTabSheet
      Caption = 'Ints'
      ImageIndex = 22
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbInts: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgInts: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsNoSpikes: TTabSheet
      Caption = 'No Spikes'
      ImageIndex = 14
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Image3: TImage
        Left = 1
        Top = 0
        Width = 100
        Height = 100
        AutoSize = True
        Proportional = True
      end
      object sbNoSpikes: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgNoSpikes: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Bisectors'
      ImageIndex = 15
      object sbBisectors: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgBisectors: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsGuidePoints: TTabSheet
      Caption = 'Guide Points'
      ImageIndex = 16
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Image4: TImage
        Left = 1
        Top = 0
        Width = 100
        Height = 100
        AutoSize = True
        Proportional = True
      end
      object sbGuidePoints: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgGuidePoints: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsParas: TTabSheet
      Caption = 'Paras'
      ImageIndex = 17
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbParas: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgParas: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsXs: TTabSheet
      Caption = 'Xs'
      ImageIndex = 18
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbXs: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgXs: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsFirstExp: TTabSheet
      Caption = 'First Exp'
      ImageIndex = 19
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbFirstExp: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgfirstExp: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsLoopFree: TTabSheet
      Caption = 'Loopless'
      ImageIndex = 20
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbLoopLessFirst: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgLooplessFirst: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsExpansion: TTabSheet
      Caption = 'Expansion'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbExpansion: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgExpansion: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsLoopsGone: TTabSheet
      Caption = 'Loops Gone'
      ImageIndex = 22
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbLoopsGone: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgLoopsGone: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsPatternsB4: TTabSheet
      Caption = 'Patterns b4 Clockwise'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbPatternsB4: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgPatternsB4: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Hull Points'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbHullPoints: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgHullPoints: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsPatternsAfter: TTabSheet
      Caption = 'Clockwise Patterns'
      ImageIndex = 9
      object sbPAtternsAfter: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgPatternsAfter: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsDistances: TTabSheet
      Caption = 'Distances'
      ImageIndex = 10
      object sbDistances: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgDistances: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsDistancesRemaining: TTabSheet
      Caption = 'Fin Dists'
      ImageIndex = 11
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbDistancesRemaining: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgDistancesRemaining: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsFinal: TTabSheet
      Caption = 'Final'
      ImageIndex = 12
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbFinal: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgFinal: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsMerge: TTabSheet
      Caption = 'Merge'
      ImageIndex = 1
      object sbMerge: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgMerge: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsPack: TTabSheet
      Caption = 'Pack'
      ImageIndex = 5
      object sbPack: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgPack: TImage
          Left = 0
          Top = 0
          Width = 916
          Height = 515
          Align = alClient
          AutoSize = True
          Proportional = True
          ExplicitWidth = 706
        end
      end
    end
    object tsDescribePattern: TTabSheet
      Caption = 'Describe Pattern'
      ImageIndex = 25
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbDescribePattern: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgDescribePattern: TImage
          Left = 0
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsDrawInterlock: TTabSheet
      Caption = 'Draw Interlock'
      ImageIndex = 24
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbDrawInterlock: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgDrawInterlock: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsEdges1: TTabSheet
      Caption = 'Edges 1'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbEdges1: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgEdges1: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsEdges2: TTabSheet
      Caption = 'Edges 2'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbEdges2: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgEdges2: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsOverlapping: TTabSheet
      Caption = 'Overlapping'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Image1: TImage
        Left = 1
        Top = 0
        Width = 100
        Height = 100
        AutoSize = True
        Proportional = True
      end
      object sbOverlapping: TScrollBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        TabOrder = 0
        object imgOverlapping: TImage
          Left = 1
          Top = 0
          Width = 100
          Height = 100
          AutoSize = True
          Proportional = True
        end
      end
    end
    object tsErrors: TTabSheet
      Caption = 'Errors'
      ImageIndex = 3
      object lbErrors: TListBox
        Left = 0
        Top = 0
        Width = 920
        Height = 519
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
  end
end
