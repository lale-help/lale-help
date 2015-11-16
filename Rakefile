# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


namespace :icons do
  task :optimize do
    system "svgo -f #{icon_path}"
  end

  task :compile => :optimize do
    Bundler.with_clean_env do
      system "fontcustom compile -c config/fontcustom.yml"
    end
  end


  def icon_path
    Rails.root.to_s + "/app/assets/icons"
  end
end