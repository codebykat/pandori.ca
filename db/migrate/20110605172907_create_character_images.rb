class CreateCharacterImages < ActiveRecord::Migration
  def self.up
    create_table :character_images do |t|
      t.references :character

      t.timestamps
    end
  end

  def self.down
    drop_table :character_images
  end
end
