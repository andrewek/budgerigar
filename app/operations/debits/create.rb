# frozen_string_literal: true

module Debits
  class Create
    # Expected Arguments
    # :amount (int)
    # :category_id (uuid)
    # :payee (str)
    # :description (str - optional)
    def initialize(params: {})
      @params = params
    end

    def perform
      return missing_amount_error unless @params[:amount].present?
      return missing_payee_error unless @params[:payee].present?

      # Fetch the category
      category_result = Categories::Fetch.new(params: { id: @params[:category_id] }).perform
      return category_result unless category_result.success?

      category = category_result.record

      @debit = Debit.new(
        amount: @params[:amount],
        category: category,
        description: @params[:description],
        payee: @params[:payee]
      )

      if @debit.valid?
        @debit.save
        success_response
      else
        failure_response
      end
    end

    private

    def success_response
      Created.new(@debit, self, DebitSerializer)
    end

    def failure_response
      Failure.new(@debit.errors.full_messages, self)
    end

    def missing_amount_error
      UnprocessableEntity.new('Amount must be present', self)
    end

    def missing_payee_error
      UnprocessableEntity.new('Payee must be present', self)
    end
  end
end
