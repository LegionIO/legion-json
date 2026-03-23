# frozen_string_literal: true

module Legion
  module JSON
    module Helper
      def json_load(string, symbolize_keys: true)
        Legion::JSON.load(string, symbolize_keys: symbolize_keys)
      end

      def json_dump(object, pretty: false)
        Legion::JSON.dump(object, pretty: pretty)
      end
    end
  end
end
