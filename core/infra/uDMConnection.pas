unit uDMConnection;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Phys,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  FireDAC.Stan.Def, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.ConsoleUI.Wait, Data.DB;

type
  TdmConnection = class(TDataModule)
    FDConnection: TFDConnection;
    FDTransaction: TFDTransaction;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure ConfigurarConexao;
  public
  end;

var
  dmConnection: TdmConnection;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

uses
  uConfigService;

procedure TdmConnection.ConfigurarConexao;
begin
  FDConnection.Connected := False;
  FDConnection.LoginPrompt := False;

  FDConnection.Params.Clear;
  FDConnection.Params.Add('DriverID=' + TConfigService.GetDriverID);
  FDConnection.Params.Add('Server=' + TConfigService.GetServer);
  FDConnection.Params.Add('Port=' + TConfigService.GetPort.ToString);
  FDConnection.Params.Add('Database=' + TConfigService.GetDatabase);
  FDConnection.Params.Add('User_Name=' + TConfigService.GetUsername);
  FDConnection.Params.Add('Password=' + TConfigService.GetPassword);
  FDConnection.Params.Add('VendorLib=' + TConfigService.GetVendorLib);

  if Trim(TConfigService.GetVendorLib) <> '' then
    FDConnection.Params.Add('VendorLib=' + TConfigService.GetVendorLib);

  FDTransaction.Connection := FDConnection;
  FDConnection.Transaction := FDTransaction;
end;

procedure TdmConnection.DataModuleCreate(Sender: TObject);
begin
  ConfigurarConexao;
  FDConnection.Connected := True;

  Writeln('Conexão PostgreSQL realizada com sucesso.');
end;

end.
