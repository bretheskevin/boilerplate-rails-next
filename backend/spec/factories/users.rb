FactoryBot.define do
  factory :user, class: "User" do
    email { "user@example.com" }
    password { "password" }
    role { User.roles[:user] }
  end

  factory :admin, class: "User" do
    email { "admin@example.com" }
    password { "password" }
    role { User.roles[:admin] }
  end
end
