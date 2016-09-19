defprotocol My.Protocol do
  def print(x)
end

defimpl My.Protocol, for: Integer do
  def print(x) do
    IO.puts("Integer #{inspect(x)}")
  end
end

defimpl My.Protocol, for: List do
  def print(x) do
    IO.puts("List #{inspect(x)}")
  end
end

defimpl My.Protocol, for: BitString do
  def print(x) do
    IO.puts("String #{inspect(x)}")
  end
end
