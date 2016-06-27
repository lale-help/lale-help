# https://relishapp.com/rspec/rspec-expectations/docs/syntax-configuration#disable-should-syntax
# 
# "The primary syntax provided by rspec-expectations is based on
# the expect method, which explicitly wraps an object or block
# of code in order to set an expectation on it.

# There's also an older should-based syntax, which relies upon should being
# monkey-patched onto every object in the system. However, this syntax can at times lead to
# some surprising failures, since RSpec does not own every object in the system and cannot
# guarantee that it will always work consistently."
# 
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end