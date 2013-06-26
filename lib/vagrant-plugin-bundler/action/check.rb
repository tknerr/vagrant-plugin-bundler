
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

          env[:machine].config.plugin.dependencies.each do |plugin, settings|

            required_version = settings[:version]
            #options = settings[:options]
            installed_version = @installed_plugins[plugin]
            
            require '/Applications/Vagrant/embedded/lib/ruby/gems/1.9.1/gems/awesome_print-1.1.0/lib/awesome_print.rb'
            #ap options if not options.nil?
            args = settings.merge(Hash[:required_version => required_version,:plugin => plugin])
            ap args

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
