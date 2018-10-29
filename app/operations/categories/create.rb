# frozen_string_literal: true

module Categories
  # Create a Category record
  class Create
    # Expected Arguments:
    #
    # + :description (str) - Unique text description
    def initialize(params: params)
      @params = params
    end

    def perform
      @category = Category.new(description: @params[:description])

      if @category.valid?
        @category.save
        success_response
      else
        failure_response
      end
    end

    private

    def success_response
      Created.new(@category, self, CategorySerializer)
    end

    def failure_response
      Failure.new(@category.errors.messages, self)
    end
  end
end
