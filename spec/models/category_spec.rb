# == Schema Information
#
# Table name: categories
#
#  id          :bigint(8)        not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  uuid        :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '.create' do
    it 'creates' do
      params = { description: 'Badgers' }
      category = Category.create(params)

      expect(category).to be_persisted
      expect(category.description).to eq('Badgers')
    end

    it 'has a UUID after creation' do
      params = { description: 'Badgers' }
      category = Category.create(params)

      expect(category).to be_persisted
      expect(category.uuid).to be_present
    end

    it 'is created in active mode' do
      params = { description: 'Badgers' }
      category = Category.create(params)

      expect(category).to be_active
    end
  end

  describe '.active' do
    context 'with soft-deleted categories' do
      it 'fetches only active categories' do
        dead_category = Category.create!(description: 'Badgers', active: false)
        live_category = Category.create!(description: 'Hats', active: true)

        result = Category.active
        expect(result).to include(live_category)
        expect(result).not_to include(dead_category)
      end
    end
  end

  describe '#valid?' do
    context 'with a duplicate category name' do
      it 'is false' do
        old_category = Category.create(description: 'Badgers')

        new_category = Category.new(description: 'Badgers')
        expect(new_category).not_to be_valid
        expect(new_category.errors[:description]).to include('has already been taken')
      end

      it 'is false even with different casing' do
        old_category = Category.create(description: 'Badgers')

        new_category = Category.new(description: 'bADGERS')
        expect(new_category).not_to be_valid
        expect(new_category.errors[:description]).to include('has already been taken')
      end

      it 'is false if no description is provided' do
        category = Category.new(description: '')
        expect(category).not_to be_valid
        expect(category.errors[:description]).to include("can't be blank")
      end
    end
  end

  describe '#allocated_sum' do
    context 'with no allocations' do
      it 'defaults to zero' do
        category = Category.create!(description: 'Badgers')
        expect(category.allocated_sum).to be_zero
      end
    end

    context 'with allocations' do
      it 'sums the allocations' do
        category = Category.create!(description: 'Badgers')
        Allocation.create!(amount: 100, category: category)
        Allocation.create!(amount: 1000, category: category)

        expect(category.allocated_sum).to eq(1100)
      end
    end
  end
end
