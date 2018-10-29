require 'rails_helper'

RSpec.describe Debits::List do
  subject { described_class }

  let(:category_1) do
    Categories::Create.new(params: { description: 'hats' }).perform.record
  end

  let(:category_2) do
    Categories::Create.new(params: { description: 'scarves' }).perform.record
  end

  let(:params_1) do
    {
      category_id: category_1.uuid,
      amount: 1000,
      payee: 'Hat Shack',
      description: 'The finest hat'
    }
  end

  let(:params_2) do
    {
      category_id: category_2.uuid,
      amount: 11000,
      payee: 'Scarf Emporium',
      description: 'neckwear'
    }
  end

  let(:debit_1) do
    Debits::Create.new(params: params_1).perform.record
  end

  let(:debit_2) do
    Debits::Create.new(params: params_2).perform.record
  end

  context 'with no params' do
    it 'lists' do
      # We gotta touch these to get them intialized
      debit_1
      debit_2

      result = subject.new(params: {}).perform
      expect(result).to be_a(Success)
      expect(result.record).to include(debit_1, debit_2)
    end
  end

  context 'with a category id' do
    it 'lists' do
      # We gotta touch these to get them intialized
      debit_1
      debit_2

      result = subject.new(params: { category_id: category_1.uuid }).perform
      expect(result).to be_a(Success)
      expect(result.record).to include(debit_1)
      expect(result.record).not_to include(debit_2)
    end
  end

  context 'with a start-date' do
    it 'lists' do
      debit_1
      debit_2

      debit_1.created_at = 5.days.ago
      debit_1.save

      result = subject.new(params: { start_date: Date.today.strftime('%Y-%m-%d') }).perform
      expect(result).to be_a(Success)
      expect(result.record).to include(debit_2)
      expect(result.record).not_to include(debit_1)
    end
  end

  context 'with an end-date' do
    it 'lists' do
      debit_1
      debit_2

      debit_1.created_at = 5.days.ago
      debit_1.save

      result = subject.new(params: { end_date: Date.yesterday.strftime('%Y-%m-%d') }).perform
      expect(result).to be_a(Success)
      expect(result.record).not_to include(debit_2)
      expect(result.record).to include(debit_1)
    end
  end

  context 'with a payee' do
    it 'lists' do
      debit_1
      debit_2

      result = subject.new(params: { payee: debit_1.payee }).perform
      expect(result).to be_a(Success)
      expect(result.record).not_to include(debit_2)
      expect(result.record).to include(debit_1)
    end
  end

  context 'with all of the above' do
    it 'lists only relevant' do
      desired = Debit.create!(category: category_1, amount: 100, created_at: 2.days.ago, payee: 'Hats')

      # Wrong date range
      Debit.create!(category: category_1, amount: 100, created_at: Date.today, payee: 'Hats')
      Debit.create!(category: category_1, amount: 100, created_at: 5.days.ago, payee: 'Hats')

      # Wrong cateogry
      Debit.create!(category: category_2, amount: 100, created_at: 2.days.ago, payee: 'Hats')

      # Wrong Payee
      Debit.create!(category: category_1, amount: 100, created_at: 2.days.ago, payee: 'Lids')

      filter_params = {
        category_id: category_1.uuid,
        payee: 'Hats',
        start_date: 3.days.ago.strftime('%Y-%m-%d'),
        end_date: 1.days.ago.strftime('%Y-%m-%d')
      }

      result = subject.new(params: filter_params).perform

      expect(result).to be_a(Success)
      expect(result.record).to include(desired)
      expect(result.record.length).to eq(1)
    end
  end
end
