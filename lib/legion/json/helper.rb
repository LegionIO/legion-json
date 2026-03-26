# frozen_string_literal: true

module Legion
  module JSON
    module Helper
      def json_load(string, symbolize_keys: true)
        Legion::JSON.load(string, symbolize_keys: symbolize_keys)
      end

      def json_dump(object, pretty: false)
        opts = { pretty: pretty }
        Legion::JSON.dump(object, **opts)
      end

      def json_parse(string, symbolize_names: true)
        Legion::JSON.parse(string, symbolize_names: symbolize_names)
      end

      def json_generate(object)
        Legion::JSON.generate(object)
      end

      def json_pretty_generate(object)
        Legion::JSON.pretty_generate(object)
      end
    end
  end
end
