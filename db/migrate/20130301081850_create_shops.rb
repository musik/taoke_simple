class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :nick
      t.string :click_url
      t.text :bulletin
      t.integer :cid
      t.datetime :created
      t.text :desc
      t.datetime :modified
      t.string :pic_path
      t.integer :sid
      t.string :title
      t.boolean :all_properties_fetched

      t.timestamps
    end
  end
end
