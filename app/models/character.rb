class Character < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true

  has_many :quotes
  has_and_belongs_to_many :episodes, :uniq => true
  has_many :character_images, :dependent => :destroy

  accepts_nested_attributes_for :character_images, :reject_if => lambda { |t| t['character_image'].nil? }

end
