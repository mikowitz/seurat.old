defmodule Seurat.LabTest do
  use Seurat.ColorTestCase, async: true

  alias Seurat.Lab
  doctest Lab

  describe "conversions" do
    property "to_lab returns itself" do
      check all(
              l <- float(min: 0, max: 100),
              a <- float(),
              b <- float()
            ) do
        lab = Lab.new(l, a, b)
        assert Seurat.to_lab(lab) == lab
      end
    end

    test "to_xyz" do
      ColorMine.parse()
      |> Enum.map(fn %{color: color, lab: lab, xyz: expected} ->
        actual = Seurat.to_xyz(lab)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
