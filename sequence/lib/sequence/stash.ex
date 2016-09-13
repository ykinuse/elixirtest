defmodule Sequence.Stash do
  use GenServer

  def start_link(initial_number) do
    {:ok, pid} = GenServer.start_link(__MODULE__, initial_number)
  end

  def get_value(pid) do
    GenServer.call(pid, :get)
  end

  def set_value(pid, number) do
    GenServer.cast(pid, {:set, number})
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:set, new_number}, state) do
    {:noreply, new_number}
  end
end
