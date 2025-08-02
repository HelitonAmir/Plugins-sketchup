

require 'sketchup.rb'
require_relative 'cabinet_box_tool'

module HamirTools
  module ModulosMarcenaria

    def self.create_module
      Sketchup.active_model.select_tool(HamirTools::ModulosMarcenaria::CabinetBoxTool.new)
    end

    def self.build_command(icon, tooltip, action)
      icon_path = File.join(__dir__, "icons", "#{icon}.svg")
      cmd = UI::Command.new(tooltip, &action.to_proc)
      cmd.tooltip = tooltip
      cmd.small_icon = icon_path
      cmd.large_icon = icon_path
      cmd
    end

    unless file_loaded?(__FILE__)
      #menu = UI.menu("Plugins")
      #menu.add_item("Criar caixote") {
      #  HamirTools::ModulosMarcenaria.create_module("CabinetBox")
      #}
      #file_loaded(__FILE__)
      toolbar = ::UI::Toolbar.new("Marcenaria")
      toolbar.add_item(self.build_command("icon_cabinet_box", "Criar Caixote", proc {HamirTools::ModulosMarcenaria.create_module}))
      toolbar.add_item(self.build_command("icon_doors", "Criar Portas", proc {HamirTools::ModulosMarcenaria.create_module}))
      toolbar.add_item(self.build_command("icon_drawers", "Criar Gavetas", proc {HamirTools::ModulosMarcenaria.create_module}))
    end


  end # module ModulosMarcenaria
end # module HamirTools
