namespace :doctors do
    task fill_in_unread_messages: :environment do
        users = User.where(is_doctor: true).pluck(:id)
        users.each do |user_id|
            unread_count = Message.eager_load(:inbox, :outbox)
                        .where(
                            'inboxes.user_id = :user_id or outboxes.user_id = :user_id',
                            { user_id: user_id }
                        ).where(read: false).size
            inbox = Inbox.find_by(user_id: user_id)
            inbox.update(unread_messages_count: unread_count) if inbox
        end
    end
end
