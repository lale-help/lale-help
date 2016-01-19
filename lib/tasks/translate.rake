namespace :translate do
  task :clean => :environment do
    I18n.backend.load_translations
    TranslationManager.new.clean
  end

  task :missing_keys => :environment do
    missing_keys = TranslationManager.new.missing_translations
    puts "\n\n Missing the following keys"
    puts Terminal::Table.new(rows: missing_keys, headings: ['Key', 'Missing Languages'])
  end
end
