require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  setup do
    @ticket = tickets(:one)
    @event = events(:one)
    @user = users(:one)
  end

  test "should get index" do
    user = User.create!({
      email: "test@gmail.com",
      password: "password"
    })
    sign_in user
    
    get :index
    assert_response :success
    assert_not_nil assigns(:tickets)

    # assert sorted by event datetime
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ticket" do
    user = User.create!({
      email: "test@gmail.com",
      password: "password"
    })
    sign_in user

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
    assert_difference('Ticket.count') do
      post :create, ticket: { event_id: event.id, user_id: user.id, num_booked: @ticket.num_booked }
    end
    assert_redirected_to ticket_path(assigns(:ticket))
    
    ticket = Ticket.create({
      event_id: event.id,
      user_id: user.id,
      num_booked: @ticket.num_booked
    })
    found_event = Event.find(ticket.event_id)
    assert(found_event.available_tickets == @event.available_tickets-ticket.num_booked, "#{found_event.available_tickets} != #{@event.available_tickets} - #{ticket.num_booked}" )
  end

  test "should show ticket" do
    get :show, id: @ticket
    assert_response :success
  end

  test "should update ticket" do
    patch :update, id: @ticket, ticket: { event_id: @ticket.event_id, user_id: @ticket.user_id,  num_booked: @ticket.num_booked }
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should destroy ticket" do
    assert_difference('Ticket.count', -1) do
      delete :destroy, id: @ticket
    end
    assert_redirected_to tickets_path
  end

end
