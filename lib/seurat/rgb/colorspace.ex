defmodule Seurat.Rgb.Colorspace do
  @moduledoc """
  Provides shared functionality for RGB colorspaces.

  Most of the shared functionality is created via the `__using__` macro,
  implemented in the target colorspace via

  ```
  use Seurat.Rgb.Colorspace
  ```

  This module also provides a simple behaviour for converting colors into
  and out of linear RGB space, in order to perform arthimetic operations
  reliably. This behaviour defines the two callbacks `c:from_linear/1` and
  `c:to_linear/1`.
  """

  defmacro __using__(_) do
    quote do
      defstruct [:red, :green, :blue]

      @type t :: %__MODULE__{
              red: float,
              green: float,
              blue: float
            }

      def new(red, green, blue) do
        %__MODULE__{
          red: clamp(red),
          green: clamp(green),
          blue: clamp(blue)
        }
      end

      defp clamp(x) when x < 0, do: 0.0
      defp clamp(x) when x > 1.0, do: 1.0
      defp clamp(x), do: x / 1

      @behaviour Seurat.Rgb.Colorspace

      defimpl Inspect do
        import Inspect.Algebra

        def inspect(%{red: r, green: g, blue: b}, _opts) do
          concat([
            "#Seurat.Rgb.",
            Module.split(__MODULE__) |> List.last(),
            "<",
            Enum.map([r, g, b], &format_float/1) |> Enum.join(", "),
            ">"
          ])
        end

        defp format_float(x) do
          Float.round(x, 4)
        end
      end
    end
  end

  @doc """
  Converts a linear RGB color into the implementing RGB colorspace
  """
  @callback from_linear(Seurat.Rgb.Linear.t()) :: Seurat.Rgb.color()

  @doc """
  Converts a color from the implementing RGB colorspace into linear RGB
  """
  @callback to_linear(Seurat.Rgb.color()) :: Seurat.Rgb.Linear.t()
end
