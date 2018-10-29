class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :description
      t.boolean :active, default: true
      t.uuid :uuid

      t.timestamps
    end
  end
end
