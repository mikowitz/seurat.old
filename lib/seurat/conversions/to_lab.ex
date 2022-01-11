defprotocol Seurat.Conversions.ToLab do
  @spec to_lab(any) :: Seurat.Lab.t()
  def to_lab(color)
end
