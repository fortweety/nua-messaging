module Payments
    class CreateService
        prepend ApplicationService

        def initialize(user_id:)
            @user = User.find_by(id: user_id)
        end

        attr_reader :payment

        def call
            response = payment_provide_factory

            if response.status == 201
                @payment = ::Payment.new(user_id: @user.id)
                fail!(@payment.errors) unless @payment.save
            else
                fail!(response.errors)
            end
        end

        def payment_provide_factory
            PaymentProviderFactory.provider.debit_card(@user)
        end
    end
end