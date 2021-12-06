defmodule Support do
  def input() do
    File.read!("day_6.txt")
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def group_by_days(fish) do
    Enum.frequencies(fish)
  end

  def process_days(acc, 0) do
    acc
  end

  def process_days(acc, days) do
    process_days(one_day(acc), days - 1)
  end

  def one_day(acc) do
    for {days_left, count} <- acc do
      if days_left == 0 do
        [
          {8, count},
          {6, count}
        ]
      else
        {days_left - 1, count}
      end
    end
    |> List.flatten()
    |> Enum.reduce(
      %{},
      fn {days_left, count}, acc ->
        Map.update(
          acc,
          days_left,
          count,
          fn existing -> existing + count end
        )
      end
    )
  end

  def count(day) do
    Enum.reduce(
      day,
      0,
      fn {_, v}, total -> total + v end
    )
  end
end

defmodule Main do
  def run() do
    initial =
      Support.input()
      |> Support.group_by_days()

    last_day = Support.process_days(initial, 80)
    IO.inspect(Support.count(last_day), label: "Part 1")

    last_day = Support.process_days(initial, 256)
    IO.inspect(Support.count(last_day), label: "Part 2")
  end
end

Main.run()
