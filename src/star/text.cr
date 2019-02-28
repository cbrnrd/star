module Star
class Text
  def self.pad(msg, len, wth="\x00")
    results = msg
    (len - msg.size).times do
      results = results + wth
    end
    return results
  end
end
end

def vprint(msg)
  puts msg if ENV["STAR_VERBOSE"]
end