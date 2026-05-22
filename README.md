# TestePessoaREST

Backend REST desenvolvido em Delphi utilizando Horse, FireDAC e PostgreSQL para gerenciamento de pessoas e endereços, incluindo integração com ViaCEP e processamento em lote.

---

# Tecnologias utilizadas

* Delphi 11 Alexandria
* Horse
* PostgreSQL 17
* FireDAC
* JSON REST API
* Boss Package Manager

---

# Arquitetura

Projeto estruturado em 3 camadas:

```text
DTO
Service
Repository
```

Organização:

```text
core/
 ├── dto
 ├── infra
 ├── model
 ├── repository
 └── service

server/
 ├── routes
 └── TestePessoaServer.dpr
```

---

# Funcionalidades implementadas

## Pessoa

* Cadastro de pessoa
* Atualização de pessoa
* Exclusão de pessoa
* Inserção em lote

## Endereço

* Relacionamento obrigatório com pessoa
* Integração ViaCEP
* Atualização automática de endereço

## REST API

* JSON request/response
* Rotas REST utilizando Horse

## Banco de Dados

* PostgreSQL
* Integridade relacional
* Transações via FireDAC

## Threads

* Processamento paralelo de atualização ViaCEP utilizando `TTask`

---

# Estrutura do banco

```sql
CREATE TABLE pessoa (
    idpessoa bigserial NOT NULL,
    flnatureza int2 NOT NULL,
    dsdocumento varchar(20) NOT NULL,
    nmprimeiro varchar(100) NOT NULL,
    nmsegundo varchar(100) NOT NULL,
    dtregistro date NULL,
    CONSTRAINT pessoa_pk PRIMARY KEY (idpessoa)
);

CREATE TABLE endereco (
    idendereco bigserial NOT NULL,
    idpessoa int8 NOT NULL,
    dscep varchar(15) NULL,
    CONSTRAINT endereco_pk PRIMARY KEY (idendereco),
    CONSTRAINT endereco_fk_pessoa
        FOREIGN KEY (idpessoa)
        REFERENCES pessoa(idpessoa)
        ON DELETE CASCADE
);

CREATE TABLE endereco_integracao (
    idendereco bigint NOT NULL,
    dsuf varchar(50) NULL,
    nmcidade varchar(100) NULL,
    nmbairro varchar(50) NULL,
    nmlogradouro varchar(100) NULL,
    dscomplemento varchar(100) NULL,
    CONSTRAINT enderecointegracao_pk PRIMARY KEY (idendereco),
    CONSTRAINT enderecointegracao_fk_endereco
        FOREIGN KEY (idendereco)
        REFERENCES endereco(idendereco)
        ON DELETE CASCADE
);
```

---

# Configuração do ambiente

## PostgreSQL

Instalar PostgreSQL 17:

[https://www.postgresql.org/download/windows/](https://www.postgresql.org/download/windows/)

Adicionar ao PATH do Windows:

```text
C:\Program Files\PostgreSQL\17\bin
```

---

# Dependências

## Boss

Instalação:

[https://github.com/HashLoad/boss](https://github.com/HashLoad/boss)

Inicialização:

```bash
boss init
```

Instalação do Horse:

```bash
boss install horse
```

---

# Configuração do projeto

## config.ini

Criar arquivo:

```text
config.ini
```

Conteúdo:

```ini
[DATABASE]
Server=localhost
Port=5432
Database=TestePessoaREST
Username=postgres
Password=postgres
DriverID=PG
VendorLib=C:\Program Files\PostgreSQL\17\bin\libpq.dll

[SERVER]
Port=9000
```

---

# Compilação

Target recomendado:

```text
Win64
```

Build:

```text
Project > Build
```

---

# Execução

Executar:

```text
TestePessoaServer.exe
```

Resultado esperado:

```text
Servidor iniciado em http://localhost:9000
```

---

# Endpoints

## Health Check

```http
GET /ping
```

---

## Inserir Pessoa

```http
POST /pessoas
```

---

## Atualizar Pessoa

```http
PUT /pessoas/:id
```

---

## Excluir Pessoa

```http
DELETE /pessoas/:id
```

---

## Inserção em Lote

```http
POST /pessoas/lote
```

---

## Atualizar ViaCEP

```http
POST /enderecos/atualizar-viacep
```

---

# Exemplo JSON

## POST /pessoas

```json
{
  "flnatureza": 1,
  "dsdocumento": "12345678900",
  "nmprimeiro": "Lucas",
  "nmsegundo": "Fonseca",
  "dtregistro": "2026-05-21",
  "enderecos": [
    {
      "dscep": "88800000",
      "integracao": {
        "dsuf": "SC",
        "nmcidade": "Criciúma",
        "nmbairro": "Centro",
        "nmlogradouro": "Rua Teste",
        "dscomplemento": "Casa"
      }
    }
  ]
}
```

---

# Ferramentas utilizadas para testes

* Postman
* DBeaver

---

# Observações técnicas

* Projeto utilizando orientação a objetos.
* Separação em camadas.
* Utilização de transações.
* Tratamento de memória com `try/finally`.
* Utilização de `TObjectList`.
* Processamento paralelo com `TTask`.
* Integração REST com ViaCEP.
* API preparada para processamento em lote.

---

# Autor

Lucas Vargas da Fonseca
