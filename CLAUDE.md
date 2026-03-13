# legion-json: JSON Wrapper for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

JSON wrapper module for the LegionIO framework. Wraps `multi_json` and `json_pure` to provide a consistent JSON interface across all Legion gems and extensions. Automatically uses faster C-extension JSON gems (like `oj`) when available.

**GitHub**: https://github.com/LegionIO/legion-json
**License**: Apache-2.0

## Architecture

```
Legion::Json
├── .load(string, symbolize_keys: true)   # Deserialize JSON -> Hash
├── .dump(hash)                            # Serialize Hash -> JSON
├── InvalidJson                            # Custom error class
└── ParseError                             # JSON parse error class
```

### Key Design Patterns

- **Thin Wrapper**: Delegates to `MultiJson.load` / `MultiJson.dump`
- **Symbolized Keys by Default**: `symbolize_keys: true` is the default (unlike standard JSON)
- **Auto C-Extension**: If `oj` gem is installed, `multi_json` automatically uses it for performance

## Dependencies

| Gem | Purpose |
|-----|---------|
| `multi_json` | JSON adapter abstraction |
| `json_pure` | Pure-Ruby JSON fallback |

## File Map

| Path | Purpose |
|------|---------|
| `lib/legion/json.rb` | Module entry with `load`/`dump` methods |
| `lib/legion/json/invalid_json.rb` | InvalidJson error class |
| `lib/legion/json/parse_error.rb` | ParseError class |
| `lib/legion/json/version.rb` | VERSION constant |

## Role in LegionIO

**Foundation gem** - used by nearly every other Legion gem. `legion-settings` depends on it directly for config file parsing. All message serialization flows through this module.

```
legion-json
  ^
  |-- legion-settings
  |     ^
  |     |-- legion-cache
  |     |-- legion-data
  |     |-- legion-transport
  |     └-- LegionIO
  └-- legion-transport (direct dependency)
```

---

**Maintained By**: Matthew Iverson (@Esity)
