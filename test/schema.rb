ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.string :username
  end

  create_table :wristbands, :force => true do |t|
    t.string :color
  end

  create_table :admirations, :force => true do |t|
    t.integer :admirer_id
    t.integer :hero_id
  end
end
