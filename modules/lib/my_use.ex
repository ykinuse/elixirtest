defmodule My.Test do
  def test_if do
    require My
    My.if 1 == 2 do
      IO.puts("hello")
    else
      IO.puts("world")
    end
  end

  def test_unless do
    require My
    My.unless 1 == 2, do: IO.puts("1 == 1")
  end

  def test_if do
    require My
    My.unless 1 == 2, do: IO.puts("1 == 1")
  end

  require My
  My.times_n(3)

end
