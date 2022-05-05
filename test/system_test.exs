defmodule System.Test do
  use ExUnit.Case, async: false

  setup do
    {:ok, system_server} = Todo.System.start_link()
    %{system_server: system_server}
  end

  test "system starts database and cache", %{system_server: system_server} do
    cache_pid = Process.whereis(Todo.Cache)

    shopping_todo_pid = Todo.Cache.server_process(cache_pid, "shopping list")

    entry1 = %{date: "01-01-2020", description: "test1"}
    Todo.Server.add_entry(shopping_todo_pid, entry1)

    assert entries_2020 = Todo.Server.entries(shopping_todo_pid, "01-01-2020")

    assert length(entries_2020) == 1
  end
end
