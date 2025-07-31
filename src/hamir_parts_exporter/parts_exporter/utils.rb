module HamirTools
  module Utils

    def self.copy_to_clipboard(content)
      content_utf16 = "\uFEFF".encode("UTF-16LE") + content.encode("UTF-16LE")
      IO.popen('clip', 'wb') { |f| f.print content_utf16 }
    end # copy_to_clipboard

    def self.save_to_file(content, panel_title, file_name, path = "")
      output_path = UI.savepanel(panel_title, path, file_name)
      if output_path == nil
        return
      end
      File.write(output_path, content)
    end # save_to_file

  end # Utils
end # HamirTools
