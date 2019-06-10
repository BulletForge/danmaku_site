class AddPasswordDigestToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :password_digest, :string
  end

  def self.down
    remove_column :users, :password_digest
  end
end
