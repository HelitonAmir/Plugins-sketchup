

require 'sketchup.rb'
require_relative 'cabinet_box_tool'

module HamirTools
  module ModulosMarcenaria

    def self.create_module(tool)
      Sketchup.active_model.select_tool(tool.new)
    end

    def self.build_command(icon, tooltip, action)
      ext = Sketchup.platform == :platform_win ? 'svg' : 'pdf'
      icon_path = File.join(__dir__, "icons", "#{icon}.#{ext}")
      cmd = UI::Command.new(tooltip, &action.to_proc)
      cmd.tooltip = tooltip
      cmd.small_icon = icon_path
      cmd.large_icon = icon_path
      cmd
    end

    unless file_loaded?(__FILE__)
      toolbar = ::UI::Toolbar.new("Marcenaria")
      toolbar.add_item(self.build_command("icon_cabinet_box", "Criar Caixote", proc {HamirTools::ModulosMarcenaria.create_module(HamirTools::ModulosMarcenaria::CabinetBoxTool)}))
      toolbar.add_item(self.build_command("icon_doors", "Criar Portas", proc {HamirTools::ModulosMarcenaria.create_module(HamirTools::ModulosMarcenaria::DoorsTool)}))
      toolbar.add_item(self.build_command("icon_drawers", "Criar Gavetas", proc {HamirTools::ModulosMarcenaria.create_module(HamirTools::ModulosMarcenaria::DrawersTool)}))
    end


  end # module ModulosMarcenaria
end # module HamirTools
