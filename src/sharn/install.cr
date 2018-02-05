require "cli"

module SharnCLI::Cmds
  macro included
    class Install < Cli::Command
      def run
        puts "Installing dependencies..."
        Process.run("shards", shell: true)
        Inspect.run
      end
    end
  end
end
