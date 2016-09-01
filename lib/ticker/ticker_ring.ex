defmodule Ticker.Ring do
  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :client, [])
    :global.register_name(@name, pid)
  end

  def spawn_client do
    :global.whereis_name(@name)
    |> send({:add_new})
  end

  def client(first_pid\\nil, last_pid\\nil, acc\\[]) do
    receive do
      {:add_new} when is_pid(last_pid) ->
        pid = spawn(__MODULE__, :ticker, [first_pid])
        send(last_pid, {:next, pid})
        IO.puts("Created new client #{inspect(pid)}")
        client(first_pid, pid, [pid | acc])
      {:add_new} ->
        pid = spawn(__MODULE__, :ticker, [])
        send(pid, {:tick})
        IO.puts("Created first client #{inspect(pid)}")
        client(pid, pid, [pid | acc])
      {:end} ->
        acc
        |> Enum.each(&(send(&1, {:end})))
        exit(:end)
    end
  end

  def ticker(next_pid\\ self, tick\\false) do
    receive do
      {:next, new_pid} ->
        IO.puts("Updating #{inspect(self)} next from #{inspect(next_pid)} to #{inspect(new_pid)}")
        ticker(new_pid, tick)
      {:tick} ->
        IO.puts("tock from #{inspect(self)}")
        ticker(next_pid, true)
      {:end} ->
        exit(:end)
      after @interval ->
        if tick do
          IO.puts("tick from #{inspect(self)}")
          send(next_pid, {:tick})
        end

        ticker(next_pid, false)
    end
  end
end
