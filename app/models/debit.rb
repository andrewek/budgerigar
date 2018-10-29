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

class Debit < ApplicationRecord
  belongs_to :category

  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :category, presence: true
  validates :payee, presence: true

  before_create :generate_uuid

  scope :created_before, ->(end_date) { where('created_at <= ?', DateTime.parse(end_date).end_of_day) }
  scope :created_after, ->(start_date) { where('created_at >= ?', DateTime.parse(start_date).beginning_of_day) }

  private

  # Prior to creation, we assign a UUID unless one has been provided for us
  # already. We don't validate this UUID, as we expect it to be universally
  # unique.
  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
