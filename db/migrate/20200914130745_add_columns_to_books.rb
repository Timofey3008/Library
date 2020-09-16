class AddColumnsToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :status, :integer
    add_column :books, :deadLine, :date
  end
end
