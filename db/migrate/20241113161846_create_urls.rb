class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls do |t|
      t.string :original_url, limit: 2048
      t.string :short_code

      t.timestamps
    end
    add_index :urls, :short_code, unique: true
  end
end
