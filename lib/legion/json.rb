# frozen_string_literal: true

require 'legion/json/version'
require 'legion/json/parse_error'
require 'legion/json/invalid_json'
require 'json'
require 'multi_json'
require_relative 'json/helper'

module Legion
  module JSON
    def parser
      @parser ||= MultiJson
    end
    module_function :parser

    def load(string, symbolize_keys: true)
      parser.load(string, symbolize_keys: symbolize_keys)
    rescue StandardError => e
      raise Legion::JSON::ParseError.build(e, string)
    end
    module_function :load

    def dump(object = nil, pretty: false, **kwargs)
      data = object.nil? ? kwargs : object
      # Only pass pretty: when true — Oj/MultiJson treats any explicit pretty: (even false) as truthy
      pretty ? parser.dump(data, pretty: true) : parser.dump(data)
    end
    module_function :dump

    def parse(string, symbolize_names: true)
      ::JSON.parse(string, symbolize_names: symbolize_names)
    rescue StandardError => e
      raise Legion::JSON::ParseError.build(e, string)
    end
    module_function :parse

    def generate(object)
      ::JSON.generate(object)
    end
    module_function :generate

    def pretty_generate(object)
      ::JSON.pretty_generate(object)
    end
    module_function :pretty_generate

    def fast_generate(object)
      ::JSON.fast_generate(object)
    end
    module_function :fast_generate
  end
end
