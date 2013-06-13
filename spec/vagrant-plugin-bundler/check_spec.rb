
require "vagrant-plugin-bundler/action/check"
require "vagrant-plugin-bundler/errors"

describe VagrantPlugins::PluginBundler::Action::Check do

  let(:app) { double("app") }
  let(:env) { double("env") }
  let(:check) { described_class.new(app, env) }

  I18n.load_path << File.expand_path("../../../locales/en.yml", __FILE__)
  I18n.reload!
  
  context "when matching" do
    before do
      check.stub(:installed_plugins => {'foo' => '1.2.3'})
      check.stub(:required_plugins => {'foo' => '1.2.3'})
    end
    it "should proceed" do
      app.should_receive(:call)
      check.call(env)
    end
  end
  
  context "when wrong version" do
    before do
      check.stub(:installed_plugins => {'foo' => '1.2.3'})
      check.stub(:required_plugins => {'foo' => '1.2.4'})
    end
    it "should error with wrong version" do
      expect { check.call(env) }.to raise_error(
        VagrantPlugins::PluginBundler::Errors::PluginsNotFoundError,
        /Version 1.2.4 of foo required. Version 1.2.3 installed/)
    end
  end

  context "when plugin not installed" do
    before do
      check.stub(:installed_plugins => {'bar' => '1.2.3'})
      check.stub(:required_plugins => {'foo' => '1.2.3'})
    end
    it "should error with plugin not installed" do
      expect { check.call(env) }.to raise_error(
        VagrantPlugins::PluginBundler::Errors::PluginsNotFoundError,
        /Version 1.2.3 of foo required. Plugin not installed/)
    end
  end
end
