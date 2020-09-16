class RenameColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :books, :deadLine, :dead_line
    rename_column :books, :reader, :reader_user_id
  end
end
