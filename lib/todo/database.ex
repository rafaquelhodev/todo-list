defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start(options \\ []) do
    GenServer.start(__MODULE__, options, name: __MODULE__)
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
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(_) do
    unless File.exists?(@db_folder) do
      File.mkdir!(@db_folder)
    end

    workers = start_workers()
    {:ok, workers}
  end

  # @impl GenServer
  # def handle_cast({:store, key, data}, state) do
  #   key
  #   |> file_name()
  #   |> File.write!(:erlang.term_to_binary(data))

  #   {:noreply, state}
  # end

  # @impl GenServer
  # def handle_call({:get, key}, _, state) do
  #   path = file_name(key)

  #   data =
  #     case File.read(path) do
  #       {:ok, content} -> :erlang.binary_to_term(content)
  #       {:error, _} -> nil
  #     end

  #   {:reply, data, state}
  # end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, workers) do
    worker_key = :erlang.phash2(key, 3)
    {:reply, Map.get(workers, worker_key), workers}
  end

  # defp file_name(key) do
  #   Path.join(@db_folder, to_string(key))
  # end

  defp start_workers() do
    for index <- 1..3, into: %{} do
      {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
      {index - 1, pid}
    end
  end
end
