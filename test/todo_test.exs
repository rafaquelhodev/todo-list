defmodule TodoTest do
  use ExUnit.Case

  test "creates todo list" do
    list =
      Todo.List.new([
        %{date: "01-01-2020", description: "teste"},
        %{date: "01-02-2021", description: "teste2"}
      ])

    assert list.auto_id == 3
    assert {:ok, _} = Map.fetch(list.entries, 1)
    assert {:ok, _} = Map.fetch(list.entries, 2)
  end

  test "gets todos by date" do
    list =
      Todo.List.new([
        %{date: "01-01-2020", description: "teste"},
        %{date: "01-01-2020", description: "teste3"},
        %{date: "01-02-2021", description: "teste2"}
      ])

    entries = Todo.List.entries(list, "01-01-2020")
    assert length(entries) == 2
  end
end
