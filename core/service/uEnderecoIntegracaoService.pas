unit uEnderecoIntegracaoService;

interface

uses
  FireDAC.Comp.Client;

type
  TEnderecoIntegracaoService = class
  private
    FoConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);

    procedure AtualizarEnderecosPorViaCep;
  end;

implementation

uses
  System.SysUtils,
  System.Threading,
  System.SyncObjs,
  System.Generics.Collections,
  System.Classes,
  Data.DB,
  uEnderecoIntegracao,
  uEnderecoIntegracaoRepository,
  uViaCepService;

type
  TEnderecoCepItem = record
    IdEndereco: Int64;
    DsCep: string;
  end;

constructor TEnderecoIntegracaoService.Create(AConnection: TFDConnection);
begin
  inherited Create;

  if not Assigned(AConnection) then
    raise Exception.Create('Conexão não informada para TEnderecoIntegracaoService.');

  FoConnection := AConnection;
end;

procedure TEnderecoIntegracaoService.AtualizarEnderecosPorViaCep;
var
  oQuery: TFDQuery;
  oLista: TList<TEnderecoCepItem>;
  oLock: TCriticalSection;
  oTasks: TArray<ITask>;
  nIndex: Integer;
  oItem: TEnderecoCepItem;
begin
  oLista := TList<TEnderecoCepItem>.Create;
  oLock := TCriticalSection.Create;
  try
    oQuery := TFDQuery.Create(nil);
    try
      oQuery.Connection := FoConnection;
      oQuery.SQL.Text :=
        'SELECT idendereco, dscep ' +
        'FROM endereco ' +
        'WHERE COALESCE(dscep, '''') <> ''''';

      oQuery.Open;

      while not oQuery.Eof do
      begin
        oItem.IdEndereco := oQuery.FieldByName('idendereco').AsLargeInt;
        oItem.DsCep := oQuery.FieldByName('dscep').AsString;
        oLista.Add(oItem);
        oQuery.Next;
      end;
    finally
      oQuery.Free;
    end;

    SetLength(oTasks, oLista.Count);

    for nIndex := 0 to oLista.Count - 1 do
    begin
      oItem := oLista[nIndex];

      oTasks[nIndex] := TTask.Run(
        procedure
        var
          oViaCepService: TViaCepService;
          oIntegracao: TEnderecoIntegracao;
          oRepository: TEnderecoIntegracaoRepository;
        begin
          oViaCepService := TViaCepService.Create;
          try
            oIntegracao := oViaCepService.ConsultarCep(oItem.DsCep);
            try
              oLock.Acquire;
              try
                oRepository := TEnderecoIntegracaoRepository.Create(FoConnection);
                try
                  oRepository.InsertOrUpdate(oItem.IdEndereco, oIntegracao);
                finally
                  oRepository.Free;
                end;
              finally
                oLock.Release;
              end;
            finally
              oIntegracao.Free;
            end;
          finally
            oViaCepService.Free;
          end;
        end);
    end;

    TTask.WaitForAll(oTasks);
  finally
    oLock.Free;
    oLista.Free;
  end;
end;

end.
