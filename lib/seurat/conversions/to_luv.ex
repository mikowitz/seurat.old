defprotocol Seurat.Conversions.ToLuv do
  @spec to_luv(any) :: Seurat.Luv.t()
  def to_luv(color)
end
