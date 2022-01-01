defmodule Seurat.Rgb.SRgb do
  @moduledoc """
  Models an RGB color in non-linear sRGB space.

  See `Seurat.Rgb` for a complete discussion of linear vs non-linear color
  space.
  """

  use Seurat.Rgb.Colorspace

  defimpl Seurat.Conversions.ToCmy do
    def to_cmy(%{red: r, green: g, blue: b}) do
      Seurat.Cmy.new(1 - r, 1 - g, 1 - b)
    end
  end

  defimpl Seurat.Conversions.ToCmyk do
    def to_cmyk(%{red: r, green: g, blue: b}) do
      k = 1 - Enum.max([r, g, b])

      case k do
        1.0 ->
          Seurat.Cmyk.new(0, 0, 0, 1)

        _ ->
          c = (1 - r - k) / (1 - k)
          m = (1 - g - k) / (1 - k)
          y = (1 - b - k) / (1 - k)

          Seurat.Cmyk.new(c, m, y, k)
      end
    end
  end

  @impl Seurat.Rgb.Colorspace
  def from_linear(%Seurat.Rgb.Linear{red: r, green: g, blue: b}) do
    new(
      color_from_linear(r),
      color_from_linear(g),
      color_from_linear(b)
    )
  end

  @impl Seurat.Rgb.Colorspace
  def to_linear(%Seurat.Rgb.SRgb{red: r, green: g, blue: b}) do
    Seurat.Rgb.Linear.new(
      color_to_linear(r),
      color_to_linear(g),
      color_to_linear(b)
    )
  end

  defp color_from_linear(x) do
    if x <= 0.0031308 do
      x * 12.92
    else
      1.055 * :math.pow(x, 1 / 2.4) - 0.055
    end
  end

  defp color_to_linear(x) do
    if x <= 0.04045 do
      x / 12.92
    else
      :math.pow((x + 0.055) / 1.055, 2.4)
    end
  end
end
