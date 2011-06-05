class Character < ActiveRecord::Base

  has_many :quotes
  has_and_belongs_to_many :episodes, :uniq => true
  has_many :character_images, :dependent => :destroy

end
