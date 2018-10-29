# frozen_string_literal: true

# This is our semi-abstract base class. We should only need to override private
# methods on child classes.
class Response
  attr_reader :source, :record, :serializer, :options

  # Constructor:
  #
  # Params:
  # + record - usually a model, but not always. The thing we actually
  #            made/modified with our operation.
  # + source - the operation itself
  # + serializer - Class constant, used for serialization
  # + options - not used yet
  #
  def initialize(record, source, serializer, options = {})
    @record = record
    @source = source
    @serializer = serializer
    @options = {}
  end

  # Get back a serialized JSON hash
  def serialize
    serializer.new(record).serializable_hash
  end

  # Boolean value indicating success
  def success?
    successful?
  end

  # Boolean value indicating failure
  def failure?
    !successful?
  end

  # symbol, which should map to an HTTP status code
  def status
    private_status
  end

  private

  def successful?
    raise StandardError, 'Should be true or false'
  end

  def private_status
    raise StandardError, 'should be a symbol corresponding to an HTTP status'
  end
end
