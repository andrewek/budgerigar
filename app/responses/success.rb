# frozen_string_literal: true

class Success < Response
  private

  def successful?
    true
  end

  def private_status
    :ok
  end
end
