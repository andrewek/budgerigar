# == Schema Information
#
# Table name: debits
#
#  id          :bigint(8)        not null, primary key
#  amount      :integer
#  description :string
#  payee       :string
#  uuid        :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#
# Indexes
#
#  index_debits_on_category_id  (category_id)
#  index_debits_on_payee        (payee)
#

class DebitSerializer
  include FastJsonapi::ObjectSerializer
  set_type :debit
  set_id :uuid

  attributes :amount, :description, :payee

  # Format date as 'YYYY-MM-DD'
  attribute :transacted_on do |obj|
    obj.created_at.strftime('%Y-%m-%d')
  end

  belongs_to :category, serializer: CategorySerializer, id_method_name: :uuid
end
