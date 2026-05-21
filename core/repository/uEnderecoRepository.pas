unit uEnderecoRepository;

interface

uses
  FireDAC.Comp.Client,
  uEndereco;

type
  TEnderecoRepository = class
  private
    FoConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);

    function Insert(AEndereco: TEndereco): Int64;
    procedure Update(AEndereco: TEndereco);
    procedure DeletePorPessoa(const AnIdPessoa: Int64);
  end;

implementation

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Stan.Param;

constructor TEnderecoRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;

  if not Assigned(AConnection) then
    raise Exception.Create('Conexão não informada para TEnderecoRepository.');

  FoConnection := AConnection;
end;

function TEnderecoRepository.Insert(AEndereco: TEndereco): Int64;
var
  oQuery: TFDQuery;
begin
  if not Assigned(AEndereco) then
    raise Exception.Create('Endereço não informado.');

  if AEndereco.IdPessoa <= 0 then
    raise Exception.Create('Endereço sem pessoa vinculada.');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FoConnection;

    oQuery.SQL.Text :=
      'INSERT INTO endereco ( ' +
      '  idpessoa, ' +
      '  dscep ' +
      ') VALUES ( ' +
      '  :idpessoa, ' +
      '  :dscep ' +
      ') RETURNING idendereco';

    oQuery.ParamByName('idpessoa').AsLargeInt := AEndereco.IdPessoa;
    oQuery.ParamByName('dscep').AsString := AEndereco.DsCep;

    oQuery.Open;

    Result := oQuery.FieldByName('idendereco').AsLargeInt;
    AEndereco.IdEndereco := Result;
  finally
    oQuery.Free;
  end;
end;

procedure TEnderecoRepository.Update(AEndereco: TEndereco);
var
  oQuery: TFDQuery;
begin
  if not Assigned(AEndereco) then
    raise Exception.Create('Endereço não informado.');

  if AEndereco.IdEndereco <= 0 then
    raise Exception.Create('Endereço sem identificador para atualização.');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FoConnection;

    oQuery.SQL.Text :=
      'UPDATE endereco SET ' +
      '  dscep = :dscep ' +
      'WHERE idendereco = :idendereco';

    oQuery.ParamByName('idendereco').AsLargeInt := AEndereco.IdEndereco;
    oQuery.ParamByName('dscep').AsString := AEndereco.DsCep;

    oQuery.ExecSQL;
  finally
    oQuery.Free;
  end;
end;

procedure TEnderecoRepository.DeletePorPessoa(const AnIdPessoa: Int64);
var
  oQuery: TFDQuery;
begin
  if AnIdPessoa <= 0 then
    raise Exception.Create('Identificador da pessoa inválido para exclusão de endereços.');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FoConnection;

    oQuery.SQL.Text :=
      'DELETE FROM endereco ' +
      'WHERE idpessoa = :idpessoa';

    oQuery.ParamByName('idpessoa').AsLargeInt := AnIdPessoa;
    oQuery.ExecSQL;
  finally
    oQuery.Free;
  end;
end;

end.
