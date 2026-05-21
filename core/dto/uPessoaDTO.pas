unit uPessoaDTO;

interface

uses
  System.SysUtils,
  System.DateUtils,
  System.JSON,
  System.Generics.Collections,
  uPessoa,
  uEndereco,
  uEnderecoIntegracao;

type
  TPessoaDTO = class
  public
    class function FromJSON(AJSON: TJSONObject): TPessoa;
    class function ToJSON(APessoa: TPessoa): TJSONObject;
  end;

implementation

class function TPessoaDTO.FromJSON(AJSON: TJSONObject): TPessoa;
var
  oEndereco: TEndereco;
  oEnderecosArray: TJSONArray;
  oEnderecoJSON: TJSONObject;
  oIntegracaoJSON: TJSONObject;
  nIndex: Integer;
begin
  if not Assigned(AJSON) then
    raise Exception.Create('JSON da pessoa não informado.');

  Result := TPessoa.Create;
  try
    Result.IdPessoa := AJSON.GetValue<Int64>('idpessoa', 0);
    Result.FlNatureza := AJSON.GetValue<Integer>('flnatureza', 0);
    Result.DsDocumento := AJSON.GetValue<string>('dsdocumento', '');
    Result.NmPrimeiro := AJSON.GetValue<string>('nmprimeiro', '');
    Result.NmSegundo := AJSON.GetValue<string>('nmsegundo', '');

    if AJSON.GetValue<string>('dtregistro', '') <> '' then
      Result.DtRegistro :=
        ISO8601ToDate(AJSON.GetValue<string>('dtregistro'));

    oEnderecosArray := AJSON.GetValue<TJSONArray>('enderecos');

    if Assigned(oEnderecosArray) then
    begin
      for nIndex := 0 to oEnderecosArray.Count - 1 do
      begin
        oEnderecoJSON := oEnderecosArray.Items[nIndex] as TJSONObject;

        oEndereco := TEndereco.Create;
        oEndereco.IdEndereco := oEnderecoJSON.GetValue<Int64>('idendereco', 0);
        oEndereco.IdPessoa := oEnderecoJSON.GetValue<Int64>('idpessoa', 0);
        oEndereco.DsCep := oEnderecoJSON.GetValue<string>('dscep', '');

        oIntegracaoJSON := oEnderecoJSON.GetValue<TJSONObject>('integracao');

        if Assigned(oIntegracaoJSON) then
        begin
          oEndereco.EnderecoIntegracao.DsUF :=
            oIntegracaoJSON.GetValue<string>('dsuf', '');

          oEndereco.EnderecoIntegracao.NmCidade :=
            oIntegracaoJSON.GetValue<string>('nmcidade', '');

          oEndereco.EnderecoIntegracao.NmBairro :=
            oIntegracaoJSON.GetValue<string>('nmbairro', '');

          oEndereco.EnderecoIntegracao.NmLogradouro :=
            oIntegracaoJSON.GetValue<string>('nmlogradouro', '');

          oEndereco.EnderecoIntegracao.DsComplemento :=
            oIntegracaoJSON.GetValue<string>('dscomplemento', '');
        end;

        Result.Enderecos.Add(oEndereco);
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TPessoaDTO.ToJSON(APessoa: TPessoa): TJSONObject;
var
  oEndereco: TEndereco;
  oEnderecosArray: TJSONArray;
  oEnderecoJSON: TJSONObject;
  oIntegracaoJSON: TJSONObject;
begin
  if not Assigned(APessoa) then
    raise Exception.Create('Pessoa não informada.');

  Result := TJSONObject.Create;
  try
    Result.AddPair('idpessoa', TJSONNumber.Create(APessoa.IdPessoa));
    Result.AddPair('flnatureza', TJSONNumber.Create(APessoa.FlNatureza));
    Result.AddPair('dsdocumento', APessoa.DsDocumento);
    Result.AddPair('nmprimeiro', APessoa.NmPrimeiro);
    Result.AddPair('nmsegundo', APessoa.NmSegundo);

    if APessoa.DtRegistro > 0 then
      Result.AddPair('dtregistro', DateToISO8601(APessoa.DtRegistro))
    else
      Result.AddPair('dtregistro', '');

    oEnderecosArray := TJSONArray.Create;

    for oEndereco in APessoa.Enderecos do
    begin
      oEnderecoJSON := TJSONObject.Create;
      oEnderecoJSON.AddPair('idendereco', TJSONNumber.Create(oEndereco.IdEndereco));
      oEnderecoJSON.AddPair('idpessoa', TJSONNumber.Create(oEndereco.IdPessoa));
      oEnderecoJSON.AddPair('dscep', oEndereco.DsCep);

      oIntegracaoJSON := TJSONObject.Create;
      oIntegracaoJSON.AddPair('dsuf', oEndereco.EnderecoIntegracao.DsUF);
      oIntegracaoJSON.AddPair('nmcidade', oEndereco.EnderecoIntegracao.NmCidade);
      oIntegracaoJSON.AddPair('nmbairro', oEndereco.EnderecoIntegracao.NmBairro);
      oIntegracaoJSON.AddPair('nmlogradouro', oEndereco.EnderecoIntegracao.NmLogradouro);
      oIntegracaoJSON.AddPair('dscomplemento', oEndereco.EnderecoIntegracao.DsComplemento);

      oEnderecoJSON.AddPair('integracao', oIntegracaoJSON);
      oEnderecosArray.AddElement(oEnderecoJSON);
    end;

    Result.AddPair('enderecos', oEnderecosArray);
  except
    Result.Free;
    raise;
  end;
end;

end.
