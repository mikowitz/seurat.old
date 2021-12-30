defmodule Seurat.HslTest do
  use Seurat.ColorTestCase, async: true
  use ExUnitProperties
  import Seurat.ColorTestCase

  alias Seurat.Hsl
  alias Seurat.Rgb.Linear
  doctest Hsl

  describe "conversions" do
    property "to_hsl returns itself" do
      check all(
              hue <- float(min: 0, max: 359.99),
              saturation <- float(min: 0, max: 1),
              lightness <- float(min: 0, max: 1)
            ) do
        hsl = Hsl.new(hue, saturation, lightness)
        assert Seurat.to_hsl(hsl) == hsl
      end
    end

    test "to_rgb" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, srgb: expected, hsl: hsl} ->
        actual = Seurat.to_rgb(hsl)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to_hsv" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, hsl: hsl, hsv: expected} ->
        actual = Seurat.to_hsv(hsl)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
