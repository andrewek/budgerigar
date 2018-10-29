# frozen_string_literal: true

module Debits
  class Fetch
    # Expected Arguments
    # + :id (uuid)
    def initialize(params: {})
      @params = params
    end

    def perform
      return missing_id_error unless @params[:id].present?

      @debit = Debit.find_by_uuid(@params[:id])

      return not_found_error unless @debit.present?
      success_response
    end

    private

    def success_response
      Success.new(@debit, self, DebitSerializer)
    end

    def missing_id_error
      UnprocessableEntity.new('You must provide an ID with which to fetch a debit', self)
    end

    def not_found_error
      NotFound.simple_response(self)
    end
  end
end
