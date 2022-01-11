defmodule Seurat.Luv do
  @moduledoc """
  The CIELUV (L*u*v*) colorspace.

  Like CIELAB, CIELUV is a device-independent color space that aims to be
  perceptually uniform. In addition, and in contrast to CIELAB, CIELUV aims to
  be linear for a fixed lightness. That is, additive mixtures of colors at a
  fixed lightness will fall in a line on the CIELUV scale.

  ## Fields

  - `l` - the lightness of the color. 0.0 gives black and 100 gives white
  - `u` - the range of valid `u` values varies depending on the values of `l`
    and `v`, but its limits are the interval (-84, 176)
  - `v` - the range of valid `v` values varies depending on the values of `l`
    and `u`, but its limits are the interval (-135, 108)

  """

  defstruct [:l, :u, :v, :white_point]

  @type t :: %__MODULE__{
          l: float,
          u: float,
          v: float,
          white_point: Seurat.WhitePoint.t()
        }

  @doc """
  Creates a new CIELUV color

  ## Examples

      iex> Luv.new(50, -30, 100)
      #Seurat.Luv<50.0, -30.0, 100.0 (D65)>

  Values outside of the limits for each field will be clamped to their
  respective limits.

      iex> Luv.new(-1, 180, -135.5)
      #Seurat.Luv<0.0, 176.0, -135.0 (D65)>
  """
  def new(l, u, v, white_point \\ Seurat.WhitePoint.D65) do
    %__MODULE__{
      l: clamp(l, 0.0, 100.0),
      u: clamp(u, -84.0, 176.0),
      v: clamp(v, -135.0, 108.0),
      white_point: white_point
    }
  end

  defp clamp(n, min, max) do
    cond do
      n < min -> min
      n > max -> max
      true -> n / 1
    end
  end

  defimpl Seurat.Conversions.ToLuv do
    def to_luv(luv), do: luv
  end

  defimpl Seurat.Conversions.ToXyz do
    @e 0.008856
    @k 903.3

    def to_xyz(%{l: l, u: u, v: v, white_point: wp}) do
      denom = wp.x() + 15 * wp.y() + 3 * wp.z()
      v0 = 9 * wp.y() / denom
      u0 = 4 * wp.x() / denom

      y =
        if l > @k * @e do
          :math.pow((l + 16) / 116, 3)
        else
          l / @k
        end

      d = y * (39 * l / (v + 13 * l * v0) - 5)
      c = -1 / 3
      b = -5 * y
      a = 1 / 3 * (52 * l / (u + 13 * l * u0) - 1)

      x = (d - b) / (a - c)
      z = x * (a + b)

      Seurat.Xyz.new(x, y, z, wp)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{l: l, u: u, v: v, white_point: wp}, _) do
      concat([
        "#Seurat.Luv<",
        inspect_components([l, u, v]),
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
