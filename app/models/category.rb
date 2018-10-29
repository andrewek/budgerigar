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

class Category < ApplicationRecord
  has_many :allocations, inverse_of: :category
  has_many :debits, inverse_of: :category

  validates :description, uniqueness: { case_sensitive: false }, presence: true

  before_create :generate_uuid

  scope :active, -> { where(active: true) }

  def overspent?
    available_amount < 0
  end

  def available_amount
    allocated_sum - spent_sum
  end

  def allocated_sum
    @allocated_sum ||= allocations.sum(:amount)
  end

  def spent_sum
    @spent_sum ||= debits.sum(:amount)
  end

  private

  # Prior to creation, we assign a UUID unless one has been provided for us
  # already. We don't validate this UUID, as we expect it to be universally
  # unique.
  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
