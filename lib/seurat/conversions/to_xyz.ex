defprotocol Seurat.Conversions.ToXyz do
  @spec to_xyz(any) :: Seurat.Xyz.t()
  def to_xyz(color)
end
