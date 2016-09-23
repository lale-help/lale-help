namespace :icons do
  task :optimize do
    sh "svgo -f #{icon_path}"
  end

  task compile: :optimize do
    Bundler.with_clean_env do
      sh "fontcustom compile -c config/fontcustom.yml"
    end
  end


  def icon_path
    Rails.root.to_s + "/app/assets/icons"
  end
end
