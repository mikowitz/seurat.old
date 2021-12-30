defmodule Seurat.Rgb do
  @moduledoc """
  `Seurat` provides models for three different types of RGB colors:

  * [`SRgb`](`Seurat.Rgb.SRgb`) - a non-linear RGB used for screen displays and
    digital media.  The non-linearity accounts for the fact that our eyes are
    more sensitive to color variation at low intensities (near black) than at
    high intensities (near white). When people talk about "RGB", this is almost
    always what they mean.
  * [`Linear`](`Seurat.Rgb.Linear`) - a linear RGB, meaning the the relationship
    between the stored color values and the resulting color intensity is a
    linear one. This model is used for adding or multiplying color intensities,
    because those operations will have the expected arithmetic results.
  * [`Gamma`](`Seurat.Rgb.Gamma`) - a non-linear RGB with a constant gamma value
    of 2.2. This value roughly estimates the gamma value fof most displays, and
    is a less computationally intensive, though inexact, approximation of the
    sRGB transfer function.

  If you are performing color manipulation on an image, it was mostly likely
  encoded in sRGB, so you would follow these steps:

  `decode from image -> convert to linear -> perform operations -> convert from
  linear -> encode to image`

  Reapplying the non-linear transfer function after color arithmetic will ensure
  the resulting image displays correctly when viewed.

  For a more in-depth discussion of the RGB color spaces and (non-)linearity,
  [Wikipedia's article on sRGB](https://en.wikipedia.org/wiki/SRGB) is a good
  place to start.

  ## Examples

  The functions `linear/3`, `srgb/3`, and `gamma/3` are used to create RGB
  colors in their respective encodings. The values given to each function are
  the values stored in the struct.

      iex> Rgb.linear(0.5, 0.0, 1.0)
      #Seurat.Rgb.Linear<0.5, 0.0, 1.0>

      iex> Rgb.srgb(0.5, 0.0, 1.0)
      #Seurat.Rgb.SRgb<0.5, 0.0, 1.0>

      iex> Rgb.gamma(0.5, 0.0, 1.0)
      #Seurat.Rgb.Gamma<0.5, 0.0, 1.0>

  We see the differences between these three colors more clearly when we convert
  each of them to `Rgb.Linear`

      iex> Rgb.linear(0.5, 0.0, 1.0) |> Rgb.to_linear()
      #Seurat.Rgb.Linear<0.5, 0.0, 1.0>

      iex> Rgb.srgb(0.5, 0.0, 1.0) |> Rgb.to_linear()
      #Seurat.Rgb.Linear<0.214, 0.0, 1.0>

      iex> Rgb.gamma(0.5, 0.0, 1.0) |> Rgb.to_linear()
      #Seurat.Rgb.Linear<0.7297, 0.0, 1.0>

  or converting a linear color into one of the non-linear spaces

      iex> Rgb.linear(0.5, 0.0, 1.0) |> Rgb.Linear.from_linear()
      #Seurat.Rgb.Linear<0.5, 0.0, 1.0>

      iex> Rgb.linear(0.5, 0.0, 1.0) |> Rgb.SRgb.from_linear()
      #Seurat.Rgb.SRgb<0.7354, 0.0, 1.0>

      iex> Rgb.linear(0.5, 0.0, 1.0) |> Rgb.Gamma.from_linear()
      #Seurat.Rgb.Gamma<0.2176, 0.0, 1.0>

  The displayed values here are rounded to 4 decimal places, but they are stored
  in the struct unrounded.
  """

  alias Seurat.Rgb.{Gamma, Linear, SRgb}

  @type color :: Gamma.t() | Linear.t() | SRgb.t()

  @doc """
  Creates a linear RGB color from the given tristimulus values
  """
  @spec linear(number, number, number) :: Linear.t()
  def linear(r, g, b) do
    Linear.new(r, g, b)
  end

  @doc """
  Creates a non-linear sRGB color from the given tristimulus values
  """
  @spec srgb(number, number, number) :: SRgb.t()
  def srgb(r, g, b) do
    SRgb.new(r, g, b)
  end

  @doc """
  Creates a non-linear gamma-corrected sRGB color from the given
  tristimulus values
  """
  @spec gamma(number, number, number) :: Gamma.t()
  def gamma(r, g, b) do
    Gamma.new(r, g, b)
  end

  @doc """
  Converts the given RGB color into linear RGB space
  """
  @spec to_linear(color) :: Linear.t()
  def to_linear(color) do
    color.__struct__.to_linear(color)
  end
end
