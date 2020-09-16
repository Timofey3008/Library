class ChangeColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :books, :status, :integer, default: 0
  end
end
