defmodule TodoApi.MixProject do
  use Mix.Project

  # Configuração do projeto: apenas dados (um keyword list) devolvidos por funções.
  def project do
    [
      app: :todo_api,
      version: "1.0.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {TodoApi.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.7"},
      {:jason, "~> 1.4"},
      # versão compatível com Erlang/OTP 26
      {:cowlib, "~> 2.13.0", override: true},
      {:ranch, "~> 2.1.0", override: true},
      {:cowboy, "~> 2.12.0", override: true}
    ]
  end
end
