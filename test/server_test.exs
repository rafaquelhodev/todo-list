defmodule Todo.Server.Test do
  use ExUnit.Case, async: true

  alias Todo.Server
  alias Todo.Database

  setup do
    Database.start_link(folder: "./persist-test")

    on_exit(fn -> File.rm_rf!("./persist-test") end)

    {:ok, server} = Server.start_link("todo-test")
    %{server: server}
  end

  test "create to-do list", %{server: server} do
    entry1 = %{date: "01-01-2020", description: "test1"}
    entry2 = %{date: "01-01-2020", description: "test2"}
    entry3 = %{date: "01-01-2021", description: "test3"}
    Server.add_entry(server, entry1)
    Server.add_entry(server, entry2)
    Server.add_entry(server, entry3)

    assert entries_2020 = Server.entries(server, "01-01-2020")
    assert entries_2021 = Server.entries(server, "01-01-2021")

    assert length(entries_2020) == 2
    assert length(entries_2021) == 1
  end
end
