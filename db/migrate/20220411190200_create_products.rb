class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false, unique: true
      t.integer :qty, null: false
      t.references :category, index: true, foreign_key: true, null: false
      
      t.timestamps
    end
  end
end
