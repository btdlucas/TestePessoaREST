unit uPessoaService;

interface

uses
  FireDAC.Comp.Client,
  uPessoa;

type
  TPessoaService = class
  private
    FoConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);

    function Insert(APessoa: TPessoa): Int64;
    procedure Update(APessoa: TPessoa);
    procedure Delete(const AnIdPessoa: Int64);
  end;

implementation

uses
  System.SysUtils,
  uEndereco,
  uPessoaRepository,
  uEnderecoRepository,
  uEnderecoIntegracaoRepository;

constructor TPessoaService.Create(AConnection: TFDConnection);
begin
  inherited Create;

  if not Assigned(AConnection) then
    raise Exception.Create('Conexão não informada para TPessoaService.');

  FoConnection := AConnection;
end;

function TPessoaService.Insert(APessoa: TPessoa): Int64;
var
  oPessoaRepository: TPessoaRepository;
  oEnderecoRepository: TEnderecoRepository;
  oEnderecoIntegracaoRepository: TEnderecoIntegracaoRepository;
  oEndereco: TEndereco;
begin
  if not Assigned(APessoa) then
    raise Exception.Create('Pessoa não informada.');

  if APessoa.Enderecos.Count = 0 then
    raise Exception.Create('Pessoa deve possuir ao menos um endereço.');

  FoConnection.StartTransaction;
  try
    oPessoaRepository := TPessoaRepository.Create(FoConnection);
    oEnderecoRepository := TEnderecoRepository.Create(FoConnection);
    oEnderecoIntegracaoRepository := TEnderecoIntegracaoRepository.Create(FoConnection);
    try
      Result := oPessoaRepository.Insert(APessoa);

      for oEndereco in APessoa.Enderecos do
      begin
        oEndereco.IdPessoa := APessoa.IdPessoa;
        oEnderecoRepository.Insert(oEndereco);

        oEnderecoIntegracaoRepository.InsertOrUpdate(
          oEndereco.IdEndereco,
          oEndereco.EnderecoIntegracao
        );
      end;
    finally
      oEnderecoIntegracaoRepository.Free;
      oEnderecoRepository.Free;
      oPessoaRepository.Free;
    end;

    FoConnection.Commit;
  except
    if FoConnection.InTransaction then
      FoConnection.Rollback;

    raise;
  end;
end;

procedure TPessoaService.Update(APessoa: TPessoa);
var
  oPessoaRepository: TPessoaRepository;
  oEnderecoRepository: TEnderecoRepository;
  oEnderecoIntegracaoRepository: TEnderecoIntegracaoRepository;
  oEndereco: TEndereco;
begin
  if not Assigned(APessoa) then
    raise Exception.Create('Pessoa não informada.');

  if APessoa.IdPessoa <= 0 then
    raise Exception.Create('Pessoa sem identificador para atualização.');

  if APessoa.Enderecos.Count = 0 then
    raise Exception.Create('Pessoa deve possuir ao menos um endereço.');

  FoConnection.StartTransaction;
  try
    oPessoaRepository := TPessoaRepository.Create(FoConnection);
    oEnderecoRepository := TEnderecoRepository.Create(FoConnection);
    oEnderecoIntegracaoRepository := TEnderecoIntegracaoRepository.Create(FoConnection);
    try
      oPessoaRepository.Update(APessoa);

      oEnderecoRepository.DeletePorPessoa(APessoa.IdPessoa);

      for oEndereco in APessoa.Enderecos do
      begin
        oEndereco.IdPessoa := APessoa.IdPessoa;
        oEnderecoRepository.Insert(oEndereco);

        oEnderecoIntegracaoRepository.InsertOrUpdate(
          oEndereco.IdEndereco,
          oEndereco.EnderecoIntegracao
        );
      end;
    finally
      oEnderecoIntegracaoRepository.Free;
      oEnderecoRepository.Free;
      oPessoaRepository.Free;
    end;

    FoConnection.Commit;
  except
    if FoConnection.InTransaction then
      FoConnection.Rollback;

    raise;
  end;
end;

procedure TPessoaService.Delete(const AnIdPessoa: Int64);
var
  oPessoaRepository: TPessoaRepository;
begin
  if AnIdPessoa <= 0 then
    raise Exception.Create('Identificador da pessoa inválido para exclusão.');

  FoConnection.StartTransaction;
  try
    oPessoaRepository := TPessoaRepository.Create(FoConnection);
    try
      oPessoaRepository.Delete(AnIdPessoa);
    finally
      oPessoaRepository.Free;
    end;

    FoConnection.Commit;
  except
    if FoConnection.InTransaction then
      FoConnection.Rollback;

    raise;
  end;
end;

end.
