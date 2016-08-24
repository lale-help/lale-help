require 'rails_helper'

describe "Edit a circle", js: true do
  
  let(:circle)        { create(:circle, :with_admin) }
  let(:admin)         { circle.admin }

  let(:circle_form)   { PageObject::Circle::Form.new }

  context "with valid inputs" do

    let(:inputs) { attributes_for(:circle_create_form) }

    before { circle_form.load(circle_id: circle.id, as: admin.id) }

    it "works" do
      new_circle_form = circle_form.submit_with(inputs)
      expect(new_circle_form).to have_flash("Circle was successfully updated")
      expect(new_circle_form.name.value).to eq(inputs[:name])
      expect(circle_form.description.value).to eq(inputs[:description])
      expect(circle_form.city.value).to eq(inputs[:city])
      expect(circle_form.postal_code.value).to eq(inputs[:postal_code])
      expect(circle_form.country.value).to eq("CA") # Canada // hack 
    end
  end

  context "when form is submitted empty" do

    let(:inputs) { attributes_for(:empty_required_circle_attributes) }

    before { circle_form.load(circle_id: circle.id, as: admin.id) }

    it "shows all error messages" do
      circle_form.submit_with(inputs)
      expect(circle_form).to be_invalid
      expect(circle_form).to have_validation_error("Please enter a name")
      expect(circle_form).to have_validation_error("Please enter a city")
      expect(circle_form).to have_validation_error("Please select a country")
    end
  end

end