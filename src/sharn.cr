require "./sharn/*"
require "cli"
require "yaml"
require "json"

module SharnCLI
  class Sharn < Cli::Supercommand
    version "0.0.1"
    command "install", default: true

    class Help
      header "Additional commands for the Shards package manager."
      footer "(C) 2017 nedpals"
    end

    class Options
      help
      version
    end

    abstract class Packager < Cli::Command
      class Options
        bool "--dev", default: true
        bool "--force", default: true
        arg_array "packages"
      end
    end

    class Add < Packager
      def run
        puts (options.dev? ? "TODO: Add development package" : "TODO: Add package")
        args.packages.each do |pkg|
          puts pkg
        end
        Inspect.run
      end
    end

    class Remove < Packager
      def run
        puts "TODO: Remove package"
        Inspect.run
      end
    end

    class Inspect < Cli::Command
      class Options
        string "-f"
      end

      def run
        shardInfo = YAML.parse(File.read((options.f? ? options.f : "./shard.yml")))
        puts "#{shardInfo["name"]}@#{shardInfo["version"]} (Crystal #{shardInfo["crystal"]})"
        shardInfo["dependencies"].each do |pkg|
          puts "└#{pkg}"
        end
      end
    end

    class Install < Cli::Command
      def run
        puts "TODO: Install package"
      end
    end
  end

  Sharn.run ARGV
end
