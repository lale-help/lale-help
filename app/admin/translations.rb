ActiveAdmin.register_page "Translations" do

  controller do
    before_filter -> { flash.now[:notice] = flash[:notice].html_safe if flash[:notice] }

    helper_method def query
      return @query if @query.present?
      if params.has_key?(:q)
        @query = cookies[:query] = params[:q]
      else
        @query = cookies[:query]
      end
    end
  end

  content do
    manager = TranslationManager.new
    panel "Search" do
      render partial: "admin/translations/search", locals: { query: query }
    end

    panel "Missing Translations" do
      table_for manager.search(:missing_translations, query) do
        column('Translation Key'){ |translation| link_to(translation.key, admin_translate_key_path(key: translation.key)) }
        column "Missing Languages", :missing_languages
        column("English") { |translation| I18n.t(translation.key, locale: :en, default: '' ) }
        column("German")  { |translation| I18n.t(translation.key, locale: :de, default: '' ) }
        column("French")  { |translation| I18n.t(translation.key, locale: :fr, default: '' ) }
      end
    end

    panel "All Translations" do
      table_for manager.search(:all_translations, query) do
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

  content title: proc{ params[:key] } do
    render partial: 'admin/translations/translate_key'
  end

  page_action 'submit', method: 'post' do
    if Rails.env.development?
      TranslationManager.new.add(params[:key], params[:translation])
      flash[:notice] = "Updated translation for: <a href='#{admin_translate_key_path(key: params[:key])}'>#{params[:key]}</a>".html_safe
      redirect_to admin_translations_path
    else
      flash[:error] = "Translations can only be defined in development."
      redirect_to :back
    end
  end

  action_item :view_site do
    link_to "Delete", admin_translate_key_delete_path(key: params[:key]), method: 'delete', confirm: 'Are you sure?'
  end

  page_action 'delete', method: 'delete' do
    if Rails.env.development?
      TranslationManager.new.remove(params[:key])
      redirect_to admin_translations_path
    else
      flash[:error] = "Translations can only be defined in development."
      redirect_to :back
    end
  end
end