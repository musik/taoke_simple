class UpdateKeywords
  @queue = 'update_keywords'
  def self.perform id
    Word.find(id).update_keywords_with_delay
  end
end
