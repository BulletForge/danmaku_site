class AddDownloadCounterToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :download_count, :integer, :default => 0
  end

  def self.down
    remove_column :versions, :download_count
  end
end
