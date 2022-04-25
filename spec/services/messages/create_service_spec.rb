RSpec.describe Messages::CreateService do
    subject { described_class }

    before(:all) do
        @patient = create(:user, :patient)
        @admin = create(:user, :admin)
        @doctor = create(:user, :doctor)
    end

    context 'valid parameters for doctor' do
      let(:doctor_params) do
        {
            user_id: @doctor.id,
            body: 'test'
        }
      end

      it 'creates a new message from doctor' do
        expect { subject.call(doctor_params) }
          .to change { @doctor.outbox.messages.count }.from(0).to(1)
          .and change { @patient.inbox.messages.count }.from(0).to(1)
      end

      it 'assigns message' do
        result = subject.call(doctor_params)

        expect(result.success?).to be_truthy
        expect(result.message).to be_kind_of(Message)
      end

      it 'should be not readen' do
        result = subject.call(doctor_params)

        expect(result.message.read).to be_falsey
      end
    end

    context 'valid parameters for patient' do
        let(:message) { create(:message, outbox_id: @doctor.outbox.id, inbox_id: @patient.inbox.id) }
        let(:old_message) { create(:message, :old, outbox_id: @doctor.outbox.id, inbox_id: @patient.inbox.id) }

        let(:patient_params) do
          {
              user_id: @patient.id,
              body: 'test',
              original_message_id: message.id
          }
        end

        let(:patient_params_old) do
            {
                user_id: @patient.id,
                body: 'test',
                original_message_id: old_message.id
            }
          end

        it 'creates a new message from patient to doctor' do
          expect { subject.call(patient_params) }
            .to change { @doctor.inbox.messages.count }.from(0).to(1)
            .and change { @patient.outbox.messages.count }.from(0).to(1)
        end

        it 'creates a new message from patient to admin' do
            expect { subject.call(patient_params_old) }
              .to change { @admin.inbox.messages.count }.from(0).to(1)
              .and change { @patient.outbox.messages.count }.from(0).to(1)
        end
    end

    context 'invalid parameters patient' do
      let(:params) do
        {
            user_id: @patient.id,
            body: 'hello'
        }
      end

      it 'does not create ad' do
        expect { subject.call(params) }
          .not_to change { Message.count }
      end

      it 'errors not empty' do
        result = subject.call(params)

        expect(result.failure?).to be_truthy
      end
    end

    context 'invalid parameters doctor' do
        let(:params) do
          {
              user_id: @doctor.id,
              body: nil
          }
        end

        it 'does not create ad' do
          expect { subject.call(params) }
            .not_to change { Message.count }
        end

        it 'errors not empty' do
          result = subject.call(params)

          expect(result.failure?).to be_truthy
        end
    end

    context 'valid parameters for patient lose script' do
        let(:message) { create(:message, outbox_id: @doctor.outbox.id, inbox_id: @patient.inbox.id) }

        let(:patient_params) do
          {
              user_id: @patient.id,
              original_message_id: message.id,
              lose_script: true
          }
        end

        it 'creates a new message from patient to admin' do
            expect { subject.call(patient_params) }
              .to change { @admin.inbox.messages.count }.from(0).to(1)
              .and change { @patient.outbox.messages.count }.from(0).to(1)
        end

        it 'send defaulted text to admin' do
            result = subject.call(patient_params)

            expect(result.success?).to be_truthy
            expect(result.message.body).to eql(Message.lost_message)
        end
    end
end
