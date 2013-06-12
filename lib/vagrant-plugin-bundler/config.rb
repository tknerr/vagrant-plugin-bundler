require "vagrant"

module VagrantPlugins
  module PluginBundler
    class Config < Vagrant.plugin("2", :config)

      attr_reader :dependencies

      def initialize()
        @dependencies = {}
      end

      def depend(name, version)
        # TODO: what if plugin version already defined?
        @dependencies[name] = version
      end
    end
  end
end
