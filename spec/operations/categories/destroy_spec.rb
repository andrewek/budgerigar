require 'rails_helper'

RSpec.describe Categories::Destroy do
  subject { described_class }

  describe '#perform' do
    context 'with a real category' do
      it 'soft-deletes' do
        create_response = Categories::Create.new(params: { description: 'Badgers' }).perform
        expect(create_response.record).to be_active
        id = create_response.record.uuid

        response = subject.new(params: { id: id }).perform

        expect(response).to be_a(Success)
        expect(response.record).not_to be_active
      end
    end

    context 'with an already soft-deleted request' do
      it 'does nothing' do
        create_response = Categories::Create.new(params: { description: 'Badgers' }).perform
        create_response.record.update_attributes!(active: false)
        expect(create_response.record).not_to be_active
        id = create_response.record.uuid

        response = subject.new(params: { id: id }).perform

        expect(response).to be_a(Success)
        expect(response.record).not_to be_active
      end
    end

    context 'with empty params' do
      it 'returns UnprocessableEntity' do
        response = subject.new(params: {}).perform

        expect(response).to be_a(UnprocessableEntity)
      end
    end

    context 'with a non-existent category' do
      it 'returns NotFound' do
        response = subject.new(params: { id: 'foobarbaz' }).perform
        expect(response).to be_a(NotFound)
      end
    end
  end
end
