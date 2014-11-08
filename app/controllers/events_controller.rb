class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  respond_to :js, :html
  
  def index
    @events = Event.all
    @events = @events.sort_by &:datetime
    respond_with(@events)
    @date = params[:month] ? Date.parse(params[:month]) : Date.today #This is from railscast.com for the datepicker

  end

  def show
    respond_with(@event)
  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    if @event.available_tickets > @event.total_tickets
      flash[:alert] = "The number of available tickets is greater than the amount of total tickets."
      redirect_to new_event_path
    else
      @event.save
      respond_with(@event)
    end
  end

  def update
    @event.update(event_params)
    respond_with(@event)
  end

  def destroy
    tickets = Ticket.all
    tickets.each do |ticket|
      if ticket.event_id == @event.id
        Ticket.destroy(ticket)
      end
    end
    
    @event.destroy
    respond_with(@event)
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params

      params.require(:event).permit(:title, :event_type, :datetime, :venue, :available_tickets, :total_tickets)

    end
end
