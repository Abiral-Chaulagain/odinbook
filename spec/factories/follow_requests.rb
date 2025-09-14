FactoryBot.define do
  factory :follow_request do
    follower { nil }
    followed { nil }
    status { 1 }
  end
end
