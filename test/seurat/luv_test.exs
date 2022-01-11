defmodule Seurat.LuvTest do
  use Seurat.ColorTestCase, async: true

  alias Seurat.Luv
  doctest Luv

  describe "conversions" do
    property "to_lab returns itself" do
      check all(
              l <- float(min: 0, max: 100),
              u <- float(min: -84, max: 176),
              v <- float(min: -135, max: 108)
            ) do
        luv = Luv.new(l, u, v)
        assert Seurat.to_luv(luv) == luv
      end
    end
  end
end
