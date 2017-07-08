require "./sharn/*"
require "cli"
require "yaml"
require "json"
require "colorize"

module SharnCLI
  class Sharn < Cli::Supercommand
    version "0.1.11"
    command "install", default: true

    # Just some crazy intro
    sleep(1)
    puts "Sharn".colorize.fore(:light_gray)
    sleep(3)

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
        shardFile = File.read("./shard.test.yml")
        shard = YAML.parse(shardFile)
        deps = YAML.parse(shard.as_h["dependencies"].to_yaml).as_h
        newDeps = {} of String => Hash(String, String)
        sLines = shardFile.lines

        args.packages.map do |pkgs|
          sleep(1)
          pkg = pkgs.split(":")
          pkg_name = pkg[0]
          pkg_repo = pkg[1]
          if args.packages.first?
            newDeps[pkg_name] = {"github" => pkg_repo}
          else
            newDeps.merge({pkg_name => {"github" => pkg_repo}})
          end

          if shardFile["dependencies"]?.try &.[pkg_name]?
            puts "#{pkg_name} was already added to shards file."
          end
        end
        compiledDeps = {"dependencies" => deps.merge(newDeps)}
        output = YAML.dump(shard.as_h.merge(compiledDeps)).gsub("---\n", "")
        File.write("./shard.test.yml", output)
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
