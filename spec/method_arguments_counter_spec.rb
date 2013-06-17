require 'test_helper'
require_relative '../lib/method_arguments_counter'

describe MethodArgumentsCounter do
  let(:test_loader) { ArgsLoader.new }
  let(:analyzer) { MethodArgumentsCounter.new }

  context 'when variable/method arguments' do
    let(:args_add_block_1) { load_args_block('blah arg1, arg2')}
    let(:args_add_block_2) { load_args_block('blah(arg1, arg2)')}

    it 'counts arguments' do
      analyzer.count(args_add_block_1).should eq([2, 1])
      analyzer.count(args_add_block_2).should eq([2, 1])
    end
  end

  context 'when hash arguments' do
    let(:args_add_block_1) { load_args_block('blah k: :v') }
    let(:args_add_block_2) { load_args_block('blah(k: :v)') }

    let(:args_add_block_3) { load_args_block('blah k1: :v1, k2: :v2') }
    let(:args_add_block_4) { load_args_block('blah(k1: :v1, k2: :v2)') }

    it 'counts arguments' do
      analyzer.count(args_add_block_1).should eq([1, 1])
      analyzer.count(args_add_block_2).should eq([1, 1])
      analyzer.count(args_add_block_3).should eq([2, 1])
      analyzer.count(args_add_block_4).should eq([2, 1])
    end
  end

  context 'when variable/method with hash' do
    let(:code_1) { load_args_block('blah arg_1, arg_2, k: :v') }
    let(:code_2) { load_args_block('blah(arg_1, arg_2, k: :v)') }
    let(:code_3) { load_args_block('blah arg_1, arg_2, k1: :v1, k2: :v2') }
    let(:code_4) { load_args_block('blah(arg_1, arg_2, k1: :v1, k2: :v2)') }

    it 'counts arguments' do
      analyzer.count(code_1).should eq([3, 1])
      analyzer.count(code_2).should eq([3, 1])
    end

    it 'counts hash keys as argumets' do
      analyzer.count(code_3).should eq([4, 1])
      analyzer.count(code_4).should eq([4, 1])
    end
  end
end
