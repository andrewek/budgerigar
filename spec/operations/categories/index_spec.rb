require 'rails_helper'

RSpec.describe Categories::Index do
  subject { described_class }

  describe '#perform' do
    context 'with active rules' do
      it 'returns all active rules' do
        category_1 = Categories::Create.new(params: { description: 'Badgers' }).perform.record
        category_2 = Categories::Create.new(params: { description: 'Hats' }).perform.record

        result = subject.new.perform
        expect(result).to be_a(Success)
        expect(result.record.length).to eq(2)
        expect(result.record).to include(category_1)
        expect(result.record).to include(category_2)
      end
    end

    context 'with inactive rules' do
      it 'returns only active categories' do
        category_1 = Categories::Create.new(params: { description: 'Badgers' }).perform.record
        category_2 = Categories::Create.new(params: { description: 'Hats' }).perform.record

        category_2 = Categories::Destroy.new(params: { id: category_2.uuid }).perform.record

        result = subject.new.perform
        expect(result).to be_a(Success)
        expect(result.record.length).to eq(1)
        expect(result.record).to include(category_1)
        expect(result.record).not_to include(category_2)
      end
    end

    context 'with no rules' do
      it 'returns an empty result' do
        result = subject.new.perform
        expect(result).to be_a(Success)
        expect(result.record).to be_empty
      end
    end
  end
end
