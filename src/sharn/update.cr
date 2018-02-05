require "cli"

module SharnCLI::Cmds
  macro included
	 class Update < Cli::Command
      def run
        puts "Updating dependencies..."
        Process.run("shards update", shell: true)
        Inspect.run
      end
    end
  end
end
