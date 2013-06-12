
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

          env[:machine].config.plugin.dependencies.each do |plugin, required_version|

            installed_version = @installed_plugins[plugin]
            
            unless installed_version
              raise Errors::PluginNotFoundError, 
                :required_version => required_version, 
                :plugin => plugin
            end
            
            if required_version != installed_version
              raise Errors::PluginVersionError, 
                :required_version => required_version, 
                :plugin => plugin,
                :installed_version => installed_version
            end
          end       

          # continue if ok
          @app.call(env)

        end
      end
    end
  end
end
