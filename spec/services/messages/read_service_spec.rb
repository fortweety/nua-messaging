RSpec.describe Messages::ReadService do
    subject { described_class }

    before(:all) do
        @patient = create(:user, :patient)
        @doctor = create(:user, :doctor)
        @message = create(:message, outbox_id: @doctor.outbox.id, inbox_id: @patient.inbox.id)
    end

    context 'valid parameters' do

      it 'read message' do
        expect { subject.call(@message) }
          .to change { @message.read }.from(false).to(true)
      end
    end
end
