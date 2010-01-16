class AddTypeToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :type, :string
  end

  def self.down
    remove_column :assets, :type, :string
  end
end
