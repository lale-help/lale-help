if Rails.env.test? || (Rails.env.development? && ENV['AWS_ACCESS_KEY'].nil?)

  Refile.cache = Refile::Backend::FileSystem.new(Rails.root.join('tmp', 'refile', Rails.env, 'cache'))
  Refile.store = Refile::Backend::FileSystem.new(Rails.root.join('tmp', 'refile', Rails.env, 'store'))

else

  require "refile/s3"
  aws_config = {
    access_key_id: ENV['AWS_ACCESS_KEY'],
    secret_access_key: ENV['AWS_SECRET_KEY'],
    region: ENV['AWS_REGION'],
    bucket: ENV['AWS_BUCKET'],
  }
  Refile.cache = Refile::S3.new(prefix: "cache", **aws_config)
  Refile.store = Refile::S3.new(prefix: "store", **aws_config)

end
