defmodule Day08 do
  def run() do
    rows = Day08.input()

    outputs =
      rows
      |> Enum.flat_map(fn {_, output} -> output end)
      |> Enum.map(fn code -> String.length(code) end)
      |> Enum.frequencies()
      |> Enum.filter(fn {length, _amount} -> length in [2, 4, 3, 7] end)
      |> Enum.reduce(0, fn {_number, amount}, acc -> acc + amount end)

    IO.inspect(outputs, label: "Part 1")

    result =
      rows
      |> Enum.map(fn {input, row} ->
        letters_to_segment_index = letters_to_normalized_segments(input)
        digits = Enum.map(row, &word_to_digits(&1, letters_to_segment_index))
        number = Enum.join(digits, "") |> String.to_integer()
      end)
      |> Enum.sum()

    IO.inspect(result, label: "Part 2")
  end

  def input() do
    File.read!("day_8.txt")
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn row ->
      [input, output] = String.split(row, [" | "], trim: true)

      {
        String.split(input, " ", trim: true),
        String.split(output, " ", trim: true)
      }
    end)
  end

  def letters_to_normalized_segments(row) do
    frequencies = row |> Enum.join("") |> String.split("", trim: true) |> Enum.frequencies()
    lengths = row |> Enum.into(%{}, fn entry -> {String.length(entry), entry} end)

    map = %{
      2 => find_by_frequency(frequencies, 6),
      5 => find_by_frequency(frequencies, 4),
      6 => find_by_frequency(frequencies, 9)
    }

    one = Map.fetch!(lengths, 2) |> String.split("", trim: true)
    map = Map.put(map, 3, hd(one -- Map.values(map)))
    map = Map.put(map, 1, find_by_frequency(frequencies, 8, Map.values(map)))

    four = Map.fetch!(lengths, 4) |> String.split("", trim: true)
    map = Map.put(map, 4, hd(four -- Map.values(map)))
    map = Map.put(map, 7, find_by_frequency(frequencies, 7, Map.values(map)))

    Enum.into(map, %{}, fn {k, v} -> {v, k} end)
  end

  defp find_by_frequency(frequencies, value, ignores \\ []) do
    Enum.find_value(frequencies, fn {k, v} -> k not in ignores && v == value && k end)
  end

  defp find_by_length(row, length) do
    Enum.find(row, fn entry -> String.length(entry) == length end)
  end

  @segments %{
    [3, 6] => 1,
    [1, 3, 4, 5, 7] => 2,
    [1, 3, 4, 6, 7] => 3,
    [2, 3, 4, 6] => 4,
    [1, 2, 4, 6, 7] => 5,
    [1, 2, 4, 5, 6, 7] => 6,
    [1, 3, 6] => 7,
    [1, 2, 3, 4, 5, 6, 7] => 8,
    [1, 2, 3, 4, 6, 7] => 9,
    [1, 2, 3, 5, 6, 7] => 0
  }

  defp word_to_digits(word, index) do
    segments = word_to_segments(word, index, [])
    Map.fetch!(@segments, segments)
  end

  defp word_to_segments("", index, acc) do
    Enum.sort(acc)
  end

  defp word_to_segments(<<letter::binary-size(1)>> <> rest, index, acc) do
    word_to_segments(rest, index, [index[letter] | acc])
  end
end

Day08.run()
