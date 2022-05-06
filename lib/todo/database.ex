defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
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

  def stop() do
    GenServer.stop(__MODULE__, :normal)
  end

  defp choose_worker(key) do
    :erlang.phash2(key, 3) + 1
  end

  @impl GenServer
  def init(_) do
    unless File.exists?(@db_folder) do
      File.mkdir!(@db_folder)
    end

    workers = start_workers()
    {:ok, workers}
  end

  defp start_workers() do
    for index <- 1..3, into: %{} do
      Todo.DatabaseWorker.start_link({@db_folder, index})
    end
  end
end
