require 'rails_helper'

describe 'New User On-boarding', type: :feature, js: true do

  def fill_in_form
    fill_in "First Name",            with: "Phil"
    fill_in "Last Name",             with: "Monroe"
    fill_in "Email",                 with: "test@example.com"
    fill_in "Password",              with: "password"
    fill_in "Password Confirmation", with: "password"
    fill_in "Mobile Phone",          with: "1-800-867-5309"
    fill_in "City",                  with: "San Francisco"
    fill_in "State",                 with: "CA"
    fill_in "Postal Code",           with: "94109"
    check   "Accept Terms and Conditions"
  end

    context 'circle membership requires admin approval' do

    let!(:circle) { submit_form(:circle_create_form, must_activate_users: true).result }

    it 'works' do

      # New User
      # - opens registration page
      # - fills form
      # - submits
      visit root_path
      click_on t('layouts.public.header.sign-up')
      fill_in_form
      click_on "Continue"
      expect(page).to have_content(t('public.circles.index.title'))
    
      # - chooses a circle which requires admin approval
      fill_in "user[location]", with: circle.address.location.geocode_query
      sleep 1
      find('.circle-marker .button.submit').click

      # - sees the "pending" message
      expect(page).to have_content(t('public.circles.membership_pending.subtitle'))

      # circle admin is notified by email
      expect(last_email.to.first).to eq(circle.admins.first.email)
    end
  end

end