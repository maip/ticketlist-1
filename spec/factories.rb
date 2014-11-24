FactoryGirl.define do
  # sequence :email do |n|
  # 	"user#{n}@example.com"
  # end

  factory :user do
    email 'blah@asu.edu'
    password 'password'
  end
end