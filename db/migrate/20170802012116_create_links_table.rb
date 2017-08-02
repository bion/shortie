class CreateLinksTable < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :original_url, null: false
      t.string :shortened_url
      t.timestamps
    end
  end
end
