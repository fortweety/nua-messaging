module Messages
    class ReadService
        prepend ApplicationService

        def initialize(message)
            @message = message
        end

        attr_reader :message

        def call
            @message.read = true
            return fail!(@message.errors) unless @message.save

            Inboxes::DecreaseUnreadMessagesCountJob.perform_later(Inbox.find_by(user_id: User.default_doctor&.id))
        end
    end
end