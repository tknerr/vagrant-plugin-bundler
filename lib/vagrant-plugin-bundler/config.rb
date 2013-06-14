require "vagrant"

module VagrantPlugins
  module PluginBundler
    class Config < Vagrant.plugin("2", :config)

      attr_reader :dependencies

      def initialize()
        @dependencies = {}
      end

      def deps(&block)
        instance_eval(&block)
      end

      def depend(name, version)
        if @dependencies[name]
          # raise early here because our hook has to run BEFORE validation
          raise Errors::DuplicatePluginDefinitionError, :plugin => name
        end
        @dependencies[name] = version
      end
    end
  end
end
