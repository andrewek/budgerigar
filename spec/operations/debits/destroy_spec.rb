require 'rails_helper'

RSpec.describe Debits::Destroy do
  subject { described_class }

  let(:category) do
    Categories::Create.new(params: { description: 'hats' }).perform.record
  end

  let(:params) do
    {
      category_id: category.uuid,
      amount: 1000,
      payee: 'Hat Shack',
      description: 'The finest hat'
    }
  end

  let(:debit) do
    Debits::Create.new(params: params).perform.record
  end

  describe '#perform' do
    context 'with an existing debit' do
      it 'succeeds' do
        result = subject.new(params: { id: debit.uuid }).perform
        expect(result).to be_a(Success)

        fetch_result = Debits::Fetch.new(params: { id: debit.uuid }).perform
        expect(fetch_result).to be_a(NotFound)
      end
    end

    context 'with a missing debit' do
      it 'fails to find' do
        result = subject.new(params: { id: SecureRandom.uuid }).perform
        expect(result).to be_a(NotFound)
      end
    end

    context 'with a missing ID' do
      it 'is unprocessable' do
        result = subject.new(params: { id: '' }).perform
        expect(result).to be_a(UnprocessableEntity)
      end
    end
  end
end
