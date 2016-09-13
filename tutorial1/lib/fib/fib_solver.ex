defmodule FibSolver do
  def fib(scheduler) do
    send scheduler, {:ready, self}
    receive do
      {:fib, n, client} ->
        send(client, {:answer, n, fib_cal(n), self})
        fib(scheduler)
      {:shutdown} ->
        exit(:normal)
    end
  end

  def fib_cal(0), do: 0
  def fib_cal(1), do: 1
  def fib_cal(n) do
    fib_cal(n-1) + fib_cal(n-2)
  end
end
