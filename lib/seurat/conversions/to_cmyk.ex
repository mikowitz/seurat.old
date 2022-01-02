defprotocol Seurat.Conversions.ToCmyk do
  @spec to_cmyk(any) :: Seurat.Cmyk.t()
  def to_cmyk(color)
end
