unit ufrmPessoaClient;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TfrmPessoaClient = class(TForm)
    lbBaseUrl: TLabel;
    edtBaseUrl: TEdit;
    lbNatureza: TLabel;
    edtFlNatureza: TEdit;
    lbDocumento: TLabel;
    edtDsDocumento: TEdit;
    lbPrimeiroNome: TLabel;
    edtNmPrimeiro: TEdit;
    lbSegundoNome: TLabel;
    edtNmSegundo: TEdit;
    lbDtRegistro: TLabel;
    edtDtRegistro: TEdit;
    lbCep: TLabel;
    edtDsCep: TEdit;
    btnInserirPessoa: TButton;
    memRetorno: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnInserirPessoaClick(Sender: TObject);
  private
    procedure ValidarCampos;
  public
  end;

var
  frmPessoaClient: TfrmPessoaClient;

implementation

{$R *.dfm}

uses
  uPessoaApiClient;

procedure TfrmPessoaClient.FormCreate(Sender: TObject);
begin
  edtBaseUrl.Text := 'http://localhost:9000';
  edtFlNatureza.Text := '1';
  edtDsDocumento.Text := '12345678900';
  edtNmPrimeiro.Text := 'Lucas';
  edtNmSegundo.Text := 'Fonseca';
  edtDtRegistro.Text := FormatDateTime('yyyy-mm-dd', Date);
  edtDsCep.Text := '01001000';
  memRetorno.Clear;
end;

procedure TfrmPessoaClient.ValidarCampos;
begin
  if Trim(edtBaseUrl.Text) = '' then
    raise Exception.Create('Informe a URL base da API.');

  if Trim(edtFlNatureza.Text) = '' then
    raise Exception.Create('Informe a natureza.');

  if Trim(edtDsDocumento.Text) = '' then
    raise Exception.Create('Informe o documento.');

  if Trim(edtNmPrimeiro.Text) = '' then
    raise Exception.Create('Informe o primeiro nome.');

  if Trim(edtNmSegundo.Text) = '' then
    raise Exception.Create('Informe o segundo nome.');

  if Trim(edtDsCep.Text) = '' then
    raise Exception.Create('Informe o CEP.');
end;

procedure TfrmPessoaClient.btnInserirPessoaClick(Sender: TObject);
var
  nFlNatureza: Integer;
  oApiClient: TPessoaApiClient;
  sRetorno: string;
begin
  try
    ValidarCampos;

    if not TryStrToInt(edtFlNatureza.Text, nFlNatureza) then
      raise Exception.Create('Natureza inválida.');

    oApiClient := TPessoaApiClient.Create(edtBaseUrl.Text);
    try
      sRetorno := oApiClient.InserirPessoa(
        nFlNatureza,
        edtDsDocumento.Text,
        edtNmPrimeiro.Text,
        edtNmSegundo.Text,
        edtDtRegistro.Text,
        edtDsCep.Text
      );

      memRetorno.Lines.Text := sRetorno;
      ShowMessage('Pessoa enviada com sucesso.');
    finally
      oApiClient.Free;
    end;
  except
    on E: Exception do
    begin
      memRetorno.Lines.Text := E.Message;
      ShowMessage(E.Message);
    end;
  end;
end;

end.
