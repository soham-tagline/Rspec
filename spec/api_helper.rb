# frozen_string_literal: true

def json_body
  parsed_body = JSON.parse(response.body)

  return parsed_body.with_indifferent_access if parsed_body.is_a?(Hash)

  parsed_body
end
