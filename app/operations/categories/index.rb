# frozen_string_literal: true

module Categories
  # List all categories
  class Index

    # Expected Arguments:
    #
    # + none
    def initialize(params: {})
      @params = params
    end

    def perform
      @categories = Category.active
      success_response
    end

    private

    def success_response
      Success.new(@categories, self, CategorySerializer)
    end
  end
end
