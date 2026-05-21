unit uPessoa;

interface

uses
  System.Generics.Collections,
  uEndereco;

type
  TPessoa = class
  private
    FnIdPessoa: Int64;
    FnFlNatureza: Integer;
    FsDsDocumento: string;
    FsNmPrimeiro: string;
    FsNmSegundo: string;
    FdDtRegistro: TDate;
    FoEnderecos: TObjectList<TEndereco>;
  public
    constructor Create;
    destructor Destroy; override;

    property IdPessoa: Int64
      read FnIdPessoa
      write FnIdPessoa;

    property FlNatureza: Integer
      read FnFlNatureza
      write FnFlNatureza;

    property DsDocumento: string
      read FsDsDocumento
      write FsDsDocumento;

    property NmPrimeiro: string
      read FsNmPrimeiro
      write FsNmPrimeiro;

    property NmSegundo: string
      read FsNmSegundo
      write FsNmSegundo;

    property DtRegistro: TDate
      read FdDtRegistro
      write FdDtRegistro;

    property Enderecos: TObjectList<TEndereco>
      read FoEnderecos;
  end;

implementation

constructor TPessoa.Create;
begin
  inherited Create;

  FoEnderecos := TObjectList<TEndereco>.Create(True);
end;

destructor TPessoa.Destroy;
begin
  FoEnderecos.Free;

  inherited;
end;

end.
