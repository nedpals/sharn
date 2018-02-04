require "./sharn/*"
require "cli"
require "yaml"
require "json"
require "colorize"
require "io"
require "process"

module SharnCLI
  class Sharn < Cli::Supercommand
    version VERSION
    command "install", default: true

    before_initialize do |cmd|
      # Just some crazy intro
      cmd.puts "Sharn".colorize.fore(:light_gray)
    end

    class Help
      header "Additional commands for the Shards dependency manager."
      footer "(C) 2017 github.com/nedpals | nedpals.xyz"
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
        bool "--noinstall", default: false
        bool "--clean", default: false
        arg_array "packages"
      end
    end

    class Add < Packager
      def run
        depType = options.dev? ? "development_dependencies" : "dependencies"
        file = options.debug? ? "./shard.test.yml" : "./shard.yml"
        puts "File detected: #{file}" if options.debug?
        shardFile = File.read(file)
        shard = YAML.parse(shardFile)
        deps = YAML.parse(shard.as_h[depType].to_yaml).as_h || {} of String => Hash(String, String)
        newDeps = {} of String => Hash(String, String)
        regex = Regex.new("^((github|gitlab|bitbucket):)?((.+):)?([^/]+)\/([^#]+)(#(.+))([^@]+)(@(.+))$")

        args.packages.map do |pkgs|
          if match = pkgs.match(regex).not_nil!.to_a
            platform = match[2] || "github"
            origin = match[4]
            owner = match[5]
            pkg_name = match[6]
            branch = "#{match[8]}#{match[9]}" || nil
            path = "#{owner}/#{pkg_name}"
            version = match[11] || nil
            pkg_detail = {platform => path, "branch" => branch, "version" => version}.compact

            puts pkg_detail if options.debug?

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

            newDeps = newDeps.merge({pkg_name => pkg_detail}).compact
          end
        end

        compiledDeps = {depType => deps.merge(newDeps)}

        inserted = options.dev? ? shard.as_a : shard.as_h.merge(compiledDeps)

        output = YAML.dump(inserted).gsub("---\n", "").split("\n")

        if options.clean?
          [2, 5].each do |idx|
            output = output.insert(idx, " ")
          end
        end

        output = output.join("\n")

        File.write(file, output)

        puts "\nDone."
        Install.run unless options.debug? || options.noinstall?
      end
    end

    class Rm < Packager
      def run
        depType = options.dev? ? "development_dependencies" : "dependencies"
        file = options.debug? ? "shard.test.yml" : "shard.yml"
        puts "File detected: #{file}" if options.debug?
        shardFile = File.read(file)
        shard = YAML.parse(shardFile)
        deps = YAML.parse(shard.as_h[depType].to_yaml).as_h || {} of String => Hash(String, String)
        newDeps = {} of String => Hash(String, String)
        newDeps = deps.reject(args.packages)
        compiledDeps = {depType => newDeps}
        output = YAML.dump(shard.as_h.merge(compiledDeps)).gsub("---\n", "")
        puts output if options.debug?
        File.write(options.debug? ? "./shard.test.yml" : "./shard.yml", output)
        puts "\n"
        Install.run unless options.debug? || options.noinstall?
      end
    end

    class Inspect < Cli::Command
      def run
        crInfo = YAML.parse(File.read("./shard.yml"))
        shardLInfo = YAML.parse(File.read("./shard.lock"))
        puts "#{crInfo["name"].colorize.mode(:underline).fore(:light_green)}@#{crInfo["version"]} (Min: Crystal #{crInfo["crystal"]})"
        shardLInfo["shards"].as_h.each do |pkg|
          pkgInfo = JSON.parse(pkg[1].to_json)
          puts " └#{pkg[0].colorize.mode(:underline).fore(:light_green)}:#{pkgInfo["github"]}@#{pkgInfo["version"]}"
        end
      end
    end

    class Install < Cli::Command
      def run
        puts "Installing dependencies..."
        Process.run("shards", shell: true)
        Inspect.run
      end
    end

    class Update < Cli::Command
      def run
        puts "Updating dependencies..."
        Process.run("shards update", shell: true)
        Inspect.run
      end
    end
  end

  Sharn.run ARGV
end
