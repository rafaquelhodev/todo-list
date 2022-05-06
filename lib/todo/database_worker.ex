defmodule Todo.DatabaseWorker do
  require Logger

  use GenServer

  def start_link({db_folder, worker_id}) do
    Logger.info("Starting database worker...")

    GenServer.start_link(__MODULE__, db_folder, name: via_tuple(worker_id))
  end

  def store(worker_id, key, data) do
    GenServer.cast(via_tuple(worker_id), {:store, key, data})
  end

  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    db_folder
    |> file_name(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  @impl GenServer
  def handle_call({:get, key}, _, db_folder) do
    path = file_name(db_folder, key)

    data =
      case File.read(path) do
        {:ok, content} -> :erlang.binary_to_term(content)
        {:error, _} -> nil
      end

    {:reply, data, db_folder}
  end

  defp file_name(folder, key) do
    Path.join(folder, to_string(key))
  end

  defp via_tuple(key) do
    Todo.Registry.via_tuple({__MODULE__, key})
  end
end
