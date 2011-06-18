class CharacterImage < ActiveRecord::Base

  belongs_to :character

  # paperclip options
  has_attached_file :photo, :styles => {
                                        :small => "190x190#",
                                        :tiny => "50x50#",
                                        :large => "320x240>" },
                    :default_url => "/images/missing.jpg"
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes

end
