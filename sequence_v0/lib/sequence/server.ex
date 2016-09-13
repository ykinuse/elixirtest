defmodule Sequence.Server do
  use GenServer
  require Logger

  @vsn "1"
  defmodule State do
    defstruct [current_number: 0, stash_pid: nil, delta: 1]
  end

  ###
  # External API

  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def next_number do
    with number = GenServer.call(__MODULE__, :next_number),
    do: "The next number is #{number}"
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
    {:ok, %State{current_number: current_number, stash_pid: stash_pid, delta: 1}}
  end

  def handle_call(:next_number, _from, state) do
    {:reply, state.current_number, %{state | current_number: state.current_number + state.delta}}
  end

  def handle_call({:set_number, new_number}, _, state) do
    {:reply, new_number, %{state | current_number: new_number}}
  end

  def handle_cast({:increment_number, delta}, state) do
    {:noreply, %{state| current_number: state.current_number+delta, delta: delta}}
  end

  def handle_info(info, state) do
    IO.puts("#{inspect(info)}")
    {:noreply, state}
  end

  def terminate(reason, state) do
    Sequence.Stash.set_value(state.stash_pid, state.current_number)
    :ok
  end

  def code_change("0", old_state={current_number, stash_pid}, extra) do
    new_state = %State{current_number: current_number, stash_pid: stash_pid}
    Logger.info("Change from 0 to 1")
    Logger.info("Extra #{inspect(extra)}")
    Logger.info("old_state #{inspect(old_state)}")
    Logger.info("new_state #{inspect(new_state)}")
    {:ok, new_state}
  end
end
