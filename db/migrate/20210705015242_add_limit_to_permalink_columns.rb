class AddLimitToPermalinkColumns < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :permalink, :string, :limit => 64
    change_column :projects, :permalink, :string, :limit => 64
  end
end
