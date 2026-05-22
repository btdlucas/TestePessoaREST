# Exemplos Postman

## POST /pessoas

URL:

```text
http://localhost:9000/pessoas
```

Body:

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

## POST /pessoas/lote

URL:

```text
http://localhost:9000/pessoas/lote
```

Body:

```json
[
  {
    "flnatureza": 1,
    "dsdocumento": "11111111111",
    "nmprimeiro": "Pessoa",
    "nmsegundo": "Um",
    "dtregistro": "2026-05-21",
    "enderecos": [
      {
        "dscep": "01001000",
        "integracao": {}
      }
    ]
  }
]
```

## POST /enderecos/atualizar-viacep

URL:

```text
http://localhost:9000/enderecos/atualizar-viacep
```

Sem body.
