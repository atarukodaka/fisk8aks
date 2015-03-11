class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.integer :number
      t.string :executed_element
      t.float :bv
      t.float :goe
      t.float :judge_scores
      t.float :score_of_panels
      
      t.belongs_to :score, index: true
    end
  end
end
