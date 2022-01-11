defmodule Seurat.Lch do
  @moduledoc """
  CIE L*C*h, a polar version of CIELAB.

  Lch shares the visual gamut and perceptual uniformity of L*a*b*, but is a
  cylindrical color shape, like HSV and HSL, which means it can be used to
  change the hue and saturation of a color while preserving its other visual
  aspects.

  ## Fields

  `l` - the lightness of the color. 0.0 gives absolute black and 100.0 gives
    the brightest white.
  `c` - the colorfulness (chroma) of the color. Similar to saturation. 0.0 gives
    gray colors, and values equal to or greater than 128 gives fully saturated
    colors. The range extends beyond 128, but 128 is a suitable upper limit for
    downsampling to sRGB or L*a*b*.
  `h` - the hue of the color in degrees.
  `white_point` - Associated white point of the color. Defaults to D65.

  """

  defstruct [:l, :c, :h, :white_point]

  @type t :: %__MODULE__{
          l: float,
          c: float,
          h: float,
          white_point: Seurat.WhitePoint.t()
        }

  @doc """
  Creates a new L*C*h color.

  ## Examples

      iex> Lch.new(50, 100, 100)
      #Seurat.Lch<50.0, 100.0, 100.0 (D65)>

  Values outside the defined ranges will be clamped to the range

      iex> Lch.new(-1, -1, 360)
      #Seurat.Lch<0.0, 0.0, 0.0 (D65)>

  """
  def new(l, c, h, white_point \\ Seurat.WhitePoint.D65) do
    %__MODULE__{
      l: clamp_l(l),
      c: clamp_c(c),
      h: clamp_h(h),
      white_point: white_point
    }
  end

  defp clamp_l(l) when l < 0, do: 0.0
  defp clamp_l(l) when l > 100, do: 100.0
  defp clamp_l(l), do: l / 1

  defp clamp_c(c) when c < 0, do: 0.0
  defp clamp_c(c), do: c / 1

  defp clamp_h(h) when h >= 360, do: :math.fmod(h, 360)
  defp clamp_h(h) when h < 0, do: clamp_h(h + 360)
  defp clamp_h(h), do: h / 1

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{l: l, c: c, h: h, white_point: wp}, _) do
      concat([
        "#Seurat.Lch<",
        inspect_components([l, c, h]),
        " (",
        inspect_white_point(wp),
        ")>"
      ])
    end

    defp inspect_components(components) do
      Enum.map(components, &Float.round(&1, 5))
      |> Enum.join(", ")
    end

    defp inspect_white_point(wp), do: Module.split(wp) |> List.last()
  end
end
