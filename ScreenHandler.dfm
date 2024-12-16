object formMainForm: TformMainForm
  ClientHeight = 498
  ClientWidth = 840
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  WindowState = wsMaximized
  OnClick = OnClick
  OnCreate = FormCreate
  OnDblClick = OnDblClick
  OnDestroy = OnDestroy
  DesignSize = (
    840
    498)
  PixelsPerInch = 96
  TextHeight = 13
  object panelButtons: TPanel
    Left = 0
    Top = 19
    Width = 121
    Height = 478
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 0
    object btnExport: TButton
      Left = 8
      Top = 15
      Width = 98
      Height = 25
      Caption = 'Export XML'
      TabOrder = 0
      OnClick = btnExportClick
    end
    object btnImport: TButton
      Left = 8
      Top = 46
      Width = 98
      Height = 25
      Caption = 'Import from XML'
      TabOrder = 1
      OnClick = btnImportClick
    end
  end
  object panelDisplay: TPanel
    Left = 0
    Top = 0
    Width = 832
    Height = 28
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    object labelX: TLabel
      Left = 8
      Top = 0
      Width = 10
      Height = 13
      Caption = 'X:'
    end
    object labelXCoordinate: TLabel
      Left = 24
      Top = 0
      Width = 4
      Height = 13
      Caption = '-'
    end
    object labelY: TLabel
      Left = 64
      Top = 0
      Width = 10
      Height = 13
      Caption = 'Y:'
    end
    object labelYCoordinate: TLabel
      Left = 80
      Top = 0
      Width = 4
      Height = 13
      Caption = '-'
    end
    object labelNums: TLabel
      Left = 115
      Top = 0
      Width = 38
      Height = 13
      Caption = 'Num(s):'
    end
    object labelNumOfPoint: TLabel
      Left = 159
      Top = 0
      Width = 4
      Height = 13
      Caption = '-'
    end
    object labelTotalDistance: TLabel
      Left = 200
      Top = 0
      Width = 91
      Height = 13
      Caption = 'Total distance(px):'
    end
    object labelDistance: TLabel
      Left = 297
      Top = 0
      Width = 4
      Height = 13
      Caption = '-'
    end
  end
end
