program TestePessoaClient;

uses
  Vcl.Forms,
  ufrmPessoaClient in 'view\ufrmPessoaClient.pas' {frmPessoaClient},
  uPessoaApiClient in 'service\uPessoaApiClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPessoaClient, frmPessoaClient);
  Application.Run;
end.
