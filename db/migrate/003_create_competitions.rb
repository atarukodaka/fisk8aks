class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.integer :cid
      t.string :name
      t.string :category
      t.string :isu_hp
      t.integer :year
      t.string :city
      t.string :noc
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
