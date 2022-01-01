defmodule Seurat.MixProject do
  use Mix.Project

  def project do
    [
      app: :seurat,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      elixirc_paths: compiler_paths(Mix.env()),
      docs: [
        main: Seurat,
        groups_for_modules: [
          Cylindrical: [
            Seurat.Hsv,
            Seurat.Hsl
          ],
          RGB: [
            Seurat.Rgb,
            Seurat.Rgb.Colorspace,
            Seurat.Rgb.Gamma,
            Seurat.Rgb.Linear,
            Seurat.Rgb.SRgb
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:nimble_csv, "~> 1.2.0"},
      {:stream_data, "~> 0.5", only: [:dev, :test]}
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
      plt_add_apps: [:ex_unit]
    ]
  end

  defp compiler_paths(:test), do: ["test/support"] ++ compiler_paths(:prod)
  defp compiler_paths(_), do: ["lib"]
end
