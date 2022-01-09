defmodule Seurat.CmykTest do
  use Seurat.ColorTestCase, async: true

  alias Seurat.Cmyk
  doctest Cmyk

  describe "conversions" do
    property "to_cmyk returns itself" do
      check all(
              cyan <- float(min: 0, max: 1),
              magenta <- float(min: 0, max: 1),
              yellow <- float(min: 0, max: 1),
              black <- float(min: 0, max: 1)
            ) do
        cmyk = Cmyk.new(cyan, magenta, yellow, black)
        assert Seurat.to_cmyk(cmyk) == cmyk
      end
    end

    test "to_rgb" do
      ColorMine.parse()
      |> Enum.map(fn %{color: color, srgb: expected, cmyk: cmyk} ->
        actual = Seurat.to_rgb(cmyk)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to_cmy" do
      ColorMine.parse()
      |> Enum.map(fn %{color: color, cmy: expected, cmyk: cmyk} ->
        actual = Seurat.to_cmy(cmyk)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
