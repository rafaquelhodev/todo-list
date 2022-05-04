defmodule Todo.Cache do
  require Logger

  alias Todo.Server
  use GenServer

  def start_link(_) do
    Logger.info("Starting cache server...")

    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(cache_pid, todo_list_name) do
    GenServer.call(cache_pid, {:server_process, todo_list_name})
  end

  @impl GenServer
  def init(_) do
    Todo.Database.start_link()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, new_server} = Server.start_link(todo_list_name)
        {:reply, new_server, Map.put(todo_servers, todo_list_name, new_server)}
    end
  end
end
