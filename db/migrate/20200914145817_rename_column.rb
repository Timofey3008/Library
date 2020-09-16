class RenameColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :books, :user_id, :owner_id
  end
end
