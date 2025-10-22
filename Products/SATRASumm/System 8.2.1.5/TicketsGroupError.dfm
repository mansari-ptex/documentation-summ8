object fmTicketsGroupError: TfmTicketsGroupError
  Left = 343
  Top = 247
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  Caption = 'Group Ticket Errors'
  ClientHeight = 276
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sgOtherErrors: TXStringGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 473
    Height = 270
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    ColCount = 1
    DefaultColWidth = 120
    DefaultRowHeight = 17
    DrawingStyle = gdsClassic
    FixedCols = 0
    RowCount = 15
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 0
    FixedLineColor = clBlack
    Columns = <
      item
        HeaderColor = clLime
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clFuchsia
        HeaderFont.Height = -11
        HeaderFont.Name = 'MS Sans Serif'
        HeaderFont.Style = []
        Color = clAqua
        Width = 454
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        EditorInheritsCellProps = False
      end>
    MultiLine = False
    ImmediateEditMode = False
    ColWidths = (
      454)
  end
end
