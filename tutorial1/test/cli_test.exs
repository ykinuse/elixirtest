defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import(Issues.CLI, only: [
    parse_args: 1,
    sort_ascending_by_created_date: 1,
    list_to_map: 1
    ])

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == { "user", "project", 99 }
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == { "user", "project", 4 }
  end

  test "sort ascending orders the correct way" do
    assert(sort_ascending_by_created_date(fake_created_at_list(~w{b c a})) == fake_created_at_list(~w{a b c}))
  end

  defp fake_created_at_list(values) do
    data = for value <- values, do: [{"created_at", value}, {"other_data", "test"}]
    list_to_map(data)
  end
end
