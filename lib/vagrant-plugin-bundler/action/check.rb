
module VagrantPlugins
  module PluginBundler
    module Action
      # This middleware checks if reqiured plugins are present
      class Check

        def initialize(app, env)
          @app    = app
          @installed_plugins = {}
        end

        def call(env)
          
          # check plugins
          #output = `D:/Repos/_github/bills-kitchen/target/build/tools/vagrant/HashiCorp/Vagrant/bin/vagrant plugin list`
          output = `vagrant plugin list`
          
          output.each_line do |line|
            name, version = line.match(/\s*(\S+)\s*\((\S+)\)/).captures
            @installed_plugins[name]=version
          end

          required_plugins = env[:machine].config.plugin.dependencies
          
          missing_plugins,good_plugins = required_plugins.partition do |plugin,version|
            required_plugins[plugin] != @installed_plugins[plugin]
          end
          
          unless missing_plugins.empty?
            errors = missing_plugins.map do |plugin, required_version| 
              installed_version = @installed_plugins[plugin]
              if installed_version
                I18n.t('vagrant_plugin_bundler.errors.plugin_version_error', 
                  :plugin => plugin,
                  :required_version => required_version,
                  :installed_version => installed_version)
              else
                I18n.t('vagrant_plugin_bundler.errors.plugin_not_found',
                  :plugin => plugin, 
                  :required_version => required_version)
              end
            end
            raise Errors::PluginsNotFoundError, :errors => errors.join("\n")
          end

          # continue if ok
          @app.call(env)

        end
      end
    end
  end
end
