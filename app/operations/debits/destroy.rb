# frozen_string_literal: true

module Debits
  class Destroy
    # Expected Arguments
    # + :id (uuid)
    def initialize(params: {})
      @params = params
    end

    def perform
      fetch_result = Debits::Fetch.new(params: { id: @params[:id] }).perform
      return fetch_result unless fetch_result.success?

      @debit = fetch_result.record
      @debit.destroy
      success_response
    end

    private

    def success_response
      Success.new(@debit, self, DebitSerializer)
    end
  end
end

