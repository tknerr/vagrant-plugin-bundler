require "pathname"
require "vagrant/action/builder"

module VagrantPlugins
  module PluginBundler
    module Action
      # The autoload farm
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :Check, action_root.join("check")
    end
  end
end
