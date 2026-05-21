unit uEnderecoIntegracaoRepository;

interface

uses
  FireDAC.Comp.Client,
  uEnderecoIntegracao;

type
  TEnderecoIntegracaoRepository = class
  private
    FoConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);

    procedure InsertOrUpdate(const AnIdEndereco: Int64;
      AEnderecoIntegracao: TEnderecoIntegracao);

    procedure Delete(const AnIdEndereco: Int64);
  end;

implementation

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Stan.Param;

constructor TEnderecoIntegracaoRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;

  if not Assigned(AConnection) then
    raise Exception.Create('Conexão não informada para TEnderecoIntegracaoRepository.');

  FoConnection := AConnection;
end;

procedure TEnderecoIntegracaoRepository.InsertOrUpdate(
  const AnIdEndereco: Int64;
  AEnderecoIntegracao: TEnderecoIntegracao);
var
  oQuery: TFDQuery;
begin
  if AnIdEndereco <= 0 then
    raise Exception.Create('Identificador do endereço inválido.');

  if not Assigned(AEnderecoIntegracao) then
    raise Exception.Create('Dados de integração do endereço não informados.');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FoConnection;

    oQuery.SQL.Text :=
      'INSERT INTO endereco_integracao ( ' +
      '  idendereco, ' +
      '  dsuf, ' +
      '  nmcidade, ' +
      '  nmbairro, ' +
      '  nmlogradouro, ' +
      '  dscomplemento ' +
      ') VALUES ( ' +
      '  :idendereco, ' +
      '  :dsuf, ' +
      '  :nmcidade, ' +
      '  :nmbairro, ' +
      '  :nmlogradouro, ' +
      '  :dscomplemento ' +
      ') ON CONFLICT (idendereco) DO UPDATE SET ' +
      '  dsuf = EXCLUDED.dsuf, ' +
      '  nmcidade = EXCLUDED.nmcidade, ' +
      '  nmbairro = EXCLUDED.nmbairro, ' +
      '  nmlogradouro = EXCLUDED.nmlogradouro, ' +
      '  dscomplemento = EXCLUDED.dscomplemento';

    oQuery.ParamByName('idendereco').AsLargeInt := AnIdEndereco;
    oQuery.ParamByName('dsuf').AsString := AEnderecoIntegracao.DsUF;
    oQuery.ParamByName('nmcidade').AsString := AEnderecoIntegracao.NmCidade;
    oQuery.ParamByName('nmbairro').AsString := AEnderecoIntegracao.NmBairro;
    oQuery.ParamByName('nmlogradouro').AsString := AEnderecoIntegracao.NmLogradouro;
    oQuery.ParamByName('dscomplemento').AsString := AEnderecoIntegracao.DsComplemento;

    oQuery.ExecSQL;
  finally
    oQuery.Free;
  end;
end;

procedure TEnderecoIntegracaoRepository.Delete(const AnIdEndereco: Int64);
var
  oQuery: TFDQuery;
begin
  if AnIdEndereco <= 0 then
    raise Exception.Create('Identificador do endereço inválido para exclusão da integração.');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FoConnection;

    oQuery.SQL.Text :=
      'DELETE FROM endereco_integracao ' +
      'WHERE idendereco = :idendereco';

    oQuery.ParamByName('idendereco').AsLargeInt := AnIdEndereco;
    oQuery.ExecSQL;
  finally
    oQuery.Free;
  end;
end;

end.
