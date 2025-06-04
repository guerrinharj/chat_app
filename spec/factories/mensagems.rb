FactoryBot.define do
  factory :mensagem do
    texto { "Esta é uma mensagem de teste." }
    association :usuario
  end
end
