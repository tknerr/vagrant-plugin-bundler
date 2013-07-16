# DEPRECATION NOTICE

---

**This plugin will no longer be actively developed, 
please use https://github.com/fgrehm/vundler instead.**

---


# Vagrant PluginBundler Plugin

[![Build Status](https://travis-ci.org/tknerr/vagrant-plugin-bundler.png?branch=master)](https://travis-ci.org/tknerr/vagrant-plugin-bundler)

This is a [Vagrant](http://www.vagrantup.com) 1.2+ plugin which hooks in before `vagrant up` and `vagrant reload` and ensures that the required vagrant plugins as specified in your Vagrantfile are installed. Think of a minimalist [Bundler](http://gembundler.com) for vagrant plugins.

## Installation

Install using the standard Vagrant 1.1+ plugin installation method:
```
$ vagrant plugin install vagrant-plugin-bundler
```

## Usage

After installing, you can specify the required plugin dependencies in your `Vagrantfile` like so:
```ruby
Vagrant.configure("2") do |config|
  
  # require the vagrant-omnibus plugin...
  config.plugin.depend 'vagrant-omnibus', '1.0.2'

  # ...because we use it here:
  config.omnibus.chef_version = "11.4.4"

  ...

end
```

Assuming the [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus) plugin is not installed yet, `vagrant up` will now fail:
```
$ vagrant up
Bringing machine 'foo' up with 'virtualbox' provider...
Version 1.0.2 of vagrant-omnibus required. No version found.

=> run `vagrant plugin install vagrant-omnibus --plugin-version 1.0.2` to fix this
```

Once you installed the missing plugin via `vagrant plugin install` and thus the required plugin dependencies are met...
```
$ vagrant plugin install vagrant-omnibus --plugin-version 1.0.2
Installing the 'vagrant-omnibus --version '1.0.2'' plugin. This can take a few minutes...
Installed the plugin 'vagrant-omnibus (1.0.2)'!
```

...you can run `vagrant up` again and it will continue as usual:
```
$ vagrant up
Bringing machine 'foo' up with 'virtualbox' provider...
[foo] Setting the name of the VM...
[foo] Clearing any previously set forwarded ports...
[foo] Fixed port collision for 22 => 2222. Now on port 2201.
[foo] Creating shared folders metadata...
[foo] Clearing any previously set network interfaces...
[foo] Preparing network interfaces based on configuration...
[foo] Forwarding ports...
[foo] -- 22 => 2201 (adapter 1)
[foo] Booting VM...
...
``` 

## Block Syntax

If you have multiple dependencies, you can specify them line by line:
```ruby
  # multiple plugin dependencies, one per line
  config.plugin.depend 'vagrant-omnibus', '1.0.2'
  config.plugin.depend 'vagrant-cachier', '0.1.0'
  config.plugin.depend 'vagrant-aws', '0.2.2'
```

But it reads better if you use the block syntax:
```ruby
  # multiple plugin dependencies in a block
  config.plugin.deps do
    depend 'vagrant-omnibus', '1.0.2'
    depend 'vagrant-cachier', '0.1.0'
    depend 'vagrant-aws', '0.2.2'
  end
```

## Community Resources

You can find resources such as blog posts about Vagrant Plugin Bundler or other projects that use Vagrant Plugin Bundler [here](https://github.com/tknerr/vagrant-plugin-bundler/wiki/Community-Resources).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Make sure specs are passing (`rake spec`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
