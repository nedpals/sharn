require "../packager"
require "file_utils"

module SharnCLI::Cmds
  macro included
	  class Rm < Packager
      def run
        puts "File detected: #{detect_shard_file}" if options.debug?
        new_deps = {} of String => Hash(String, String)
        new_deps = deps_hash.reject(args.packages)
        compiled_deps = {dep_type => new_deps}
        output = YAML.dump(parsed_shard_file.as_h.merge(compiled_deps)).gsub("---\n", "")

        puts output if options.debug?

        File.write(detect_shard_file, output)
        FileUtils.rm_rf(args.packages.map! { |pkgs| "lib/" + pkgs })
      end
    end
  end
end
