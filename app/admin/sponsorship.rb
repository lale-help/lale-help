ActiveAdmin.register Sponsorship do

  index do
    selectable_column
    column :sponsor
    column :circle
    column :starts_on
    column :ends_on
    column "Duration (days)" do |s|
      (s.ends_on - s.starts_on).to_i + 1
    end
    column :created_at
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    inputs do
      f.input :circle
      f.input :sponsor
      f.input :starts_on, as: :datepicker
      f.input :ends_on,   as: :datepicker
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end


end
