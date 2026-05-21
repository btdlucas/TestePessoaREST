unit uEndereco;

interface

uses
  uEnderecoIntegracao;

type
  TEndereco = class
  private
    FnIdEndereco: Int64;
    FnIdPessoa: Int64;
    FsDsCep: string;
    FoEnderecoIntegracao: TEnderecoIntegracao;
  public
    constructor Create;
    destructor Destroy; override;

    property IdEndereco: Int64
      read FnIdEndereco
      write FnIdEndereco;

    property IdPessoa: Int64
      read FnIdPessoa
      write FnIdPessoa;

    property DsCep: string
      read FsDsCep
      write FsDsCep;

    property EnderecoIntegracao: TEnderecoIntegracao
      read FoEnderecoIntegracao
      write FoEnderecoIntegracao;
  end;

implementation

constructor TEndereco.Create;
begin
  inherited Create;

  FoEnderecoIntegracao := TEnderecoIntegracao.Create;
end;

destructor TEndereco.Destroy;
begin
  FoEnderecoIntegracao.Free;

  inherited;
end;

end.
