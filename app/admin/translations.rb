ActiveAdmin.register_page "Translations" do
  content do
    manager = TranslationManager.new
    panel "Search" do
      render partial: "admin/translations/search", locals: { query: params[:q] }
    end

    panel "Missing Translations" do
      table_for manager.search(:missing_translations, params[:q]) do
        column('Translation Key'){ |translation| link_to(translation.key, admin_translate_key_path(key: translation.key)) }
        column "Missing Languages", :missing_languages
        column("English") { |translation| I18n.t(translation.key, locale: :en, default: '' ) }
        column("German")  { |translation| I18n.t(translation.key, locale: :de, default: '' ) }
        column("French")  { |translation| I18n.t(translation.key, locale: :fr, default: '' ) }
      end
    end

    panel "All Translations" do
      table_for manager.search(:all_translations, params[:q]) do
        column('Translation Key'){ |translation| link_to(translation.key, admin_translate_key_path(key: translation.key)) }
        column "Languages", :languages
        column("English") { |translation| I18n.t(translation.key, locale: :en, default: '' ) }
        column("German")  { |translation| I18n.t(translation.key, locale: :de, default: '' ) }
        column("French")  { |translation| I18n.t(translation.key, locale: :fr, default: '' ) }
      end
    end
  end
end

ActiveAdmin.register_page "translate_key" do
  breadcrumb do
    ['translations']
  end

  menu false

  content title: Proc.new { params[:key] }  do
    render partial: 'admin/translations/translate_key'
  end

  page_action 'submit', method: 'post' do
    TranslationManager.new.add(params[:key], params[:translation])
    redirect_to :back
  end
end