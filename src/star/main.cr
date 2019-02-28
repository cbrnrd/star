require "./cli"

if ARGV.size == 0
  ARGV << "-h"
end

Star::Cli.run(ARGV)