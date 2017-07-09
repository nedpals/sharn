require "./sharn/*"
require "cli"
require "yaml"
require "json"
require "colorize"

module SharnCLI
  class Sharn < Cli::Supercommand
    version "0.1.13"
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
        bool "--dev", default: false
        bool "--force", default: false
        string "--branch"
        arg_array "packages"
      end
    end

    class Add < Packager
      def run
        shardFile = File.read("./shard.yml")
        shard = YAML.parse(shardFile)
        deps = YAML.parse(shard.as_h["dependencies"].to_yaml).as_h
        newDeps = {} of String => Hash(String, String)

        args.packages.map do |pkgs|
          sleep(1)
          pkg = pkgs.split(/[:@]/)

          if shardFile["dependencies"]?.try &.[pkg_name]?
            puts "#{pkg_name} was already added to shards file."
          if %w(git gitlab github bitbucket).any? { |s| pkg.first.includes? s }
            pkg_git = pkg[0]
            pkg_name = pkg[1]
            pkg_repo = pkg[2]
            pkg_ver = pkg[3].nil? ? nil : pkg[3]
            pkg_branch = options.branch.nil? ? nil : options.branch
          else
            pkg_git = "github"
            pkg_name = pkg[0]
            pkg_repo = pkg[1]
            pkg_ver = pkg[2].nil? ? nil : pkg[2]
            pkg_branch = options.branch.nil? ? nil : options.branch
          end

          if args.packages.first?
            newDeps[pkg_name] = {pkg_git => pkg_repo, "version" => pkg_ver, "branch" => pkg_branch}.compact
          else
            newDeps.merge({pkg_name => {pkg_git => pkg_repo, "version" => pkg_ver, "branch" => pkg_branch}}.compact)
          end
        end
        compiledDeps = {"dependencies" => deps.merge(newDeps)}
        output = YAML.dump(shard.as_h.merge(compiledDeps)).gsub("---\n", "")
        File.write("./shard.yml", output)
        puts "\n"
        Inspect.run
      end
    end

    class Remove < Packager
      def run
        shardFile = File.read("./shard.yml")
        shard = YAML.parse(shardFile)
        deps = YAML.parse(shard.as_h["dependencies"].to_yaml).as_h
        newDeps = {} of String => Hash(String, String)
        sleep(1)
        newDeps = deps.reject(args.packages)
        compiledDeps = {"dependencies" => newDeps}
        output = YAML.dump(shard.as_h.merge(compiledDeps)).gsub("---\n", "")
        File.write("./shard.yml", output)
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
