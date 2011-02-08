ActiveRecord::Schema.define(:version => 1) do
  create_table :articles do |t|
    t.string :title
    t.text   :content
    t.timestamps
  end
end
