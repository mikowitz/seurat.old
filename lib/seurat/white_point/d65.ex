defmodule Seurat.WhitePoint.D65 do
  @moduledoc """
  CIE D series standard illuminant D65

  D65 white point represents natural daylight with a color temperature of 6500K
  for 2° standard observer.

  D65 2° standard observer is often considered the default illuminant, when no
  other white point or illuminant is specified.
  """

  @behaviour Seurat.WhitePoint

  def x, do: 0.95047
  def y, do: 1.0
  def z, do: 1.08883
end
