defmodule Identicon do
  # 1st hash Input string
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    # edg eralng
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(
      pixel_map,
      fn {start, stop} -> :egd.filledRectangle(image, start, stop, fill) end
    )

    :egd.render(image)
  end

  # itterate and find x , y pixels
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(
        grid,
        fn {_code, index} ->
          horizontal = rem(index, 5) * 50
          vertical = div(index, 5) * 50

          top_left = {horizontal, vertical}
          bottom_right = {horizontal + 50, vertical + 50}

          {top_left, bottom_right}
        end
      )

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd(%Identicon.Image{grid: grid} = image) do
    Enum.filter(
      grid,
      fn {code, _index} ->
        # reminder / 2 => return 0 or 1
        rem(code, 2) == 0
      end
    )

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      # [[145, 46, 200], [3, 178, 206], [73, 228, 165], [65, 6, 141], [73, 90, 181]]
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    # [145, 46, 200] => [145, 46, 200,46,145]
    [first, secound | _tail] = row
    # append (++)
    row ++ [secound, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # %Identicon.Image{hex: hex_list} = image
    # [r, g, b | _tail] = hex_list
    # [r, g, b]
    %Identicon.Image{image | color: {r, g, b}}
    # for explain it
    # %Identicon.Image{
    #   hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112],
    #   color: nil
    # } =
    #   %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    # hash = :crypto.hash(:md, input)
    # :binary.bin_to_list(hash)
    # the same as above
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
