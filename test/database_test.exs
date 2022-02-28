defmodule Todo.Database.Test do
  use ExUnit.Case, async: false

  alias Todo.Cache
  alias Todo.Server
  alias Todo.Database

  setup do
    {:ok, cache_server} = Cache.start()
    %{cache_server: cache_server}
  end

  test "get to-do server from cache server",  %{cache_server: cache_server} do
    shopping_todo_pid = Cache.server_process(cache_server, "database test")

    entry1 = %{date: "01-01-2020", description: "test1"}
    Server.add_entry(shopping_todo_pid, entry1)

    Database.stop()

    Database.start()

    shopping_todo_pid = Cache.server_process(cache_server, "database test")

    assert entries_2020 = Server.entries(shopping_todo_pid, "01-01-2020")

    assert length(entries_2020) == 1
  end
end
