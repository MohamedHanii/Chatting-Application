class AddDefaultValueToCount < ActiveRecord::Migration[5.0]
  def change
    change_column_default :applications, :chatCount, 0
    change_column_default :chats, :messageCount, 0
  end
end
