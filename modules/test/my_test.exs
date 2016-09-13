defmodule MyTest do
  use ExUnit.Case

  test "macro if" do
    require My
    assert (My.if 1+1 == 2, do: "hello", else: "world") == "hello"
  end

  test "macro unless" do
    require My
    assert (My.unless 1+1 != 2, do: "hello") == "hello"
    value = My.unless 1+1 != 2 do
      "hello"
    end
    assert value == "hello"
  end

  require My
  My.times_n(3)

  test "macro times" do
    assert times_3(3) == 9
  end

  test "macro q" do
    assert My.q(1) == 1
  end
end
