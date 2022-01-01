defprotocol Seurat.Conversions.ToHsv do
  @spec to_hsv(any) :: Seurat.Hsv.t()
  def to_hsv(color)
end
