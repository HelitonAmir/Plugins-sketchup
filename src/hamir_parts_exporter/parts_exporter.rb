require 'sketchup.rb'
require 'extensions.rb'

module HamirTools
  unless file_loaded?(__FILE__)
    ex = SketchupExtension.new('Exportador MDF', 'parts_exporter/main')
    ex.description = 'Exportador de peças MDF.'
    ex.version     = '0.0.1'
    ex.copyright   = 'Hamir'
    ex.creator     = 'Hamir'
    Sketchup.register_extension(ex, true)
    file_loaded(__FILE__)
  end
end # module HamirTools
