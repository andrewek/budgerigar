# frozen_string_literal: true

module Debits
  class List
    # Expected Arguments (all optional)
    # + :category_id (uuid)
    # + :start_date (YYYY-MM-DD)
    # + :end_date (YYYY-MM-DD)
    # + :payee (str)
    def initialize(params: {})
      @params = params
    end

    def perform
      # Chronological order
      @debits = Debit.order(id: :asc)

      if @params[:category_id].present?
        category_result = Categories::Fetch.new(params: { id: @params[:category_id] }).perform
        return no_category_response unless category_result.success?
        @debits = @debits.where(category_id: category_result.record.id)
      end

      @debits = @debits.where(payee: @params[:payee]) if @params[:payee].present?
      @debits = @debits.created_after(@params[:start_date]) if @params[:start_date].present?
      @debits = @debits.created_before(@params[:end_date]) if @params[:end_date].present?

      success_response
    end

    private

    # TODO: Handle invalid start_date
    def invalid_start_date_response
      UnprocessableEntity.new('start_date must be formated YYYY-MM-DD', self)
    end

    # TODO: handle invalid end_date
    def invalid_end_date_response
      UnprocessableEntity.new('end_date must be formated YYYY-MM-DD', self)
    end

    def no_category_response
      Success.new([], self, DebitSerializer)
    end

    def success_response
      Success.new(@debits, self, DebitSerializer)
    end
  end
end
