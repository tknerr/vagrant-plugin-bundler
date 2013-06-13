module VagrantPlugins
  module PluginBundler
    class Command < Vagrant.plugin(2, :command)
      
      def initialize(argv, env)
        super
        @subcommand = split_main_and_subcommand(argv)[1]
      end

      def execute
        case @subcommand
        when 'install'
          puts "TODO: install missing plugins"
        when 'uninstall'
          puts "TODO: do we need uninstall really?"
        else
          @env.ui.info(help)
        end
      end

      def help
        OptionParser.new do |o|
          o.banner = "Usage: vagrant bundle <command>"
          o.separator ""
          o.separator "Available subcommands:"
          o.separator "    install"
          o.separator "    uninstall"
        end
      end
    end
  end
end