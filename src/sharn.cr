require "./sharn/*"
require "cli"
require "yaml"
require "json"
require "colorize"

module SharnCLI
  class Sharn < Cli::Supercommand
    version "0.0.1"
    command "install", default: true

    puts "Sharn".colorize.fore(:light_gray)
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
        shardFile = YAML.parse(File.read("./shard.yml"))
        deps = YAML.parse(shardFile.as_h["dependencies"].to_yaml).as_h

        args.packages.each do |pkgs|
          pkg = pkgs.split(":")
          name = pkg[0]
          gitUrl = pkg[1]

          oldDeps = deps
          deps = deps.merge({name => {"github" => gitUrl}})

          puts oldDeps
        end
        puts deps.to_yaml # --> TODO: Still figuring out how to replace file contents
        puts "\n"
        Inspect.run
      end
    end

    class Remove < Packager
      def run
        puts "TODO: Remove package"
        puts "\n"
        Inspect.run
      end
    end

    class Inspect < Cli::Command
      class Options
        string "-f"
      end

      def run
        crInfo = YAML.parse(File.read((options.f? ? options.f : "./shard.yml")))
        shardLInfo = YAML.parse(File.read("./shard.lock"))
        puts "#{crInfo["name"].colorize.mode(:underline).fore(:light_green)}@#{crInfo["version"]} (Crystal #{crInfo["crystal"]})"
        shardLInfo["shards"].as_h.each do |pkg|
          pkgInfo = JSON.parse(pkg[1].to_json)
          puts " └#{pkg[0].colorize.mode(:underline).fore(:light_green)}:#{pkgInfo["github"]}@#{pkgInfo["version"]}"
        end
      end
    end

    class Install < Cli::Command
      def run
        puts "TODO: Install package"

        puts "\n"
        Inspect.run
      end
    end
  end

  Sharn.run ARGV
end
