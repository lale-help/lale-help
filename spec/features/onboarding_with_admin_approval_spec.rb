require 'rails_helper'

describe 'New User On-boarding', type: :feature, js: true do


  def fill_in_form
    fill_in "First Name",            with: "Phil"
    fill_in "Last Name",             with: "Monroe"
    fill_in "Email",                 with: "test@example.com"
    fill_in "Password",              with: "passworD1"
    fill_in "Password Confirmation", with: "passworD1"
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

      # - circle admin is notified by email
      expect(last_email.to.first).to eq(circle.admin.email)
      expect(last_email.subject).to eq("[Lale] #{t('mailers.subject.user_mailer.account_activation')}")
    end
  end


  context "admin approves new user", type: :feature do
    
    let!(:circle) { submit_form(:circle_create_form).result }
    let!(:new_member) do
      user = create(:pending_user, primary_circle: circle)
      circle.roles.send('circle.volunteer').create user: user
      user
    end

    it "works", :ci_ignore do
      # verify setup
      expect(circle.volunteers).to include(new_member)

      # circle admin goes to manage users page
      visit circle_path(circle, as: circle.admin)
      click_on t('layouts.internal.sidebar.admin')
      click_on t('circle.admins.nav.invite-volunteers')

      # ensure we are on track. This also waits for the page to load
      expect(page).to have_content(t('circle.admins.invite.pending_members_headline'))
      expect(page).to have_content(new_member.name)

      # ensure admin action is properly indicated
      expect(page).to have_css('#admin_link .badge')
      expect(page).to have_css('.admin-nav .invite .before-icon')

      # circle admin clicks on Accept
      click_on t('circle.admins.pending_members_list.activate')

      # user disappears
      expect(page).not_to have_content(new_member.name)

      # admin action indicators disappear
      expect(page).not_to have_css('#admin_link .badge')
      expect(page).not_to have_css('.admin-nav .invite .before-icon')
      
      # new user is notified
      expect(last_email.to.first).to eq(new_member.email)
      expect(last_email.subject).to eq("[Lale] #{t('mailers.subject.user_mailer.account_activated')}")

      # user appears in helper list
      click_on t('circle.members.index.directory')
      expect(page).to have_content(new_member.name)
    end
  end

end
