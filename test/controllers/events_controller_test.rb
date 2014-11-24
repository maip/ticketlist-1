require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
    @future_event = events(:two)

    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
    assert_operator(assigns(:events).index(@event), :<, assigns(:events).index(@future_event), 'Events not sorted by datetime')
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert(@event.available_tickets <= @event.total_tickets, 'Available tickets is greater than total tickets')
    assert(@event.datetime >= DateTime.current, "Event #{@event.datetime} is in the past")
    assert_difference('Event.count') do
      post :create, event: {
                      available_tickets: @event.available_tickets,
                      datetime: @event.datetime,
                      event_type: @event.event_type,
                      title: @event.title,
                      total_tickets: @event.total_tickets,
                      venue: @event.venue,
                      user_id: @user.id,
                      photo: fixture_file_upload('placeholder.png', 'image/png')
                    }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, id: @event
    assert_response :success
  end

  test "should update event" do
    patch :update, id: @event, event: {
                                 available_tickets: @event.available_tickets,
                                 datetime: @event.datetime,
                                 event_type: @event.event_type,
                                 title: @event.title,
                                 total_tickets: @event.total_tickets,
                                 venue: @event.venue,
                                 user_id: @user.id,
                                 photo: fixture_file_upload('placeholder.png', 'image/png')
                               }
    assert(@event.available_tickets <= @event.total_tickets, 'Available tickets is greater than total tickets')
    assert(@event.datetime >= DateTime.current, "Event #{@event.datetime} is in the past")
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, id: @event
    end

    # assert delete tickets with matching event id
    tickets = Ticket.where(event_id: @event.id)
    assert(tickets.empty?, "Did not delete tickets for this event")

    assert_redirected_to events_path
  end

end
