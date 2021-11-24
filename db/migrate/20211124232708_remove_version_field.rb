class RemoveVersionField < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :version_number, :string
  end
end
