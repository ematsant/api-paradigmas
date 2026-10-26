defmodule TodoApi.Router do
  @moduledoc """
  Rotas HTTP. Cada rota é uma transformação de dados:
  `conn` (requisição) -> `conn` (resposta). Nenhuma rota guarda estado.
  """

  use Plug.Router

  alias TodoApi.Store

  @invalid_title "O titulo nao pode ser vazio."
  @not_found "Tarefa nao encontrada."

  plug :cors
  plug :match
  plug Plug.Parsers, parsers: [:json], pass: ["*/*"], json_decoder: Jason
  plug :dispatch

  # ---------------------------------------------------------------------------
  # Rotas
  # ---------------------------------------------------------------------------

  options _ do
    send_resp(conn, 204, "")
  end

  get "/", do: health(conn)
  get "/health", do: health(conn)

  get "/todos" do
    {:ok, todos} = Store.all()
    json(conn, 200, todos)
  end

  get "/todos/:id" do
    id |> parse_id() |> with_id(&Store.get/1) |> respond(conn, 200)
  end

  post "/todos" do
    conn.body_params |> Map.get("title") |> Store.add() |> respond(conn, 201)
  end

  patch "/todos/:id" do
    id |> parse_id() |> with_id(&Store.toggle/1) |> respond(conn, 200)
  end

  patch "/todos/:id/toggle" do
    id |> parse_id() |> with_id(&Store.toggle/1) |> respond(conn, 200)
  end

  patch "/todos/:id/complete" do
    id |> parse_id() |> with_id(&Store.toggle/1) |> respond(conn, 200)
  end

  delete "/todos/:id" do
    id |> parse_id() |> with_id(&Store.delete/1) |> respond(conn, 204)
  end

  match _ do
    json(conn, 404, %{error: "Rota não encontrada."})
  end

  # ---------------------------------------------------------------------------
  # Funções auxiliares (puras, exceto o envio final da resposta)
  # ---------------------------------------------------------------------------

  defp health(conn) do
    json(conn, 200, %{status: "ok", paradigm: "funcional", language: "Elixir"})
  end

  defp parse_id(text) do
    case Integer.parse(text) do
      {id, ""} -> {:ok, id}
      _ -> {:error, :not_found}
    end
  end

  defp with_id({:ok, id}, fun), do: fun.(id)
  defp with_id(error, _fun), do: error

  defp respond(:ok, conn, 204), do: send_resp(conn, 204, "")
  defp respond({:ok, body}, conn, status), do: json(conn, status, body)
  defp respond({:error, :invalid_title}, conn, _), do: json(conn, 400, %{error: @invalid_title})
  defp respond({:error, :not_found}, conn, _), do: json(conn, 404, %{error: @not_found})
  defp respond({:error, _}, conn, _), do: json(conn, 500, %{error: "Erro interno."})

  defp json(conn, status, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(body))
  end

  defp cors(conn, _opts) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("access-control-allow-methods", "GET, POST, PATCH, DELETE, OPTIONS")
    |> put_resp_header("access-control-allow-headers", "content-type, accept")
  end
end
