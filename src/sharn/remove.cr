require "../packager"

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

        puts "\n"

        Install.run unless options.debug? || options.noinstall?
      end
    end
  end
end
