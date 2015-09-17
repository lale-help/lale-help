namespace :postgresql do
  task :initdb do
    unless Dir.exists?('.postgres')
      puts "Initializing PostgreSQL Database"
      sh 'initdb', '.postgres'
    end
  end

  task :start do
    puts "Starting PostgreSQL"
    exec 'postgres', '-D', File.expand_path('./.postgres')
  end
end

namespace :db do
  task :init => 'postgresql:initdb'
end
