require "cli"

module SharnCLI::Cmds
  macro included
    class Inspect < Cli::Command
      class Options
        string "-f", default: "./shard.yml"
        string "--lockfile", default: "shard.lock"
      end

      def run
        shard = YAML.parse(File.read(options.f))
        lockfile = YAML.parse(File.read(options.lockfile))
        puts "#{shard["name"].colorize.mode(:underline).fore(:light_green)}@#{shard["version"]} (Min: Crystal #{shard["crystal"]})"
        lockfile["shards"].as_h.each do |installed_pkg|
          pkg_info = JSON.parse(installed_pkg[1].to_json)
          puts " └#{installed_pkg[0].colorize.mode(:underline).fore(:light_green)}:#{pkg_info["github"]}@#{pkg_info["version"]}"
        end
      end
    end
  end
end
