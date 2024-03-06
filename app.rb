require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  erb(:home)
end

get("/results") do
  #Grab the ID and Key for API usage
  seatgeek_id = ENV.fetch("SEATGEEK_ID")
  seatgeek_key = ENV.fetch("SEATGEEK_KEY")

  #Grabs the string the user inputted
  @result = params["item"]

  #Replaces whitespace within that string with dashes
  @result = @result.gsub(" ", "-")

  #String variable which holds the api endpoint events along with authentication using the ID and Key.
  #Also filters all the events based on the string the user inputted
  api_url = "https://api.seatgeek.com/2/events?client_id=#{seatgeek_id}&client_secret=#{seatgeek_key}&q=#{@result}"

  #Grabs data from the endpoint using HTTP, parses the data using JSON
  raw_data = HTTP.get(api_url)
  parsed_data = JSON.parse(raw_data)

  #Stores all the events from the parsed data
  @events = parsed_data["events"]
  
  erb(:results)
end
