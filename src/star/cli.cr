require "commander"
require "./constants"
require "./util"
require "./text"
require "./commands/*"

module Star
class Cli
  def self.run(args)

    cli = Commander::Command.new do |command|
      command.use = "star"
      command.long = "The Stupid Archive format\n\n  star v#{Star::VERSION}"

      command.commands.add do |cmd|
        cmd.use = "combine <star file> [file1 file2 ...]"
        cmd.short = "Combines the files into a .star file."
        cmd.long = cmd.short

        cmd.run do |opts, args|
          # star combine MyName.star file1.txt file2.txt ...
          fail_with("You need a list of files first.") if args.size == 1
          fail_with("File extension needs to be '.star'") unless args[0].ends_with?(".star")
          filename = args[0]
          files = args[1..-1]
          Star::Commands::Combine.run(filename, opts, files)
        end
      end

      command.commands.add do |cmd|
        cmd.use = "extract <star file> [outfile] [opts]"
        cmd.short = "Extracts all files"
        cmd.long = cmd.short

        cmd.flags.add do |f|
          f.name = "gzip"
          f.short = "-g"
          f.long = "--gzip"
          f.description = "Decompress the gzipped .star file."
          f.default = false
        end

        cmd.flags.add do |f|
          f.name = "delete"
          f.short = "-d"
          f.long = "--delete"
          f.description = "Delte the star file after extracting it."
          f.default = false
        end

        cmd.run do |opts, args|
          if args.size == 0
            puts "You need to specify a starfile to extract."
            exit(1)
          end
          filename = args[0]
          if args.size == 1
            outfile = args[0].gsub(".star", "")
            outfile = outfile.gsub(".gz", "") if opts.bool["gzip"] 
          else 
            outfile = args[1]
          end
          Star::Extract.run(filename, outfile, opts)
        end
      end

      command.commands.add do |cmd|
        cmd.use = "version"
        cmd.short = "Show the star program version"
        cmd.long = command.short

        cmd.run do
          puts "star v\u001b[37;1m#{Star::VERSION}\u001b[0m"
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