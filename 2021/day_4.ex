defmodule Board do
  defstruct [:index, :row_count, :column_count, :sum, :winner]

  @line_count (for line <- 0..4 do
                 {line, 5}
               end)
              |> Enum.into(%{})

  def new(matrix) do
    board_index =
      for {row, row_idx} <- Enum.with_index(matrix),
          {value, column_idx} <- Enum.with_index(row) do
        {value, {row_idx, column_idx}}
      end
      |> Enum.into(%{})

    sum = board_index |> Map.keys() |> Enum.sum()

    %__MODULE__{
      index: board_index,
      row_count: @line_count,
      column_count: @line_count,
      sum: sum,
      winner: false
    }
  end

  def draw(board, number) do
    if index = board.index[number] do
      {row, column} = index
      row_count = update_in(board.row_count, [row], &(&1 - 1))
      column_count = update_in(board.column_count, [column], &(&1 - 1))

      %{
        board
        | row_count: row_count,
          column_count: column_count,
          column_count: update_in(board.column_count, [column], &(&1 - 1)),
          sum: board.sum - number,
          winner: board.winner || row_count[row] == 0 || column_count[column] == 0
      }
    else
      board
    end
  end
end

defmodule Support do
  def input() do
    rows =
      File.read!("day_4.txt")
      |> String.split("\n", trim: true)

    [draws | boards] = rows

    draws =
      draws
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      boards
      |> Enum.map(fn row ->
        row |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.chunk_every(5)
      |> Enum.map(fn board ->
        Board.new(board)
      end)

    {draws, boards}
  end
end

defmodule Main do
  def run() do
    {draws, boards} = Support.input()

    {winner, draw} =
      Enum.reduce_while(
        draws,
        boards,
        fn draw, boards ->
          boards = Enum.map(boards, &Board.draw(&1, draw))
          winner = Enum.find(boards, & &1.winner)

          if winner do
            {:halt, {winner, draw}}
          else
            {:cont, boards}
          end
        end
      )

    IO.inspect(winner.sum * draw, label: "Part 1")

    {_, winner, draw} =
      Enum.reduce(
        draws,
        {boards, nil, nil},
        fn draw, {boards, last_winner, last_draw} ->
          boards = Enum.map(boards, &Board.draw(&1, draw))
          {winners, boards_left} = Enum.split_with(boards, & &1.winner)
          winner = List.last(winners)

          if winner do
            {boards_left, winner, draw}
          else
            {boards_left, last_winner, last_draw}
          end
        end
      )

    IO.inspect(winner.sum * draw, label: "Part 2")
  end
end

Main.run()
