class Inboxes::DecreaseUnreadMessagesCountJob < ApplicationJob
    queue_as :default

    def perform(inbox)
        current_count = inbox.unread_messages_count
        inbox.unread_messages_count -= 1
        inbox.save!
    end
  end