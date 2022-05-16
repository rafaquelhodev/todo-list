defmodule Registry.Test do
  use ExUnit.Case, async: true

  test "registry todo database worker" do
    [{old_worker_2_pid, _}] = Registry.lookup(Todo.Registry, {Todo.DatabaseWorker, 2})

    [{new_worker_2_pid, _}] = Registry.lookup(Todo.Registry, {Todo.DatabaseWorker, 2})

    assert old_worker_2_pid == new_worker_2_pid
  end
end
