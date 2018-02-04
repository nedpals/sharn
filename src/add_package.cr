require "cli"
require "packager"

module SharnCLI
  def add_package(add_type : String, packages : Array(String))
    new_deps = {} of String => Hash(String, String)
    dep_type = add_type === "dev" ? "development_dependencies" : "dependencies"
    puts "File detected: #{detect_shard_file}" if options.debug?
    regex = Regex.new("^((github|gitlab|bitbucket):)?((.+):)?([^\/]+)\/([^#]+)(#(.+))?$")
    ver_regex = Regex.new("([^@]+)(@(.+))")

    packages.map do |pkgs|
      if package_info = pkgs.match(regex).not_nil!
        platform = package_info[2]? || "github"
        origin = package_info[4]? || nil
        owner = package_info[5]

        if name_ver = package_info[6].match(ver_regex)
          pkg_name = name_ver[1]
          version = name_ver[3]
        else
          pkg_name = package_info[6]
          version = nil
        end

        if package_info[8]?
          if branch_ver = package_info[8].match(ver_regex)
            branch = branch_ver[1] || nil
            version = branch_ver[3] || nil
          end
        else
          branch = nil
          version = nil
        end

        path = "#{owner}/#{pkg_name}"
        pkg_detail = {platform => path, "branch" => branch, "version" => version}.compact

        puts pkg_detail if options.debug?

        if [owner, pkg_name].includes?(nil)
          platform = "git"
          path = origin
        end

        if parsed_shard_file[dep_type].as_h.has_key?(pkg_name)
          puts "#{pkg_name} was already added to shards file."
        end

        new_deps = new_deps.merge({pkg_name => pkg_detail}).compact
      else
        puts "No match found."
      end
    end

    compiled_deps = {dep_type => deps_hash.merge(new_deps)}
    inserted = options.dev? ? parsed_shard_file.as_a : parsed_shard_file.as_h.merge(compiled_deps)
    output = YAML.dump(inserted).gsub("---\n", "").split("\n")
    clean_shard(output)
    output = output.join("\n")

    return output
  end
end
