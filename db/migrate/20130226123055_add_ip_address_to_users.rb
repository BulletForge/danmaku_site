class AddIpAddressToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :ip_address, :string
  end

  def self.down
    remove_column :users, :ip_address
  end
end
