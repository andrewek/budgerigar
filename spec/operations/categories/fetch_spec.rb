require 'rails_helper'

RSpec.describe Categories::Fetch do
  subject { described_class }

  describe '#perform' do
    context 'with an existing record' do
      it 'finds with UUID' do
        # Set up the DB
        create_result = Categories::Create.new(params: { description: 'my cool category' }).perform

        category = create_result.record

        operation = subject.new(params: { id: category.uuid })
        result = operation.perform
        expect(result).to be_a(Success)
        expect(result.record).to eq(category)
      end

      it 'finds with sanitized UUID' do
        # Set up the DB
        create_result = Categories::Create.new(params: { description: 'my cool category' }).perform

        category = create_result.record

        new_uuid = category.uuid.gsub('-', '').downcase

        operation = subject.new(params: { id: new_uuid })
        result = operation.perform
        expect(result).to be_a(Success)
        expect(result.record).to eq(category)
      end
    end

    context 'with no record' do
      it 'returns NotFound' do
        operation = subject.new(params: { id: SecureRandom.uuid })
        result = operation.perform
        expect(result).to be_a(NotFound)
        expect(result.serialize[:errors]).not_to be_empty
      end
    end

    context 'with no passed in ID' do
      it 'returns UnprocessableEntity' do
        operation = subject.new(params: {})
        result = operation.perform

        expect(result).to be_a(UnprocessableEntity)
        expect(result.serialize[:errors]).not_to be_empty
      end
    end
  end
end
