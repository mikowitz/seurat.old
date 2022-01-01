defmodule Seurat.Cmyk do
  @moduledoc """
  CMYK color model.

  The CMYK (Cyan, Magenta, Yellow, Key (black)) color model is an extension of
  the CMY color model. By adding black as a base ink color, this allows for
  printing deeper black and unsaturated colors with less ink, since it does not
  need to use a combination of cyan, magenta, and yellow.

  ## Fields

  The `Seurat.Cmyk` struct models its four fields

  * `cyan`
  * `magenta`
  * `yellow`
  * `black`

  as floats in the range [0, 1]. Values given outside of that range are clamped
  to that range upon creation.

  ## Conversion

  Because the appearance of CMYK colors is dependent on the ink used in the
  printing process, it is possible for different printer hardware and its ink
  to produce slightly different results, so there is not a true CMYK standard.
  However, to allow for simple digital manipulation of CMYK color values,
  `Seurat` provides a simple conversion formula between CMYK and sRGB color
  models so that CMYK color values taken from printing materials can be rendered
  digitally as accurately as is reasonable. RGB colors using a non-sRGB model
  must convert to sRGB before converting to CMYK.
  """

  defstruct [:cyan, :magenta, :yellow, :black]

  @type t :: %__MODULE__{
          cyan: float,
          magenta: float,
          yellow: float,
          black: float
        }

  @doc """
  Creates a new `CMYK` color from the given values

  ## Examples

      iex> Cmyk.new(0.05, 1, 0.3, 0.5)
      #Seurat.Cmyk<0.05, 1.0, 0.3, 0.5>

  Values outside the range [0, 1] are clamped to that range

      iex> Cmyk.new(0.05, 3, -1, 0.3)
      #Seurat.Cmyk<0.05, 1.0, 0.0, 0.3>

  """
  @spec new(number, number, number, number) :: __MODULE__.t()
  def new(cyan, magenta, yellow, black) do
    %__MODULE__{
      cyan: clamp(cyan),
      magenta: clamp(magenta),
      yellow: clamp(yellow),
      black: clamp(black)
    }
  end

  def clamp(n) when n < 0, do: 0.0
  def clamp(n) when n > 1, do: 1.0
  def clamp(n), do: n / 1

  defimpl Seurat.Conversions.ToCmyk do
    def to_cmyk(cmyk), do: cmyk
  end

  defimpl Seurat.Conversions.ToCmy do
    def to_cmy(%{cyan: c, magenta: m, yellow: y, black: k}) do
      c = c * (1 - k) + k
      m = m * (1 - k) + k
      y = y * (1 - k) + k

      Seurat.Cmy.new(c, m, y)
    end
  end

  defimpl Seurat.Conversions.ToRgb do
    def to_rgb(%{cyan: c, magenta: m, yellow: y, black: k}) do
      r = (1 - c) * (1 - k)
      g = (1 - m) * (1 - k)
      b = (1 - y) * (1 - k)

      Seurat.Rgb.SRgb.new(r, g, b)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{cyan: c, magenta: m, yellow: y, black: k}, _) do
      concat([
        "#Seurat.Cmyk<",
        Enum.map([c, m, y, k], &Float.round(&1, 4)) |> Enum.join(", "),
        ">"
      ])
    end
  end
end
