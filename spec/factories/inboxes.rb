FactoryBot.define do
    factory :inbox do
        user nil
        unread_messages_count { 0 }
    end
end
