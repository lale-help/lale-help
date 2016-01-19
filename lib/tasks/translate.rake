namespace :translate do
  SUPPORTED_LANGS = [:en, :de, :fr]

  task :flatten => :environment do
    I18n.backend.load_translations

    yamls = Hash.new

    SUPPORTED_LANGS.each do |lang|
      yamls[lang] = { lang => I18n.backend.send(:translations)[lang] }.to_yaml
    end

    Dir.glob(Rails.root.to_s+'/config/locales/**/*.yml').each do |path|
      rm_rf path
    end

    yamls.each do |lang, yaml|
      path = Rails.root.to_s+"/config/locales/#{lang}.yml"
      puts "Saving #{lang} translations to #{path}"
      File.open(path, 'w') { |f| f.puts(yaml) }
    end
  end

  task :keys => :environment do

  end
end