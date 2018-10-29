# == Schema Information
#
# Table name: allocations
#
#  id          :bigint(8)        not null, primary key
#  amount      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#
# Indexes
#
#  index_allocations_on_category_id  (category_id)
#

require 'rails_helper'

RSpec.describe Allocation, type: :model do
  let(:category) do
    Categories::Create.new(params: { description: 'Badgers' }).perform.record
  end

  describe '#valid?' do
    context 'with valid amount' do
      it 'is true' do
        a = Allocation.new(amount: 1000, category: category)
        expect(a).to be_valid
      end
    end

    context 'with a missing amount' do
      it 'is false' do
        a = Allocation.new(amount: nil, category: category)
        expect(a).not_to be_valid
        expect(a.errors.messages[:amount]).to include('is not a number')
      end
    end

    context 'with a negative amount' do
      it 'is false' do
        a = Allocation.new(amount: -1000, category: category)
        expect(a).not_to be_valid
        expect(a.errors.messages[:amount]).to include('must be greater than 0')
      end
    end

    context 'with a zero amount' do
      it 'is false' do
        a = Allocation.new(amount: 0, category: category)
        expect(a).not_to be_valid
        expect(a.errors.messages[:amount]).to include('must be greater than 0')
      end
    end

    context 'with a missing category' do
      it 'is false' do
        a = Allocation.new(amount: 1000, category: nil)
        expect(a).not_to be_valid
        expect(a.errors.messages[:category]).to include('must exist')
      end
    end
  end

  describe '#category' do
    it 'returns a category' do
      a = Allocation.create!(amount: 1000, category: category)
      expect(a.category).to eq(category)
    end
  end
end
