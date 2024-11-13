ActiveRecord::Schema[7.1].define(version: 2024_11_13_161846) do
  create_table "urls", force: :cascade do |t|
    t.string "original_url"
    t.string "short_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["short_code"], name: "index_urls_on_short_code", unique: true
  end

end
