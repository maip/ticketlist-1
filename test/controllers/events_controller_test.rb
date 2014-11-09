require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
    assert(@events == @events.sort_by &:datetime, 'sorts events by time')
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, event: { available_tickets: @event.available_tickets, datetime: @event.datetime, event_type: @event.event_type, title: @event.title, total_tickets: @event.total_tickets, venue: @event.venue, user_id: @event.user_id }
    end
    assert(@event.available_tickets <= @event.total_tickets, 'Available tickets is not less than or equal to total tickets')
    assert(@event.datetime < DateTime.current, 'Cannot create an event in the past')

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, id: @event
    assert_response :success
  end

  test "should update event" do
    patch :update, id: @event, event: { available_tickets: @event.available_tickets, datetime: @event.datetime, event_type: @event.event_type, title: @event.title, total_tickets: @event.total_tickets, venue: @event.venue, user_id: @event.user_id }
    assert(@event.available_tickets <= @event.total_tickets, 'Available tickets is not less than or equal to total tickets')
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, id: @event
    end

    assert_redirected_to events_path
  end
end
