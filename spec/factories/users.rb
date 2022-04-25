FactoryBot.define do
    factory :user do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }

        trait :admin do
            is_admin { true }
        end

        trait :doctor do
            is_doctor { true }
        end

        trait :patient do
            is_patient { true }
        end

        after(:create) do |user|
            create(:outbox, user_id: user.id)
            create(:inbox, user_id: user.id)
        end
    end
end
