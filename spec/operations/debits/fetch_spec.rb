require 'rails_helper'

RSpec.describe Debits::Fetch do
  subject { described_class }

  describe '#perform' do
    context 'with an existing debit' do
      it 'succeeds' do
        category = Categories::Create.new(params: { description: 'hats' }).perform.record
        debit_response = Debits::Create.new(
          params: { category_id: category.uuid, amount: 100, payee: 'hats emporium' }
        ).perform

        expect(debit_response).to be_a(Created)

        result = subject.new(params: { id: debit_response.record.uuid }).perform
        expect(result).to be_a(Success)
      end
    end

    context 'with a missing ID' do
      it 'is unprocessable' do
        result = subject.new(params: { id: nil }).perform
        expect(result).to be_a(UnprocessableEntity)
      end
    end

    context 'with no debit' do
      it 'cannot find' do
        result = subject.new(params: { id: SecureRandom.uuid }).perform
        expect(result).to be_a(NotFound)
      end
    end
  end
end
