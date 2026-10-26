defmodule TodoApi.Store do
  @moduledoc """
  Estado da aplicação sem NENHUMA variável mutável.

  O estado é apenas o ARGUMENTO de uma função recursiva (`loop/1`) rodando
  em um processo leve do BEAM. Cada mensagem gera um novo estado (calculado
  pelas funções puras de `TodoApi.Logic`) que é passado à próxima chamada
  recursiva. É o mesmo padrão do `MailboxProcessor` da versão em F#.
  """

  alias TodoApi.Logic

  @name __MODULE__
  @timeout 5_000

  # ---------------------------------------------------------------------------
  # Inicialização (usada pelo supervisor)
  # ---------------------------------------------------------------------------

  def child_spec(_arg) do
    %{id: @name, start: {__MODULE__, :start_link, [Logic.initial_todos()]}}
  end

  def start_link(initial_todos) do
    pid = spawn_link(fn -> loop(initial_todos) end)
    Process.register(pid, @name)
    {:ok, pid}
  end

  # ---------------------------------------------------------------------------
  # API: cada função envia uma mensagem e espera a resposta
  # ---------------------------------------------------------------------------

  def all, do: ask(:all)
  def get(id), do: ask({:get, id})
  def add(title), do: ask({:add, title})
  def toggle(id), do: ask({:toggle, id})
  def delete(id), do: ask({:delete, id})

  defp ask(request) do
    ref = make_ref()
    send(@name, {request, self(), ref})

    receive do
      {^ref, reply} -> reply
    after
      @timeout -> {:error, :timeout}
    end
  end

  # ---------------------------------------------------------------------------
  # Loop recursivo: o estado "muda" apenas sendo passado adiante
  # ---------------------------------------------------------------------------

  defp loop(todos) do
    receive do
      {request, from, ref} ->
        {reply, next_todos} = handle(request, todos)
        send(from, {ref, reply})
        loop(next_todos)
    end
  end

  # Cada handle/2 é uma função pura: (pedido, estado) -> {resposta, novo_estado}
  defp handle(:all, todos), do: {{:ok, todos}, todos}
  defp handle({:get, id}, todos), do: {Logic.find(todos, id), todos}

  defp handle({:add, title}, todos) do
    todos |> Logic.add(title) |> to_transition(todos)
  end

  defp handle({:toggle, id}, todos) do
    todos |> Logic.toggle(id) |> to_transition(todos)
  end

  defp handle({:delete, id}, todos) do
    case Logic.delete(todos, id) do
      {:ok, new_todos} -> {:ok, new_todos}
      error -> {error, todos}
    end
  end

  defp to_transition({:ok, {todo, new_todos}}, _old), do: {{:ok, todo}, new_todos}
  defp to_transition(error, old), do: {error, old}
end
