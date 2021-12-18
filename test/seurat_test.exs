defmodule SeuratTest do
  use ExUnit.Case
  doctest Seurat

  test "greets the world" do
    assert Seurat.hello() == :world
  end
end
