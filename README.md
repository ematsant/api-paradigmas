# API Todo List — Paradigma Funcional (Elixir) & Frontend

Repositório da disciplina de **Paradigmas de Linguagens de Programação**.
Este projeto implementa o contrato da aplicação **Todo List** sob o **Paradigma Funcional**, utilizando a linguagem **Elixir** sobre a máquina virtual BEAM, integrado ao frontend web oficial da disciplina.

---

## 📁 Estrutura do Repositório

O projeto é organizado como um monorepo para facilitar a execução e avaliação:

```
api-paradigmas/
├── backend/            # API REST implementada em Elixir (Plug/Cowboy)
│   ├── lib/            # Código-fonte (Router, Store com Actor Model, Lógica Pura)
│   ├── test/           # Testes unitários das funções puras
│   ├── mix.exs         # Configuração do projeto e dependências
│   └── README.md       # Documentação técnica específica do backend
├── frontend/           # Interface Web (HTML, CSS e JavaScript do professor)
│   ├── index.html      # Página principal da Todo List
│   ├── app.js          # Lógica de interface e chamadas HTTP
│   ├── config.js       # Configuração da URL da API (http://localhost:5000)
│   └── styles.css      # Estilização da interface
├── .gitignore          # Regras para ignorar compilações e dependências
└── README.md           # Documentação geral do repositório
```

---

## 🚀 Como Executar o Projeto

### 1. Pré-requisitos
- [Elixir](https://elixir-lang.org/) (versão 1.14 ou superior) e Erlang/OTP.

> **Dica no ambiente Linux local:** Caso tenha instalado o Elixir no diretório local, certifique-se de carregar o PATH:
> ```bash
> export PATH=~/.local/beam/otp/bin:~/.local/beam/elixir/bin:$PATH
> ```

---

### 2. Executando o Backend (API Elixir)

1. Abra um terminal na pasta do backend:
   ```bash
   cd backend
   ```

2. Instale as dependências (necessário apenas na primeira vez):
   ```bash
   mix deps.get
   ```

3. (Opcional) Execute os testes unitários:
   ```bash
   mix test
   ```

4. Inicie o servidor da API:
   ```bash
   mix run --no-halt
   ```
   *A API iniciará ouvindo na porta **5000**: `http://localhost:5000`*

---

### 3. Executando o Frontend

1. Abra o arquivo `frontend/index.html` diretamente no seu navegador, ou use uma extensão como o **Live Server** no VS Code.
2. O arquivo `frontend/config.js` já vem configurado com:
   ```javascript
   window.APP_CONFIG = {
     USE_API: true,
     API_URL: "http://localhost:5000",
     LOCAL_STORAGE_KEY: "paradigm-todo.items",
   };
   ```
3. A interface web se conectará automaticamente à API em Elixir na porta 5000!

---

## 🔌 Contrato de Rotas da API

| Método | Endpoint | Descrição | Status Sucesso | Status Erro |
| :--- | :--- | :--- | :--- | :--- |
| **GET** | `/todos` | Lista todas as tarefas | `200 OK` | — |
| **GET** | `/todos/:id` | Consulta tarefa por ID | `200 OK` | `404 Not Found` |
| **POST** | `/todos` | Cria nova tarefa com título | `201 Created` | `400 Bad Request` |
| **PATCH** | `/todos/:id` | Alterna status (`completed`) | `200 OK` | `404 Not Found` |
| **DELETE** | `/todos/:id` | Remove tarefa por ID | `204 No Content` | `404 Not Found` |

---

## 🧠 Pilares do Paradigma Funcional no Código

1. **Imutabilidade Total de Dados:**
   - No Elixir, variáveis não sofrem mutação em memória.
   - Qualquer atualização (`logic.ex`) utiliza cópias com *Map Update* (`%{todo | completed: ...}`), garantindo previsibilidade e ausência de efeitos colaterais.

2. **Funções Puras & Pipelines (`|>`):**
   - Zero laços iterativos (`for`, `while`) ou variáveis de controle (`i++`).
   - O cálculo do próximo ID (`next_id`) encadeia transformações puras através do operador pipe:
     ```elixir
     todos
     |> Enum.map(& &1.id)
     |> Enum.max()
     |> Kernel.+(1)
     ```

3. **Estado por Recursão (Actor Model):**
   - Não há banco de dados nem variáveis globais mutáveis.
   - O estado vive no parâmetro de uma função recursiva de cauda (`loop(todos)` em `store.ex`). Ao receber uma mensagem, o processo calcula o novo estado e chama a si mesmo passando a nova lista: `loop(next_todos)`.

---

## 👥 Integrantes do Grupo

- **Matheus Martins**
- **Mateus Vieira**
- **Kauan Teixeira**
