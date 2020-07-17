require "yaml"
require "regex"

class Package
    property name : String
    property author : String
    property platform : String
    property version : String?
    property branch : String?

    def initialize(@platform, @author, @name, @branch, @version); end

    def path : String
        "#{author}/#{name}"
    end

    def self.parse(uri : String) : Package
        platforms = ["github", "gitlab", "bitbucket"].join("|")
        regex = Regex.new("^(?:(#{platforms}):)?([^\/]+)\/([^#@]+)(?:#(\w+))?(?:@(.+))?$")
        
        if info = regex.match(uri).not_nil!
            platform = info[1]? || "github"
            author = info[2]
            name = info[3]
            branch = info[4]?
            version = info[5]?

            return Package.new(platform, author, name, branch, version)
        else
            raise "Invalid package identifier."
        end
    end

    def to_shard_h : Hash(YAML::Any, YAML::Any)
        shard_h = Hash(String, String).new
        shard_h[platform] = path
        if !version.nil?
            shard_h["version"] = version.not_nil!
        end
        if !branch.nil?
            shard_h["branch"] = branch.not_nil!
        end

        shard_h.map { |k, v| [YAML::Any.new(k), YAML::Any.new(v)] }.to_h
    end
end