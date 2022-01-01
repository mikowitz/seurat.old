defmodule Seurat.Cmy do
  @moduledoc """
  CMY color model.

  The CMY (Cyan, Magenta, Yellow) color model is a subtractive
  model used in color printing. It works by reducing the red, green, and blue
  light that is reflected from the printing surface, hence a "subtractive"
  model. White light minus red leave cyan, white minus green leaves magenta,
  and white minus blue leaves yellow. Subtracting all three results in full
  black. This can be shown in pseudo-color arithmetic below

  ```
  # white            red                cyan
  RGB.new(1, 1, 1) - RGB.new(1, 0, 0) = RGB.new(0, 1, 1)
  ```

  ## Fields

  The `Seurat.Cmy` struct models its three fields

  * `cyan`
  * `magenta`
  * `yellow`

  as floats in the range [0, 1]. Values given outside of that range are clamped
  to that range upon creation.

  ## Conversion

  Because the appearance of CMY colors is dependent on the ink used in the
  printing process, it is possible for different printer hardware and its ink
  to produce slightly different results, so there is not a true CMY standard.
  However, to allow for simple digital manipulation of CMY color values,
  `Seurat` provides a simple conversion formula between CMY and sRGB color
  models so that CMY color values taken from printing materials can be rendered
  digitally as accurately as is reasonable. RGB colors using a non-sRGB model
  must convert to sRGB before converting to CMY.
  """

  defstruct [:cyan, :magenta, :yellow]

  @type t :: %__MODULE__{
          cyan: float,
          magenta: float,
          yellow: float
        }

  @doc """
  Creates a new `CMY` color from the given values

  ## Examples

      iex> Cmy.new(0.05, 1, 0.3)
      #Seurat.Cmy<0.05, 1.0, 0.3>

  Values outside the range [0, 1] are clamped to that range

      iex> Cmy.new(0.05, 3, -1)
      #Seurat.Cmy<0.05, 1.0, 0.0>

  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(cyan, magenta, yellow) do
    %__MODULE__{
      cyan: clamp(cyan),
      magenta: clamp(magenta),
      yellow: clamp(yellow)
    }
  end

  def clamp(n) when n < 0, do: 0.0
  def clamp(n) when n > 1, do: 1.0
  def clamp(n), do: n / 1

  defimpl Seurat.Conversions.ToRgb do
    def to_rgb(%{cyan: c, magenta: m, yellow: y}) do
      Seurat.Rgb.SRgb.new(1 - c, 1 - m, 1 - y)
    end
  end

  defimpl Seurat.Conversions.ToCmy do
    def to_cmy(cmy), do: cmy
  end

  defimpl Seurat.Conversions.ToCmyk do
    def to_cmyk(%{cyan: c, magenta: m, yellow: y}) do
      k = Enum.min([c, m, y])

      if k == 1.0 do
        Seurat.Cmyk.new(0, 0, 0, 1)
      else
        c = (c - k) / (1 - k)
        m = (m - k) / (1 - k)
        y = (y - k) / (1 - k)
        Seurat.Cmyk.new(c, m, y, k)
      end
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{cyan: c, magenta: m, yellow: y}, _) do
      concat([
        "#Seurat.Cmy<",
        Enum.map([c, m, y], &Float.round(&1, 4)) |> Enum.join(", "),
        ">"
      ])
    end
  end
end
