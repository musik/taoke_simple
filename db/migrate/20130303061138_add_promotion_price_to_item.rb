class AddPromotionPriceToItem < ActiveRecord::Migration
  def change
    add_column :items, :promotion_price, :decimal,:precision => 9, :scale => 2
  end
end
