defmodule Seurat.Xyz do
  @moduledoc """
  The CIE 1931 XYZ color space.

  The XYZ colorspace provides a quantitative link between perceived colors and
  the wavelengths that produce them, providing a non-device-specific way to
  define the colors we see using numbers. Because of this it is often used when
  converting from one colorspace to another.

  In addition to the X, Y, and Z fields, it also requires a standard illuminant
  and observer to be specified, defined jointly as the color's "white point".
  By default, the illuminant and observer are D65 for 2° observer. This
  illuminant is intended to represent average daylight. See
  [this Wikipedia article](https://en.wikipedia.org/wiki/Standard_illuminant)
  for a full discussion of standard illuminants.

  ## Fields

  * `x` - this measures the scale of what can be seen as a response curve for
    human eyes' cone cells. Its range depends on the white point, but goes from
    0.0 to 0.95047 for the default D65
  * `y` - the luminance of the color, with 0 as black and 1 as white
  * `z` - this measures the scale of what can be seen as the blue stimulation.
    Its range alse depends on the white point, but for D65 ranges from 0.0 to
    1.08883.
  * `white_point` - the white point representing the color's illuminant and
    observer. By default this is D65 for 2° observer

  ## Conversions

  ### RGB <-> XYZ

  Converting from XYZ to RGB will return a color in Linear RGB colorspace.
  Converting to XYZ from another RGB color model will convert to Linear, and
  then to XYZ
  """

  defstruct [:x, :y, :z, :white_point]

  @type t :: %__MODULE__{
          x: float,
          y: float,
          z: float,
          white_point: Seurat.WhitePoint.t()
        }

  @doc """
  Define a color in the XYZ colorspace.

      iex> Xyz.new(0.5, 0.5, 0.5)
      #Seurat.Xyz<0.5, 0.5, 0.5 (D65)>

  Values outside the allowed range by the color's whitepoint will be clamped to
  that range

      iex> Xyz.new(-0.5, 0.5, 2)
      #Seurat.Xyz<0.0, 0.5, 1.08883 (D65)>

  """
  def new(x, y, z, white_point \\ Seurat.WhitePoint.D65) do
    %__MODULE__{
      x: clamp(x, white_point, :x),
      y: clamp(y, white_point, :y),
      z: clamp(z, white_point, :z),
      white_point: white_point
    }
  end

  defp clamp(n, _, _) when n < 0, do: 0.0

  defp clamp(n, white_point, key) do
    case apply(white_point, key, []) do
      max when max < n -> max
      _ -> n / 1
    end
  end

  defimpl Seurat.Conversions.ToXyz do
    def to_xyz(xyz), do: xyz
  end

  defimpl Seurat.Conversions.ToRgb do
    def to_rgb(%{x: x, y: y, z: z}) do
      r = calculate_color(x, y, z, 3.2404542, -1.5371385, -0.4985314)
      g = calculate_color(x, y, z, -0.9692660, 1.8760108, 0.0415560)
      b = calculate_color(x, y, z, 0.0556434, -0.2040259, 1.0572252)
      Seurat.Rgb.Linear.new(r, g, b)
    end

    defp calculate_color(x, y, z, a, b, c) do
      x * a + y * b + z * c
    end
  end

  defimpl Seurat.Conversions.ToYxy do
    def to_yxy(%{x: x, y: y, z: z, white_point: white_point}) do
      if x + y + z == 0 do
        Seurat.Yxy.new(0, 0, 0, white_point)
      else
        yxy_x = x / (x + y + z)
        yxy_y = y / (x + y + z)
        luma = y
        Seurat.Yxy.new(yxy_x, yxy_y, luma, white_point)
      end
    end
  end

  defimpl Seurat.Conversions.ToLab do
    @e 0.008856
    @k 903.3

    def to_lab(%{x: x, y: y, z: z, white_point: wp}) do
      xr = x / wp.x()
      yr = y / wp.y()
      zr = z / wp.z()

      fx = calculate_intermediary(xr)
      fy = calculate_intermediary(yr)
      fz = calculate_intermediary(zr)

      l = 116 * fy - 16
      a = 500 * (fx - fy)
      b = 200 * (fy - fz)

      Seurat.Lab.new(l, a, b, wp)
    end

    defp calculate_intermediary(n) do
      if n > @e do
        :math.pow(n, 1 / 3)
      else
        (@k * n + 16) / 116
      end
    end
  end

  defimpl Seurat.Conversions.ToLuv do
    @e 0.008856
    @k 903.3

    def to_luv(%{x: x, y: y, z: z, white_point: wp}) do
      xr = wp.x()
      yr = wp.y()
      zr = wp.z()

      denom_r = xr + 15 * yr + 3 * zr

      v_prime_r = 9 * yr / denom_r
      u_prime_r = 4 * xr / denom_r

      denom = x + 15 * y + 3 * z

      v_prime = 9 * y / denom
      u_prime = 4 * x / denom

      y_r = y / yr

      l =
        if y_r > @e do
          116 * :math.pow(y_r, 1 / 3) - 16
        else
          @k * y_r
        end

      u = 13 * l * (u_prime - u_prime_r)
      v = 13 * l * (v_prime - v_prime_r)

      Seurat.Luv.new(l, u, v, wp)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{x: x, y: y, z: z, white_point: wp}, _) do
      concat([
        "#Seurat.Xyz<",
        inspect_components([x, y, z]),
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
