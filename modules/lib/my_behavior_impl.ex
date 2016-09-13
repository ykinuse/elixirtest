defmodule My.Behavior.Impl do
  @behaviour My.Behavior

  def test_integer do
    1
  end

  def test_param(list) do
    list
  end
end
