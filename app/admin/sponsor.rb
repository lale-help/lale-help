ActiveAdmin.register Sponsor do

  form do |f|
    f.semantic_errors
    f.inputs do
      input :name
      input :url
      # transient attribute to upload the logo; will be fished out in the controller patch below
      input :image_file, as: :file
      input :description
    end
    f.actions
  end

  # patching the default controller action
  controller do
    def create
      outcome = Sponsor::Create.run(params[:sponsor].merge(current_user: current_user))
      if outcome.success?
        redirect_to admin_sponsor_path(outcome.result)
      else
        # HACK build the structure and @sponsor instance that activeadmin expects
        params[:sponsor].delete(:image_file)
        @sponsor = Sponsor.new(params[:sponsor])
        outcome.errors.message.each { |k, v| @sponsor.errors.add(k, v) }
        render :new
      end
    end
  end

  index do
    selectable_column
    column :name
    column :url
    column :current_sponsorships do |sponsor|
      sponsor.sponsorships.current.count
    end
    column :created_at
    column :updated_at
    actions
  end

  sidebar "Current Sponsorships", only: [:edit, :show] do
    ul do
      sponsorships = sponsor.sponsorships.current.order(ends_on: :asc)
      sponsorships.each do |s|
        circle_link = link_to(s.circle.name, admin_circle_path(s.circle))
        li "#{circle_link} from #{s.starts_on} to #{s.ends_on}.".html_safe
      end
    end
  end

end
