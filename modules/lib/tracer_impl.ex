defmodule Tracer.Impl do
  use Tracer

  def_sub_module(Impl2)

  def test do
    "test"
  end

  def test(n) when n == 2 do
    n
  end

  def add_list_with_guard(list)
  when is_list(list) and length(list) > 3  do
    Enum.reduce(list, 0, &(&1 + &2))
  end

  defmodule Test2 do
    def test(), do: "test"
  end
end
