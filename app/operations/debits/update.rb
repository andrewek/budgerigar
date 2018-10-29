# frozen_string_literal: true

module Debits
  class Update
    # Expected Arguments
    # + :id (UUID) - required
    # + :category_id (uuid) - optional
    # + :payee (str) - optional
    # + :description (str) - optional
    def initialize(params: {})
      @params = params
    end

    def perform
      fetch_result = Debits::Fetch.new(params: { id: @params[:id] }).perform
      return fetch_result unless fetch_result.success?

      @debit = fetch_result.record

      if @params[:category_id].present?
        category_fetch = Categories::Fetch.new(params: { id: @params[:category_id] }).perform
        return category_fetch unless category_fetch.success?
        @debit.category = category_fetch.record
      end

      if @params[:amount]
        @debit.amount = @params[:amount]
      end

      if @params[:description]
        @debit.description = @params[:description]
      end

      if @params[:payee]
        @debit.payee = @params[:payee]
      end

      if @debit.valid?
        @debit.save
        success_response
      else
        failure_response
      end
    end

    private

    def failure_response
      Failure.new(@debit.errors.full_messages, self)
    end

    def success_response
      Success.new(@debit, self, DebitSerializer)
    end
  end
end

