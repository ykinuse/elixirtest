defmodule Tracer.Impl do
  use Tracer

  def test when true do
    123
  end

  def add_list_with_guard(list) when length(list) > 3 do
    Enum.reduce(list, 0, &(&1 + &2))
  end
end
