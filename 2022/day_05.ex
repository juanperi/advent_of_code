defmodule Day05 do
  require ExUnit.Assertions
  import ExUnit.Assertions

  @input File.read!("day_05.txt")
  @test_input File.read!("day_05_test.txt")

  def run() do
    assert part_1(@test_input) == "CMZ"
    IO.inspect(part_1(@input), label: "Part 1:")

    assert part_2(@test_input) == "MCD"
    IO.inspect(part_2(@input), label: "Part 2:")
  end

  def part_1(input) do
    %{stacks: stacks, movements: movements} = input |> reshape()

    stacks
    |> process_movements(movements, :one_by_one)
    |> get_top_crates()
    |> Enum.join()
  end

  def part_2(input) do
    %{stacks: stacks, movements: movements} = input |> reshape()

    stacks
    |> process_movements(movements, :many_at_once)
    |> get_top_crates()
    |> Enum.join()
  end

  defp reshape(input) do
    [stacks, movements] = String.split(input, "\n\n", trim: true)

    %{
      stacks: parse_stacks(stacks),
      movements: parse_movements(movements)
    }
  end

  defp parse_stacks(stacks) do
    stacks
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split("", trim: true)
    end)
    |> Enum.reverse()
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.reject(fn [first | _] -> first == " " end)
    |> Enum.into(%{}, fn [id | crates] ->
      {String.to_integer(id), crates |> Enum.reject(&(&1 == " ")) |> Enum.reverse()}
    end)
  end

  defp parse_movements(movements) do
    movements
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.scan(~r/\d+/, &1))
    |> Enum.map(fn matches -> matches |> List.flatten() |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn [count, from, to] -> %{count: count, from: from, to: to} end)
  end

  defp process_movements(stacks, movements, type) do
    Enum.reduce(movements, stacks, &process_movement(&1, &2, type))
  end

  defp process_movement(%{count: count}, stacks, _type) when count == 0 do
    stacks
  end

  defp process_movement(movement, stacks, type) do
    count =
      case type do
        :one_by_one -> 1
        :many_at_once -> movement.count
      end

    {crates_to_move, rest} = Enum.split(stacks[movement.from], count)
    stacks = put_in(stacks, [movement.to], List.flatten([crates_to_move | stacks[movement.to]]))
    stacks = put_in(stacks, [movement.from], List.wrap(rest))
    process_movement(%{movement | count: movement.count - count}, stacks, type)
  end

  defp get_top_crates(stacks) do
    stacks_count = length(Map.keys(stacks))

    for stack_index <- 1..stacks_count do
      List.first(Map.get(stacks, stack_index))
    end
  end
end

Day05.run()
