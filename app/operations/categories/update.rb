# frozen_string_literal: true

module Categories
  # We occasionally want to rename our categories
  class Update
    # Expected Arguments:
    # + :id (UUID) - ID of category to update
    # + :description (str) - new Description
    def initialize(params: {})
      @params = params
    end

    def perform
      # Save ourselves a step if our params are malformed
      return no_description_error unless @params[:description].present?

      # Find the category
      category_fetch_response = Categories::Fetch.new(params: { id: @params[:id] }).perform

      return category_fetch_response unless category_fetch_response.success?

      @category = category_fetch_response.record

      # Update it, if possible
      @category.description = @params[:description]

      if @category.valid?
        @category.save
        success_response
      else
        failure_response
      end
    end

    def success_response
      Success.new(@category, self, CategorySerializer, { include: [:debits, :'debits.uuid']})
    end

    def failure_response
      Failure.new(@category.errors.messages, self)
    end

    def no_description_error
      UnprocessableEntity.new('Missing a Description', self)
    end
  end
end
