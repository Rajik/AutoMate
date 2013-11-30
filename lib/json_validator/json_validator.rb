require 'json-schema'
require 'json'
require 'pp'

module JsonValidator
  def validate_response(actual_json, api_version)
    case api_version
      when 2
        json_schema_location = File.read(Rails.root.join('lib/assets/v2_schema.json'))
      when 3
        json_schema_location = File.read(Rails.root.join('lib/assets/v3_schema.json'))
      when 4
        json_schema_location = File.read(Rails.root.join('lib/assets/v4_schema.json'))
      else
        puts "Unknown api version"
    end

    json_validator_fully_validate = JSON::Validator.fully_validate(json_schema_location, JSON.parse(actual_json))
    return json_validator_fully_validate
  end
end