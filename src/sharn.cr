require "./sharn/*"
require "cli"
require "yaml"
require "json"
require "colorize"
require "io"
require "process"

module SharnCLI
  class Sharn < Cli::Supercommand
    version "0.1.16"
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
        bool "--debug", default: false
        arg_array "packages"
      end
    end

    class Add < Packager
      def run
        depType = options.dev? ? "development_dependencies" : "dependencies"

        shardFile = File.read(options.debug? ? "./shard.test.yml" : "./shard.yml")
        shard = YAML.parse(shardFile)
        deps = YAML.parse(shard.as_h[depType].to_yaml).as_h || {} of String => Hash(String, String)
        newDeps = {} of String => Hash(String, String)

        args.packages.map do |pkgs|
          regex = Regex.new("^((github|gitlab|bitbucket):)?((.+):)?([^/]+)\/([^#]+)(#(.+))?$")

          if match = regex.match(pkgs).not_nil!.to_a
            platform = match[2] || "github"
            origin = match[4]
            owner = match[5]
            pkg_name = match[6]
            branch = match[8] || "master"
            path = "#{owner}/#{pkg_name}"

            if owner == nil && pkg_name == nil
              platform = "git"
              path = origin
            end

            # if origin === nil
            #   if platform === "github"
            #     origin = "github.com"
            #   elsif platform === "gitlab"
            #     origin = "gitlab.com"
            #   elsif platform === "bitbucket"
            #     origin = "bitbucket.com"
            #   end
            # end

            if shard[depType].as_h.has_key?(pkg_name)
              puts "#{pkg_name} was already added to shards file."
            end
          end

          newDeps = newDeps.merge({pkg_name => {platform => path, "branch" => branch}}).compact
        end
        # sleep(1)
        compiledDeps = {depType => deps.merge(newDeps)}

        if options.dev?
          inserted = shard.as_a
          output = YAML.dump(inserted).gsub("---\n", "")
        else
          output = YAML.dump(shard.as_h.merge(compiledDeps)).gsub("---\n", "")
        end

        puts output
        File.write(options.debug? ? "./shard.test.yml" : "./shard.yml", output)
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
        output = IO::Memory.new

        Process.run("shards", output: output)
        output.close
        output.to_s

        puts "\n"
        Inspect.run
      end
    end

    class Update < Cli::Command
      def run
        output = IO::Memory.new

        Process.run("shards update", output: output)
        output.close
        output.to_s

        puts "\n"
        Inspect.run
      end
    end
  end

  Sharn.run ARGV
end
