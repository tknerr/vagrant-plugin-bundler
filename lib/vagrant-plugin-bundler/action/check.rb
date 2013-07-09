
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
            match = line.match(/\s*(\S+)\s*\((\S+)\)/)
            if not match.nil?
              name, version = match.captures
              @installed_plugins[name]=version
            else
              raise Errors::PluginVersionError, line
            end
          end

          env[:machine].config.plugin.dependencies.each do |plugin, settings|

            required_version = settings[:version]
            #options = settings[:options]
            installed_version = @installed_plugins[plugin]
            
            args = settings.merge(Hash[:required_version => required_version,:plugin => plugin])

            unless installed_version
              raise Errors::PluginNotFoundError, 
                args
            end
            
            if required_version != installed_version
              args[:installed_version] = installed_version
              raise Errors::PluginVersionError, 
                args
            end
          end       

          # continue if ok
          @app.call(env)

        end
      end
    end
  end
end
