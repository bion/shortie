class AddIndexToLinksShortName < ActiveRecord::Migration[5.0]
  def change
    add_index :links, :short_name
  end
end
