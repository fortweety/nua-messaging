FactoryBot.define do
    factory :message do
        body { Faker::Lorem.paragraph(sentence_count: 7) }
        association :outbox, factory: :outbox
        association :inbox, factory: :inbox
        read { false }

        trait :old do
            created_at { Date.today - 10.days }
        end
    end
end
