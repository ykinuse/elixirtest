defmodule Sequence.Server do
  use GenServer

  def handle_call(:next_number, _from, current_number) do
    {:reply, current_number, current_number + 1}
  end

  def handle_call({:set_number, new_number}, _, _) do
    {:reply, new_number, new_number}
  end

  def handle_call({:factors, number}, _, _) do
    {:reply, {:factor_of, number, number*2}, []}
  end
end
