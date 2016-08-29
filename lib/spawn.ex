defmodule Spawn do
  def test do
    receive do
      {pid, msg} ->
        IO.puts("#{inspect(pid)} #{msg}")
    end

    test
  end

  def run(n) do
    me = spawn(Spawn, :test, [])
    1..n
    |> Enum.map(fn(x)
      -> spawn(fn() -> send(me, {self, x}) end)
      end)
  end

  def test_send(sender, sequence) do
    send(sender, "#{sequence}")
  end

  def run_test_send(n) do
    0..n
    |> Enum.each(fn(x) -> spawn(Spawn, :test_send, [self, x]) end)
  end

  def receive do
    receive do
      msg ->
        IO.puts(msg)
    end
  end
end
