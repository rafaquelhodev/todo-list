defmodule Registry.Test do
  use ExUnit.Case, async: false

  test "registry todo database worker" do
    Todo.System.start_link()

    [{old_worker_2_pid, _}] = Registry.lookup(Todo.Registry, {Todo.DatabaseWorker, 2})

    ## killing worker 2
    true = Process.exit(old_worker_2_pid, :kill)

    [{new_worker_2_pid, _}] = Registry.lookup(Todo.Registry, {Todo.DatabaseWorker, 2})

    assert old_worker_2_pid != new_worker_2_pid
  end
end
