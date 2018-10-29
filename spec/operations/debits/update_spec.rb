require 'rails_helper'

RSpec.describe Debits::Update do
  subject { described_class }

  let(:category) do
    Categories::Create.new(params: { description: 'hats' }).perform.record
  end

  let(:new_category) do
    Categories::Create.new(params: { description: 'scarves' }).perform.record
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
    context 'with a new category' do
      it 'updates' do
        result = subject.new(params: { id: debit.uuid, category_id: new_category.uuid }).perform
        expect(result).to be_a(Success)
        expect(result.record.category).to eq(new_category)
      end
    end

    context 'with no new attributes' do
      it 'does nothing' do
        result = subject.new(params: { id: debit.uuid }).perform
        expect(result).to be_a(Success)
      end
    end

    context 'with a new amount' do
      it 'updates' do
        result = subject.new(params: { id: debit.uuid, amount: 50000 }).perform
        expect(result).to be_a(Success)
        expect(result.record.amount).to eq(50000)
      end
    end

    context 'with a new payee' do
      it 'updates' do
        result = subject.new(params: { id: debit.uuid, payee: 'Haberdashery, LLC' }).perform
        expect(result).to be_a(Success)
        expect(result.record.payee).to eq('Haberdashery, LLC')
      end
    end

    context 'with a new description' do
      it 'updates' do
        result = subject.new(params: { id: debit.uuid, description: 'New Lid' }).perform
        expect(result).to be_a(Success)
        expect(result.record.description).to eq('New Lid')
      end
    end

    context 'with invalid id' do
      it 'fails' do
        result = subject.new(params: { id: SecureRandom.uuid, description: 'blah' }).perform
        expect(result).to be_a(NotFound)
      end
    end

    context 'with invalid category' do
      it 'fails' do
        result = subject.new(params: { id: debit.uuid, category_id: SecureRandom.uuid }).perform
        expect(result).to be_a(Failure)
      end
    end

    context 'with invalid amount' do
      it 'fails' do
        result = subject.new(params: { id: debit.uuid, amount: 0 }).perform
        expect(result).to be_a(Failure)
      end
    end

    context 'with invalid payee' do
      it 'fails' do
        result = subject.new(params: { id: debit.uuid, payee: '' }).perform
        expect(result).to be_a(Failure)
      end
    end
  end
end
