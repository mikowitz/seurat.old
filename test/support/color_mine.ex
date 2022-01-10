defmodule Seurat.ColorMine do
  @moduledoc false
  # source: https://github.com/Ogeon/palette/blob/master/palette/tests/convert/data_color_mine.csv

  def data_stream do
    "test/support/data_color_mine.csv"
    |> File.stream!()
    |> NimbleCSV.RFC4180.parse_stream(skip_headers: false)
  end

  def headers do
    data_stream()
    |> Enum.take(1)
    |> List.first()
    |> Enum.map(&String.to_atom/1)
  end

  def data do
    data_stream()
    |> Enum.drop(1)
    |> Enum.map(fn row ->
      Enum.zip(headers(), Enum.map(row, &parse_float/1))
      |> Enum.into(%{})
    end)
  end

  def parse do
    data()
    |> Enum.map(fn row ->
      %{
        color: row.color,
        srgb: Seurat.Rgb.SRgb.new(row.rgb_r, row.rgb_g, row.rgb_b),
        linear_rgb: Seurat.Rgb.to_linear(Seurat.Rgb.SRgb.new(row.rgb_r, row.rgb_g, row.rgb_b)),
        hsv: Seurat.Hsv.new(row.hsv_h, row.hsv_s, row.hsv_v),
        hsl: Seurat.Hsl.new(row.hsl_h, row.hsl_s, row.hsl_l),
        cmy: Seurat.Cmy.new(row.cmy_c, row.cmy_m, row.cmy_y),
        cmyk: Seurat.Cmyk.new(row.cmyk_c, row.cmyk_m, row.cmyk_y, row.cmyk_k),
        xyz: Seurat.Xyz.new(row.xyz_x, row.xyz_y, row.xyz_z),
        yxy: Seurat.Yxy.new(row.yxy_x, row.yxy_y, row.yxy_luma)
      }
    end)
  end

  def parse_float(s) do
    case Float.parse(s) do
      {f, _} -> f
      :error -> s
    end
  end
end
