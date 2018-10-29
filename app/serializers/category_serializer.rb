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

class CategorySerializer
  include FastJsonapi::ObjectSerializer
  set_type :category
  set_id :uuid

  attributes :description, :active
end
