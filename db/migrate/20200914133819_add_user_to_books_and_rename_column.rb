class AddUserToBooksAndRenameColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :reader, :integer
    rename_column :books, :user_id, :owner_id
  end
end
