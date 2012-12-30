class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :name
      t.string :slug,:limit=>10
      t.boolean :publish
      t.boolean :isbrand
      t.string :keywords

      t.timestamps
    end
  end
end
