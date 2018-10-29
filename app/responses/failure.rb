# frozen_string_literal: true

# Response object encapsulating a failure
class Failure
  attr_reader :errors, :source

  def initialize(errors, source)
    @errors = errors
    @source = source
  end

  # Loosely based on the JSON API spec: https://jsonapi.org/format/#errors
  def serialize
    { errors: [@errors].flatten }
  end

  def success?
    false
  end

  def failure?
    true
  end

  def status
    :bad_request
  end
end
