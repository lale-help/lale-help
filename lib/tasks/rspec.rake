#
# Clear tasks before redefining (redefining a task keeps the original and appends to it)
#
Rake::Task[:spec].clear
Rake::Task['spec:features'].clear

#
# default task.
#
desc "An alias for spec:default"
task spec:    'spec:default'
task default: 'spec:default'

namespace :spec do

  def prerequisites
    ["db:test:load"]
  end

  task(:default) do
    Rake::Task["spec:reliable"].execute
    Rake::Task["spec:unreliable"].execute
    Rake::Task["spec:retry_failed"].execute
  end

  desc "Run only the reliable specs"
  RSpec::Core::RakeTask.new(reliable: prerequisites) do |t|
    t.rspec_opts = %w{--tag ~unreliable --fail-fast}
  end

  desc "Run only the specs that fail randomly (tag :unreliable)"
  RSpec::Core::RakeTask.new(unreliable: prerequisites) do |t|
    t.rspec_opts = %w{--tag unreliable}
  end

  RSpec::Core::RakeTask.new("spec:retry_failed") do |t|
    t.rspec_opts = "--only-failures"
    t.verbose = false
  end

  RSpec::Core::RakeTask.new(all: prerequisites) do |t|
    t.rspec_opts = %w{--tag ~unreliable --tag ~fast}
    t.pattern = FileList['spec/**/*_spec.rb']
  end

  desc "Run only the very fast tests (tag :fast)"
  RSpec::Core::RakeTask.new(fast: prerequisites) do |t|
    t.rspec_opts = %w{--tag fast}
  end

  desc "Run the code examples in spec/features"
  RSpec::Core::RakeTask.new(features: prerequisites) do |t|
    t.rspec_opts = %w{--tag ~unreliable --tag ~fast}
    t.pattern = FileList['spec/features/**/*_spec.rb']
  end

end