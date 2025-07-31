require 'fileutils'
require 'zip'

module HamirTools
  module Exporter
    EXPORT_DIR = 'export'.freeze
    SRC_DIR = 'src'.freeze
    OUTPUT_DIR = 'output'.freeze

    def self.build_extension(extension_name)

      extension_root = File.join(SRC_DIR, extension_name)
      puts extension_root
      extension_target = File.join(EXPORT_DIR, extension_name)

      FileUtils.mkdir_p(extension_target)

      Dir.glob("#{extension_root}/**/*.rb").each do |path|
        next if File.directory?(path)

        relative_path = path.sub("#{extension_root}/", '')
        destination = "#{extension_target}/#{relative_path}"

        FileUtils.mkdir_p(File.dirname(destination))
        FileUtils.cp(path, destination)
      end

      extension_file = "#{OUTPUT_DIR}/#{extension_name}.rbz"
      Zip::OutputStream.open(extension_file) do |zos|
        Dir.glob("#{extension_root}/**/*").each do |file|
          next if File.directory?(file)
          zip_path = file.sub("#{extension_root}/", '')
          zos.put_next_entry(zip_path)
          zos.write File.binread(file)
        end
      end
    end

    def self.run
      FileUtils.rm_rf(EXPORT_DIR)
      FileUtils.mkdir_p(EXPORT_DIR)

      Dir.glob("#{SRC_DIR}/**").each do |path|

        if File.directory?(path)
          name = path.sub("#{SRC_DIR}/", '')
          build_extension(name)
        end
      end

      puts "Exportação concluída!"
    end
  end
end

# Executa a exportação
HamirTools::Exporter.run
