defprotocol Seurat.Conversions.ToHsl do
  @spec to_hsl(any) :: Seurat.Hsl.t()
  def to_hsl(color)
end
