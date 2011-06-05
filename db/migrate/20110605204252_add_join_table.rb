class AddJoinTable < ActiveRecord::Migration
  def self.up
    create_table :characters_episodes, :id => false do |t|
      t.references :episode, :character
    end
  end

  def self.down
    drop_table :characters_episodes
  end
end
