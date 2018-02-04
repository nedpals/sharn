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

    include Cmds
  end

  Sharn.run ARGV
end
