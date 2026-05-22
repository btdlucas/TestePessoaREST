# Client VCL

Client VCL simples para validar comunicação REST/JSON com o servidor Horse.

## Fluxo

1. Rodar o servidor `TestePessoaServer`.
2. Executar o client VCL.
3. Conferir URL base:

```text
http://localhost:9000
```

4. Clicar em `Inserir Pessoa`.
5. Validar retorno no memo e registros no PostgreSQL.

## Endpoint usado

```http
POST /pessoas
```
