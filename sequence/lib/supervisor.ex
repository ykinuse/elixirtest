defmodule Sequence.Supervisor do
  use Supervisor

  def start_link(initial_number) do
    result = {:ok, pid} = Supervisor.start_link(__MODULE__, [initial_number])
    start_workers(pid, initial_number)
    result
  end

  def start_workers(pid, initial_number) do
    {:ok, stash} = Supervisor.start_child(pid, worker(Sequence.Stash, [initial_number]))
    Supervisor.start_child(pid, supervisor(Sequence.SubSupervisor, [stash]))
  end

  def init(_) do
    supervise([], strategy: :one_for_one)
  end
end
