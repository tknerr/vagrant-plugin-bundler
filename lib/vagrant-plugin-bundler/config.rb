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

      def depend(name, version, *options)
        if @dependencies[name]
          # raise early here because our hook has to run BEFORE validation
          raise Errors::DuplicatePluginDefinitionError, :plugin => name
        end
        settings = Hash[ :version => version, :message => '' ]
        if (not options.nil?()) and options.length > 0
          options.each { |opt|
            opt.each { |k,v|
              settings[k] = v
            }
          }
        end
        #require '/Applications/Vagrant/embedded/lib/ruby/gems/1.9.1/gems/awesome_print-1.1.0/lib/awesome_print.rb'
        #ap settings
        @dependencies[name] = settings
      end
    end
  end
end
