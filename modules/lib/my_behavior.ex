defmodule My.Behavior do

  @callback test_integer() :: integer

  @callback test_param(list :: Keyword.t) :: binary
end
