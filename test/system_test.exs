defmodule System.Test do
  use ExUnit.Case, async: true

  test "system starts database and cache" do
    shopping_todo_pid = Todo.Cache.server_process("shopping list")

    entry1 = %{date: "01-01-2020", description: "test1"}
    Todo.Server.add_entry(shopping_todo_pid, entry1)

    assert entries_2020 = Todo.Server.entries(shopping_todo_pid, "01-01-2020")

    assert length(entries_2020) == 1
  end
end
