defmodule Todo.Database do
  @db_folder "./persist"

  def start_link do
    unless File.exists?(@db_folder) do
      File.mkdir!(@db_folder)
    end

    workers = Enum.map(1..3, &worker_specification/1)

    Supervisor.start_link(workers, strategy: :one_for_one)
  end

  def worker_specification(worker_id) do
    default_spec = {Todo.DatabaseWorker, {@db_folder, worker_id}}
    Supervisor.child_spec(default_spec, id: worker_id)
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    :erlang.phash2(key, 3) + 1
  end
end
