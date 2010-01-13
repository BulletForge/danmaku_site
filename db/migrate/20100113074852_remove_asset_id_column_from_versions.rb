class RemoveAssetIdColumnFromVersions < ActiveRecord::Migration
  def self.up
    remove_column :versions, :asset_id
  end

  def self.down
    add_column :versions, :asset_id, :integer
  end
end
