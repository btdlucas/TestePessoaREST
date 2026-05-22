object frmPessoaClient: TfrmPessoaClient
  Left = 0
  Top = 0
  Caption = 'Cliente REST - Cadastro de Pessoa'
  ClientHeight = 430
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object lbBaseUrl: TLabel
    Left = 24
    Top = 24
    Width = 44
    Height = 13
    Caption = 'Base URL'
  end
  object lbNatureza: TLabel
    Left = 24
    Top = 72
    Width = 45
    Height = 13
    Caption = 'Natureza'
  end
  object lbDocumento: TLabel
    Left = 144
    Top = 72
    Width = 57
    Height = 13
    Caption = 'Documento'
  end
  object lbPrimeiroNome: TLabel
    Left = 24
    Top = 120
    Width = 70
    Height = 13
    Caption = 'Primeiro Nome'
  end
  object lbSegundoNome: TLabel
    Left = 328
    Top = 120
    Width = 73
    Height = 13
    Caption = 'Segundo Nome'
  end
  object lbDtRegistro: TLabel
    Left = 24
    Top = 168
    Width = 66
    Height = 13
    Caption = 'Data Registro'
  end
  object lbCep: TLabel
    Left = 176
    Top = 168
    Width = 19
    Height = 13
    Caption = 'CEP'
  end
  object edtBaseUrl: TEdit
    Left = 24
    Top = 40
    Width = 705
    Height = 21
    TabOrder = 0
  end
  object edtFlNatureza: TEdit
    Left = 24
    Top = 88
    Width = 97
    Height = 21
    TabOrder = 1
  end
  object edtDsDocumento: TEdit
    Left = 144
    Top = 88
    Width = 209
    Height = 21
    TabOrder = 2
  end
  object edtNmPrimeiro: TEdit
    Left = 24
    Top = 136
    Width = 273
    Height = 21
    TabOrder = 3
  end
  object edtNmSegundo: TEdit
    Left = 328
    Top = 136
    Width = 273
    Height = 21
    TabOrder = 4
  end
  object edtDtRegistro: TEdit
    Left = 24
    Top = 184
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object edtDsCep: TEdit
    Left = 176
    Top = 184
    Width = 145
    Height = 21
    TabOrder = 6
  end
  object btnInserirPessoa: TButton
    Left = 24
    Top = 224
    Width = 145
    Height = 33
    Caption = 'Inserir Pessoa'
    TabOrder = 7
    OnClick = btnInserirPessoaClick
  end
  object memRetorno: TMemo
    Left = 24
    Top = 280
    Width = 705
    Height = 121
    TabOrder = 8
  end
end
