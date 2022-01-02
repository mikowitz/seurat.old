defmodule Seurat.RgbTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  import Seurat.ColorTestCase

  alias Seurat.Rgb
  alias Rgb.{Gamma, Linear, SRgb}
  doctest Rgb

  describe "conversions" do
    property "to_rgb returns itself" do
      check all(
              red <- float(min: 0, max: 1),
              green <- float(min: 0, max: 1),
              blue <- float(min: 0, max: 1)
            ) do
        srgb = SRgb.new(red, green, blue)
        assert Seurat.to_rgb(srgb) == srgb

        gamma = Gamma.new(red, green, blue)
        assert Seurat.to_rgb(gamma) == gamma

        linear = Linear.new(red, green, blue)
        assert Seurat.to_rgb(linear) == linear
      end
    end

    test "to_hsv" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, srgb: rgb, hsv: expected} ->
        actual = Seurat.to_hsv(rgb)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to_hsl" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, srgb: rgb, hsl: expected} ->
        actual = Seurat.to_hsl(rgb)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to_cmy" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, srgb: rgb, cmy: expected} ->
        actual = Seurat.to_cmy(rgb)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to_cmyk" do
      Seurat.DataMineData.parse()
      |> Enum.map(fn %{color: color, srgb: rgb, cmyk: expected} ->
        actual = Seurat.to_cmyk(rgb)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
