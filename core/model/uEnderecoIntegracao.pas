unit uEnderecoIntegracao;

interface

type
  TEnderecoIntegracao = class
  private
    FsDsUF: string;
    FsNmCidade: string;
    FsNmBairro: string;
    FsNmLogradouro: string;
    FsDsComplemento: string;
  public
    property DsUF: string
      read FsDsUF
      write FsDsUF;

    property NmCidade: string
      read FsNmCidade
      write FsNmCidade;

    property NmBairro: string
      read FsNmBairro
      write FsNmBairro;

    property NmLogradouro: string
      read FsNmLogradouro
      write FsNmLogradouro;

    property DsComplemento: string
      read FsDsComplemento
      write FsDsComplemento;
  end;

implementation

end.
