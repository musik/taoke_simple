class AddDeltaToWord < ActiveRecord::Migration
  def change
    add_column :words, :delta, :boolean, :default=>true, :null=>false
    add_index :words, :delta
    add_column :items, :delta, :boolean, :default=>true, :null=>false
    add_index :items, :delta
    add_column :shops, :delta, :boolean, :default=>true, :null=>false
    add_index :shops, :delta
  end
end
