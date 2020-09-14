class CreateReserved < ActiveRecord::Migration[6.0]
  def change
    create_table :reserveds do |t|
      t.belongs_to :user
      t.belongs_to :book

      t.timestamps
    end
  end
end
