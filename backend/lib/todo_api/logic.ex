defmodule TodoApi.Logic do
  @moduledoc """
  Núcleo PURO da aplicação.

  Todas as funções aqui:
    * recebem dados imutáveis e devolvem NOVOS dados (nunca alteram nada);
    * não fazem I/O, não guardam estado, não têm efeitos colaterais;
    * sinalizam sucesso/erro com tuplas `{:ok, valor}` / `{:error, motivo}`.

  Uma tarefa é apenas um mapa: `%{id: inteiro, title: string, completed: booleano}`.
  """

  @doc "Lista inicial de tarefas (mesma do frontend do professor)."
  def initial_todos do
    [
      %{id: 1, title: "Conhecer o contrato da API", completed: true},
      %{id: 2, title: "Implementar o primeiro paradigma", completed: false}
    ]
  end

  @doc "Valida o título: precisa ser string com conteúdo além de espaços."
  def validate_title(title) when is_binary(title) do
    title
    |> String.trim()
    |> then(fn
      "" -> {:error, :invalid_title}
      clean -> {:ok, clean}
    end)
  end

  def validate_title(_), do: {:error, :invalid_title}

  @doc "Próximo id = maior id + 1 (ou 1 se a lista estiver vazia)."
  def next_id([]), do: 1

  def next_id(todos) do
    todos
    |> Enum.map(& &1.id)
    |> Enum.max()
    |> Kernel.+(1)
  end

  @doc "Busca uma tarefa pelo id."
  def find(todos, id) do
    todos
    |> Enum.find(&(&1.id == id))
    |> case do
      nil -> {:error, :not_found}
      todo -> {:ok, todo}
    end
  end

  @doc "Cria uma tarefa. Devolve `{:ok, {nova_tarefa, nova_lista}}`."
  def add(todos, title) do
    with {:ok, clean} <- validate_title(title) do
      new_todo = %{id: next_id(todos), title: clean, completed: false}
      {:ok, {new_todo, todos ++ [new_todo]}}
    end
  end

  @doc "Alterna `completed`. Devolve `{:ok, {tarefa_atualizada, nova_lista}}`."
  def toggle(todos, id) do
    with {:ok, todo} <- find(todos, id) do
      updated = %{todo | completed: not todo.completed}
      {:ok, {updated, Enum.map(todos, &replace_if_same(&1, updated))}}
    end
  end

  @doc "Remove uma tarefa. Devolve `{:ok, nova_lista}`."
  def delete(todos, id) do
    with {:ok, _todo} <- find(todos, id) do
      {:ok, Enum.reject(todos, &(&1.id == id))}
    end
  end

  defp replace_if_same(%{id: id}, %{id: id} = updated), do: updated
  defp replace_if_same(todo, _updated), do: todo
end
