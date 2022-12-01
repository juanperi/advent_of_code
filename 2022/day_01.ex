defmodule Day01 do
  def run() do
    input = Support.input()
    result =
      input
      |> Enum.map(&Enum.sum/1)
      |> Enum.max()

    IO.inspect(result, label: "Part 1")

    result =
      input
      |> Enum.map(&Enum.sum/1)
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.sum()

    IO.inspect(result, label: "Part 2")
  end
end

defmodule Support do
  def input() do
    File.read!("day_01.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end

Day01.run()
