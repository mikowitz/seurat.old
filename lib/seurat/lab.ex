defmodule Seurat.Lab do
  @moduledoc """
  The CIELAB (L*a*b*) colorspace.

  CIELAB is intended as a perceptually uniform space, meaning that a given
  numerical change in color value corresponds to a similar perceived change in
  color. L*a*b* is not truly perceptually uniform, but is still useful for
  detecting small color differences.

  Like CIE XYZ, L*a*b* is a device independent "standard observer" model, and
  part of a color's definition includes a standard illuminant. This value
  defaults to [D65](`Seurat.WhitePoint.D65`).

  The CIELAB space is 3-dimensional, and covers the entire range of human color
  perception. Because of this, and its near perceptual uniformity, it is useful
  for converting between other color spaces, as well as color manipulation.

  It is based on the opponent color model of human vision, with opposing pairs
  of red/green and yellow/blue.

  ## Fields

  - `l` - the lightness of the color. 0.0 gives black and 100 gives white
  - `a` - the red/green opponent colors. Negative values move towards green, and
    positive values towards red.
  - `b` - the blue/yellow opponent colors. Negative values toward blue and
    positive values toward yellow.

  The `a` and `b` values are unbounded, and can extend beyond ±150 to cover the
  entire human color gamut. However, not every L*a*b* color is necessarily
  convertible to other, more limited color spaces. For example, because typical
  computer displays can only display the sRGB gamut, values for `a` and `b`
  outside of the range [-127, 128] cannot be converted exactly to sRGB colors.
  """

  defstruct [:l, :a, :b, :white_point]

  @type t :: %__MODULE__{
          l: float,
          a: float,
          b: float,
          white_point: Seurat.WhitePoint.t()
        }

  @doc """
  Models a new CIELAB color.

  ## Examples

      iex> Lab.new(50, 100, -100)
      #Seurat.Lab<50.0, 100.0, -100.0 (D65)>

  `a` and `b` values are unbounded, but `l` will be clamped to the range [0, 1]

      iex> Lab.new(105, -200, 200)
      #Seurat.Lab<100.0, -200.0, 200.0 (D65)>

  """
  def new(l, a, b, white_point \\ Seurat.WhitePoint.D65) do
    %__MODULE__{
      l: clamp(l),
      a: a / 1,
      b: b / 1,
      white_point: white_point
    }
  end

  defp clamp(n) when n < 0, do: 0.0
  defp clamp(n) when n > 100, do: 100.0
  defp clamp(n), do: n / 1

  defimpl Seurat.Conversions.ToLab do
    def to_lab(lab), do: lab
  end

  defimpl Seurat.Conversions.ToXyz do
    @e 0.008856
    @k 903.3

    def to_xyz(%{l: l, a: a, b: b, white_point: wp}) do
      fy = (l + 16) / 116
      fx = a / 500 + fy
      fz = fy - b / 200

      xr =
        if :math.pow(fx, 3) > @e do
          :math.pow(fx, 3)
        else
          (116 * fx - 16) / @k
        end

      yr =
        if l > @k * @e do
          :math.pow((l + 16) / 116, 3)
        else
          l / @k
        end

      zr =
        if :math.pow(fz, 3) > @e do
          :math.pow(fz, 3)
        else
          (116 * fz - 16) / @k
        end

      Seurat.Xyz.new(xr * wp.x(), yr * wp.y(), zr * wp.z(), wp)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{l: l, a: a, b: b, white_point: wp}, _) do
      concat([
        "#Seurat.Lab<",
        inspect_components([l, a, b]),
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
