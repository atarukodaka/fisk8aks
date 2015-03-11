class CreateSkaters < ActiveRecord::Migration
  def change
    create_table :skaters do |t|
      t.integer :isu_number
      t.string :name
      t.string :noc
      t.string :country
      t.string :discipline
      t.string :bio
      
      t.timestamps
    end
  end
end
