class AddExpirationToLink < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :expiration, :datetime
    add_index :links, :expiration
  end
end
