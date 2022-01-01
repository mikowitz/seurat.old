defprotocol Seurat.Conversions.ToRgb do
  @spec to_rgb(any) :: Seurat.Rgb.color()
  def to_rgb(color)
end
