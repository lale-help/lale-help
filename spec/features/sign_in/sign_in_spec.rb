require 'rails_helper'

describe 'Sign in and sign out', type: :feature, js: true do

  def fill_in_form
    fill_in "Email address", with: user.email
    fill_in "Password",      with: user.identity.password
  end

  let!(:circle) { submit_form(:circle_create_form).result }
  
  context 'Sign in with correct data' do

    let!(:user) { create(:circle_role_volunteer, circle: circle, status: :active).user }

    it 'works (as well as logout)' do
      visit root_path
      fill_in_form
      click_on "Sign in"
      expect(page).to have_content(t('circles.show..dashboard_title', name: circle.name))

      find('.user-name').click
      find('.user-dropdown').click_on(t('layouts.internal.header.sign-out'))
       # using the clicks with find here since find *waits* until the element is visible on the page
       # this should make the tests more reliable.
      expect(find('body.public h2')).to have_content(t('sessions.new.sign-in-phrase'))
    end
  end


  context 'Sign in with incorrect data' do

    let!(:user) do 
      user = create(:circle_role_volunteer, circle: circle, status: :active).user
      user.identity.password = "wrong password"
      user
    end

    it 'shows an error message' do
      visit root_path
      fill_in_form
      click_on "Sign in"
      expect(page).to have_content(t('sessions.new.sign-in-phrase'))
      # TODO check for apropriate flash message
    end
  end

  context 'Pending user signs in' do

    let!(:circle) { submit_form(:circle_create_form, must_activate_users: true).result }
    let!(:user) { create(:circle_role_volunteer, circle: circle, status: :pending).user }

    it 'sees membership pending message' do
      visit root_path
      fill_in_form
      click_on "Sign in"
      expect(page).to have_content(t('public.circles.membership_inactive.pending.title'))
    end
  end


end
