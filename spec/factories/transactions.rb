FactoryBot.define do
  factory :transaction do
    association :user
    amount { 10 }
    currency { '$' }
  end
end
