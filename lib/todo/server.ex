defmodule Todo.Server do
  alias Todo.List
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def entries(server_pid, date) do
    GenServer.call(server_pid, {:entries, date})
  end

  def add_entry(server_pid, new_entry) do
    GenServer.cast(server_pid, {:add_entry, new_entry})
  end

  @impl GenServer
  def init(_) do
    {:ok, List.new()}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, todo_list) do
    {:reply, List.entries(todo_list, date), todo_list}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, todo_list) do
    new_state = List.add_entry(todo_list, new_entry)
    {:noreply, new_state}
  end
end
