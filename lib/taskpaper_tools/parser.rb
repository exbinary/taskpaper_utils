require 'taskpaper_tools/line_item'

module TaskpaperTools
  class Parser

    def parse_file path
      File.open(path) { |file| parse file }
    end

    def parse enum
      document = Document.new
      enum.reduce(document) { |preceding_entry, line| Entry.new(line, preceding_entry) }
      document
    end

  end
end
