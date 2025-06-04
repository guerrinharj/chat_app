FactoryBot.define do
    factory :usuario do
        nome { "Gabriel Guerra" }
        username { "gabriel_guerra" }
        email { "gabriel@example.com" }
        password { "supersecurepassword123456" }
        password_confirmation { "supersecurepassword123456" }

        trait :confirmed do
            confirmed_at { Time.current }
            confirmation_token { nil }
        end
    end
end
