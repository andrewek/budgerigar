# == Schema Information
#
# Table name: debits
#
#  id          :bigint(8)        not null, primary key
#  amount      :integer
#  payee       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#
# Indexes
#
#  index_debits_on_category_id  (category_id)
#  index_debits_on_payee        (payee)
#

require 'rails_helper'

RSpec.describe Debit, type: :model do
  let(:category) do
    Categories::Create.new(
      params: { description: 'badgers' }
    ).perform.record
  end

  describe '.create' do
    let(:params) do
      {
        amount: 10000,
        category: category,
        payee: 'Hats, Inc.'
      }
    end

    it 'can be created' do
      debit = Debit.new(params)
      expect(debit).to be_valid
      debit.save!
      expect(debit).to be_persisted
    end

    it 'requires a positive amount' do
      params[:amount] = 0
      debit = Debit.new(params)
      expect(debit).not_to be_valid
      expect(debit.errors.messages[:amount]).to include('must be greater than 0')
    end

    it 'requires a category' do
      params[:category] = nil
      debit = Debit.new(params)
      expect(debit).not_to be_valid
      expect(debit.errors.messages[:category]).to include('must exist')
    end

    it 'requires a payee' do
      params[:payee] = nil
      debit = Debit.new(params)
      expect(debit).not_to be_valid
      expect(debit.errors.messages[:payee]).to include("can't be blank")
    end

    it 'allows a description' do
      params[:description] = 'One excellent hat'
      debit = Debit.new(params)
      expect(debit).to be_valid
      debit.save
      expect(debit.description).to eq('One excellent hat')
    end

    it 'has a UUID' do
      debit = Debit.new(params)
      debit.save!
      expect(debit.uuid).to be_present
    end

    it 'can accept a passed in UUID' do
      params[:uuid] = SecureRandom.uuid
      debit = Debit.new(params)
      debit.save
      expect(debit.uuid).to eq(params[:uuid])
    end
  end
end
