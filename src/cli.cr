require "option_parser"
require "time"
require "./utils"
require "./sharn"

class CLI
  def self.show_version
    puts "Sharn " + Sharn.version
    puts "Crystal: " + Crystal::VERSION
  end

  def self.print_header
    now = Time.utc
    puts "Sharn " + Sharn.version
    puts "Copyright 2017-#{now.year.to_s} Ned Palacios | github.com/nedpals"  
  end

  def self.run
    is_dev = false
    is_no_install = false
    selected_path = "."
    selected_cmd = ""
    packages = Array(String).new

    parser = OptionParser.new do |parser|
      parser.banner = "sharn [command] [option] [arguments...]"

      parser.on("add", "Add the packages into the manifest") do
        parser.banner = "sharn add [options] [packages...]"

        parser.on("-D", "--dev", "Add the packages as development dependencies.") do
          is_dev = true
        end

        parser.on("-ni", "--noinstall", "Skip installing dependencies listed on shard.yml.") do
          is_no_install = true
        end

        parser.on("-p PATH", "--path=PATH", "Specify the path to use.") do |s_path|
          selected_path = s_path
        end

        selected_cmd = "add"
      end

      parser.on("remove", "Remove the specified packages") do
        parser.banner = "sharn add [options] [packages...]"

        parser.on("-ni", "--noinstall", "Skip installing dependencies listed on shard.yml.") do
          is_no_install = true
        end

        parser.on("-p PATH", "--path=PATH", "Specify the path to use.") do |s_path|
          selected_path = s_path
        end

        selected_cmd = "remove"
      end

      parser.on("-h", "--help", "Show the help screen.") do
        print_header if selected_cmd.empty?
        puts parser
        exit
      end

      parser.on("-v", "--version", "Prints the version of the application") do
        show_version
        exit
      end

      parser.unknown_args do |args|
        if ["add", "remove"].includes?(selected_cmd)
          packages = args
        end
      end
    end

    parser.parse
    sharn = Sharn.new(selected_path)

    case selected_cmd
    when "add"
      n_added, _ = sharn.add(packages, dev: is_dev)
      puts "#{n_added} packages were added."
    when "remove"
      n_removed, _ = sharn.remove(packages)
      puts "#{n_removed} packages were removed."
    else
      print_header
      puts parser
      exit
    end
  end
end

CLI.run