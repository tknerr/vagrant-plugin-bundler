
require "vagrant-plugin-bundler/config"
require "vagrant-plugin-bundler/errors"

describe VagrantPlugins::PluginBundler::Config do
  let(:config) { described_class.new }

  # Ensure tests are not affected by AWS credential environment variables
  before :each do
    ENV.stub(:[] => nil)
  end

  describe "config.dependencies" do

    context "when nothing specified" do
      before do
        config.finalize!
      end
      it "should be empty" do
        config.dependencies.should be_empty
      end      
    end

    context "when single plugin specified" do
      before do
        config.depend 'foo', '1.0.0'
        config.finalize!
      end
      it "should contain exactly one plugin" do
        config.dependencies.size.should == 1
      end
      it "should contain the specified plugin" do
        config.dependencies.should == {"foo"=>{:version=>"1.0.0", :message=>""}}
      end
    end

    context "when multiple plugins specified" do
      context "with all different plugins" do
        before do
          config.depend 'foo', '1.0.0'
          config.depend 'bar', '1.1.0'
          config.finalize!
        end
        it "should contain all specified plugins" do
          config.dependencies.should == {"foo"=>{:version=>"1.0.0", :message=>""}, "bar"=>{:version=>"1.1.0", :message=>""}}
        end
      end
      context "with same plugin twice" do
        it "should fail" do
          begin
            config.depend 'foo', '1.0.0'
            config.depend 'foo', '1.1.0'
            fail "it should have raised 'DuplicatePluginDefinitionError'"
          rescue VagrantPlugins::PluginBundler::Errors::DuplicatePluginDefinitionError
            # expected
          end
        end
      end
    end

    context "when specifying multiple dependencies in a block" do
      it "should work too" do
        config.deps do
          depend 'foo', '1.0'
          depend 'bar', '2.0'
        end
        config.finalize!
        config.dependencies.should == {"foo"=>{:version=>"1.0", :message=>""}, "bar"=>{:version=>"2.0", :message=>""}}
      end
    end
  end
end
