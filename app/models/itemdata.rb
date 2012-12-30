class Itemdata < ActiveRecord::Base
  belongs_to :word
  attr_accessible :data
end
