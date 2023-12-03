defmodule Day01 do
  require ExUnit.Assertions
  import ExUnit.Assertions

  @input File.read!("day_01.txt")

  def run() do
    example =
      """
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
      """
    assert part_1(example) == 142
    IO.inspect(part_1(@input), label: "Part 1")

    example =
      """
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
      """
    assert part_2(example) == 281
    IO.inspect(part_2(@input), label: "Part 2")
  end

  def part_1(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      for codepoint <- String.to_charlist(line),
        codepoint >= 48,
        codepoint <= 57 do
          codepoint - 48
      end
    end)
    |> Enum.reduce(0, fn line, acc ->
      first = List.first(line) || 0
      last = List.last(line) || 0

      acc + first * 10 + last
    end)
  end

  @patterns ~w(one two three four five six seven eight nine)
  def part_2(input) do
    input
    |> String.replace(@patterns, fn number -> to_string(Enum.find_index(@patterns, & &1 == number) + 1) end)
    |> part_1()
  end
end

Day01.run()
