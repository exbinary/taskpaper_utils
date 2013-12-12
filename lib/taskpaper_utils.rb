%w(version helpers indent_aware entry_container
   document entry project task note parser).each do |lib|
  require "taskpaper_utils/#{lib}"
end

module TaskpaperUtils
  def self.parse(file)
    Parser.new.parse_file file
  end
  def self.save(document, path)
    File.open(path, 'w') do |file|
      document.yield_raw_text { |raw_text| file.puts raw_text }
    end
  end
end
