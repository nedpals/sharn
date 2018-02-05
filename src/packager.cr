require "cli"

module SharnCLI
  abstract class Packager < Cli::Command
    class Options
      bool "--dev", default: false
      bool "--force", default: false
      bool "--debug", default: false
      bool "--noinstall", default: false
      bool "--clean", default: false
      arg_array "packages"
    end

    def dep_type : String
      options.dev? ? "development_dependencies" : "dependencies"
    end

    def detect_shard_file : String
      options.debug? ? "./shard.test.yml" : "./shard.yml"
    end

    def parsed_shard_file : YAML::Any
      YAML.parse(File.read(detect_shard_file))
    end

    def empty_deps_hash
      {} of String => Hash(String, String)
    end

    def deps_hash : Hash(YAML::Type, YAML::Type)
      YAML.parse(parsed_shard_file.as_h[dep_type].to_yaml).as_h
    end

    def clean_shard(output : Array(String))
      puts output if options.debug?

      if options.clean?
        [2, 5].each do |idx|
          output = output.insert(idx, "\n")
        end
      end
    end
  end
end
