unit uEnderecoIntegracaoRoutes;

interface

procedure RegistrarRotasEnderecoIntegracao;

implementation

uses
  System.SysUtils,
  Horse,
  uDMConnection,
  uEnderecoIntegracaoService;

procedure RegistrarRotasEnderecoIntegracao;
begin
  THorse.Post('/enderecos/atualizar-viacep',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      oService: TEnderecoIntegracaoService;
    begin
      oService := TEnderecoIntegracaoService.Create(dmConnection.FDConnection);
      try
        oService.AtualizarEnderecosPorViaCep;
        Res.Status(200).Send('{"status":"enderecos atualizados"}');
      finally
        oService.Free;
      end;
    end);
end;

end.
