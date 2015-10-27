FactoryGirl.define do
  factory :token do
    token_type { "simple" }

    factory :reset_password_token do
      token_type { "reset_password" }
      context { { user_id: user.id } }

      transient do
        user {}
      end
    end
  end
end
