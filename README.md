# OpenApi2JsonSchema

This is a simplified ruby port of [Javascript library
openapi-schema-to-json-schema](https://github.com/openapi-contrib/openapi-schema-to-json-schema)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'open_api_2_json_schema'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install open_api_2_json_schema

## Usage

```ruby
# if you want to convert from file
OpenApi2JsonSchema.convert_from_file("path/to/open_api.yml")

# if you want to convert from stringify hash
schema = {
  'type' => 'string',
  'format' => 'date-time',
  'nullable' => true
}
OpenApi2JsonSchema.convert(schema)
```

### Discriminator

```yaml
# Sample YAML file
schema:
  discriminator:
    propertyName: key
    mapping:
      value1: 'path-to-file-2.yml'
      value2: 'path-to-file-2.yml'
  properties:
    key:
      type: string
      enum:
        - value1
        - value2
```

```json
"schema": {
  "properties": {
    "key": {
      "type": "string",
      "enum": ["value1", "value2"]
    }
  },
  "discriminator": {
    "propertyName": "name",
    "mapping": {
      "value1": {
        "type": "object"
      },
      "value2": {
        "type": "array"
      }
    }
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hieuk09/open_api_2_json_schema.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
