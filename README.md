# legion-json

JSON wrapper module for the [LegionIO](https://github.com/LegionIO/LegionIO) framework. Wraps `multi_json` and `json_pure` to provide a consistent JSON interface across all Legion gems and extensions. Automatically uses faster C-extension JSON gems (like `oj`) when available.

**Version**: 1.3.2

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
Legion::JSON.dump(pretty: true, foo: 'bar')             # keyword form — object: nil uses kwargs as data

# Full stdlib surface
Legion::JSON.parse(json_string)               # ::JSON.parse with symbolize_names: true
Legion::JSON.generate(object)                 # ::JSON.generate
Legion::JSON.pretty_generate(object)          # ::JSON.pretty_generate
Legion::JSON.fast_generate(object)            # ::JSON.fast_generate
```

Keys are symbolized by default, unlike standard Ruby JSON. `load` delegates to `MultiJson`; `parse`/`generate`/`pretty_generate`/`fast_generate` delegate to Ruby's stdlib `::JSON`.

Inside `module Legion`, `JSON` resolves to `Legion::JSON`. Use `::JSON` to access stdlib directly.

## Requirements

- Ruby >= 3.4

## License

Apache-2.0
