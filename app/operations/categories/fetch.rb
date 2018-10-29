# frozen_string_literal: true

module Categories
  # Find a Category record by UUID
  class Fetch
    # Expected Arguments
    # + :id (UUID) - ID of record we're fetching
    def initialize(params: {})
      @params = params
    end

    def perform
      uuid = @params[:id]
      return no_uuid_error unless uuid.present?

      @category = Category.find_by_uuid(uuid)

      if @category.present?
        success_response
      else
        not_found_response
      end
    end

    private

    def serializer
      CategorySerializer
    end

    def success_response
      Success.new(@category, self, serializer)
    end

    def not_found_response
      NotFound.simple_response(self)
    end

    def no_uuid_error
      UnprocessableEntity.new('You must provide an ID with which to fetch a category', self)
    end
  end
end

