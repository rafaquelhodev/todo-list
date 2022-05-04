defmodule Todo.DatabaseWorker do
  require Logger

  use GenServer

  def start(db_folder) do
    Logger.info("Starting database worker...")

    GenServer.start(__MODULE__, db_folder)
  end

  def store(pid, key, data) do
    GenServer.cast(pid, {:store, key, data})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
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
end