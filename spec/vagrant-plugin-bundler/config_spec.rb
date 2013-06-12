require "vagrant-plugin-bundler/config"

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
        config.dependencies.should == { 'foo' => '1.0.0' }
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
          config.dependencies.should == { 'foo' => '1.0.0', 'bar' => '1.1.0' }
        end
      end
      context "with same plugin twice" do
        before do
          config.depend 'foo', '1.0.0'
          config.depend 'foo', '1.1.0'
          config.finalize!
        end
        it "should contain the plugin only once" do
          config.dependencies.size.should == 1
        end
        it "the last one should win" do
          config.dependencies.should == { 'foo' => '1.1.0' }
        end
      end
    end
  end
end
