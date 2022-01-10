defmodule Seurat.YxyTest do
  use Seurat.ColorTestCase, async: true

  alias Seurat.Yxy
  doctest Yxy

  describe "conversions" do
    property "to_yxy returns itself" do
      check all(
              x <- float(min: 0, max: 1.0),
              y <- float(min: 0, max: 1.0),
              luma <- float(min: 0, max: 1.0)
            ) do
        yxy = Yxy.new(x, y, luma)
        assert Seurat.to_yxy(yxy) == yxy
      end
    end

    test "to_xyz" do
      ColorMine.parse()
      |> Enum.map(fn %{color: color, yxy: yxy, xyz: expected} ->
        actual = Seurat.to_xyz(yxy)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
