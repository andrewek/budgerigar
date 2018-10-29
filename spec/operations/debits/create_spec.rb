require 'rails_helper'

RSpec.describe Debits::Create do
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

  describe '#perform' do
    context 'with valid params' do
      it 'succeeds' do
        result = subject.new(params: params).perform
        expect(result).to be_a(Success)

        record = result.record
        expect(record).to be_persisted
        expect(record.category).to eq(category)
        expect(record.amount).to eq(1000)
        expect(record.payee).to eq('Hat Shack')
        expect(record.description).to eq('The finest hat')
      end
    end

    context 'with a missing description' do
      it 'succeeds' do
        params[:description] = nil
        result = subject.new(params: params).perform
        expect(result).to be_a(Success)

        record = result.record
        expect(record.description).to be_nil
      end
    end

    context 'with a missing category' do
      it 'fails' do
        params[:category_id] = nil
        result = subject.new(params: params).perform
        expect(result).to be_a(UnprocessableEntity)
      end
    end

    context 'with a non-existent category' do
      it 'fails' do
        params[:category_id] = SecureRandom.uuid
        result = subject.new(params: params).perform
        expect(result).to be_a(NotFound)
      end
    end

    context 'with a negative amount' do
      it 'fails' do
        params[:amount] = -1000
        result = subject.new(params: params).perform
        expect(result).to be_a(Failure)
      end
    end

    context 'with a 0 amount' do
      it 'fails' do
        params[:amount] = 0
        result = subject.new(params: params).perform
        expect(result).to be_a(Failure)
      end
    end

    context 'with a missing amount' do
      it 'fails' do
        params[:amount] = nil
        result = subject.new(params: params).perform
        expect(result).to be_a(UnprocessableEntity)
      end
    end

    context 'with a missing payee' do
      it 'fails' do
        params[:payee] = ''
        result = subject.new(params: params).perform
        expect(result).to be_a(UnprocessableEntity)
      end
    end
  end
end
