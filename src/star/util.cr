require "gzip"

def fail_with(msg, error_obj)
  puts "Could not complete operation: #{msg}:#{error_obj.message}"
  exit(1)
end

def fail_with(msg)
  puts "Could not complete operation: #{msg}"
  exit 1
end

class File
  def self.gzip?(path : String) : Bool
    File.read(path)[0..3] == "\x1f\x8b\x08\x08"
  end
end