unit uPessoaApiClient;

interface

type
  TPessoaApiClient = class
  private
    FsBaseURL: string;
  public
    constructor Create(const AsBaseURL: string);

    function InserirPessoa(
      const AnFlNatureza: Integer;
      const AsDsDocumento: string;
      const AsNmPrimeiro: string;
      const AsNmSegundo: string;
      const AsDtRegistro: string;
      const AsDsCep: string
    ): string;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetConsts;

constructor TPessoaApiClient.Create(const AsBaseURL: string);
begin
  inherited Create;

  FsBaseURL := AsBaseURL.TrimRight(['/']);
end;

function TPessoaApiClient.InserirPessoa(
  const AnFlNatureza: Integer;
  const AsDsDocumento: string;
  const AsNmPrimeiro: string;
  const AsNmSegundo: string;
  const AsDtRegistro: string;
  const AsDsCep: string
): string;
var
  oHttpClient: THTTPClient;
  oRequestBody: TStringStream;
  oResponse: IHTTPResponse;
  oPessoaJSON: TJSONObject;
  oEnderecosArray: TJSONArray;
  oEnderecoJSON: TJSONObject;
  oIntegracaoJSON: TJSONObject;
  sURL: string;
begin
  oPessoaJSON := TJSONObject.Create;
  try
    oPessoaJSON.AddPair('flnatureza', TJSONNumber.Create(AnFlNatureza));
    oPessoaJSON.AddPair('dsdocumento', AsDsDocumento);
    oPessoaJSON.AddPair('nmprimeiro', AsNmPrimeiro);
    oPessoaJSON.AddPair('nmsegundo', AsNmSegundo);
    oPessoaJSON.AddPair('dtregistro', AsDtRegistro);

    oIntegracaoJSON := TJSONObject.Create;

    oEnderecoJSON := TJSONObject.Create;
    oEnderecoJSON.AddPair('dscep', AsDsCep);
    oEnderecoJSON.AddPair('integracao', oIntegracaoJSON);

    oEnderecosArray := TJSONArray.Create;
    oEnderecosArray.AddElement(oEnderecoJSON);

    oPessoaJSON.AddPair('enderecos', oEnderecosArray);

    oHttpClient := THTTPClient.Create;
    try
      oHttpClient.ContentType := 'application/json';

      sURL := FsBaseURL + '/pessoas';

      oRequestBody := TStringStream.Create(oPessoaJSON.ToJSON, TEncoding.UTF8);
      try
        oResponse := oHttpClient.Post(sURL, oRequestBody);

        if not (oResponse.StatusCode in [200, 201]) then
          raise Exception.CreateFmt(
            'Erro ao inserir pessoa. HTTP %d - %s',
            [oResponse.StatusCode, oResponse.ContentAsString]
          );

        Result := oResponse.ContentAsString;
      finally
        oRequestBody.Free;
      end;
    finally
      oHttpClient.Free;
    end;
  finally
    oPessoaJSON.Free;
  end;
end;

end.
