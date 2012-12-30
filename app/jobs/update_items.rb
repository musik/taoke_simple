class UpdateItems
  @queue = 'update_items'
  def self.perform id
    keep_time 1 do
      Word.find(id).update_items
    end
  end
end
