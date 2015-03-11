class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :name
      t.float :factor
      t.float :judge_scores
      t.float :score_of_panels
      
      t.belongs_to :score, index: true
    end
  end
end
