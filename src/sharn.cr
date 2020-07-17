require "option_parser"
require "path"
require "./package"

class Sharn
  include Utils

  @@VERSION = "0.3.0"
  property dir : Path
  property file_name : String = "shard.yml"
  property content : String
  property yaml : Hash(YAML::Any, YAML::Any)
  property write_file : Bool = true

  def self.version : String
    @@VERSION
  end

  def initialize(path)
    @dir = Path[path].expand(home: true)

    if dir.extension.size > 0
      @dir = Path[@dir.dirname]
    end

    @content = File.read(shard_file_path)
    @yaml = YAML.parse(@content).as_h
  end

  def shard_file_path : Path
    @dir.join(@file_name)
  end

  def add(packages : Array(String), dev : Bool = false)
    dep_key = dev ? "development_dependencies" : "dependencies"
    deps = yaml.has_key?(dep_key) ? yaml[dep_key].as_h : Hash(YAML::Any, YAML::Any).new
    n_added = 0

    packages.map {|name| Package.parse(name) }.each do |pkg|
      pkg_name = YAML::Any.new(pkg.name)
      if deps.has_key?(pkg_name)
        puts "Packages \"#{pkg.name}\" already exists. Skipping..."
      end

      deps[pkg_name] = YAML::Any.new(pkg.to_shard_h)
      n_added += 1
    end

    output = process_output(yaml, spaces: count_spaces(content))
    File.write(shard_file_path, output) if write_file
    return {n_added, output}
  end

  def remove(packages : Array(String)) : Tuple(Int32, String)
    n_removed = 0

    packages.each do |pkg_name|
      ["development_dependencies", "dependencies"].each do |key|
        next if !yaml.has_key?(key) || !yaml[key].as_h.has_key?(pkg_name)
        yaml[key].as_h.delete(pkg_name)
        n_removed += 1
        yaml.delete(key) if yaml[key].size == 0
        break
      end
    end

    output = process_output(yaml, spaces: count_spaces(content))
    File.write(shard_file_path, output) if write_file
    return {n_removed, output}
  end
end
