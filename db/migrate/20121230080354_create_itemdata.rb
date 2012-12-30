class CreateItemdata < ActiveRecord::Migration
  def change
    create_table :itemdata do |t|
      t.references :word
      t.binary :data

      t.timestamps
    end
    add_index :itemdata, :word_id
  end
end
