# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::JSON::Helper do
  let(:test_class) do
    Class.new do
      include Legion::JSON::Helper
    end
  end
  let(:instance) { test_class.new }

  describe '#json_load' do
    it 'parses JSON with symbolized keys by default' do
      result = instance.json_load('{"name":"test","value":42}')
      expect(result).to eq(name: 'test', value: 42)
    end

    it 'parses JSON with string keys when requested' do
      result = instance.json_load('{"name":"test"}', symbolize_keys: false)
      expect(result).to eq('name' => 'test')
    end

    it 'raises ParseError on invalid JSON' do
      expect { instance.json_load('not json') }.to raise_error(Legion::JSON::ParseError)
    end
  end

  describe '#json_dump' do
    it 'serializes a hash to JSON' do
      result = instance.json_dump({ name: 'test', value: 42 })
      parsed = instance.json_load(result)
      expect(parsed).to eq(name: 'test', value: 42)
    end

    it 'accepts pretty option' do
      result = instance.json_dump({ name: 'test' }, pretty: true)
      expect(result).to include("\n")
    end
  end
end
