class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.string :chatName
      t.decimal :chatNumber
      t.decimal :messageCount
      t.integer :appId

      t.timestamps
    end
  end
end
