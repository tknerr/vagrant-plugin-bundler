require "vagrant"

module VagrantPlugins
  module PluginBundler
    module Errors
      class VagrantPluginBundlerError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_plugin_bundler.errors")
      end

      class PluginNotFoundError < VagrantPluginBundlerError
        error_key(:plugin_not_found)
      end

      class DuplicatePluginDefinitionError < VagrantPluginBundlerError
        error_key(:duplicate_plugin_definition)
      end

      class PluginVersionError < VagrantPluginBundlerError
        error_key(:plugin_version_error)
      end
    end
  end
end
