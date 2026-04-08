# Legion::JSON

## [1.3.2] - 2026-04-08

### Fixed
- Removed `require 'legion/logging'` and `Legion::Logging::Helper` dependency that broke standalone usage (legion-logging is not a gemspec dependency)
- Fixed SimpleCov profile not being activated in spec_helper, restoring 100% coverage enforcement

## [1.3.1] - 2026-03-27

### Changed
- `.dump` now accepts `**kwargs` — callers can pass `Legion::JSON.dump(key: val)` without wrapping in `{}`
- `pretty:` keyword option preserved; all other kwargs become the serialized object

## [1.3.0] - 2026-03-26

### Added
- `.parse(string, symbolize_names: true)` — wraps `::JSON.parse` with `ParseError` error handling and symbol keys by default
- `.generate(object)` — wraps `::JSON.generate` for compact output
- `.pretty_generate(object)` — wraps `::JSON.pretty_generate` for formatted output
- `.fast_generate(object)` — wraps `::JSON.fast_generate` for unchecked fast output
- Helper methods: `json_parse`, `json_generate`, `json_pretty_generate` in `Legion::JSON::Helper`

## [1.2.1] - 2026-03-22

### Added
- `Legion::JSON::Helper` mixin module with `json_load` and `json_dump` convenience methods for LEX extensions

## v1.2.0
Moving from BitBucket to GitHub. All git history is reset from this point on