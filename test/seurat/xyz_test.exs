defmodule Seurat.XyzTest do
  use Seurat.ColorTestCase, async: true

  alias Seurat.Xyz
  alias Seurat.WhitePoint.D65
  doctest Seurat.Xyz

  describe "conversions" do
    property "to_xyz returns itself" do
      check all(
              x <- float(min: 0, max: D65.x()),
              y <- float(min: 0, max: D65.y()),
              z <- float(min: 0, max: D65.z())
            ) do
        xyz = Xyz.new(x, y, z)
        assert Seurat.to_xyz(xyz) == xyz
      end
    end

    test "to_rgb" do
      ColorMine.parse()
      |> Enum.map(fn %{color: color, linear_rgb: expected, xyz: xyz} ->
        actual = Seurat.to_rgb(xyz)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to_yxy" do
      ColorMine.parse()
      |> Enum.map(fn %{color: color, yxy: expected, xyz: xyz} ->
        actual = Seurat.to_yxy(xyz)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
