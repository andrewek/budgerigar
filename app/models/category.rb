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

  validates :description, uniqueness: { case_sensitive: false }, presence: true

  before_save :generate_uuid

  scope :active, -> { where(active: true) }

  def allocated_sum
    self.allocations.sum(:amount)
  end

  private

  # Prior to creation, we assign a UUID unless one has been provided for us
  # already. We don't validate this UUID, as we expect it to be universally
  # unique.
  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
