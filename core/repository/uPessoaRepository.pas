unit uPessoaRepository;

interface

uses
  FireDAC.Comp.Client,
  uPessoa;

type
  TPessoaRepository = class
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
  Data.DB,
  FireDAC.Stan.Param;

constructor TPessoaRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;

  if not Assigned(AConnection) then
    raise Exception.Create('Conexão não informada para TPessoaRepository.');

  FoConnection := AConnection;
end;

function TPessoaRepository.Insert(APessoa: TPessoa): Int64;
var
  oQuery: TFDQuery;
begin
  if not Assigned(APessoa) then
    raise Exception.Create('Pessoa não informada.');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FoConnection;

    oQuery.SQL.Text :=
      'INSERT INTO pessoa ( ' +
      '  flnatureza, ' +
      '  dsdocumento, ' +
      '  nmprimeiro, ' +
      '  nmsegundo, ' +
      '  dtregistro ' +
      ') VALUES ( ' +
      '  :flnatureza, ' +
      '  :dsdocumento, ' +
      '  :nmprimeiro, ' +
      '  :nmsegundo, ' +
      '  :dtregistro ' +
      ') RETURNING idpessoa';

    oQuery.ParamByName('flnatureza').AsInteger := APessoa.FlNatureza;
    oQuery.ParamByName('dsdocumento').AsString := APessoa.DsDocumento;
    oQuery.ParamByName('nmprimeiro').AsString := APessoa.NmPrimeiro;
    oQuery.ParamByName('nmsegundo').AsString := APessoa.NmSegundo;

    if APessoa.DtRegistro > 0 then
      oQuery.ParamByName('dtregistro').AsDate := APessoa.DtRegistro
    else
      oQuery.ParamByName('dtregistro').Clear;

    oQuery.Open;

    Result := oQuery.FieldByName('idpessoa').AsLargeInt;
    APessoa.IdPessoa := Result;
  finally
    oQuery.Free;
  end;
end;

procedure TPessoaRepository.Update(APessoa: TPessoa);
var
  oQuery: TFDQuery;
begin
  if not Assigned(APessoa) then
    raise Exception.Create('Pessoa não informada.');

  if APessoa.IdPessoa <= 0 then
    raise Exception.Create('Pessoa sem identificador para atualização.');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FoConnection;

    oQuery.SQL.Text :=
      'UPDATE pessoa SET ' +
      '  flnatureza = :flnatureza, ' +
      '  dsdocumento = :dsdocumento, ' +
      '  nmprimeiro = :nmprimeiro, ' +
      '  nmsegundo = :nmsegundo, ' +
      '  dtregistro = :dtregistro ' +
      'WHERE idpessoa = :idpessoa';

    oQuery.ParamByName('idpessoa').AsLargeInt := APessoa.IdPessoa;
    oQuery.ParamByName('flnatureza').AsInteger := APessoa.FlNatureza;
    oQuery.ParamByName('dsdocumento').AsString := APessoa.DsDocumento;
    oQuery.ParamByName('nmprimeiro').AsString := APessoa.NmPrimeiro;
    oQuery.ParamByName('nmsegundo').AsString := APessoa.NmSegundo;

    if APessoa.DtRegistro > 0 then
      oQuery.ParamByName('dtregistro').AsDate := APessoa.DtRegistro
    else
      oQuery.ParamByName('dtregistro').Clear;

    oQuery.ExecSQL;
  finally
    oQuery.Free;
  end;
end;

procedure TPessoaRepository.Delete(const AnIdPessoa: Int64);
var
  oQuery: TFDQuery;
begin
  if AnIdPessoa <= 0 then
    raise Exception.Create('Identificador da pessoa inválido para exclusão.');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FoConnection;

    oQuery.SQL.Text :=
      'DELETE FROM pessoa ' +
      'WHERE idpessoa = :idpessoa';

    oQuery.ParamByName('idpessoa').AsLargeInt := AnIdPessoa;
    oQuery.ExecSQL;
  finally
    oQuery.Free;
  end;
end;

end.
