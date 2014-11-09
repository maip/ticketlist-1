require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  setup do
    @ticket = tickets(:one)
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
      post :create, ticket: { event_id: @ticket.event_id, user_id: @ticket.user_id,  num_booked: @ticket.num_booked }
    end
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should show ticket" do
    get :show, id: @ticket
    assert_response :success
  end


  test "should show tickets by time" do
    get :index, id: @etickets_controller
    assert(@ticket == @ticket.sort_by &:datetime, 'sorts tickets by time')
  end


  test "updating available tickets after booking tickets" do
    get :ticket, id: @ticket
   assert(@ticket.available_tickets > @ticket.total_tickets, 'The number of available tickets is greater than total tickets' )
  end

    test "book tickets function" do
   assert_difference('ticket.count') do
      post :book, ticket: { available_tickets: @ticket.available_tickets, user_id: @ticket.user_id, datetime: @ticket.datetime, event_type: @ticket.event_type, title: @ticket.title, total_tickets: @ticket.total_tickets, venue: @ticket.venue }
      patch :update, id: @ticket, ticket: { available_tickets: @ticket.available_tickets, user_id: @ticket.user_id, datetime: @ticket.datetime, ticket_type: @ticket.ticket_type, title: @ticket.title, total_tickets: @ticket.total_tickets, venue: @ticket.venue }
    assert_redirected_to ticket_path(assigns(:ticket))
  end
end

  test "should get edit" do
    get :edit, id: @ticket
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
