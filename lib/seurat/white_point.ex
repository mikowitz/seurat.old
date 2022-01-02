defmodule Seurat.WhitePoint do
  @moduledoc """
  Representation of a white point for a CIE standard illuminant.

  A standard illuminant represents a theoretical source of light that can be
  used for reliably comparing colors recorded under different lighting
  conditions. Each illuminant defines a white point which represents, often
  standardized in XYZ format, the tristimulus values for a target white under
  that illuminant.

  The following illuminants have been published by the International Commission
  on Illumination (often shortened to CIE after the French name "Commission
  internationale de l'éclairage)

  * A - represents domestic, tungsten-filament lighting with a color temperature
    of around 2856K.
  * B - represents noon sunlight, with a correlated color temperature of 4874K.
    (deprecated in favor of the D series of illuminants)
  * C - represents average daylight, with a correlated color temperature of
    6774K. (deprecated in favor of the D series of illuminants)
  * D50 - represents natural dalyight with a color temperature of around 5000K
  * D55 - represents natural dalyight with a color temperature of around 5500K
  * [D65](`Seurat.WhitePoint.D65`) - often used as the default when no white
    point or illuminant is specified, this illuminant is a daylight illuminant
    that corresponds roughly to average midday light in Western/Northen Europe.
  * D75 - represents natural dalyight with a color temperature of around 7500K
  * E - represents the equal energy radiator
  * F2 - represents a semi-broadband fluorescent lamp
  * F7 - represents a broadband fluorescent lamp
  * F11 - represents a narrowband fluorescent lamp

  """

  @type t :: Seurat.Illuminant.D65

  @callback x() :: float
  @callback y() :: float
  @callback z() :: float
end
