require 'sketchup.rb'
require 'extensions.rb'

module HamirTools
  unless file_loaded?(__FILE__)
    ex = SketchupExtension.new('Módulo de Marcenaria', 'modulos_marcenaria/main')
    ex.description = 'Módulos para compor marcenaria.'
    ex.version     = '0.0.1'
    ex.copyright   = 'Hamir'
    ex.creator     = 'Hamir'
    Sketchup.register_extension(ex, true)

    file_loaded(__FILE__)
  end
end # module HamirTools
