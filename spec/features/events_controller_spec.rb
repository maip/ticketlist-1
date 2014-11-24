require 'rails_helper'

# include Warden::Test::Helpers
# Warden.test_mode!

# user = FactoryGirl.create(:user)
# login_as(user, :scope => :user)

describe 'page' do
  it 'lets the user create an event', :js => true do
  visit root_path
  click_on 'Sign up.'
  fill_in 'Email', with: 'hello@gmail.com'
  fill_in 'Password', with: '12345678'
  fill_in 'Password confirmation', with: '12345678'
  click_on 'Sign up'
  # visit new_event_path
  # fill_in 'Title', :with => 'Event title'
  # fill_in 'Event type', :with => 'Event type'
  # fill_in 'Datetime', :with => DateTime.current.change(year: 2015)
  # fill_in 'Venue', :with => 'Venue'
  # fill_in 'Available tickets', :with => 100
  # fill_in 'Total tickets', :with => 100
  # attach_file('placeholder.png', 'image/png')
  # click_on 'Submit'
  # expect(page).to have_content 'Event title'
  # Warden.test_reset! 
end
end