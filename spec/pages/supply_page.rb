# Encapsulates methods for handling Supplies via the appropriate pages
class SupplyPage < Struct.new(:supply)
  include Capybara::DSL

  def create(overrides = {})
    if(self.visible?)
      add_super_button.click
      click_on "Supply"
      fill_supply_page(overrides)     
      click_button  "Create Supply"
      return supply
    end
    nil
  end

  def edit(overrides = {})
    edit_super_button.click
    click_on "Edit Supply"
    fill_supply_page(overrides)
    click_button "Update Supply"
  end

  def visible?
    begin
        add_super_button
        true
    rescue Capybara::ElementNotFound
        false
    end
  end

  def editable?
    begin
        edit_super_button
        true
    rescue Capybara::ElementNotFound
        false
    end
  end

  def complete
    edit_super_button.click
    click_on  "Complete Supply"
  end

  def has_supply
    click_on "I have this Supply"
  end

  private 

  def add_super_button
    find '.button-super', text: /Add/
  end

  def edit_super_button
    find '.button-super', text: /Edit Supply/
  end

  def fill_supply_page(overrides = {})
    fill_in "Name of supply",  with: overrides[:name] || supply.name
    fill_in "Description",     with: overrides[:description] || supply.description
    fill_in "Due Date",        with: overrides[:due_date] || supply.due_date                      
    fill_in "Location",        with: overrides[:location] || supply.location
  end
end