defmodule Todo.Server do
  require Logger

  alias Todo.List
  alias Todo.Database
  use GenServer

  def start_link(name) do
    Logger.info("Starting server for #{name}")

    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def entries(server_pid, date) do
    GenServer.call(server_pid, {:entries, date})
  end

  def add_entry(server_pid, new_entry) do
    GenServer.cast(server_pid, {:add_entry, new_entry})
  end

  @impl GenServer
  def init(name) do
    {:ok, {name, Database.get(name) || List.new()}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, List.entries(todo_list, date), {name, todo_list}}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_state = List.add_entry(todo_list, new_entry)
    Database.store(name, todo_list)
    {:noreply, {name, new_state}}
  end

  defp via_tuple(name) do
    Todo.Registry.via_tuple({__MODULE__, name})
  end
end
