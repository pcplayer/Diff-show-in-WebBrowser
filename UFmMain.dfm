object FmMain: TFmMain
  Left = 0
  Top = 0
  Caption = #23558#20004#27573#25991#26412#30340#23545#27604#32467#26524#26174#31034#21040' WebBrowser '#37324#38754
  ClientHeight = 682
  ClientWidth = 1002
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 294
    Width = 1002
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 24
    ExplicitTop = 361
    ExplicitWidth = 891
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1002
    Height = 49
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 40
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 49
    Width = 1002
    Height = 245
    Align = alTop
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 449
      Top = 1
      Height = 243
      ExplicitLeft = 520
      ExplicitTop = 96
      ExplicitHeight = 100
    end
    object Panel6: TPanel
      Left = 1
      Top = 1
      Width = 448
      Height = 243
      Align = alLeft
      TabOrder = 0
      object Memo1: TMemo
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 440
        Height = 235
        Align = alClient
        Lines.Strings = (
          'Memo1')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object Panel7: TPanel
      Left = 452
      Top = 1
      Width = 549
      Height = 243
      Align = alClient
      TabOrder = 1
      object Memo2: TMemo
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 541
        Height = 235
        Align = alClient
        Lines.Strings = (
          'Memo2')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 297
    Width = 1002
    Height = 385
    Align = alClient
    TabOrder = 2
    object Splitter3: TSplitter
      Left = 446
      Top = 1
      Height = 383
      ExplicitLeft = 560
      ExplicitTop = 128
      ExplicitHeight = 100
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 445
      Height = 383
      Align = alLeft
      TabOrder = 0
      object WebBrowser1: TWebBrowser
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 437
        Height = 375
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 200
        ExplicitTop = 184
        ExplicitWidth = 300
        ExplicitHeight = 150
        ControlData = {
          4C0000002A2D0000C22600000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object Panel5: TPanel
      Left = 449
      Top = 1
      Width = 552
      Height = 383
      Align = alClient
      TabOrder = 1
      object WebBrowser2: TWebBrowser
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 544
        Height = 375
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 248
        ExplicitTop = 184
        ExplicitWidth = 300
        ExplicitHeight = 150
        ControlData = {
          4C00000039380000C22600000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
end
