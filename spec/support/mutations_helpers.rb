module MutationsHelpers
  def submit_form(name, overrides={})
    form = FactoryGirl.factory_by_name(name).build_class
    attributes = FactoryGirl.attributes_for(name, overrides)
    form.new(attributes).submit
  end
end
