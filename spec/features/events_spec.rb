require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

user = FactoryGirl.create(:user)
# user2 = FactoryGirl.create(:user)
login_as(user, :scope => :user)

feature 'user uploads avatar' do
  scenario 'new avatar' do
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Settings'
    fill_in 'user_current_password', with: '12345678'
    attach_file('user_avatar', 'public/images/placeholder.png')
    click_on 'Update'
    expect(page).to have_content 'updated successfully'
    expect(page).to have_xpath ".//img[contains(@src,'placeholder.png')]"
  end

  scenario 'replace existing avatar' do
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Settings'
    fill_in 'user_current_password', with: '12345678'
    attach_file('user_avatar', 'public/images/missing.png')
    click_on 'Update'
    expect(page).to have_content 'updated successfully'
    expect(page).to have_xpath ".//img[contains(@src,'missing.png')]"
  end
end

feature 'user creates an event' do
  scenario 'bad datetime' do
    login_as(user, :scope => :user)
    visit root_path
    click_on 'New Event'
    fill_in 'event_title', :with => 'Badeventtitle'
    fill_in 'event_event_type', :with => 'Event type'
    fill_in 'event_venue', :with => 'Venue'
    fill_in 'event_available_tickets', :with => 50
    fill_in 'event_total_tickets', :with => 100
    attach_file('event_photo', 'public/images/placeholder.png')
    click_button 'Create Event'
    expect(page).to_not have_content 'Badeventtitle'
    expect(page).to_not have_xpath ".//img[contains(@src,'placeholder.png')]"
  end

  scenario 'bad available tickets' do
    login_as(user, :scope => :user)
    visit root_path
    click_on 'New Event'
    fill_in 'event_title', :with => 'Badeventtitle'
    fill_in 'event_event_type', :with => 'Event type'
    select '2015', :from => 'event_datetime_1i'
    fill_in 'event_venue', :with => 'Venue'
    fill_in 'event_available_tickets', :with => 100
    fill_in 'event_total_tickets', :with => 50
    attach_file('event_photo', 'public/images/placeholder.png')
    click_button 'Create Event'
    expect(page).to_not have_content 'Badeventtitle'
    expect(page).to_not have_xpath ".//img[contains(@src,'placeholder.png')]"
  end

  scenario 'create a new event from no events' do
    login_as(user, :scope => :user)
    visit root_path
    expect(page).to have_content 'no events'
    click_on 'New Event'
    fill_in 'event_title', :with => 'Event title'
    fill_in 'event_event_type', :with => 'Event type'
    select '2015', :from => 'event_datetime_1i'
    fill_in 'event_venue', :with => 'Venue'
    fill_in 'event_available_tickets', :with => 50
    fill_in 'event_total_tickets', :with => 100
    attach_file('event_photo', 'public/images/placeholder.png')
    click_button 'Create Event'
    expect(page).to have_content 'Event title'
    expect(page).to have_xpath ".//img[contains(@src,'placeholder.png')]"
  end

  scenario 'create a new event with existing events' do
    login_as(user, :scope => :user)
    visit root_path
    expect(page).to have_content 'Event title'
    click_on 'New Event'
    fill_in 'event_title', :with => 'Secondeventtitle'
    fill_in 'event_event_type', :with => 'Event type'
    select '2015', :from => 'event_datetime_1i'
    fill_in 'event_venue', :with => 'Venue'
    fill_in 'event_available_tickets', :with => 50
    fill_in 'event_total_tickets', :with => 100
    attach_file('event_photo', 'public/images/placeholder.png')
    click_button 'Create Event'
    expect(page).to have_content 'Secondeventtitle'
    expect(page).to have_xpath ".//img[contains(@src,'placeholder.png')]"
  end
end

feature 'user views an event' do
  scenario 'existing event' do
    login_as(user, :scope => :user)
    visit events_path
    expect(page).to have_content 'Event title'
    first(:link, 'Show').click
    expect(page).to have_xpath ".//img[contains(@src,'placeholder.png')]"
    expect(page).to have_content 'Event title'
    expect(page).to have_content 'Event type'
    expect(page).to have_content '2015'
    expect(page).to have_content 'Venue'
    expect(page).to have_content '50'
    expect(page).to have_content '100'
  end
end

feature 'user edits an event' do
  scenario 'existing event' do
    login_as(user, :scope => :user)
    visit events_path
    expect(page).to have_content 'Event title'
    first(:link, 'Edit').click
    fill_in 'event_title', :with => 'Editedeventtitle'
    click_button 'Update Event'
    expect(page).to have_content 'Editedeventtitle'
  end
end

feature 'user books a ticket' do
  scenario 'new ticket from existing event' do
    login_as(user, :scope => :user)
    visit events_path
    expect(page).to have_content 'Editedeventtitle'
    first(:link, 'Show').click
    click_on 'Book'
    expect(page).to have_xpath ".//img[contains(@src,'placeholder.png')]"
    expect(page).to have_content 'Editedeventtitle'
    expect(page).to have_content '1'
  end

  scenario 'another ticket from existing event' do
    login_as(user, :scope => :user)
    visit events_path
    expect(page).to have_content 'Editedeventtitle'
    first(:link, 'Show').click
    click_on 'Book'
    expect(page).to have_content 'Added 1'
    expect(page).to have_xpath ".//img[contains(@src,'placeholder.png')]"
    expect(page).to have_content 'Editedeventtitle'
    expect(page).to have_content '1'
  end

  # scenario 'new ticket from another user' do
  #   logout(:user)
  #   login_as(user2, :scope => :user)
  #   visit events_path
  #   expect(page).to have_content 'Editedeventtitle'
  #   first(:link, 'Show').click
  #   click_on 'Book'
  #   expect(page).to have_xpath ".//img[contains(@src,'placeholder.png')]"
  #   expect(page).to have_content 'Editedeventtitle'
  #   expect(page).to have_content '1'
  # end
end

feature 'user views ticket list' do
  scenario 'merged ticket from user' do
    login_as(user, :scope => :user)
    visit tickets_path
    expect(page).to have_xpath ".//img[contains(@src,'placeholder.png')]"
    expect(page).to have_content 'Editedeventtitle'
    expect(page).to have_content '2'
  end
  
  # scenario 'ticket from user2' do
  #   logout(:user)
  #   login_as(user2, :scope => :user)
  #   visit tickets_path
  #   expect(page).to have_xpath ".//img[contains(@src,'placeholder.png')]"
  #   expect(page).to have_content 'Editedeventtitle'
  #   expect(page).to have_content '1'
  # end
end

feature 'user deletes an event' do
  scenario 'existing event' do
    login_as(user, :scope => :user)
    visit events_path
    expect(page).to have_content 'Editedeventtitle'
    first(:link, 'Destroy').click
    expect(page).to_not have_content 'Editedeventtitle'
    visit tickets_path
    expect(page).to_not have_content 'Editedeventtitle'
  end
end

Warden.test_reset!