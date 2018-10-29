class CreateDebits < ActiveRecord::Migration[5.2]
  def change
    create_table :debits do |t|
      t.string :payee
      t.integer :amount
      t.integer :category_id
      t.index :payee
      t.index :category_id
      t.uuid :uuid
      t.string :description

      t.timestamps
    end
  end
end
