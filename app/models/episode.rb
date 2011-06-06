class Episode < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true

  has_many :quotes, :dependent => :destroy
  has_and_belongs_to_many :characters, :uniq => :true

  default_scope :order => 'airdate'
end
