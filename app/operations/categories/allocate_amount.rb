# frozen_string_literal: true

module Categories
  # Add an Allocation to a Category
  class AllocateAmount
    # Expected Arguments
    # + :category_id (uuid) - UUID for category we're giving this allocation
    # + :amount (integer) - Integer amount (in cents)
    def initialize(params: {})
      @params = params
    end

    def perform
      return missing_amount_error unless @params[:amount].present?

      category_result = Categories::Fetch.new(params: { id: @params[:category_id] }).perform
      return category_result unless category_result.success?

      @category = category_result.record

      @allocation = Allocation.new(category: @category, amount: @params[:amount])

      if @allocation.valid?
        @allocation.save
        success_response
      else
        failure_response
      end
    end

    private

    def success_response
      Success.new(@category, self, CategorySerializer)
    end

    def failure_response
      Failure.new(@allocation.errors.full_messages, self)
    end

    def missing_amount_error
      UnprocessableEntity.new('Amount must be present', self)
    end
  end
end
