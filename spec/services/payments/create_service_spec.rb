RSpec.describe Payments::CreateService do
    subject { described_class }

    before(:all) do
        @patient = create(:user, :patient)
        @doctor = create(:user, :doctor)
    end

    context 'valid parameters for payment' do

      it 'succesfuly create a payment' do
        expect { subject.call(user_id: @patient.id) }
          .to change { @patient.payments.count }.from(0).to(1)
      end

      it 'assigns payment' do
        result = subject.call(user_id: @patient.id)

        expect(result.success?).to be_truthy
        expect(result.payment).to be_kind_of(Payment)
      end
    end

    context 'failure payment factory' do
        let(:status_stub) { instance_double(StubResponse, status: 422, errors: ['connection error']) }

        before { subject.any_instance.stub(:payment_provide_factory).and_return(status_stub) }

        it 'should didnt create payment because factory didnt answer' do
            expect { subject.call(user_id: @patient.id) }
            .not_to change { @patient.payments.count }
        end

        it 'shoud return errors with connection' do
            result = subject.call(user_id: @patient.id)

            expect(result.failure?).to be_truthy
            expect(result.errors).not_to be_empty
        end
    end
end
