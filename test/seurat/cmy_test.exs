defmodule Seurat.CmyTest do
  use Seurat.ColorTestCase, async: true

  alias Seurat.Cmy
  doctest Cmy

  describe "conversions" do
    property "to_cmy returns itself" do
      check all(
              cyan <- float(min: 0, max: 1),
              magenta <- float(min: 0, max: 1),
              yellow <- float(min: 0, max: 1)
            ) do
        cmy = Cmy.new(cyan, magenta, yellow)
        assert Seurat.to_cmy(cmy) == cmy
      end
    end

    test "to_rgb" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, srgb: expected, cmy: cmy} ->
        actual = Seurat.to_rgb(cmy)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to_cmyk" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, cmyk: expected, cmy: cmy} ->
        actual = Seurat.to_cmyk(cmy)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
