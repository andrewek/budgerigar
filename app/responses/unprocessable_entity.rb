# frozen_string_literal: true

class UnprocessableEntity < Failure
  private

  def status
    :unprocessable_entity
  end
end
