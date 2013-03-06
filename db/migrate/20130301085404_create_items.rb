class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :nick
      t.integer :num_iid
      t.integer :seller_credit_score ,:limit=>2
      t.integer :volume
      t.decimal :price,             :precision=>9,:scale=>2  
      t.decimal :commission,        :precision=>9,:scale=>2  
      t.decimal :commission_volume, :precision=>9,:scale=>2
      t.integer :commission_num
      t.integer :commission_rate
      t.string :item_location
      t.string :shop_click_url
      t.string :pic_url
      t.string :click_url

      t.references :shop

      t.boolean :all_properties_fetched

      t.timestamps
    end
    change_column :items, :num_iid, :bigint
  end
end
