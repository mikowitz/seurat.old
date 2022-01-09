defmodule Seurat.ColorTestCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnitProperties
      import Seurat.ColorTestCase
      alias Seurat.ColorMine
    end
  end

  def assert_colors_equal(
        %{__struct__: s} = expected,
        %{__struct__: s} = actual,
        color,
        epsilon \\ 0.05
      ) do
    fields = Map.keys(expected) -- [:__struct__, :rgb_model, :white_point]

    for field <- fields do
      assert_in_delta Map.get(expected, field),
                      Map.get(actual, field),
                      epsilon,
                      "#{color}: expected #{inspect(expected)}, got #{inspect(actual)}"
    end
  end
end
