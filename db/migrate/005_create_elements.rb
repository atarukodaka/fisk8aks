class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.integer :number
      t.string :executed_element
      t.string :info
      t.string :credit
      t.float :bv
      t.float :goe
      t.string :judge_scores
      t.float :score_of_panels
      
      t.belongs_to :score, index: true

      t.timestamps
    end
  end
end
