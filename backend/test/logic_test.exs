defmodule TodoApi.LogicTest do
  use ExUnit.Case, async: true
  alias TodoApi.Logic

  test "add cria tarefa com próximo id sem alterar a lista original" do
    original = Logic.initial_todos()
    {:ok, {todo, new_list}} = Logic.add(original, "  Nova  ")
    assert todo == %{id: 3, title: "Nova", completed: false}
    assert length(new_list) == 3
    assert length(original) == 2
  end

  test "add rejeita título vazio" do
    assert Logic.add([], "   ") == {:error, :invalid_title}
    assert Logic.add([], nil) == {:error, :invalid_title}
  end

  test "toggle e delete" do
    todos = Logic.initial_todos()
    assert {:ok, {%{id: 2, completed: true}, _}} = Logic.toggle(todos, 2)
    assert {:ok, [%{id: 2}]} = Logic.delete(todos, 1)
    assert Logic.delete(todos, 99) == {:error, :not_found}
  end
end
