

require 'sketchup.rb'
require_relative 'cabinet_box_tool'

module HamirTools
  module ModulosMarcenaria

    unless file_loaded?(__FILE__)
      menu = UI.menu("Plugins")
      menu.add_item("Criar caixote") {
        HamirTools::ModulosMarcenaria.create_module("CabinetBox")
      }
      file_loaded(__FILE__)
    end

    def self.create_module(tipo)
      Sketchup.active_model.select_tool(HamirTools::ModulosMarcenaria::CabinetBoxTool.new)
    end
  end # module ModulosMarcenaria
end # module HamirTools
