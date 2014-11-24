require 'rails_helper'

RSpec.describe EventsController, :type => :controller do
  include Capybara::DSL

  setup do
    @event = events(:one)
    @future_event = events(:two)

    @user = users(:one)
    sign_in @user
  end

  describe 'events page' do
    it 'lets the user create an event', :js => true do
    	visit "/"
    	click_on 'Sign up.'
    	fill_in 'Email', :with => "someone@asu.edu"
      #visit new_event_path
      fill_in 'title', :with => 'Event title'
      fill_in :event_type, :with => 'Event type'
      fill_in :datetime, :with => DateTime.current.change(year: 2015)
      fill_in :venue, :with => 'Venue'
      fill_in :available_tickets, :with => 100
      fill_in :total_tickets, :with => 100
      attach_file('placeholder.png', 'image/png')
      click_on 'Submit'
      page.should have_content('Event title')
    end
  end

end
