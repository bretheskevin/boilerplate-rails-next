class AddDeletedAtToDummies < ActiveRecord::Migration[7.1]
  def change
    add_column :dummies, :deleted_at, :datetime
    add_index :dummies, :deleted_at
  end
end
