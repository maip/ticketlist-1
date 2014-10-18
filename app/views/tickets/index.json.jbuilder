json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :event, :num_booked
  json.url ticket_url(ticket, format: :json)
end
