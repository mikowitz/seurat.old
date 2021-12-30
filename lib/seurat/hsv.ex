defmodule Seurat.Hsv do
  @moduledoc """
  Modeling for the HSV (hue, saturation, value) colorspace.

  In contrast to the RGB color model, HSV was created to be a more
  human-analogue color model, defining a color by its hue, saturation and value,
  rather than a combination of red, green, and blue hues.

  This colorspace is modeled as a cylinder, with the `hue` is the angle around
  the cylinder, `saturation` is the distance from the center (the center being
  pure white, the outer rim being the most "colorful"), and `value` being the
  distance from the cylinder's base (the bottom being black, and the top being
  the most vibrant). This models how colors appear under light.

  This colorspace makes certain operations on colors especially straightforword,
  such as changing the hue from red to green (rotation around the cylinder) or
  dulling a color (reducing the value).

  ## Fields

  * `hue` - the radial angle of the color's hue, given in degrees in the range
    [0, 360).
  * `saturation` - the "colorfulness" of the color, in the range [0, 1]. `0`
    will produce a full white, while `1` will produce a highly saturated color
  * `value` - the brightness of the color, in the range [0, 1]. `0` will
    give full black, while `1` will produce the brightest version of the color

  ## Conversions

  Converting between HSV and RGB is a straightforward operation, but because
  `RGB` can mean different things (see `Seurat.Rgb` for a full discussion), an
  `HSV` color keeps a record of what RGB color model it was converted from. A
  new `HSV` color assumes `sRGB`.

  As shown in the examples below, the conversion function will result in the
  same red, green, and blue values. But, because the color model is different,
  the two resulting colors are not actually the same.

  ## Examples

      iex> color = Hsv.new(100, 0.5, 0.5)
      #Seurat.Hsv<100.0, 0.5, 0.5 (SRgb)>
      iex> Seurat.to_rgb(color)
      #Seurat.Rgb.SRgb<0.3333, 0.5, 0.25>

      iex> color = Hsv.new(100, 0.5, 0.5, Linear)
      #Seurat.Hsv<100.0, 0.5, 0.5 (Linear)>
      iex> Seurat.to_rgb(color)
      #Seurat.Rgb.Linear<0.3333, 0.5, 0.25>
  """

  defstruct [:hue, :saturation, :value, :rgb_model]

  @type t :: %__MODULE__{
          hue: float,
          saturation: float,
          value: float,
          rgb_model: Seurat.Rgb.model()
        }

  @doc """
  Creates a new HSV color from a given hue, saturation, and value.

  It assumes the RGB color model used for conversions will be `SRgb`.

  ## Examples

      iex> Hsv.new(100, 0.5, 0.5)
      #Seurat.Hsv<100.0, 0.5, 0.5 (SRgb)>

  An `Rgb` color model can be specified, to indicate that when converted to RGB,
  this color will return a value in the given color model.

      iex> Hsv.new(100, 0.5, 0.5, Linear)
      #Seurat.Hsv<100.0, 0.5, 0.5 (Linear)>

  """
  @spec new(number, number, number, Seurat.Rgb.model() | nil) :: __MODULE__.t()
  def new(hue, saturation, value, rgb_model \\ Seurat.Rgb.SRgb) do
    %__MODULE__{
      hue: clamp_angle(hue),
      saturation: clamp(saturation),
      value: clamp(value),
      rgb_model: rgb_model
    }
  end

  defimpl Seurat.Conversions.ToRgb do
    # Formula: https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB_alternative
    def to_rgb(%{hue: h, saturation: s, value: v, rgb_model: rgb_model}) do
      f = fn n ->
        k = :math.fmod(n + h / 60, 6)
        v - v * s * max(0, Enum.min([k, 4 - k, 1]))
      end

      rgb_model.new(f.(5), f.(3), f.(1))
    end
  end

  defimpl Seurat.Conversions.ToHsv do
    def to_hsv(hsv), do: hsv
  end

  defimpl Seurat.Conversions.ToHsl do
    def to_hsl(%{hue: h, saturation: s, value: v, rgb_model: rgb_model}) do
      l = v - v * s / 2

      s =
        case l do
          l when l in [0.0, 1.0] -> 0
          _ -> (v - l) / min(l, 1 - l)
        end

      Seurat.Hsl.new(h, s, l, rgb_model)
    end
  end

  defp clamp_angle(x) when x > 360, do: :math.fmod(x, 360)
  defp clamp_angle(x) when x < 0, do: clamp_angle(x + 360)
  defp clamp_angle(x), do: x / 1

  defp clamp(x) when x < 0, do: 0.0
  defp clamp(x) when x > 1.0, do: 1.0
  defp clamp(x), do: x / 1

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%{rgb_model: m} = color, _) do
      concat([
        "#Seurat.Hsv<",
        inspect_components(color),
        " (",
        inspect_rgb_model(m),
        ")>"
      ])
    end

    def inspect_components(%{hue: h, saturation: s, value: v}) do
      [
        Float.round(h, 1),
        Float.round(s, 4),
        Float.round(v, 4)
      ]
      |> Enum.join(", ")
    end

    defp inspect_rgb_model(model), do: Module.split(model) |> List.last()
  end
end
