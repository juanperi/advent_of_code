defmodule Day06 do
  require ExUnit.Assertions
  import ExUnit.Assertions

  @input File.read!("day_06.txt")

  def run() do
    assert part_1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
    assert part_1("nppdvjthqldpwncqszvftbrmjlhg") == 6
    assert part_1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
    IO.inspect(part_1(@input), label: "Part 1")

    assert part_2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
    assert part_2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
    IO.inspect(part_2(@input), label: "Part 2")
  end

  def part_1(input) do
    find_marker(input, 4, 4)
  end

  def part_2(input) do
    find_marker(input, 14, 14)
  end

  defp find_marker(string, position, group_size) do
    <<marker_head, current_marker::binary-size(group_size - 1), rest::binary>> = string

    if has_repeated?(<<marker_head, current_marker::binary>>) do
      find_marker(<<current_marker::binary, rest::binary>>, position + 1, group_size)
    else
      position
    end
  end

  defp has_repeated?(<<>>), do: false

  defp has_repeated?(<<first, rest::binary>>) do
    if String.contains?(rest, <<first>>) do
      true
    else
      has_repeated?(rest)
    end
  end
end

Day06.run()
