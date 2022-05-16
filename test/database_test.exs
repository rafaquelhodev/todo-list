defmodule Todo.Database.Test do
  use ExUnit.Case, async: true

  alias Todo.Cache
  alias Todo.Server

  test "get to-do server from cache server" do
    shopping_todo_pid = Cache.server_process("database test")

    entry1 = %{date: "01-01-2020", description: "test1"}
    Server.add_entry(shopping_todo_pid, entry1)

    shopping_todo_pid = Cache.server_process("database test")

    assert entries_2020 = Server.entries(shopping_todo_pid, "01-01-2020")

    assert length(entries_2020) == 1
  end
end
