
require "../*"
module Star
module Commands
class Combine
  def self.run(fname, opts={} of String => String, *files)
    puts "combine task: #{fname} #{files}"
    write_file(fname, files)
  end

  def self.write_file(outname, *filenames)
    files = [] of File
    fnames = filenames[0][0]
    fnames.each do |f|
      fail_with("File doesn't exist: #{f}") unless File.exists?(f)
      files << File.new(f, "w+")
    end

    # File objects are in `files` array, iterate through them and combine
    contents = String.build do |s|
      s << Star::Text.pad("\x73\x20\x74\x20\x61\x20\x72\x20\x31", 16) # Magic: `s t a r 1
      s << "\xCA\xFE\xCA\xFE\xBA\xBE\xBA\xBE" # Begin file list
    end
  end
end
end
end