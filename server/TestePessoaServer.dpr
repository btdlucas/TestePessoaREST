program TestePessoaServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse;

begin
  THorse.Get('/ping',
   procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('{"status":"ok"}');
    end);
  
  Writeln('Servidor iniciado em http://localhost:9000');
  THorse.Listen(9000);
  end.