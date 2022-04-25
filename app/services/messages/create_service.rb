module Messages
    class CreateService
        prepend ApplicationService

        def initialize(user_id:, body: Message.lost_message, original_message_id: nil, lose_script: false)
            @user = User.find_by(id: user_id)
            @body = body
            @original_message_id = original_message_id
            @outbox = Outbox.find_by(user_id: user_id)&.id
            @lose_script = lose_script
        end

        attr_reader :message

        def call
            decline_inbox
            @message = Message.new({
                body: @body,
                read: false,
                outbox_id: @outbox,
                inbox_id: @inbox&.id
            })

            return fail!(@message.errors) unless @message.save
            puts "BEFORE INCREASE"
            puts "============="
            Inboxes::IncreaseUnreadMessagesCountJob.perform_later(Inbox.find_by(user_id: User.default_doctor&.id))
        end

        private

        def decline_inbox
            if @user.is_doctor?
                doctor_sender
            else
                return fail!('original_message_id blank for patient') if @user.is_patient? && !@original_message_id
                user_sender
            end
        end

        def doctor_sender
            @inbox = Inbox.find_by(user_id: User.current&.id)
        end

        def user_sender
            date = Message.find_by(id: @original_message_id)&.created_at
            if @lose_script || !date || date < Date.today - 7.days
                @inbox = Inbox.find_by(user_id: User.default_admin&.id)
            else
                @inbox = Inbox.find_by(user_id: User.default_doctor&.id)
            end
        end
    end
end