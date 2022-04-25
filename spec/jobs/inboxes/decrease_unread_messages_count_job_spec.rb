require 'rails_helper'

RSpec.describe Inboxes::DecreaseUnreadMessagesCountJob, type: :job do
    subject { described_class }

    let(:user) { create(:user, :doctor) }

    context 'succesfuly increase inbox' do
        it 'updates unreaded message count' do
            user.inbox.update(unread_messages_count: 1)
            subject.perform_now(user.inbox)

            expect(user.inbox.unread_messages_count).to eq(0)
        end
    end
end
