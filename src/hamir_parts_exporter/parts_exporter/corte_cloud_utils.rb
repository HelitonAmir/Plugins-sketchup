module HamirTools
  module Utils
    module CorteCloud
      def self.boolean_to_s(value)
        value ? "S" : nil
      end

      def self.to_corte_cloud_row(mdf_part)
        [
          1,																						#Quantidade
          mdf_part.length,															#Comprimento
          mdf_part.width,																#Largura
          mdf_part.name,																#Função
          self.boolean_to_s(mdf_part.edge_length1),			#Fita C1
          self.boolean_to_s(mdf_part.edge_length2),			#Fita C2
          self.boolean_to_s(mdf_part.edge_width1),			#Fita L1
          self.boolean_to_s(mdf_part.edge_width2),			#Fita L2
          "#{mdf_part.melamine} #{mdf_part.thickness}",	#Material
          mdf_part.component,														#Complemento
          self.boolean_to_s(mdf_part.ignore_grain)			#Ignorar veio
        ]
      end
    end
  end
end
