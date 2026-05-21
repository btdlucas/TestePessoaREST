program TestePessoaServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  uConfigService in '..\core\infra\uConfigService.pas',
  uDMConnection in '..\core\infra\uDMConnection.pas' {dmConnection: TDataModule};

begin
  dmConnection := TdmConnection.Create(nil);
  try
    THorse.Get('/ping',
      procedure(Req: THorseRequest; Res: THorseResponse)
      begin
        Res.Send('{"status":"ok"}');
      end);

    Writeln(
      Format(
        'Servidor iniciado em http://localhost:%d',
        [TConfigService.GetServerPort]
      )
    );

    THorse.Listen(TConfigService.GetServerPort);
  finally
    dmConnection.Free;
  end;
end.
