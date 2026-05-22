unit uViaCepService;

interface

uses
  uEnderecoIntegracao;

type
  TViaCepService = class
  public
    function ConsultarCep(const AsCep: string): TEnderecoIntegracao;
  end;

implementation

uses
  System.SysUtils,
  System.JSON,
  System.Net.HttpClient;

function TViaCepService.ConsultarCep(const AsCep: string): TEnderecoIntegracao;
var
  oHttpClient: THTTPClient;
  oResponse: IHTTPResponse;
  oJSONValue: TJSONValue;
  oJSONObject: TJSONObject;
  sUrl: string;
begin
  if Trim(AsCep) = '' then
    raise Exception.Create('CEP não informado.');

  sUrl := Format('https://viacep.com.br/ws/%s/json/', [AsCep]);

  oHttpClient := THTTPClient.Create;
  try
    oResponse := oHttpClient.Get(sUrl);

    if oResponse.StatusCode <> 200 then
      raise Exception.CreateFmt('Erro ao consultar ViaCEP. Status HTTP: %d',
        [oResponse.StatusCode]);

    oJSONValue := TJSONObject.ParseJSONValue(oResponse.ContentAsString);
    try
      if not Assigned(oJSONValue) then
        raise Exception.Create('Retorno inválido da API ViaCEP.');

      oJSONObject := oJSONValue as TJSONObject;

      if Assigned(oJSONObject.GetValue('erro')) then
        raise Exception.CreateFmt('CEP não encontrado: %s', [AsCep]);

      Result := TEnderecoIntegracao.Create;
      Result.DsUF := oJSONObject.GetValue<string>('uf', '');
      Result.NmCidade := oJSONObject.GetValue<string>('localidade', '');
      Result.NmBairro := oJSONObject.GetValue<string>('bairro', '');
      Result.NmLogradouro := oJSONObject.GetValue<string>('logradouro', '');
      Result.DsComplemento := oJSONObject.GetValue<string>('complemento', '');
    finally
      oJSONValue.Free;
    end;
  finally
    oHttpClient.Free;
  end;
end;

end.
