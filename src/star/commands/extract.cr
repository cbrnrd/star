# Copyright 2019 cbrnrd
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "gzip"

module Star
class Extract
  def self.run(infile : String, outdir : String, opts={} of String => String)
    verb = opts.bool["verbose"] || false
    # Check if file is in gzip format
    if File.gzip?(infile) && (opts.bool["gzip"] == false || opts.bool["gzip"].nil?)
      fail_with("File is in gzip format. Use the -g flag.")
    end

    if opts.bool["gzip"]
      # Write decompressed star file to disk and continue
      # also delete .gz from `infile`
      new_fname = infile.gsub(".gz", "")
      File.open(infile) do |f|
        Gzip::Reader.open(f) do |g|
          puts "Reading gzip file and writing to temp starfile..." if verb
          File.open(new_fname, "w") {|x| x << g.gets_to_end}
        end
      end
      infile = new_fname
    end

    fail_with("Could not find starfile #{infile}") unless File.exists?(infile)
    fail_with("Specified starfile is not a valid starfile") unless is_star_file(infile)

    star_contents = File.read(infile)

    fail_with("Target directory already exists: \"#{outdir}\"") if (File.exists?(outdir) || File.directory?(outdir))

    # If we get here, that means the target directory does not exist. Continue with creating the directory.
    begin
      puts "Creating \"#{outdir}\" directory..." if verb
      Dir.mkdir("#{outdir}")
    rescue e : Exception
      fail_with("Unable to create target directory", e)
    end
    filelist = get_file_listing(star_contents)
    hashlist = filelist.map{|f| f = f.split("{*&*}")[1]}
    if verb
      puts "hashlist: "
      hashlist.each { |h| puts "  " + h }
      puts "Removing hashes from filelist object"
    end
    filelist.map!{|f| f = f.split("{*&*}")[0]} # Remove file hash
    filelist.map!{|f| File.basename(f)} # Only use the basename

    # filelist contains ONLY BASENAMES
    # Get file contents of file (at index n)
    filelist.each_with_index do |name, i|
        unless check_hash(get_file_contents_at_index(i, star_contents), hashlist[i])
          puts "Removing the output directory due to hash mismatch." if verb
          Dir.rmdir(outdir)
          fail_with("Hash mismatch at file \"#{filelist[i]}.\" The data is either corrupted or has been tampered with.") 
        end
        puts "  extract ".colorize(:light_blue).mode(:bold).to_s + "#{outdir}#{File::SEPARATOR}#{name}" if verb
        File.open("#{outdir}#{File::SEPARATOR}#{name}", "w"){ |f| f << get_file_contents_at_index(i, star_contents) }
    end
    
    File.delete(infile) if opts.bool["gzip"] || opts.bool["delete"]

  end

  def self.sort_files(files : Array(String))
    return files.sort_by { |pth| pth.size }
  end

  def self.get_file_listing(contents) : Array(String)
    flist = [] of String
    contents = contents.gsub(Star::Text.pad("s t a r 1", 16), "") # remove magic
    contents = contents.gsub(Star::Spec::BEGIN_FILE_LIST, "") # remove begin file list
    contents = contents.partition(Star::Spec::END_FILE_LIST)
    return (contents[0].split("{:\x00:}") { |f| flist << f }).as(Array(String))
  end

  def self.get_file_contents_at_index(index : Number, contents) : String
    file_contents = contents.split(Star::Spec::END_FILE_LIST)[1..-1] # Split by star end of file hex
    file_contents.map!{|a| a.gsub(Star::Spec::BEGIN_FILE, "") } # Remove starbegin indicator
    file_contents = file_contents[0].split("\x53\x20\x54\x20\x41\x20\x52\x20\x45\x20\x4e\x20\x44\x20\x4f\x20\x46\x20\x5c\x20\x5c\x20\x26\x24")[0..-2]
    return file_contents[index]
  end

  def self.is_star_file(path : String) : Bool
    return (path[-5..-1] == ".star" && (File.read(path)[0..8] == "s t a r 1"))
  end

  def self.check_hash(contents, hash)
    return OpenSSL::Digest.new("SHA256").update(contents).hexdigest.to_s == hash
  end

  # This is pretty much the same as #run but without writing anything to disk
  def self.verify_archive(infile, opts={} of String => String)
    verb = opts.bool["verbose"] || false
    # Check if file is in gzip format
    if File.gzip?(infile) && (opts.bool["gzip"] == false || opts.bool["gzip"].nil?)
      fail_with("File is in gzip format. Use the -g flag.")
    end

    fail_with("Could not find starfile #{infile}") unless File.exists?(infile)
    fail_with("Specified starfile is not a valid starfile") unless is_star_file(infile)

    star_contents = File.read(infile)

    filelist = get_file_listing(star_contents)
    hashlist = filelist.map{|f| f = f.split("{*&*}")[1]}
    if verb
      puts "hashlist: "
      hashlist.each { |h| puts "  " + h }
      puts "Removing hashes from filelist object"
    end
    filelist.map!{|f| f = f.split("{*&*}")[0]} # Remove file hash
    filelist.map!{|f| File.basename(f)} # Only use the basename

    # filelist contains ONLY BASENAMES
    # Get file contents of file (at index n)
    failed_files = {} of String => String # filename => hash in file
    filelist.each_with_index do |name, i|
      unless check_hash(get_file_contents_at_index(i, star_contents), hashlist[i])
        failed_files[filelist[i]] = hashlist[i]
      end
    end

    if failed_files.size == 0
      puts "Archive passed verification."
    else
      puts "Archive did not pass verification."
      puts "Verification failures:"
      failed_files.each do |n, h|
        puts "  #{n} is supposed to have hash #{h[0..8]}, has #{OpenSSL::Digest.new("SHA256").update(star_contents).hexdigest.to_s[0..8]} instead." 
      end
    end
  end

end
end