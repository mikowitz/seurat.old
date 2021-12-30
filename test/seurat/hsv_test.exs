defmodule Seurat.HsvTest do
  use Seurat.ColorTestCase, async: true
  use ExUnitProperties

  import Seurat.ColorTestCase

  alias Seurat.Hsv
  alias Seurat.Rgb.Linear
  doctest Seurat.Hsv

  describe "conversions" do
    property "to_hsv returns itself" do
      check all(
              hue <- float(min: 0, max: 359.99),
              saturation <- float(min: 0, max: 1),
              value <- float(min: 0, max: 1)
            ) do
        hsv = Hsv.new(hue, saturation, value)
        assert Seurat.to_hsv(hsv) == hsv
      end
    end

    test "to_rgb" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, srgb: expected, hsv: hsv} ->
        actual = Seurat.to_rgb(hsv)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to_hsl" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, hsl: expected, hsv: hsv} ->
        actual = Seurat.to_hsl(hsv)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
