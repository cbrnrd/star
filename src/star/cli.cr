require "commander"
require "./constants"
require "./commands/*"

module Star
class Cli
  def self.run(args)
    cli = Commander::Command.new do |command|
      command.use = "star"
      command.long = "The Stupid Archive format\n\n  star v#{Star::VERSION}"

      command.commands.add do |cmd|
        cmd.use = "combine"
        cmd.short = "Combines the files into a .star file."
        cmd.long = cmd.short

        cmd.run do |opts, args|
          # star combine MyName.star file1.txt file2.txt ...
          filename = args[0]
          files = args[1..-1]
          Star::Commands::Combine.run(filename, opts, files)
        end
      end

      command.flags.add do |flag|
        flag.name = "verbose"
        flag.long = "--verbose"
        flag.description = "Run with verbose output."
        flag.default = false
      end

    end
    Commander.run(cli, args)
  end
end
end