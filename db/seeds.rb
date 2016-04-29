
User::Identity.find_or_create_by(email: 'lale-bot@lale.help') do |identity|
  identity.password = SecureRandom.uuid
  identity.user = User.new(first_name: 'Lale', last_name: 'Bot', status: :pending)
end
