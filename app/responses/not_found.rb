# frozen_string_literal: true

class NotFound < Failure
  def self.simple_response(source)
    self.new( { errors: ['Could not locate this record'] }, source)
  end

  private

  def status
    :not_found
  end
end
