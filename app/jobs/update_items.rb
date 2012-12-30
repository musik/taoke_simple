class UpdateItems
  @queue = 'update_items'
  def self.perform id
    Word.find(id).update_items
  end
end
