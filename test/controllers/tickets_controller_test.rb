require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  setup do
    @ticket = tickets(:one)
  end

  test "should get index" do
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
    event = Event.find(@ticket.event_id)
    before_available_tickets = event.available_tickets
    assert_difference('Ticket.count') do
      post :create, ticket: { event_id: @ticket.event_id, user_id: @ticket.user_id, num_booked: @ticket.num_booked }
    end
    assert(event.available_tickets == before_available_tickets-@ticket.num_booked, 'Incorrect subtraction of tickets booked from available tickets' )
    assert_redirected_to ticket_path(assigns(:ticket))
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
