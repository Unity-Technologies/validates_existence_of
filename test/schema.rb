ActiveRecord::Schema.define(:version => 1) do
  create_table :boxes, :force => true do |t|
    t.timestamps
  end

  create_table :items, :force => true do |t|
    t.integer :box_id
    t.timestamps
  end
end
