defmodule Seurat.Rgb.Linear do
  @moduledoc """
  Models an RGB color in linear RGB space.

  See `Seurat.Rgb` for a complete discussion of linear vs non-linear color
  space.
  """

  use Seurat.Rgb.Colorspace

  @impl Seurat.Rgb.Colorspace
  def from_linear(linear), do: linear

  @impl Seurat.Rgb.Colorspace
  def to_linear(linear), do: linear
end
