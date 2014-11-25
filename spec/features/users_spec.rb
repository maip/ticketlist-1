require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'user signs up' do
  scenario 'new user' do
    visit root_path
    click_on 'Sign up.'
    fill_in 'user_email', with: 'user@gmail.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end

feature 'user signs out' do
  scenario 'existing user signs out' do
    visit root_path
    click_on 'Log in.'
    fill_in 'user_email', with: 'user@gmail.com'
    fill_in 'user_password', with: '12345678'
    click_on 'Log in'
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end

feature 'user signs in' do
  scenario 'existing user signs in again' do
    visit root_path
    click_on 'Log in.'
    fill_in 'user_email', with: 'user@gmail.com'
    fill_in 'user_password', with: '12345678'
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'existing user tries to sign in with wrong password' do
    visit root_path
    click_on 'Log in.'
    fill_in 'user_email', with: 'user@gmail.com'
    fill_in 'user_password', with: '11111111'
    click_on 'Log in'
    expect(page).to have_content 'Invalid email or password.'
  end
end

feature 'password' do
  scenario 'user updates password' do
    visit root_path
    click_on 'Log in.'
    fill_in 'user_email', with: 'user@gmail.com'
    fill_in 'user_password', with: '12345678'
    click_on 'Log in'
    click_on 'Settings'
    fill_in 'user_email', with: 'user@gmail.com'
    fill_in 'user_password', with: 'abcdefgh'
    fill_in 'user_password_confirmation', with: 'abcdefgh'
    fill_in 'user_current_password', with: '12345678'
    click_on 'Update'
    expect(page).to have_content 'Your account has been updated successfully.'
  end
end

Warden.test_reset!