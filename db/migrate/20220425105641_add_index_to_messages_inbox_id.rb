class AddIndexToMessagesInboxId < ActiveRecord::Migration[5.0]
  def up
    return if index_exists?(:messages, :inbox_id)
    add_index :messages, :inbox_id
  end

  def down
    return unless index_exists?(:messages, :inbox_id)
    remove_index :messages, :inbox_id
  end
end
