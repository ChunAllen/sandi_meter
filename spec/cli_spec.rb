require 'test_helper'
require_relative '../lib/sandi_meter/cli'

describe SandiMeter::CLI do
  include FakeFS::SpecHelpers
  
  let(:cli) { SandiMeter::CLI }
  let(:gem_root) { File.expand_path('../', File.dirname(__FILE__)) }
  
  before do
    FakeFS.activate!

    FakeFS::FileSystem.clone(gem_root)
  end

  after do
    FakeFS.deactivate!
  end

  describe '#execute' do
    before do 
      @original_argv = ARGV
      ARGV.clear
    end
    
    after do 
      ARGV.clear
      ARGV.concat(@original_argv)
    end
    
    context 'with the graph flag passed in' do
      before { ARGV.push('-g') }
      after { ARGV.pop }
      
      it 'opens the graph in a web browser' do
        cli.should_receive(:open_in_browser)
        expect { cli.execute }.to raise_error(SystemExit)
      end
    end

    context 'with the quiet flag passed in' do
      before do
        ARGV.push('-q')
        ARGV.push('-g')
      end
      after do 
        ARGV.pop 
        ARGV.pop 
      end
      
      it 'does not open the browser' do
        cli.should_not_receive(:open_in_browser)
        expect { cli.execute }.to raise_error(SystemExit)
      end
    end
  end
end
