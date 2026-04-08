# frozen_string_literal: true

require 'spec_helper'
require 'legion/json'

RSpec.describe Legion::JSON do
  describe '.parser' do
    it 'returns MultiJson as the default parser' do
      expect(described_class.parser).to eq(MultiJson)
    end

    it 'memoizes the parser' do
      expect(described_class.parser).to be(described_class.parser)
    end
  end

  describe '.load' do
    context 'with symbolized keys (default)' do
      it 'parses a simple JSON object' do
        result = described_class.load('{"foo":"bar"}')
        expect(result).to eq(foo: 'bar')
      end

      it 'parses nested JSON objects' do
        json = '{"outer":{"inner":"value","deep":{"key":"found"}}}'
        result = described_class.load(json)
        expect(result[:outer][:inner]).to eq('value')
        expect(result[:outer][:deep][:key]).to eq('found')
      end

      it 'parses JSON with multiple keys' do
        json = '{"a":"1","b":"2","c":"3"}'
        result = described_class.load(json)
        expect(result).to eq(a: '1', b: '2', c: '3')
      end
    end

    context 'with symbolize_keys: false' do
      it 'returns string keys' do
        result = described_class.load('{"foo":"bar"}', symbolize_keys: false)
        expect(result).to eq('foo' => 'bar')
        expect(result.keys.first).to be_a(String)
      end

      it 'returns string keys for nested objects' do
        json = '{"outer":{"inner":"value"}}'
        result = described_class.load(json, symbolize_keys: false)
        expect(result['outer']['inner']).to eq('value')
      end
    end

    context 'with various JSON types' do
      it 'parses integers' do
        result = described_class.load('{"count":42}')
        expect(result[:count]).to eq(42)
      end

      it 'parses floats' do
        result = described_class.load('{"price":19.99}')
        expect(result[:price]).to eq(19.99)
      end

      it 'parses booleans' do
        result = described_class.load('{"active":true,"deleted":false}')
        expect(result[:active]).to be true
        expect(result[:deleted]).to be false
      end

      it 'parses null values' do
        result = described_class.load('{"value":null}')
        expect(result[:value]).to be_nil
        expect(result).to have_key(:value)
      end

      it 'parses arrays' do
        result = described_class.load('{"items":[1,2,3]}')
        expect(result[:items]).to eq([1, 2, 3])
      end

      it 'parses top-level arrays' do
        result = described_class.load('[1,"two",3]')
        expect(result).to eq([1, 'two', 3])
      end

      it 'parses an empty object' do
        result = described_class.load('{}')
        expect(result).to eq({})
      end

      it 'parses an empty array' do
        result = described_class.load('[]')
        expect(result).to eq([])
      end

      it 'parses unicode strings' do
        result = described_class.load('{"greeting":"héllo wörld 🌍"}')
        expect(result[:greeting]).to eq('héllo wörld 🌍')
      end

      it 'parses strings with escaped characters' do
        result = described_class.load('{"text":"line1\\nline2\\ttab"}')
        expect(result[:text]).to eq("line1\nline2\ttab")
      end
    end

    context 'round-trip fidelity' do
      it 'preserves data through load -> dump -> load' do
        original = '{"name":"test","count":5,"active":true,"tags":["a","b"]}'
        hash = described_class.load(original)
        json = described_class.dump(hash)
        reloaded = described_class.load(json)
        expect(reloaded).to eq(hash)
      end
    end
  end

  describe '.dump' do
    it 'serializes a simple hash' do
      result = described_class.dump({ foo: 'bar' })
      expect(result).to eq('{"foo":"bar"}')
    end

    it 'serializes nested hashes' do
      result = described_class.dump({ a: { b: 'c' } })
      expect(described_class.load(result)).to eq(a: { b: 'c' })
    end

    it 'serializes arrays' do
      result = described_class.dump([1, 2, 3])
      expect(result).to eq('[1,2,3]')
    end

    it 'serializes nil values' do
      result = described_class.dump({ key: nil })
      expect(result).to eq('{"key":null}')
    end

    it 'serializes booleans' do
      result = described_class.dump({ yes: true, no: false })
      parsed = described_class.load(result)
      expect(parsed[:yes]).to be true
      expect(parsed[:no]).to be false
    end

    it 'serializes an empty hash' do
      expect(described_class.dump({})).to eq('{}')
    end

    it 'serializes an empty array' do
      expect(described_class.dump([])).to eq('[]')
    end

    context 'with pretty: true' do
      it 'produces formatted output with newlines' do
        result = described_class.dump({ foo: 'bar' }, pretty: true)
        expect(result).to include("\n")
        expect(described_class.load(result)).to eq(foo: 'bar')
      end

      it 'produces valid JSON that round-trips' do
        original = { name: 'test', items: [1, 2] }
        pretty = described_class.dump(original, pretty: true)
        expect(described_class.load(pretty)).to eq(original)
      end
    end

    context 'with pretty: false (default)' do
      it 'produces compact output without extra whitespace' do
        result = described_class.dump({ foo: 'bar' })
        expect(result).not_to include("\n")
      end
    end
  end

  describe '.parse' do
    it 'parses JSON with symbolized keys by default' do
      result = described_class.parse('{"foo":"bar"}')
      expect(result).to eq(foo: 'bar')
    end

    it 'parses nested objects with symbolized keys' do
      result = described_class.parse('{"outer":{"inner":"value"}}')
      expect(result[:outer][:inner]).to eq('value')
    end

    it 'returns string keys when symbolize_names is false' do
      result = described_class.parse('{"foo":"bar"}', symbolize_names: false)
      expect(result).to eq('foo' => 'bar')
    end

    it 'parses arrays' do
      result = described_class.parse('[1,"two",3]')
      expect(result).to eq([1, 'two', 3])
    end

    it 'raises ParseError on invalid JSON' do
      expect { described_class.parse('{bad}') }.to raise_error(Legion::JSON::ParseError)
    end

    it 'includes original input in ParseError' do
      bad = '{"broken'
      expect { described_class.parse(bad) }.to raise_error(Legion::JSON::ParseError) do |e|
        expect(e.data).to eq(bad)
      end
    end

    it 'round-trips with generate' do
      original = { name: 'test', count: 5 }
      json = described_class.generate(original)
      result = described_class.parse(json)
      expect(result).to eq(original)
    end
  end

  describe '.generate' do
    it 'serializes a hash to compact JSON' do
      result = described_class.generate({ foo: 'bar' })
      expect(result).to eq('{"foo":"bar"}')
    end

    it 'serializes an array' do
      result = described_class.generate([1, 2, 3])
      expect(result).to eq('[1,2,3]')
    end

    it 'produces compact output without newlines' do
      result = described_class.generate({ a: 1, b: 2 })
      expect(result).not_to include("\n")
    end

    it 'serializes nested structures' do
      result = described_class.generate({ a: { b: [1, 2] } })
      parsed = described_class.parse(result)
      expect(parsed).to eq(a: { b: [1, 2] })
    end
  end

  describe '.pretty_generate' do
    it 'produces formatted output with newlines' do
      result = described_class.pretty_generate({ foo: 'bar' })
      expect(result).to include("\n")
    end

    it 'produces valid JSON that round-trips' do
      original = { name: 'test', items: [1, 2] }
      pretty = described_class.pretty_generate(original)
      expect(described_class.parse(pretty)).to eq(original)
    end

    it 'produces indented output' do
      result = described_class.pretty_generate({ foo: 'bar' })
      expect(result).to include('  ')
    end
  end

  describe '.fast_generate' do
    it 'serializes a hash' do
      result = described_class.fast_generate({ foo: 'bar' })
      expect(described_class.parse(result)).to eq(foo: 'bar')
    end

    it 'serializes an array' do
      result = described_class.fast_generate([1, 2, 3])
      expect(described_class.parse(result)).to eq([1, 2, 3])
    end
  end
end

RSpec.describe Legion::JSON::ParseError do
  describe '.build' do
    let(:original_error) do
      MultiJson.load('{bad json}')
    rescue StandardError => e
      e
    end
    let(:bad_input) { '{bad json}' }
    let(:parse_error) { described_class.build(original_error, bad_input) }

    it 'is a StandardError' do
      expect(parse_error).to be_a(StandardError)
    end

    it 'preserves the original error message' do
      expect(parse_error.message).to eq(original_error.message)
    end

    it 'stores the original input as data' do
      expect(parse_error.data).to eq(bad_input)
    end

    it 'stores the original error as cause' do
      expect(parse_error.cause).to eq(original_error)
    end

    it 'preserves the original backtrace' do
      expect(parse_error.backtrace).to eq(original_error.backtrace)
    end
  end

  context 'when raised from Legion::JSON.load' do
    it 'raises ParseError for unclosed string' do
      expect { Legion::JSON.load('{"foo":"bar}') }.to raise_error(described_class)
    end

    it 'raises ParseError for unclosed brace' do
      expect { Legion::JSON.load('{') }.to raise_error(described_class)
    end

    it 'raises ParseError for unquoted keys' do
      expect { Legion::JSON.load('{foo:"bar"}') }.to raise_error(described_class)
    end

    it 'raises ParseError for trailing comma' do
      expect { Legion::JSON.load('{"foo":"bar",}') }.to raise_error(described_class)
    end

    it 'raises ParseError for completely invalid input' do
      expect { Legion::JSON.load('not json at all') }.to raise_error(described_class)
    end

    it 'returns nil for empty string' do
      expect(Legion::JSON.load('')).to be_nil
    end

    it 'includes the original input in the error' do
      bad_input = '{"broken'
      begin
        Legion::JSON.load(bad_input)
      rescue described_class => e
        expect(e.data).to eq(bad_input)
      end
    end
  end
end

RSpec.describe Legion::Exception::InvalidJson do
  it 'is a StandardError' do
    expect(described_class.new).to be_a(StandardError)
  end

  it 'can be raised and rescued' do
    expect { raise described_class, 'bad data' }.to raise_error(described_class, 'bad data')
  end
end

RSpec.describe Legion::Json do
  it 'has a version number' do
    expect(Legion::Json::VERSION).not_to be_nil
  end

  it 'has a version that is a string' do
    expect(Legion::Json::VERSION).to be_a(String)
  end

  it 'has a version matching semver format' do
    expect(Legion::Json::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
