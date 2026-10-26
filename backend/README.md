# API Todo List em Elixir — Paradigma Funcional

API compatível com o frontend do professor (`vmussak.github.io-main/paradigmas/todo-list`).

## Como rodar

O Erlang/OTP 26 e o Elixir 1.16 foram instalados em `~/.local/beam` (sem sudo). Em cada terminal:

```bash
export PATH=~/.local/beam/otp/bin:~/.local/beam/elixir/bin:$PATH
cd "Apresentação elixir/api_todo"
mix deps.get      # só na primeira vez
mix test          # testes das funções puras
mix run --no-halt # sobe em http://localhost:5000
```

No frontend, ative o "Modo API" com a URL `http://localhost:5000`.

## Rotas

| Método | Rota | Resposta |
|---|---|---|
| GET | `/` e `/health` | 200 |
| GET | `/todos` | 200 lista |
| GET | `/todos/:id` | 200 / 404 |
| POST | `/todos` `{"title": "..."}` | 201 / 400 |
| PATCH | `/todos/:id/toggle` (ou `/complete`) | 200 / 404 |
| DELETE | `/todos/:id` | 204 / 404 |

## Por que é 100% funcional

| Arquivo | Papel |
|---|---|
| `lib/todo_api/logic.ex` | **Funções puras**: recebem dados imutáveis e devolvem novos dados (`{:ok, _}` / `{:error, _}`), com pattern matching, guards, `with` e pipes `|>`. |
| `lib/todo_api/store.ex` | **Estado sem mutação**: a lista de tarefas é só o argumento da função recursiva `loop/1` de um processo. Cada mensagem calcula um novo estado com as funções puras e chama `loop(novo_estado)`. |
| `lib/todo_api/router.ex` | **Rotas como transformação**: `conn -> conn`, compondo funções com `|>`. |
| `lib/todo_api/application.ex` | Sobe o processo de estado e o servidor HTTP. |

Sem classes, sem objetos, sem variáveis mutáveis, sem laços imperativos, sem `Agent`/ETS.
