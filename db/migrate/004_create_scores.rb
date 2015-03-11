class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.string :score_name
      t.integer :sid
      t.string :discipline
      t.string :segment
      t.date :date

      t.integer :ranking

      t.string :noc
      t.integer :skating_order

      t.float :tss
      t.float :tes
      t.float :pcs
      t.integer :deductions

      t.float :total_bv
      t.string :pdf

      t.integer :deductions

      t.belongs_to :skater, index: true
      t.belongs_to :competition, index: true

      t.timestamps
    end
  end
end
