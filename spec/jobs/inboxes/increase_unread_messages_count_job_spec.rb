require 'rails_helper'

RSpec.describe Inboxes::IncreaseUnreadMessagesCountJob, type: :job do
    subject { described_class }

    let(:user) { create(:user, :doctor) }

    context 'succesfuly increase inbox' do
        it 'updates unreaded message count' do
            subject.perform_now(user.inbox)

            expect(user.inbox.unread_messages_count).to eq(1)
        end
    end
end
