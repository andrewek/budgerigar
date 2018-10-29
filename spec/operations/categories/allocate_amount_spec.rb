require 'rails_helper'

RSpec.describe Categories::AllocateAmount do
  subject { described_class }

  let(:category) do
    Categories::Create.new(params: { description: 'Badgers' }).perform.record
  end

  describe '#perform' do
    context 'with valid params' do
      it 'succeeds' do
        allocation_result = subject.new(params: { category_id: category.uuid, amount: 1000 }).perform
        expect(allocation_result).to be_a(Success)

        record = allocation_result.record
        expect(record).to be_persisted
        expect(record.allocated_sum).to eq(1000)
        expect(record).to eq(category)
      end
    end

    context 'with a missing category ID' do
      it 'fails' do
        allocation_result = subject.new(params: { category_id: '', amount: 1000 }).perform
        expect(allocation_result).to be_a(UnprocessableEntity)
        expect(allocation_result.serialize[:errors]).to include('You must provide an ID with which to fetch a category')
      end
    end

    context 'with a missing amount' do
      it 'fails' do
        allocation_result = subject.new(params: { category_id: category.uuid, amount: nil }).perform
        expect(allocation_result).to be_a(UnprocessableEntity)
        expect(allocation_result.serialize[:errors]).to include('Amount must be present')
      end
    end

    context 'with an invalid category ID' do
      it 'fails' do
        allocation_result = subject.new(params: { category_id: 'foobarbaz', amount: 1000 }).perform
        expect(allocation_result).to be_a(NotFound)
      end
    end

    context 'with an invalid amount' do
      it 'fails' do
        allocation_result = subject.new(params: { category_id: category.uuid, amount: 0 }).perform

        expect(allocation_result).to be_a(Failure)
        expect(allocation_result.serialize[:errors]).to include('Amount must be greater than 0')
      end
    end
  end
end
