require "../*"
require "openssl"
module Star
module Commands
class Combine
  def self.run(fname, opts={} of String => String, *files)
    write_file(fname, files)
  end

  def self.write_file(outname, *filenames)

    files = [] of File
    fnames = filenames[0][0]

    fnames.each do |f|
      fail_with("File doesn't exist: #{f}") unless File.exists?(f)
      files << File.new(f, "a")
    end

    begin
      fnames.map! do |f|
        f = f + "{*&*}" + OpenSSL::Digest.new("SHA256").update(File.read(f)).hexdigest
      end
      # File objects are in `files` array, iterate through them and combine
      s = String.build do |s|
        s << Star::Text.pad("\x73\x20\x74\x20\x61\x20\x72\x20\x31", 16) # Magic: `s t a r 1
        s << "\xCA\xFE\xCA\xFE\xBA\xBE\xBA\xBE" # Begin file list
        s << fnames.join("{:\x00:}")
        s << "\xBA\xBE\xBA\xBE\xCA\xFE\xCA\xFE" # End file list
        files.each do |f|
          s << "\x53\x20\x54\x20\x41\x20\x52\x20\x42\x20\x45\x20\x47\x20\x49\x20\x4e\x20\x5c\x20\x5c\x20\x26\x24"
          s << File.read(f.path)
          s << "\x53\x20\x54\x20\x41\x20\x52\x20\x45\x20\x4e\x20\x44\x20\x4f\x20\x46\x20\x5c\x20\x5c\x20\x26\x24"
        end
        s << Star::Text.pad("\x65\x20\x73\x20\x74\x20\x61\x20\x72", 16) # End of the file
      end
      File.open(outname, "w") { |fl| fl << s }
    rescue e : Exception 
      fail_with("Error writing file to disk", e)
    end
  end
end
end
end