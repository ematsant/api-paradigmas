defmodule TodoApi.Application do
  @moduledoc "Ponto de entrada: sobe o processo de estado e o servidor HTTP na porta 5000."

  use Application
  require Logger

  @port 5000

  @impl true
  def start(_type, _args) do
    Logger.info("API FUNCIONAL EM ELIXIR iniciada em http://localhost:#{@port}")

    Supervisor.start_link(
      [
        TodoApi.Store,
        {Plug.Cowboy, scheme: :http, plug: TodoApi.Router, options: [port: @port]}
      ],
      strategy: :one_for_one,
      name: TodoApi.Supervisor
    )
  end
end
