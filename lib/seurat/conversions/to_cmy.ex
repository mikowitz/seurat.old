defprotocol Seurat.Conversions.ToCmy do
  @spec to_cmy(any) :: Seurat.Cmy.t()
  def to_cmy(color)
end
