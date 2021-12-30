defmodule Seurat.Hsl do
  @moduledoc """
  Modeling for the HSL (hue, saturation, lightness) colorspace.

  Similar to the `Seurat.Hsv` colorspace, `Hsl` is also a cylindrical color
  model, but rather than modeling how colors appear under light, it models
  how paints mix to create color. Adding `lightness` brightens the color, with
  a lightness value of 1 corresponding to full white, rather than than a fully
  saturated color.

  ## Fields

  * `hue` - the radial angle of the color's hue, given in degrees in the range
    [0, 360).
  * `saturation` - the "colorfulness" of the color, in the range [0, 1]. `0`
    will produce a full white, while `1` will produce a highly saturated color
  * `lightness` - the amount of white added to the color. `0` will produce
    full black, while a lightness of `1` results in a full white.

  ## Conversions

  Converting between HSL and RGB is a straightforward operation, but because
  `RGB` can mean different things (see `Seurat.Rgb` for a full discussion), an
  `HSL` color keeps a record of what RGB color model it was converted from. A
  new `HSL` color assumes `sRGB`.

  As shown in the examples below, the conversion function will result in the
  same red, green, and blue values. But, because the color model is different,
  the two resulting colors are not actually the same.

  ## Examples

      iex> color = Hsl.new(100, 0.5, 0.5)
      #Seurat.Hsl<100.0, 0.5, 0.5 (SRgb)>
      iex> Seurat.to_rgb(color)
      #Seurat.Rgb.SRgb<0.4167, 0.75, 0.25>

      iex> color = Hsl.new(100, 0.5, 0.5, Linear)
      #Seurat.Hsl<100.0, 0.5, 0.5 (Linear)>
      iex> Seurat.to_rgb(color)
      #Seurat.Rgb.Linear<0.4167, 0.75, 0.25>

  """

  defstruct [:hue, :saturation, :lightness, :rgb_model]

  @type t :: %__MODULE__{
          hue: float,
          saturation: float,
          lightness: float,
          rgb_model: Seurat.Rgb.model()
        }

  @doc """
  Creates a new HSL color from a given hue, saturation, and lightness.

  It assumes the RGB color model used for conversions will be `SRgb`.

  ## Examples

      iex> Hsl.new(100, 0.5, 0.5)
      #Seurat.Hsl<100.0, 0.5, 0.5 (SRgb)>

  An `Rgb` color model can be specified, to indicate that when converted to RGB,
  this color will return a value in the given color model.

      iex> Hsl.new(100, 0.5, 0.5, Linear)
      #Seurat.Hsl<100.0, 0.5, 0.5 (Linear)>

  """
  @spec new(number, number, number, Seurat.Rgb.model() | nil) :: __MODULE__.t()
  def new(hue, saturation, lightness, rgb_model \\ Seurat.Rgb.SRgb) do
    %__MODULE__{
      hue: clamp_angle(hue),
      saturation: clamp(saturation),
      lightness: clamp(lightness),
      rgb_model: rgb_model
    }
  end

  defimpl Seurat.Conversions.ToRgb do
    # Formula: https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB_alternative
    def to_rgb(%{hue: h, saturation: s, lightness: l, rgb_model: rgb_model}) do
      f = fn n ->
        k = :math.fmod(n + h / 30, 12)
        a = s * min(l, 1 - l)
        l - a * max(-1, Enum.min([k - 3, 9 - k, 1]))
      end

      rgb_model.new(f.(0), f.(8), f.(4))
    end
  end

  defimpl Seurat.Conversions.ToHsv do
    def to_hsv(%{hue: h, saturation: s, lightness: l, rgb_model: rgb_model}) do
      v = l + s * min(l, 1 - l)

      s =
        case v do
          0.0 -> 0
          _ -> 2 - 2 * l / v
        end

      Seurat.Hsv.new(h, s, v, rgb_model)
    end
  end

  defimpl Seurat.Conversions.ToHsl do
    def to_hsl(hsl), do: hsl
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
        "#Seurat.Hsl<",
        inspect_components(color),
        " (",
        inspect_rgb_model(m),
        ")>"
      ])
    end

    def inspect_components(%{hue: h, saturation: s, lightness: l}) do
      [
        Float.round(h, 1),
        Float.round(s, 4),
        Float.round(l, 4)
      ]
      |> Enum.join(", ")
    end

    defp inspect_rgb_model(model), do: Module.split(model) |> List.last()
  end
end
