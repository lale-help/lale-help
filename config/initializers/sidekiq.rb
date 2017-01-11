redis_config = {
  url: ENV["REDISCLOUD_URL"] || 'redis://localhost:6379/12',
  network_timeout: 5
}

Sidekiq.configure_server { |config| config.redis = redis_config }
Sidekiq.configure_client { |config| config.redis = redis_config }
