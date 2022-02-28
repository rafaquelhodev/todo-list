defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start(options \\ []) do
    GenServer.start(__MODULE__, options, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def stop() do
    GenServer.stop(__MODULE__, :normal)
  end

  @impl GenServer
  def init(_) do
    unless File.exists?(@db_folder) do
      File.mkdir!(@db_folder)
    end

    {:ok, nil}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, state) do
    key
    |> file_name()
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:get, key}, _, state) do
    path = file_name(key)

    data =
      case File.read(path) do
        {:ok, content} -> :erlang.binary_to_term(content)
        {:error, _} -> nil
      end

    {:reply, data, state}
  end

  defp file_name(key) do
    Path.join(@db_folder, to_string(key))
  end
end
