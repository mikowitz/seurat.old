defmodule Seurat.ColorTestCase do
  use ExUnit.CaseTemplate

  def assert_colors_equal(expected, actual, color, epsilon \\ 0.05) do
    fields = Map.keys(expected) -- [:__struct__, :rgb_model]

    for field <- fields do
      assert_in_delta Map.get(expected, field),
                      Map.get(actual, field),
                      epsilon,
                      "#{color}: expected #{inspect(expected)}, got #{inspect(actual)}"
    end
  end
end
