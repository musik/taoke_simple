class UpdateKeywords
  @queue = 'p1'
  def self.perform id
    Word.find(id).update_keywords_with_delay
  end
end
