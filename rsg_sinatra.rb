require 'sinatra'
# require 'sinatra/reloader' if development?
require './rsg'

get '/' do
  @title = "Hello work!"
end

get '/test' do
  "why you no work?"
end

get '/Star-Trek-episode' do
  # input = params[:filename]
  # if input.match?(/[^\w\.\-]/)
  #   'That is not right'
  # else
    rsg('Star-Trek-episode')
  # end
end