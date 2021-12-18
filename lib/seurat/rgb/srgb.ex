defmodule Seurat.Rgb.SRgb do
  @moduledoc """
  Models an RGB color in non-linear sRGB space.

  See `Seurat.Rgb` for a complete discussion of linear vs non-linear color
  space.
  """

  use Seurat.Rgb.Colorspace

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
