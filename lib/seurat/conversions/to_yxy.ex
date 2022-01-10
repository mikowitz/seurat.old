defprotocol Seurat.Conversions.ToYxy do
  @spec to_yxy(any) :: Seurat.Yxy.t()
  def to_yxy(color)
end
