

def fail_with(msg, error_obj)
  puts "Could not complete operation: #{msg}:#{error_obj.message}"
  exit(1)
end

def fail_with(msg)
  puts "Could not complete operation: #{msg}"
  exit 1
end