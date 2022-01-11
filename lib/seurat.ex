defmodule Seurat do
  @moduledoc """
  Seurat provides a pure Elixir library for color management and conversion.

  Named for Georges Seurat, whose pointillist style provides an early analogue
  for pixel-based digital imagery, this library provides the ability to create
  colors in a number of colorspaces, modify those colors, and convert them
  between colorspaces.

  The following colorspaces are supported, each of which is described in more
  detail in its own module:

  * [RGB](`Seurat.Rgb`)
  * [HSV](`Seurat.Hsv`)
  * [HSL](`Seurat.Hsl`)
  """

  def to_rgb(color) do
    Seurat.Conversions.ToRgb.to_rgb(color)
  end

  def to_hsv(color) do
    Seurat.Conversions.ToHsv.to_hsv(color)
  end

  def to_hsl(color) do
    Seurat.Conversions.ToHsl.to_hsl(color)
  end

  defdelegate to_cmy(color), to: Seurat.Conversions.ToCmy
  defdelegate to_cmyk(color), to: Seurat.Conversions.ToCmyk
  defdelegate to_xyz(color), to: Seurat.Conversions.ToXyz
  defdelegate to_yxy(color), to: Seurat.Conversions.ToYxy
  defdelegate to_lab(color), to: Seurat.Conversions.ToLab
  defdelegate to_luv(color), to: Seurat.Conversions.ToLuv
end
