# Complemento - Etapas finais TestePessoaREST

Este pacote contém arquivos complementares para avançar o teste após o POST /pessoas já estar funcionando.

## Conteúdo

- `core/service/uViaCepService.pas`
- `core/service/uEnderecoIntegracaoService.pas`
- `server/routes/uEnderecoIntegracaoRoutes.pas`
- `server/routes/uPessoaLoteRoutes.pas`
- `docs/exemplos_postman.md`

## Integração sugerida

1. Copiar as units para as pastas equivalentes do projeto.
2. Adicionar as units ao projeto Delphi Server.
3. Registrar as rotas no `TestePessoaServer.dpr`:

```delphi
uses
  ...
  uEnderecoIntegracaoRoutes in 'routes\uEnderecoIntegracaoRoutes.pas',
  uPessoaLoteRoutes in 'routes\uPessoaLoteRoutes.pas';
```

Antes do `THorse.Listen`:

```delphi
RegistrarRotasPessoa;
RegistrarRotasEnderecoIntegracao;
RegistrarRotasPessoaLote;
```

4. Fazer Build.
5. Testar endpoints no Postman.
