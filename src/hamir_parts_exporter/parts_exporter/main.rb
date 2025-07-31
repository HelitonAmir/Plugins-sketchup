require 'sketchup.rb'
require 'csv'
require_relative 'utils'
require_relative 'corte_cloud_utils'
require_relative 'mdf_part'

module HamirTools
  module MDFPartsExporter

    unless file_loaded?(__FILE__)
      menu = UI.menu("Plugins")
      menu.add_item("Exportar Peças MDF para CSV") {
        self.export_parts_to_csv
      }
      file_loaded(__FILE__)
    end

    def self.is_exportable?(component)
      if !component.is_a?(Sketchup::ComponentInstance)
        return false
      end

      "S".casecmp(component.get_attribute("dynamic_attributes","v_exportar_pecas_mdf")) == 0
    end # is_exportable

    def self.export_parts_to_csv

      model = Sketchup.active_model
      entities = model.active_entities
      parts = []

      entities.each do |entity|
        if self.is_exportable?(entity)
          component_name = entity.name.empty? ? entity.definition.name : entity.name
          collect_parts(entity.definition.entities, parts, component_name)
        end
      end

      content = CSV.generate(col_sep: "\t") do |csv|
        parts.each do |part|
          csv << Utils::CorteCloud.to_corte_cloud_row(part)
        end
      end

      Utils.copy_to_clipboard(content)
      Utils.save_to_file(content, "Salvar lista de peças como CSV", "lista_pecas.csv")
    end # export_parts_to_csv

    def self.collect_parts(entities, parts, component_name)
      entities.each do |entity|
        if entity.visible? && entity.is_a?(Sketchup::ComponentInstance)
          bb = entity.bounds

          thickness, short_side, long_side = [
            bb.width.to_mm.round(0),
            bb.height.to_mm.round(0),
            bb.depth.to_mm.round(0)
          ].sort()

          if MDFPart.valid_thickness?(thickness)
            part_name = entity.name.empty? ? entity.definition.name : entity.name

            #TODO: Coletar orientação do veio. Ainda não foi criado um atributo para isso.
            part = MDFPart.new(component_name, part_name, short_side, long_side, thickness, :IGNORE_GRAIN)

            parts << part
          end

          collect_parts(entity.definition.entities, parts, component_name)
        end
      end
    end # collect_parts

  end # module MDFPartsExporter
end # module HamirTools
