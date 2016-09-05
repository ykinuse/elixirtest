defmodule Ticker do
  @interval 2000
  @name :ticker

  def test_with(n) do
    start
    1..n
    |> Enum.each(fn(_x) ->
      Client.start
      |> register
    end)
  end

  def start do
    case :global.whereis_name(@name) do
      :undefined ->
        pid = spawn(__MODULE__, :generator, [])
        :global.register_name(@name, pid)
      _ignored ->
    end
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
          all_clients ->
            IO.puts("tick")
            acc = if acc >= size do 0 else acc end
            all_clients
            |> Enum.at(acc)
            |> send({:tick})
            generator(all_clients, acc + 1, size)
        end
    end
  end
end

defmodule Client do
  def start do
    spawn(__MODULE__, :listen, [])
  end

  def listen do
    receive do
      {:tick} ->
        IO.puts("tock #{inspect(self)}")
        listen
      {:end} ->
        exit(:end)
    end
  end
end
