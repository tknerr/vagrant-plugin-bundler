begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant PluginBundler plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.2.0"
  raise "The Vagrant PluginBundler plugin is only compatible with Vagrant 1.2+"
end

module VagrantPlugins
  module PluginBundler
    class Plugin < Vagrant.plugin("2")
      name "PluginBundler"
      description <<-DESC
      This plugin checks a list of requirements against the installed plugins.
      DESC

      config "plugin" do
        setup_i18n
        require_relative "config"
        Config
      end

      command "bundle" do
        require_relative "command"
        Command
      end

      # This initializes the internationalization strings.
      def self.setup_i18n
        I18n.load_path << File.expand_path("locales/en.yml", PluginBundler.source_root)
        I18n.reload!
      end

      check_action_hook = lambda do |hook|
        require_relative 'action/check'
        hook.before Vagrant::Action::Builtin::ConfigValidate, VagrantPlugins::PluginBundler::Action::Check
      end
      action_hook 'check-plugin-dependencies-on-machine-up', :machine_action_up, &check_action_hook
      action_hook 'check-plugin-dependencies-on-machine-reload', :machine_action_reload, &check_action_hook

    end
  end
end
