# frozen_string_literal: true

module Categories
  # Soft-delete a category (preserve the record)
  class Destroy
    # Expect Arguments
    # + id (UUID) - ID of category to be destroyed
    def initialize(params: {})
      @params = params
    end

    def perform
      category_fetch_response = Categories::Fetch.new(params: { id: @params[:id] }).perform

      return category_fetch_response unless category_fetch_response.success?

      @category = category_fetch_response.record
      return success_response unless @category.active?

      @category.update_attributes!(active: false)

      success_response
    end

    def success_response
      Success.new(@category, self, CategorySerializer)
    end
  end
end
