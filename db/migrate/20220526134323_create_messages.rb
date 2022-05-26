class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :messageContent
      t.decimal :messageNumber
      t.integer :chatId

      t.timestamps
    end
  end
end
