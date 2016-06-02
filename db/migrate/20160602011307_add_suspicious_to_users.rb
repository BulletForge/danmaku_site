class AddSuspiciousToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :suspicious, :boolean, :default => false
  end

  def self.down
    remove_column :users, :suspicious
  end
end
