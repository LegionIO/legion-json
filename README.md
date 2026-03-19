# legion-json

JSON wrapper module for the [LegionIO](https://github.com/LegionIO/LegionIO) framework. Wraps `multi_json` and `json_pure` to provide a consistent JSON interface across all Legion gems and extensions. Automatically uses faster C-extension JSON gems (like `oj`) when available.

**Version**: 1.2.0

## Installation

```bash
gem install legion-json
```

Or add to your Gemfile:

```ruby
gem 'legion-json'
```

## Usage

```ruby
require 'legion/json'

json_string = '{"foo":"bar","nested":{"hello":"world"}}'
Legion::JSON.load(json_string)                          # => {foo: "bar", nested: {hello: "world"}}
Legion::JSON.load(json_string, symbolize_keys: false)   # => {"foo" => "bar", ...}

hash = { foo: 'bar', nested: { hello: 'world' } }
Legion::JSON.dump(hash)                                 # => '{"foo":"bar","nested":{"hello":"world"}}'
```

Keys are symbolized by default, unlike standard Ruby JSON.

## Requirements

- Ruby >= 3.4

## License

Apache-2.0
