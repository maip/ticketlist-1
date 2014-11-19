require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
    @future_event = events(:two)
    # @past_event = events(:three)
  end

  test "should sign in user" do
    user = User.create!({
      email: "test@gmail.com",
      password: "password"
    })
    sign_in user
    assert_response :success
    assert @controller.instance_variable_set(:"@current_user", true)
  end

  test "should get index" do
    user = User.create!({
      email: "test@gmail.com",
      password: "password"
    })
    sign_in user

    get :index
    assert_response :success
    assert_not_nil assigns(:events)

    event = Event.create({
      available_tickets: @event.available_tickets,
      datetime: @event.datetime,
      event_type: @event.event_type,
      title: @event.title,
      total_tickets: @event.total_tickets,
      venue: @event.venue,
      user_id: user.id,
      photo: fixture_file_upload('placeholder.png', 'image/png')
    })
    future_event = Event.create({ available_tickets: @future_event.available_tickets,
      datetime: @future_event.datetime,
      event_type: @future_event.event_type,
      title: @future_event.title,
      total_tickets: @future_event.total_tickets,
      venue: @future_event.venue,
      user_id: user.id,
      photo: fixture_file_upload('placeholder.png', 'image/png')
    })
    all = Event.all
    assert_operator(all.index(event), :<, all.index(future_event), 'Events not sorted by datetime')
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    user = User.create!({
      email: "test@gmail.com",
      password: "password"
    })
    sign_in user

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
                      #user_id: user.id,
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
                                 # user_id: user.id,
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

    assert_redirected_to events_path
  end

end
