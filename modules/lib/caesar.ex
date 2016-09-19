defprotocol Caesar do
  def encrypt(string, shift)

  def rot13(string)
end

defimpl Caesar, for: [BitString, List] do

  def rot13(string) do
    encrypt(string, 13)
  end

  def encrypt(string, shift) do
    to_charlist(string)
    |> Enum.map(&(shift(&1, shift)))
  end

  defp shift(char, 0) do
    char
  end

  defp shift(?z, shift) do
    shift(?a, shift - 1)
  end

  defp shift(?Z, shift) do
    shift(?Z, shift - 1)
  end

  defp shift(char, shift) do
    shift(char + 1, shift - 1)
  end
end
