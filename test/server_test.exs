defmodule Todo.Server.Test do
  use ExUnit.Case, async: true

  alias Todo.Server

  setup do
    {:ok, server} = Server.start
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
