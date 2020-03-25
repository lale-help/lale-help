web: bin/rails server puma -p $PORT -b 0.0.0.0
db:  bin/rake postgresql:start
worker: bundle exec sidekiq -c 10 -q default -q mailers