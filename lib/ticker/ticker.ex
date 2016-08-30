defmodule Ticker do
  @interval 2000
  @name :ticker

  def test_with(n) do
    start
    1..n
    |> Enum.each(fn(x) ->
      x
      |> Client.start
      |> register
    end)
  end

  def start do
    pid = spawn(__MODULE__, :generator, [])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    :global.send(@name, {:register, client_pid})
  end

  def stop do
    :global.send(@name, {:end})
  end

  def generator(clients \\[], acc\\0, size\\0) do
    receive do
      {:register, client_pid} ->
        generator(clients ++ [client_pid], acc, size + 1)
      {:end} ->
        IO.puts("end")
        clients
        |> Enum.each(&(send(&1, {:end})))
        exit(:end)
      after @interval ->
        case clients do
          [] ->
            IO.puts("lonely tick")
            generator(clients, acc, size)
          all_clients when acc >= size ->
            IO.puts("tick")
            all_clients
            |> Enum.at(0)
            |> send({:tick})
            generator(all_clients, 1, size)
          all_clients ->
            IO.puts("tick")
            all_clients
            |> Enum.at(acc)
            |> send({:tick})
            generator(all_clients, acc + 1, size)
        end
    end
  end
end

defmodule Client do
  def start(n) do
    pid = spawn(__MODULE__, :listen, [n])
  end

  def listen(n) do
    receive do
      {:tick} ->
        IO.puts("tock #{n}")
        listen(n)
      {:end} ->
        exit(:end)
    end
  end
end
