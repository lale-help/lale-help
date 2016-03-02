module MutationsHelpers
  def submit_form(name, overrides={})
    form = FactoryGirl.factory_by_name(name).build_class
    attributes = FactoryGirl.attributes_for(name)
    form.new(attributes, overrides).submit
  end
end
