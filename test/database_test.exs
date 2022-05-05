defmodule Todo.Database.Test do
  use ExUnit.Case, async: false

  alias Todo.Cache
  alias Todo.Server
  alias Todo.Database

  setup do
    {:ok, system_server} = Todo.System.start_link()
    %{system_server: system_server}
  end

  test "get to-do server from cache server", %{system_server: system_server} do
    cache_pid = Process.whereis(Todo.Cache)

    shopping_todo_pid = Cache.server_process(cache_pid, "database test")

    entry1 = %{date: "01-01-2020", description: "test1"}
    Server.add_entry(shopping_todo_pid, entry1)

    Database.stop()

    Database.start_link(nil)

    shopping_todo_pid = Cache.server_process(cache_pid, "database test")

    assert entries_2020 = Server.entries(shopping_todo_pid, "01-01-2020")

    assert length(entries_2020) == 1
  end
end
