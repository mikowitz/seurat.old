defmodule Seurat.Yxy do
  @moduledoc """
  The CIE 193 Yxy (also abbreviated XyY) color space.

  This is a luminance-chromaticity color space derived from `Seurat.Xyz`, and is
  widely used to define colors. The CIE chromaticity diagram is a plot of the x
  and y values of this colorspace.

  Like the XYZ colorspace it also requires a standard illuminant. It defaults to
  the D65 for CIE 2° observer.

  ## Fields

  `x` - the x chromacity coordinate. Typical range is between 0 and 1.
  `y` - the y chromacity coordinate. Typical range is between 0 and 1.
  `luma` - (Y) is the measure of brightness of the color. Its range is 0 (black)
    to 1 (white)
  * `white_point` - the white point representing the color's illuminant and
    observer. By default this is D65 for 2° observer
  """

  defstruct [:x, :y, :luma, :white_point]

  @type t :: %__MODULE__{
          x: float,
          y: float,
          luma: float,
          white_point: Seurat.WhitePoint.t()
        }

  @doc """
  Creates a new Yxy color from the given values and optional white point.

  ## Examples

      iex> Yxy.new(0.5, 0.5, 0.5)
      #Seurat.Yxy<0.5, 0.5, 0.5 (D65)>

  Values outside the range [0, 1] will be clamped to that range

      iex> Yxy.new(-0.5, 0.5, 1.05)
      #Seurat.Yxy<0.0, 0.5, 1.0 (D65)>

  """
  def new(x, y, luma, white_point \\ Seurat.WhitePoint.D65) do
    %__MODULE__{
      x: clamp(x),
      y: clamp(y),
      luma: clamp(luma),
      white_point: white_point
    }
  end

  defp clamp(n) when n < 0, do: 0.0
  defp clamp(n) when n > 1, do: 1.0
  defp clamp(n), do: n / 1

  defimpl Seurat.Conversions.ToYxy do
    def to_yxy(yxy), do: yxy
  end

  defimpl Seurat.Conversions.ToXyz do
    def to_xyz(%{x: x, y: y, luma: luma, white_point: white_point}) do
      if y == 0 do
        Seurat.Xyz.new(0, 0, 0, white_point)
      else
        xyz_x = x * luma / y
        xyz_y = luma
        xyz_z = (1 - x - y) * luma / y
        Seurat.Xyz.new(xyz_x, xyz_y, xyz_z)
      end
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{x: x, y: y, luma: l, white_point: wp}, _) do
      concat([
        "#Seurat.Yxy<",
        inspect_components([x, y, l]),
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
