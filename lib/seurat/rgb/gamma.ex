defmodule Seurat.Rgb.Gamma do
  @moduledoc """
  Models an RGB color in non-linear gamma-corrected space.

  See `Seurat.Rgb` for a complete discussion of linear vs non-linear color
  space.
  """

  @n 2.2

  use Seurat.Rgb.Colorspace

  @impl Seurat.Rgb.Colorspace
  def from_linear(%Seurat.Rgb.Linear{red: r, green: g, blue: b}) do
    new(
      exp(r, @n),
      exp(g, @n),
      exp(b, @n)
    )
  end

  @impl Seurat.Rgb.Colorspace
  def to_linear(%Seurat.Rgb.Gamma{red: r, green: g, blue: b}) do
    Seurat.Rgb.Linear.new(
      exp(r, 1 / @n),
      exp(g, 1 / @n),
      exp(b, 1 / @n)
    )
  end

  defp exp(x, pow), do: :math.pow(x, pow)
end
