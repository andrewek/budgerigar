require 'rails_helper'

RSpec.describe Categories::Update do
  subject { described_class }

  describe '#perform' do
    context 'with valid params' do
      it 'updates' do
        create_response = Categories::Create.new(params: { description: 'Badgers' }).perform
        expect(create_response.record).to be_active
        id = create_response.record.uuid

        response = subject.new(params: { id: id, description: 'Honey-Badgers' }).perform

        expect(response).to be_a(Success)
        expect(response.record.description).to eq('Honey-Badgers')
      end
    end

    context 'with valid ID and invalid description' do
      it 'fails' do
        original_category = Categories::Create.new(params: { description: 'Honey-Badgers' }).perform
        expect(original_category).to be_success

        create_response = Categories::Create.new(params: { description: 'Badgers' }).perform

        expect(create_response.record).to be_active
        id = create_response.record.uuid

        # This description is already taken
        response = subject.new(params: { id: id, description: 'Honey-Badgers' }).perform

        expect(response).to be_a(Failure)
      end
    end

    context 'with empty params' do
      it 'returns UnprocessableEntity on missing ID' do
        response = subject.new(params: { description: 'Badgers'}).perform

        expect(response).to be_a(UnprocessableEntity)
      end

      it 'returns UnprocessableEntity on missing description' do
        create_response = Categories::Create.new(params: { description: 'Badgers' }).perform
        expect(create_response.record).to be_active
        id = create_response.record.uuid

        response = subject.new(params: { id: id, description: '' }).perform
        expect(response).to be_a(UnprocessableEntity)
      end
    end

    context 'with a non-existent category' do
      it 'returns NotFound' do
        response = subject.new(params: { id: 'foobarbaz', description: 'blah' }).perform
        expect(response).to be_a(NotFound)
      end
    end
  end
end
