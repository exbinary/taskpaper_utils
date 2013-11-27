require 'taskpaper_tools/entry'

module TaskpaperTools
  class Parser

    def initialize
      @text_util = TextUtility.new
    end

    def parse_file(path)
      File.open(path) { |file| parse file }
    end

    def parse(enum)
      document = Document.new
      enum.reduce(document) do |preceding_entry, line| 
        create_entry(line).tap do |current_entry|
          find_parent_of(current_entry, preceding_entry).add_child(current_entry)
        end
      end
      document
    end

    def create_entry(line)
      raw_text = @text_util.strip_leave_indents(line)
      ( case
        when raw_text =~ /\A(\s*)?-/  then Task
        when raw_text.end_with?(':')  then Project
        else                               Note
        end
      ).new raw_text
    end

    def find_parent_of(current_entry, preceding_entry)
      return preceding_entry if preceding_entry.type? :document
      case @text_util.compare_indents(preceding_entry, current_entry)
      when -1 then preceding_entry
      when  0 then select_parent_of_equally_indented_entry(current_entry, preceding_entry)
      when  1 then find_parent_of(current_entry, preceding_entry.parent)
      end
    end

    def select_parent_of_equally_indented_entry(current_entry, preceding_entry)
      if @text_util.unindented(preceding_entry)
        return preceding_entry.document if current_entry.is_a?(Project)
        return preceding_entry if preceding_entry.is_a?(Project)
      end
      return preceding_entry.parent
    end
  end
end
