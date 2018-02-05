require "cli"

module SharnCLI
  abstract class Packager < Cli::Command
    class Options
      bool "--dev", default: false, desc: "Adds packages as development dependency"
      bool "--force", default: false, desc: "Forces install shards"
      bool "--debug", default: false, desc: "For testing purposes"
      bool "--noinstall", default: false, desc: "Disable automatic install upon adding/removing"
      bool "--clean", default: false, desc: "(Experimental) Formats your Shards YAML file."
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

    def insert_hash(hash, key, new_key, new_value)
      pairs = hash.to_a

      index = pairs.index { |(k, v)| k == key }
      raise "key not found" unless index

      pairs.insert(index, {new_key, new_value})
      pairs.to_h
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
