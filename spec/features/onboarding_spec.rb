require 'rails_helper'

describe 'New User On-boarding', type: :feature, js: true do
  context 'regular sign up flow' do
    context 'with circle nearby' do
      let!(:circle) { submit_form(:circle_create_form).result }

      #
      # FIXME onboarding is changing due to admin approval of new users, 
      # spec needs to be adapted
      # 
      xit 'works', :ci_ignore do
        visit root_path
        click_on t('layouts.public.header.sign-up')

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

        click_on "Continue"

        expect(page).to have_content(t('public.circles.index.title'))

        fill_in "user[location]", with: circle.address.location.geocode_query
        find('.circle-marker .title').drag_by(0, 40)
        find('.circle-marker .button.submit').click

        expect(page).to have_content(t('circles.show..dashboard_title', name: circle.name))
      end
    end

    context 'create new circle' do
      xit 'works' do
        pending 'onboarding now requires admin approval, this spec needs to be adapted.'
        visit root_path
        click_on t('layouts.public.header.sign-up')

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

        click_on "Continue"

        expect(page).to have_content(t('public.circles.index.title'))

        click_on t('public.circles.index.create-circle-button')

        fill_in "Circle name",   with: 'My Circle'
        fill_in "City",          with: "San Francisco"
        fill_in "Postal Code",   with: "94109"

        find(:select, "Country").first(:option, "United States").select_option

        click_on t('helpers.submit.create', model: Circle)

        expect(page).to have_content(t('circles.show..dashboard_title', name: "My Circle"))
      end
    end
  end


  context 'join circle flow' do
    let!(:circle) { submit_form(:circle_create_form).result }

    xit 'works' do

      visit join_circle_path(circle)

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

      click_on t('workflow.join')

      expect(page).to have_content(t('circles.show..dashboard_title', name: circle.name))
    end
  end

end
