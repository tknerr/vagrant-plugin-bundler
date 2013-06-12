# -*- mode: ruby -*-
# vi: set ft=ruby :

# require plugin for testing via bundler
Vagrant.require_plugin "vagrant-plugin-bundler"
Vagrant.require_plugin "vagrant-omnibus"


Vagrant.configure("2") do |config|

  config.plugin.depend 'vagrant-omnibus', '1.0.2'
 # config.plugin.depend 'vagrant-omnibus'
  config.plugin.depend 'vagrant-foo', '1.0.2'

  # we require vagrant-omnibus plugin!
  config.omnibus.chef_version = "11.4.4"

  # sample vm
  config.vm.define :foo do |foo_config|
    foo_config.vm.box = "opscode_ubuntu-13.04_provisionerless"
    foo_config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box"
  end

end
