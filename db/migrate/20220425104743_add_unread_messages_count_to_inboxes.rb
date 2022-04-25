class AddUnreadMessagesCountToInboxes < ActiveRecord::Migration[5.0]
  def up
    add_column :inboxes, :unread_messages_count, :integer, default: 0
  end

  def down
    remove_column :inboxes, :unread_messages_count, :integer
  end
end
