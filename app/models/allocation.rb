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

class Allocation < ApplicationRecord
  belongs_to :category

  validates :amount, numericality: { greater_than: 0, only_integer: true }
  validates :category, presence: true
end
