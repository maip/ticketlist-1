require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  setup do
    @ticket = tickets(:one)
    @event = events(:one)

    @user = User.create!({
      email: 'test@gmail.com',
      password: 'password'
    })
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tickets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ticket" do
    assert_difference('Ticket.count') do
      post :create, ticket: { event_id: @event.id, user_id: @user.id, num_booked: @ticket.num_booked }
    end
    assert_redirected_to ticket_path(assigns(:ticket))
    
    updated_event = Event.find(@event)
    assert(updated_event.available_tickets == @event.available_tickets-@ticket.num_booked,
           "#{updated_event.available_tickets} != #{@event.available_tickets} - #{@ticket.num_booked}" ) 

    assert_no_difference('Ticket.count') do
      post :create, ticket: { event_id: @event.id, user_id: @user.id, num_booked: 1 }
    end

    existing_ticket = Ticket.find_by(event_id: @event.id, user_id: @user.id)
    assert(existing_ticket.num_booked == @ticket.num_booked+1,
           "Did not add booked to existing ticket #{existing_ticket.num_booked}.")   
  end

  test "should sort tickets by event datetime" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tickets)

    past_event = @event
    assigns(:tickets).each do |ticket|
      event = Event.find(ticket.event_id)
      assert(event.datetime >= past_event.datetime, "Tickets not ordered by datetime.")
      past_event = event
    end
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
