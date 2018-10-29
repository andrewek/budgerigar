require 'rails_helper'

RSpec.describe Categories::Create do
  subject { described_class }

  describe '.perform_using' do
    context 'with valid params' do
      it 'succeeds' do
        params = { description: 'my category' }
        builder = subject.new(params: params)
        result = builder.perform

        expect(result).to be_success
        expect(result).to be_a(Created)
        expect(result.record).to be_a(Category)
        expect(result.source).to eq(builder)
        expect(result.serializer).to eq(CategorySerializer)
      end

      it 'does not carry over UUID' do
        params = { description: 'my category', uuid: SecureRandom.uuid }
        builder = subject.new(params: params)
        result = builder.perform

        expect(result).to be_success
        expect(result).to be_a(Created)
        expect(result.record.uuid).not_to eq(params[:uuid])
      end
    end

    context 'with invalid params' do
      it 'fails' do
        builder = subject.new(params: {})
        result = builder.perform
        expect(result).to be_a(Failure)

        serialized_result = result.serialize
        expect(serialized_result[:errors]).not_to be_empty
      end
    end
  end
end
