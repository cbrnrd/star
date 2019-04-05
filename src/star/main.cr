require "./cli"

if ARGV.size == 0 || ARGV[0] == "--verbose"
  ARGV << "-h"
end

Star::Cli.run(ARGV)