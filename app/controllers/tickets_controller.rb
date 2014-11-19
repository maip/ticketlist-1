class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  respond_to :js, :html
  
  def index
    @tickets = Ticket.where(user_id: current_user.id)
    sorted_tickets = []
    events = Event.all.sort_by &:datetime
    events.each do |event|
      @tickets.each do |ticket|
        if event.id == ticket.event_id
          sorted_tickets.push(ticket)
        end
      end
    end
    @ticket = sorted_tickets
    respond_with(@tickets)
  end

  def show
    respond_with(@ticket)
  end

  def new
    @ticket = Ticket.new
    respond_with(@ticket)
  end

  def edit
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user_id = current_user.id

    @event = Event.find(@ticket.event_id)
    @event.update_attribute :available_tickets, @event.available_tickets-@ticket.num_booked
    @event.save
    
    existing_ticket = Ticket.find_by({:event_id => @ticket.event_id, :user_id => @ticket.user_id})
    if existing_ticket.nil?
      @ticket.save
      respond_with(@ticket)
    else
      flash[:notice] = "Added #{existing_ticket.num_booked} ticket(s) to #{@ticket.num_booked} existing ticket(s)."
      existing_ticket.update_attribute :num_booked, existing_ticket.num_booked+@ticket.num_booked
      existing_ticket.save
      respond_with(existing_ticket)
    end
  end

  def update
    @ticket.update(ticket_params)
    respond_with(@ticket)
  end

  def destroy
    @ticket.destroy
    respond_with(@ticket)
  end

  private
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:event_id, :user_id, :num_booked)
    end
end
