defmodule Sequence.Server do
  use GenServer

  ###
  # External API

  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def next_number do
    GenServer.call(__MODULE__, :next_number)
  end

  def set_number(new_number) do
    GenServer.call(__MODULE__, {:set_number, new_number})
  end

  def increment_number(delta) do
    GenServer.cast(__MODULE__, {:increment_number, delta})
  end

  def terminate(reason) do
    GenServer.stop(__MODULE__, reason)
  end

  ###
  # GenServer API
  def init(stash_pid) do
    current_number = Sequence.Stash.get_value(stash_pid)
    {:ok, {current_number, stash_pid}}
  end

  def handle_call(:next_number, _from, {current_number, stash_pid}) do
    {:reply, current_number, {current_number + 1, stash_pid}}
  end

  def handle_call({:set_number, new_number}, _, {current_number, stash_pid}) do
    {:reply, new_number, {new_number, stash_pid}}
  end

  def handle_cast({:increment_number, delta}, {current_number, stash_pid}) do
    {:noreply, {current_number + delta, stash_pid}}
  end

  def handle_info(info, state) do
    IO.puts("#{inspect(info)}")
    {:noreply, state}
  end

  def terminate(reason, {current_number, stash_pid}) do
    Sequence.Stash.set_value(stash_pid, current_number)
    :ok
  end
end
