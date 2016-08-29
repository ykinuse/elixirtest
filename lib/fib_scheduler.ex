defmodule FibScheduler do
  def rec_run(num_process, to_calculate) do
    Enum.each(1..num_process, fn(x) ->
      {time, result} = :timer.tc(
        FibScheduler,
        :run,
        [x, to_calculate]
      )

      if(num_process == 1) do
        IO.puts(inspect(result))
        IO.puts("\n time (s)#")
      end

      :io.format("~2B     ~.2f  ~s~n", [x, time/1_000_000.0, inspect(result)])
    end)
  end

  def run(num_process, to_calculate) do
    1..num_process
    |> Enum.map(fn(x) -> spawn(FibSolver, :fib, [self])  end)
    |> schedule_process(to_calculate)
  end

  def schedule_process(processes, to_calculate, results\\ []) do
    receive do
      {:ready, pid} when length(to_calculate) > 0->
        [head|tail] = to_calculate
        send(pid, {:fib, head, self})
        schedule_process(processes, tail, results)
      {:ready, pid} when length(processes) > 1 ->
        send(pid, {:shutdown})
        schedule_process(List.delete(processes, pid), to_calculate, results)
      {:ready, pid} ->
        send(pid, {:shutdown})
        Enum.sort(results, fn({n1, _}, {n2, _}) -> n1 <= n2  end)
      {:answer, number, result, _pid} ->
        schedule_process(processes, to_calculate, [{number, result} | results])
    end
  end
end
